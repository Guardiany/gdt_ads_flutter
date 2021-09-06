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
@end

@implementation GDTSplashView {
    int64_t _viewId;
    UILabel * _uiLabel;
    FlutterMethodChannel* _channel;
}

- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
    if ([super init]) {
        if (frame.size.width == 0) {
            frame = CGRectMake(frame.origin.x, frame.origin.y, [UIScreen mainScreen].bounds.size.width, 50);
        }
    }
    
    NSDictionary *dic = args;
    NSString *content = dic[@"content"];
    
    self.container = [[UIView alloc] initWithFrame:frame];
    [self loadSplash:content];
    
//    _uiLabel = [[UILabel alloc] initWithFrame:frame];
//    _uiLabel.textColor = [UIColor redColor];
//    if (content != nil) {
//        _uiLabel.text = content;
//    } else {
//        _uiLabel.text = @"原生的textview";
//    }
//    _uiLabel.font = [UIFont systemFontOfSize:20];
//    _uiLabel.textAlignment = NSTextAlignmentCenter;
//    _uiLabel.backgroundColor = [UIColor grayColor];
//    _viewId = viewId;
    return self;
}

- (nonnull UIView *)view {
    return _uiLabel;
}

-(void)loadSplash: (NSString*)content {
    [self.container removeFromSuperview];
    GDTSplashAd *splash = [[GDTSplashAd alloc] initWithPlacementId:content];
    splash.delegate = self;
    //开屏拉取时间，超时则放弃展示
    splash.fetchDelay = 3;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [self.container addSubview:window];
    [splash showFullScreenAdInWindow:window withLogoImage:nil skipView:nil];
}

- (void)splashAdDidLoad:(GDTSplashAd *)splashAd {
    NSLog(@"广告拉取成功");
}

- (void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    NSLog(@"广告展示成功");
}

- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    NSLog(@"广告展示失败%s%@",__FUNCTION__,error);
}

- (void)splashAdExposured:(GDTSplashAd *)splashAd
{
    NSLog(@"广告已曝光");
}

- (void)splashAdClicked:(GDTSplashAd *)splashAd
{
    if (splashAd.splashZoomOutView) {
        [splashAd.splashZoomOutView removeFromSuperview];
    }
    NSLog(@"广告已点击");
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdWillClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"广告关闭");
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd
{
     NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd
{
     NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

@end
