//
//  GdtFlutterEvent.h
//  gdt_ads_flutter
//
//  Created by 爱互动 on 2021/9/9.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface GdtFlutterEvent : NSObject<FlutterStreamHandler>

- (instancetype)initWithRegistrar: (NSObject<FlutterPluginRegistrar>*)registrar;

- (void)sendEvent:(NSDictionary *)event;

@end
