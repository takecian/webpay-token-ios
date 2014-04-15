//
//  WPYNameFieldDresser.m
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYNameFieldDresser.h"

@implementation WPYNameFieldDresser

- (void)dressTextField:(UITextField *)textField
{
    textField.placeholder = @"Taro Yamada";
    textField.keyboardType = UIKeyboardTypeASCIICapable;
}

@end
