//
//  WPYTextFieldDresser.h
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WPYCardFormViewConstants.h"

@interface WPYTextFieldDresser : NSObject
+ (WPYTextFieldDresser *)dresserFromType:(WPYCardFormFieldType)type;
- (void)dressTextField:(UITextField *)textField;
@end
