import 'dart:convert';

import 'package:http/http.dart' as http;

const _styleHost = 'tiles.openfreemap.org';
const _languageParam = 'lang';

/// Style URL for the OpenFreeMap "liberty" style with labels in [languageCode].
///
/// The language is only a marker for [LocalizedStyleClient]: it is stripped
/// before the request is sent, but it keeps the style cache of one language
/// from being served for another.
String localizedStyleUri(String languageCode) =>
    'https://$_styleHost/styles/liberty?$_languageParam=$languageCode';

/// HTTP client that rewrites the labels of a style requested through
/// [localizedStyleUri] so they use the `name:<lang>` tile attribute, falling
/// back to the style's default label when a feature has no such translation.
class LocalizedStyleClient extends http.BaseClient {
  LocalizedStyleClient([http.Client? inner]) : _inner = inner ?? http.Client();

  final http.Client _inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final url = request.url;
    final language = url.queryParameters[_languageParam];
    if (url.host != _styleHost || language == null) {
      return _inner.send(request);
    }

    final params = Map.of(url.queryParameters)..remove(_languageParam);
    final plainRequest = http.Request(
      request.method,
      Uri(
        scheme: url.scheme,
        host: url.host,
        port: url.hasPort ? url.port : null,
        path: url.path,
        queryParameters: params.isEmpty ? null : params,
      ),
    )..headers.addAll(request.headers);
    final response = await http.Response.fromStream(
      await _inner.send(plainRequest),
    );
    if (response.statusCode != 200) {
      return http.StreamedResponse(
        Stream.value(response.bodyBytes),
        response.statusCode,
        headers: response.headers,
        request: request,
      );
    }

    final body = utf8.encode(
      localizeStyleJson(utf8.decode(response.bodyBytes), language),
    );
    return http.StreamedResponse(
      Stream.value(body),
      response.statusCode,
      contentLength: body.length,
      headers: {'content-type': 'application/json; charset=utf-8'},
      request: request,
    );
  }

  @override
  void close() => _inner.close();
}

/// Returns [styleJson] with every symbol label preferring `name:<language>`.
String localizeStyleJson(String styleJson, String language) {
  final style = jsonDecode(styleJson) as Map<String, dynamic>;
  if (language != 'en') {
    for (final layer
        in (style['layers'] as List).cast<Map<String, dynamic>>()) {
      final layout = layer['layout'];
      if (layout is! Map<String, dynamic>) continue;
      final textField = layout['text-field'];
      // Only labels built from the names are translated, not e.g. road refs.
      if (textField != null && jsonEncode(textField).contains('"name')) {
        layout['text-field'] = [
          'coalesce',
          ['get', 'name:$language'],
          textField,
        ];
      }
    }
  }
  return jsonEncode(style);
}
