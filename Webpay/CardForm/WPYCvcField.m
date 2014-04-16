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
{
    UITextField *_cvcField;
}

static NSInteger const WPYCvcMaxValue = 4;

#pragma mark initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _cvcField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _cvcField.placeholder = @"123";
        _cvcField.keyboardType = UIKeyboardTypeNumberPad;
        _cvcField.delegate = self;
        
        [self addSubview:_cvcField];
    }
    return self;
}

- (NSString *)text
{
    return _cvcField.text;
}

#pragma mark textfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *newValue = [textField.text stringByReplacingCharactersInRange:range withString:replacementString];
    return newValue.length <= WPYCvcMaxValue;
}

@end
