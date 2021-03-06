import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:gdt_ads_flutter/gdt_ads_callback.dart';
import 'package:gdt_ads_flutter/gdt_ads_flutter.dart';
import 'package:gdt_ads_flutter_example/splash_view_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext buildContext) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _platformVersion = 'Unknown';
  String _sdkVersion = 'Unknown';
  bool? _registerResult;
  bool loadComplete = false;

  StreamSubscription? _rewardVideoStream;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _initSdk();
    _rewardVideoStream = GdtAdsFlutter.initRewardStream(RewardVideoCallback(
      onLoad: () {
        print('onLoad');
        loadComplete = true;
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
        _loadRewardVideo();
      },
      onReward: () {
        print('onReward');
      },
    ));
  }

  _initSdk() async {
    _registerResult = await GdtAdsFlutter.register(iosAppId: '1200064850');
    _loadRewardVideo();
    setState(() {});
  }

  _loadRewardVideo() {
    GdtAdsFlutter.loadReardVideo(placementId: '4072435033794278');
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    String sdkVersionl;
    try {
      platformVersion = await GdtAdsFlutter.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    try {
      sdkVersionl = await GdtAdsFlutter.sdkVersion ?? 'Unknown Sdk version';
    } on PlatformException {
      sdkVersionl = 'Failed to get sdk version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _sdkVersion = sdkVersionl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Running on: $_platformVersion\nSdk Version: $_sdkVersion'),
            Text('${_registerResult == null ? '???????????????sdk' : _registerResult! ? 'sdk???????????????' : 'sdk???????????????'}'),
            Padding(padding: EdgeInsets.only(top: 15)),
            TextButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (con) {
                return SplashViewPage();
              }));
            }, child: Text('????????????', style: TextStyle(fontSize: 18),),),
            TextButton(onPressed: () {
              // GdtAdsFlutter.loadAndShowRewardVideo(context: context, placementId: '4072435033794278');
              if (loadComplete) {
                GdtAdsFlutter.showReardVideo(context: context);
              }
              // Navigator.push(context, MaterialPageRoute(builder: (con) {
              //   return RewardVideoViewPage();
              // }));
            }, child: Text('????????????', style: TextStyle(fontSize: 18),),),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _rewardVideoStream?.cancel();
  }
}


