//
//  WPYCvcField.m
//  Webpay
//
//  Created by yohei on 4/16/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYCvcField.h"

@interface WPYCvcField () <UITextFieldDelegate>
@end

@implementation WPYCvcField

static NSInteger const WPYCvcMaxValue = 4;

#pragma mark initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.placeholder = @"123";
        self.keyboardType = UIKeyboardTypeNumberPad;
        self.delegate = self;
    }
    return self;
}


#pragma mark textfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *newValue = [textField.text stringByReplacingCharactersInRange:range withString:replacementString];
    return newValue.length <= WPYCvcMaxValue;
}

@end
