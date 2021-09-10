
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gdt_ads_flutter/gdt_ads_callback.dart';
import 'package:gdt_ads_flutter/reward_video/reward_video_view.dart';
import 'package:gdt_ads_flutter/splash_view/splash_view.dart';

class GdtAdsFlutter {
  static const MethodChannel _channel =
      const MethodChannel('gdt_ads_flutter');
  static const EventChannel adEventEvent = const EventChannel("com.ahd.gdt_flutter/ad_event");

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

  ///预加载激励视频广告
  static void loadReardVideo({
    required String placementId,
    bool isShowLog = false,
    ///设置激励视频是否静音
    bool videoMuted = false,
  }) {
    _channel.invokeMethod('loadRewardVideo', {
      'placementId': placementId,
      'isShowLog': isShowLog,
      'videoMuted': videoMuted,
    });
  }

  ///显示激励视频
  static void showReardVideo({required BuildContext context,}) {
    _channel.invokeMethod('showRewardVideo', {});
  }

  ///加载并播放激励视频
  static Future loadAndShowRewardVideo({
    required BuildContext context,
    required String placementId,
    bool isShowLog = false,
    ///设置激励视频是否静音
    bool videoMuted = false,
  }) async {
    _channel.invokeMethod('loadAndShowRewardVideo', {
      'placementId': placementId,
      'isShowLog': isShowLog,
      'videoMuted': videoMuted,
    });
  }

  ///设置激励视频监听
  static StreamSubscription initRewardStream(RewardVideoCallback callback) {
    StreamSubscription _adStream = adEventEvent.receiveBroadcastStream().listen((data) {
      if (data['adType'] != 'rewardAd') {
        return;
      }
      switch (data['method']){
        case 'onLoad':
          callback.onLoad!();
          break;
        case 'onShow':
          callback.onShow!();
          break;
        case 'error':
          callback.onFail!(data['errorMessage']);
          break;
        case 'onWillVisible':
          break;
        case 'onClick':
          callback.onClick!();
          break;
        case 'onFinish':
          callback.onFinish!();
          break;
        case 'onClosed':
          callback.onClose!();
          break;
        case 'onReward':
          callback.onReward!();
          break;
      }
    });
    return _adStream;
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
  @Deprecated("推荐使用新方法 loadReardVideo和showReardVideo或者loadAndShowRewardVideo，监听回调：initRewardStream")
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
