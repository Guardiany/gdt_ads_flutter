#import "GdtAdsFlutterPlugin.h"
#import "GDTSDKConfig.h"
#import "Splash/GDTSplashViewFactory.h"
#import "RewardVideoViewFactory.h"

@implementation GdtAdsFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"gdt_ads_flutter"binaryMessenger:[registrar messenger]];
    GdtAdsFlutterPlugin* instance = [[GdtAdsFlutterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    //注册开屏广告
    [registrar registerViewFactory:[[GDTSplashViewFactory alloc] initWithMessenger:registrar.messenger] withId:@"com.ahd.splash_view"];
    //注册激励视频广告
    [registrar registerViewFactory:[[RewardVideoViewFactory alloc] initWithMessenger:registrar.messenger] withId:@"com.ahd.reward_video"];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }
    if ([@"getSdkVersion" isEqualToString:call.method]) {
        result([GDTSDKConfig sdkVersion]);
    }
    if ([@"register" isEqualToString:call.method]) {
        NSDictionary *map = call.arguments;
        NSString *appId = [map valueForKey:@"appId"];
        BOOL registerResult = [GDTSDKConfig registerAppId: appId];
        [GDTSDKConfig setChannel:3];
        result([NSNumber numberWithBool:registerResult]);
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

@end
