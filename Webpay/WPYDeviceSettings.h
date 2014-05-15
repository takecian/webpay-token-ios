//
//  WPYDeviceSettings.h
//  Webpay
//
//  Created by yohei on 5/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPYDeviceSettings : NSObject
+ (NSString *)preferredLanguage;
+ (BOOL)isJapanese;
@end
