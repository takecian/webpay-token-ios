//
//  WPYTextFieldDresser.m
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYTextFieldDresser.h"

// textfield dresser subclasses
#import "WPYNumberFieldDresser.h"
#import "WPYExpiryFieldDresser.h"
#import "WPYCvcFieldDresser.h"
#import "WPYNameFieldDresser.h"

@implementation WPYTextFieldDresser

+ (WPYTextFieldDresser *)dresserFromType:(WPYCardFormFieldType)type
{
    switch (type)
    {
        case WPYNumberField:
            return [[WPYNumberFieldDresser alloc] init];
            
        case WPYExpiryField:
            return [[WPYExpiryFieldDresser alloc] init];
            
        case WPYCvcField:
            return [[WPYCvcFieldDresser alloc] init];
            
        case WPYNameField:
            return [[WPYNameFieldDresser alloc] init];
    }
}

- (void)dressTextField:(UITextField *)textField
{
    nil;
}

@end
