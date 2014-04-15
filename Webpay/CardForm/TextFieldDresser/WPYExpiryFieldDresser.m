//
//  WPYExpiryFieldDresser.m
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYExpiryFieldDresser.h"

#import "WPYExpiryPickerView.h"

@implementation WPYExpiryFieldDresser

- (void)dressTextField:(UITextField *)textField
{
    textField.placeholder = @"01/15";
    
    WPYExpiryPickerView *expiryPicker = [[WPYExpiryPickerView alloc] init];
    textField.inputView = expiryPicker;
}

@end
