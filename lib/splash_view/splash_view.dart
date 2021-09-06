
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gdt_ads_flutter/gdt_ads_callback.dart';

class SplashView extends StatefulWidget {

  const SplashView({
    Key? key,
    this.width,
    this.height,
    required this.placementId,
    this.isShowLog = false,
    this.callback,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String placementId;
  final bool isShowLog;
  final SplashViewCallback? callback;

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  final String _viewType = 'com.ahd.splash_view';
  MethodChannel? _channel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Center(
        child: UiKitView(
          viewType: _viewType,
          creationParams: {
            'placementId': '${widget.placementId}',
            'isShowLog': widget.isShowLog,
          },
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: _registerChannel,
        ),
      ),
    );
  }

  void _registerChannel(int id) {
    _channel = MethodChannel("${_viewType}_$id");
    _channel?.setMethodCallHandler(_platformCallHandler);
  }

  Future<dynamic> _platformCallHandler(MethodCall call) async {
    if (widget.callback == null) {
      return;
    }
    switch (call.method) {
      case 'onLoad':
        widget.callback?.onLoad!();
        break;
      case 'onPresent':
        widget.callback?.onShow!();
        break;
      case 'onFail':
        widget.callback?.onFail!(call.arguments);
        break;
      case 'onExposured':
        break;
      case 'onClick':
        widget.callback?.onClick!();
        break;
      case 'onWillClosed':
        widget.callback?.onFinish!();
        break;
      case 'onClosed':
        widget.callback?.onClose!();
        break;
    }
  }
}
