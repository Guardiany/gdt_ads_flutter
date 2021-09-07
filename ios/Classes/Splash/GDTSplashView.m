//
//  GDTSplashView.m
//  Pods
//
//  Created by 爱互动 on 2021/9/2.
//

#import <Foundation/Foundation.h>
#import "GDTSplashView.h"
#import "GDTSplashAd.h"

@interface GDTSplashView () <GDTSplashAdDelegate>

@property (nonatomic, strong) GDTSplashAd *splashAd;

@end

@implementation GDTSplashView {
    int64_t _viewId;
    FlutterMethodChannel* _channel;
    BOOL _isShowLog;
    UIWindow *container;
}

- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
    
    NSString *methodName = [NSString stringWithFormat:@"com.ahd.splash_view_%lld", viewId];
    _channel = [FlutterMethodChannel methodChannelWithName:methodName binaryMessenger:messenger];
    
    NSDictionary *dic = args;
    NSString *placementId = dic[@"placementId"];
    NSNumber *isShowLog = dic[@"isShowLog"];
    _isShowLog = [isShowLog boolValue];
    
    container = [[UIWindow alloc] initWithFrame:frame];
    //重要！！将app的rootViewController赋给container
    container.rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [self loadSplash:placementId];
    _viewId = viewId;
    return self;
}

- (nonnull UIView *)view {
    return container;
}

-(void)loadSplash: (NSString*)content {
//    [self.container removeFromSuperview];
    self.splashAd = [[GDTSplashAd alloc] initWithPlacementId:content];
    self.splashAd.delegate = self;
    //开屏拉取时间，超时则放弃展示
    self.splashAd.fetchDelay = 3;
//    window = [[UIApplication sharedApplication] keyWindow];
//    [self.container addSubview:window];
    [self.splashAd loadAd];
}

- (void)splashAdDidLoad:(GDTSplashAd *)splashAd {
    [self showDebugLog:@"广告拉取成功"];
    [_channel invokeMethod:@"onLoad" arguments:@"广告拉取成功"];
    if ([self.splashAd isAdValid]) {
        [self.splashAd showAdInWindow:container withBottomView:nil skipView:nil];
    }
}

- (void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    [self showDebugLog:@"广告展示成功"];
    [_channel invokeMethod:@"onPresent" arguments:@"广告展示成功"];
}

- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    [self showDebugLog:[NSString stringWithFormat:@"广告拉取失败或展示失败,%@",error]];
    [_channel invokeMethod:@"onFail" arguments:@"广告拉取失败或展示失败"];
}

- (void)splashAdExposured:(GDTSplashAd *)splashAd
{
    [self showDebugLog:@"广告已曝光"];
    [_channel invokeMethod:@"onExposured" arguments:@"广告已曝光"];
}

- (void)splashAdClicked:(GDTSplashAd *)splashAd
{
    if (splashAd.splashZoomOutView) {
        [splashAd.splashZoomOutView removeFromSuperview];
    }
    [self showDebugLog:@"广告已点击"];
    [_channel invokeMethod:@"onClick" arguments:@"广告已点击"];
}

- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{
    [self showDebugLog:[NSString stringWithFormat:@"%s",__FUNCTION__]];
}

- (void)splashAdWillClosed:(GDTSplashAd *)splashAd
{
    [self showDebugLog:@"广告即将关闭"];
    [_channel invokeMethod:@"onWillClosed" arguments:@"广告关闭"];
}

- (void)splashAdClosed:(GDTSplashAd *)splashAd
{
    [self showDebugLog:@"广告关闭"];
    [_channel invokeMethod:@"onClosed" arguments:@"广告关闭"];
}

- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    [self showDebugLog:[NSString stringWithFormat:@"%s",__FUNCTION__]];
}

- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    [self showDebugLog:[NSString stringWithFormat:@"%s",__FUNCTION__]];
}

- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    [self showDebugLog:[NSString stringWithFormat:@"%s",__FUNCTION__]];
}

- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    [self showDebugLog:[NSString stringWithFormat:@"%s",__FUNCTION__]];
}

- (void)showDebugLog:(NSString *)message {
    if (_isShowLog) {
        NSLog(@"%@", message);
    }
}

@end
