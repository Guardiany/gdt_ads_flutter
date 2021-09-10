//
//  GdtAdsRewardVideo.m
//  gdt_ads_flutter
//
//  Created by 爱互动 on 2021/9/9.
//

#import <Foundation/Foundation.h>
#import "GdtAdsRewardVideo.h"
#import "GdtAdsFlutterPlugin.h"
#import "GdtFlutterEvent.h"
#import "GDTRewardVideoAd.h"

@interface GdtAdsRewardVideo () <GDTRewardedVideoAdDelegate>

@property (nonatomic, strong) GDTRewardVideoAd *rewardVideoAd;

@end

@implementation GdtAdsRewardVideo {
    BOOL _isShowLog;
    BOOL autoShowAd;
    NSDictionary *dic;
}

+ (GdtAdsRewardVideo *)instance {
    static GdtAdsRewardVideo* instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self.class alloc] init];
    });
    return instance;
}

- (void)loadAndShowRewardVideo:(NSDictionary *)args {
    autoShowAd = true;
    dic = args;
    NSString *placementId = dic[@"placementId"];
    NSNumber *isShowLog = dic[@"isShowLog"];
    _isShowLog = [isShowLog boolValue];
    NSNumber *videoMutedNum = dic[@"videoMuted"];
    BOOL videoMuted = [videoMutedNum boolValue];
    self.rewardVideoAd = [[GDTRewardVideoAd alloc] initWithPlacementId:placementId];
    self.rewardVideoAd.delegate = self;
    // 设置激励视频是否静音
    self.rewardVideoAd.videoMuted = videoMuted;
    [self.rewardVideoAd loadAd];
}

- (void)loadRewardVideoWithArgs:(NSDictionary *)args {
    autoShowAd = false;
    dic = args;
    NSString *placementId = dic[@"placementId"];
    NSNumber *isShowLog = dic[@"isShowLog"];
    _isShowLog = [isShowLog boolValue];
    NSNumber *videoMutedNum = dic[@"videoMuted"];
    BOOL videoMuted = [videoMutedNum boolValue];
    self.rewardVideoAd = [[GDTRewardVideoAd alloc] initWithPlacementId:placementId];
    self.rewardVideoAd.delegate = self;
    // 设置激励视频是否静音
    self.rewardVideoAd.videoMuted = videoMuted;
    [self.rewardVideoAd loadAd];
}

- (void)showRewardVideo{
    if (self.rewardVideoAd.isAdValid) {
        UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
        [self.rewardVideoAd showAdFromRootViewController:rootViewController];
    } else {
        if (dic != nil) {
            [self loadAndShowRewardVideo:dic];
        }
    }
}

- (void)showDebugLog:(NSString *)message {
    if (_isShowLog) {
        NSLog(@"%@", message);
    }
}

#pragma mark - GDTRewardVideoAdDelegate

- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    NSString *errorString = @"";
    if (error.code == 4014) {
        errorString = @"请拉取到广告后再调用展示接口";
    } else if (error.code == 4016) {
        errorString = @"应用方向与广告位支持方向不一致";
    } else if (error.code == 5012) {
        errorString = @"广告已过期";
    } else if (error.code == 4015) {
        errorString = @"广告已经播放过，请重新拉取";
    } else if (error.code == 5002) {
        errorString = @"视频下载失败";
    } else if (error.code == 5003) {
        errorString = @"视频播放失败";
    } else if (error.code == 5004) {
        errorString = @"没有合适的广告";
    } else if (error.code == 5013) {
        errorString = @"请求太频繁，请稍后再试";
    } else if (error.code == 3002) {
        errorString = @"网络连接超时";
    } else if (error.code == 5027) {
        errorString = @"页面加载失败";
    } else {
        errorString = [NSString stringWithFormat:@"未知错误 (errorCode=%ld)", (long)error.code];
    }
    [self showDebugLog:errorString];
    NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:@"rewardAd", @"adType", @"onError", @"method", errorString, @"errorMessage", nil];
    [ad_event sendEvent:result];
}

- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd {
    [self showDebugLog:@"广告数据加载成功"];
    NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:@"rewardAd", @"adType", @"onLoad", @"method", nil];
    [ad_event sendEvent:result];
    if (autoShowAd) {
        [self showRewardVideo];
    }
}

- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd {
    [self showDebugLog:@"视频文件加载成功"];
    NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:@"rewardAd", @"adType", @"onFileLoad", @"method", nil];
    [ad_event sendEvent:result];
}

- (void)gdt_rewardVideoAdWillVisible:(GDTRewardVideoAd *)rewardedVideoAd {
    [self showDebugLog:@"视频播放页即将打开"];
    NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:@"rewardAd", @"adType", @"onWillVisible", @"method", nil];
    [ad_event sendEvent:result];
}

- (void)gdt_rewardVideoAdDidExposed:(GDTRewardVideoAd *)rewardedVideoAd {
    [self showDebugLog:@"广告已曝光"];
    NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:@"rewardAd", @"adType", @"onShow", @"method", nil];
    [ad_event sendEvent:result];
}

- (void)gdt_rewardVideoAdDidClose:(GDTRewardVideoAd *)rewardedVideoAd {
    [self showDebugLog:@"广告已关闭"];
    NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:@"rewardAd", @"adType", @"onClosed", @"method", nil];
    [ad_event sendEvent:result];
}

- (void)gdt_rewardVideoAdDidClicked:(GDTRewardVideoAd *)rewardedVideoAd {
    [self showDebugLog:@"广告已点击"];
    NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:@"rewardAd", @"adType", @"onClick", @"method", nil];
    [ad_event sendEvent:result];
}

- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd info:(NSDictionary *)info {
    [self showDebugLog:[NSString stringWithFormat:@"播放达到激励条件 transid:%@", [info objectForKey:@"GDT_TRANS_ID"]]];
    NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:@"rewardAd", @"adType", @"onReward", @"method", nil];
    [ad_event sendEvent:result];
}

- (void)gdt_rewardVideoAdDidPlayFinish:(GDTRewardVideoAd *)rewardedVideoAd {
    [self showDebugLog:@"视频播放结束"];
    NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:@"rewardAd", @"adType", @"onFinish", @"method", nil];
    [ad_event sendEvent:result];
}

@end
