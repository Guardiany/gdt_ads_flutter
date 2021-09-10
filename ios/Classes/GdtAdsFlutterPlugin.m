#import "GdtAdsFlutterPlugin.h"
#import "GDTSDKConfig.h"
#import "Splash/GDTSplashViewFactory.h"
#import "RewardVideoViewFactory.h"
#import "GdtFlutterEvent.h"
#import "GdtAdsRewardVideo.h"

GdtFlutterEvent *ad_event;

@implementation GdtAdsFlutterPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"gdt_ads_flutter"binaryMessenger:[registrar messenger]];
    GdtAdsFlutterPlugin* instance = [[GdtAdsFlutterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    //注册开屏广告
    [registrar registerViewFactory:[[GDTSplashViewFactory alloc] initWithMessenger:registrar.messenger] withId:@"com.ahd.splash_view"];
    //注册激励视频广告
    [registrar registerViewFactory:[[RewardVideoViewFactory alloc] initWithMessenger:registrar.messenger] withId:@"com.ahd.reward_video"];
    //注册event与Flutter进行交互
    ad_event = [[GdtFlutterEvent alloc] initWithRegistrar:registrar];
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
    if ([@"loadAndShowRewardVideo" isEqualToString:call.method]) {
        [[GdtAdsRewardVideo instance] loadAndShowRewardVideo:call.arguments];
        result(nil);
    }
    if ([@"loadRewardVideo" isEqualToString:call.method]) {
        [[GdtAdsRewardVideo instance] loadRewardVideoWithArgs:call.arguments];
        result(nil);
    }
    if ([@"showRewardVideo" isEqualToString:call.method]) {
        [[GdtAdsRewardVideo instance] showRewardVideo];
        result(nil);
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

@end
