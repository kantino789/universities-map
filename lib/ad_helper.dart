import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

String get _debugAndroidBannerAdUnitId =>
    'ca-app-pub-3940256099942544/6300978111';
String get _releaseAndroidBannerAdUnitId =>
    'ca-app-pub-5606607334991302/1829600643';
String get _androidBannerAdUnitId => _debugAndroidBannerAdUnitId;

String get _debugIOSBannerAdUnitId => 'ca-app-pub-3940256099942544/2934735716';
// String get _releaseIOSBannerAdUnitId =>
//     'TODO';
String get _iosBannerAdUnitId => _debugIOSBannerAdUnitId;

String get bannerAdUnitId {
  if (kIsWeb) {
    return "";
  } else if (Platform.isAndroid) {
    return _androidBannerAdUnitId;
  } else if (Platform.isIOS) {
    return _iosBannerAdUnitId;
  } else {
    return "";
  }
}

Future<InitializationStatus?> initGoogleMobileAds() async {
  if (kIsWeb) {
    return null;
  }
  return MobileAds.instance.initialize();
}
