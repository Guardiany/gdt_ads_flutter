//
//  GdtAdsRewardVideo.h
//  gdt_ads_flutter
//
//  Created by 爱互动 on 2021/9/9.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "GdtFlutterEvent.h"

@interface GdtAdsRewardVideo : NSObject

extern GdtFlutterEvent *ad_event;

+ (GdtAdsRewardVideo *)instance;

- (void)loadAndShowRewardVideo:(NSDictionary *)args;

- (void)loadRewardVideoWithArgs:(NSDictionary *)args;

- (void)showRewardVideo;

@end
