import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:universities_map/ad_helper.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<StatefulWidget> createState() => _AdBannerWidget();
}

class _AdBannerWidget extends State<AdBannerWidget> {
  late BannerAd? bannerAd;

  bool isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      return;
    }
    String adUnitId = bannerAdUnitId;
    if (adUnitId.isNotEmpty) {
      bannerAd = BannerAd(
        adUnitId: adUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (_) {
            setState(() {
              isBannerAdReady = true;
            });
          },
          onAdFailedToLoad: (ad, err) {
            isBannerAdReady = false;
            ad.dispose();
          },
        ),
      );
      bannerAd?.load();
    } else {
      bannerAd = null;
    }
  }

  @override
  void dispose() {
    bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return bannerAd != null
        ? Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: bannerAd?.size.width.toDouble(),
              height: bannerAd?.size.height.toDouble(),
              child: isBannerAdReady ? AdWidget(ad: bannerAd!) : null,
            ),
          )
        : SizedBox.shrink();
  }
}
