//
//  RewardVideoView.m
//  gdt_ads_flutter
//
//  Created by 爱互动 on 2021/9/3.
//

#import <Foundation/Foundation.h>
#import "RewardVideoView.h"
#import "GDTRewardVideoAd.h"

@interface RewardVideoView () <GDTRewardedVideoAdDelegate>

@property (nonatomic, strong) GDTRewardVideoAd *rewardVideoAd;

@end

@implementation RewardVideoView{
    int64_t _viewId;
    FlutterMethodChannel* _channel;
    BOOL _isShowLog;
    BOOL _videoMuted;
}

- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
    
    NSString *methodName = [NSString stringWithFormat:@"com.ahd.reward_video_%lld", viewId];
    _channel = [FlutterMethodChannel methodChannelWithName:methodName binaryMessenger:messenger];
    
    NSDictionary *dic = args;
    NSString *placementId = dic[@"placementId"];
    NSNumber *isShowLog = dic[@"isShowLog"];
    _isShowLog = [isShowLog boolValue];
    NSNumber *videoMuted = dic[@"videoMuted"];
    _videoMuted = [videoMuted boolValue];
    
    self.container = [[UIWindow alloc] initWithFrame:frame];
    self.container.rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    
    [self loadVideo:placementId];
    
    _viewId = viewId;
    return self;
}

-(void) loadVideo: (NSString*)content {
    self.rewardVideoAd = [[GDTRewardVideoAd alloc] initWithPlacementId:content];
    self.rewardVideoAd.delegate = self;
    // 设置激励视频是否静音
    self.rewardVideoAd.videoMuted = _videoMuted;
    [self.rewardVideoAd loadAd];
}

- (nonnull UIView *)view {
    return self.container;
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
    [_channel invokeMethod:@"error" arguments:errorString];
}

- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd {
    [self showDebugLog:@"广告数据加载成功"];
    [_channel invokeMethod:@"onLoad" arguments:nil];
    if (!self.rewardVideoAd.isAdValid) {
        [_channel invokeMethod:@"error" arguments:@"广告失效，请重新拉取"];
        return;
    }
    [self.rewardVideoAd showAdFromRootViewController:self.container.rootViewController];
}

- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd {
    [self showDebugLog:@"视频文件加载成功"];
    [_channel invokeMethod:@"onFileLoad" arguments:nil];
}

- (void)gdt_rewardVideoAdWillVisible:(GDTRewardVideoAd *)rewardedVideoAd {
    [self showDebugLog:@"视频播放页即将打开"];
    [_channel invokeMethod:@"onWillVisible" arguments:nil];
}

- (void)gdt_rewardVideoAdDidExposed:(GDTRewardVideoAd *)rewardedVideoAd {
    [self showDebugLog:@"广告已曝光"];
    [_channel invokeMethod:@"onShow" arguments:nil];
}

- (void)gdt_rewardVideoAdDidClose:(GDTRewardVideoAd *)rewardedVideoAd {
    [self showDebugLog:@"广告已关闭"];
    [_channel invokeMethod:@"onClosed" arguments:nil];
}

- (void)gdt_rewardVideoAdDidClicked:(GDTRewardVideoAd *)rewardedVideoAd {
    [self showDebugLog:@"广告已点击"];
    [_channel invokeMethod:@"onClick" arguments:nil];
}

- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd info:(NSDictionary *)info {
    [self showDebugLog:[NSString stringWithFormat:@"播放达到激励条件 transid:%@", [info objectForKey:@"GDT_TRANS_ID"]]];
    [_channel invokeMethod:@"onReward" arguments:nil];
}

- (void)gdt_rewardVideoAdDidPlayFinish:(GDTRewardVideoAd *)rewardedVideoAd {
    [self showDebugLog:@"视频播放结束"];
    [_channel invokeMethod:@"onFinish" arguments:nil];
}

- (void)showDebugLog:(NSString *)message {
    if (_isShowLog) {
        NSLog(@"%@", message);
    }
}

@end
