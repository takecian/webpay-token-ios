//
//  WPYDeviceSettings.h
//  Webpay
//
//  Created by yohei on 5/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPYDeviceSettings : NSObject
+ (BOOL)isiOS8;
+ (BOOL)isiOS7;
+ (NSString *)preferredLanguage;
+ (BOOL)isJapanese;
+ (NSString *)osVersion;
+ (NSString *)device;
@end
