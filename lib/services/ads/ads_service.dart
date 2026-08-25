import 'package:flutter/foundation.dart';
import '../config/app_config_service.dart';

enum AdType {
  banner,
  interstitial,
  rewarded,
}

class AdsService extends ChangeNotifier {
  final AppConfigService configService;

  bool _isInitialized = false;
  bool _isBannerVisible = false;

  AdsService({required this.configService});

  bool get isInitialized => _isInitialized;
  bool get isBannerVisible => _isBannerVisible;
  bool get adsEnabled => configService.adsEnabled;

  Future<void> initialize() async {
    if (!adsEnabled) {
      debugPrint('[AdsService] Ads are disabled by Remote Admin config');
      _isInitialized = true;
      return;
    }

    try {
      // In production Flutter apps with google_mobile_ads:
      // await MobileAds.instance.initialize();
      _isInitialized = true;
      debugPrint('[AdsService] Initialized with remote App ID: ${configService.config.androidBannerId}');
      notifyListeners();
    } catch (e) {
      debugPrint('[AdsService] Initialization skipped or error: $e');
      _isInitialized = true;
    }
  }

  void showBanner() {
    if (!adsEnabled) return;
    _isBannerVisible = true;
    notifyListeners();
    debugPrint('[AdsService] showBanner using unit ID: ${configService.config.androidBannerId}');
  }

  void hideBanner() {
    _isBannerVisible = false;
    notifyListeners();
    debugPrint('[AdsService] hideBanner');
  }

  Future<bool> showInterstitial() async {
    if (!adsEnabled) return false;
    debugPrint('[AdsService] showInterstitial with ID: ${configService.config.androidInterstitialId}');
    return true;
  }

  Future<bool> showRewarded({required VoidCallback onRewarded}) async {
    if (!adsEnabled) {
      // If ads disabled, grant reward directly for smooth user experience
      onRewarded();
      return true;
    }

    debugPrint('[AdsService] showRewarded with ID: ${configService.config.androidRewardedId}');
    // Simulate rewarded video completion
    onRewarded();
    return true;
  }
}
