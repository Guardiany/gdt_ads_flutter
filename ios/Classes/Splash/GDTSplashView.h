//
//  GDTSplashView.h
//  Pods
//
//  Created by 爱互动 on 2021/9/2.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "GDTSplashAd.h"

NS_ASSUME_NONNULL_BEGIN

@interface GDTSplashView : NSObject<FlutterPlatformView>

-(instancetype)initWithWithFrame:(CGRect)frame
                  viewIdentifier:(int64_t)viewId
                       arguments:(id _Nullable)args
                 binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@property UIWindow *container;

@end

NS_ASSUME_NONNULL_END
