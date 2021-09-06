
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gdt_ads_flutter/gdt_ads_callback.dart';
import 'package:gdt_ads_flutter/reward_video/reward_video_view.dart';
import 'package:gdt_ads_flutter/splash_view/splash_view.dart';

class GdtAdsFlutter {
  static const MethodChannel _channel =
      const MethodChannel('gdt_ads_flutter');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String?> get sdkVersion async {
    final String? version = await _channel.invokeMethod('getSdkVersion');
    return version;
  }

  static Future<bool?> register({
    required String iosAppId,
  }) async {
    final bool? result = await _channel.invokeMethod('register', {'appId': iosAppId});
    return result;
  }

  ///开屏广告
  static Widget splashView({
    required BuildContext context,
    double? width,
    double? height,
    required String placementId,
    bool isShowLog = false,
    SplashViewCallback? callback,
  }) {
    if (width == null) {
      width = MediaQuery.of(context).size.width;
    }
    if (height == null) {
      height = MediaQuery.of(context).size.height;
    }
    return SplashView(
      width: width,
      height: height,
      placementId: placementId,
      isShowLog: isShowLog,
      callback: callback,
    );
  }

  ///激励视频
  static Widget rewardVideoView({
    required BuildContext context,
    double? width,
    double? height,
    required String placementId,
    bool isShowLog = false,
    ///设置激励视频是否静音
    bool videoMuted = false,
    RewardVideoCallback? callback,
  }) {
    if (width == null) {
      width = MediaQuery.of(context).size.width;
    }
    if (height == null) {
      height = MediaQuery.of(context).size.height;
    }
    return RewardVideoView(
      placementId: placementId,
      width: width,
      height: height,
      isShowLog: isShowLog,
      videoMuted: videoMuted,
      callback: callback,
    );
  }
}
