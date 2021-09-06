//
//  RewardVideoView.h
//  gdt_ads_flutter
//
//  Created by 爱互动 on 2021/9/3.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface RewardVideoView : NSObject<FlutterPlatformView>

-(instancetype)initWithFrame:(CGRect)frame
                  viewIdentifier:(int64_t)viewId
                       arguments:(id _Nullable)args
                 binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@property UIWindow *container;

@end

NS_ASSUME_NONNULL_END
