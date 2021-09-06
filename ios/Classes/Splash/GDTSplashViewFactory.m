//
//  GDTSplashViewFactory.m
//  gdt_ads_flutter
//
//  Created by 爱互动 on 2021/9/2.
//

#import <Foundation/Foundation.h>
#import "GDTSplashView.h"
#import "GDTSplashViewFactory.h"

@implementation GDTSplashViewFactory{
    NSObject<FlutterBinaryMessenger> *_messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messager {
    self = [super init];
    if (self) {
        _messenger = messager;
    }
    return self;
}

//设置参数的编码方式
- (NSObject<FlutterMessageCodec>*)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}

- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    //args 为flutter 传过来的参数
    GDTSplashView *splashView = [[GDTSplashView alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return splashView;
}

@end
