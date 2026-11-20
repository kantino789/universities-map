import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:universities_map/view/helpers/localized_style_client.dart';

const _style = {
  'layers': [
    {
      'id': 'label',
      'layout': {
        'text-field': [
          'coalesce',
          ['get', 'name_en'],
          ['get', 'name'],
        ],
      },
    },
    {
      'id': 'ref',
      'layout': {
        'text-field': [
          'to-string',
          ['get', 'ref'],
        ],
      },
    },
    {'id': 'background'},
  ],
};

void main() {
  test('localizeStyleJson prefers the language name on name labels only', () {
    final result =
        jsonDecode(localizeStyleJson(jsonEncode(_style), 'fr')) as Map;
    final layers = result['layers'] as List;

    expect(layers[0]['layout']['text-field'], [
      'coalesce',
      ['get', 'name:fr'],
      [
        'coalesce',
        ['get', 'name_en'],
        ['get', 'name'],
      ],
    ]);
    expect(layers[1]['layout']['text-field'], [
      'to-string',
      ['get', 'ref'],
    ]);
  });

  test('English keeps the style unchanged', () {
    expect(jsonDecode(localizeStyleJson(jsonEncode(_style), 'en')), _style);
  });

  test(
    'client strips the language marker and localizes the response',
    () async {
      Uri? requested;
      final client = LocalizedStyleClient(
        MockClient((request) async {
          requested = request.url;
          return http.Response(jsonEncode(_style), 200);
        }),
      );

      final response = await client.get(Uri.parse(localizedStyleUri('de')));

      expect(
        requested.toString(),
        'https://tiles.openfreemap.org/styles/liberty',
      );
      expect(response.body, contains('name:de'));
    },
  );
}
