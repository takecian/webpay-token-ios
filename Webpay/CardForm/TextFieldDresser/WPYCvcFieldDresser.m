//
//  WPYCvcFieldDresser.m
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYCvcFieldDresser.h"

@implementation WPYCvcFieldDresser

- (void)dressTextField:(UITextField *)textField
{
    textField.placeholder = @"123";
    textField.keyboardType = UIKeyboardTypeNumberPad;
}

@end
