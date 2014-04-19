//
//  WPYCvcField.m
//  Webpay
//
//  Created by yohei on 4/16/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYCvcField.h"

#import "WPYCreditCard.h"

@interface WPYCvcField () <UITextFieldDelegate>
@end

static NSInteger const WPYCvcMaxValue = 4;

@implementation WPYCvcField
#pragma mark initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _textField.placeholder = @"123";
        _textField.secureTextEntry = YES;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.delegate = self;
        
        [self addSubview:_textField];
    }
    return self;
}



#pragma mark
- (WPYFieldKey)key
{
    return WPYCvcFieldKey;
}



#pragma mark textfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *newValue = [textField.text stringByReplacingCharactersInRange:range withString:replacementString];
    return newValue.length <= WPYCvcMaxValue;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *cvc = textField.text;
    if (cvc.length == 0) // don't validate if cvc is not filled
    {
        return;
    }
    
    WPYCreditCard *creditCard = [[WPYCreditCard alloc] init];
    NSError *error = nil;
    if ([creditCard validateCvc:&cvc error:&error])
    {
        [self notifySuccess];
    }
    else
    {
        [self notifyError:error];
    }
}

@end