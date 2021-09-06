
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdt_ads_flutter/gdt_ads_flutter.dart';
import 'package:gdt_ads_flutter/gdt_ads_callback.dart';

class SplashViewPage extends StatefulWidget {
  const SplashViewPage({Key? key}) : super(key: key);

  @override
  _SplashViewPageState createState() => _SplashViewPageState();
}

class _SplashViewPageState extends State<SplashViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GdtAdsFlutter.splashView(
        context: context,
        placementId: '7012225939971275',
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
            Navigator.pop(context);
          },
          onClose: () {
            print('onClose');
          },
        ),
      ),
    );
  }
}
