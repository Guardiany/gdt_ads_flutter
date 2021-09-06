# 腾讯优量汇广告 Flutter版本

## 简介
  gdt_ads_flutter是一款集成了腾讯优量汇sdk的Flutter插件,目前仅支持iOS端部分功能，剩余功能和Android端正在开发

## 官方文档
* [Android](https://developers.adnet.qq.com/doc/android/access_doc)
* [IOS](https://developers.adnet.qq.com/doc/ios/guide)

## 集成步骤
#### 1、pubspec.yaml
```Dart
gdt_ads_flutter: ^0.0.1
```

#### 2、IOS
SDK最新版本已配置插件中，其余根据SDK文档配置，在Info.plist加入
```
 <key>io.flutter.embedded_views_preview</key>
    <true/>
```

## 使用

#### 1、SDK初始化
```Dart
await GdtAdsFlutter.register(iosAppId: '你的appID');
```
#### 2、获取SDK版本
```Dart
await GdtAdsFlutter.sdkVersion;
```
#### 3、开屏广告
```Dart
GdtAdsFlutter.splashView(
        context: context,
        placementId: '你的广告位ID',
        callback: SplashViewCallback(
          onLoad: () {
            print('onLoad');
          },
          onFail: (error) {
            print('$error');
          },
          onShow: () {
            print('onShow');
          },
          onClick: () {
            print('onClick');
          },
          onFinish: () {
            print('onFinish');
          },
          onClose: () {
            print('onClose');
          },
        ),
      ),
```
#### 4、激励视频
```Dart
GdtAdsFlutter.rewardVideoView(
        context: context,
        placementId: '你的广告位ID',
        videoMuted: true,
        callback: RewardVideoCallback(
          onLoad: () {
            print('onLoad');
          },
          onFail: (error) {
            print('$error');
          },
          onShow: () {
            print('onShow');
          },
          onClick: () {
            print('onClick');
          },
          onFinish: () {
            print('onFinish');
          },
          onClose: () {
            print('onClose');
            Navigator.pop(context);
          },
          onReward: () {
            print('onReward');
          },
        ),
      ),
```

## 联系方式
* Email: 1204493146@qq.com
