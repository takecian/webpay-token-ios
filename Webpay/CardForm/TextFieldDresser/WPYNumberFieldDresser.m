//
//  WPYNumberFieldDresser.m
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYNumberFieldDresser.h"

@implementation WPYNumberFieldDresser

- (void)dressTextField:(UITextField *)textField
{
    textField.placeholder = @"1234 5678 9012 3456";
    textField.keyboardType = UIKeyboardTypeNumberPad;
}
@end
