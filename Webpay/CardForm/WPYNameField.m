//
//  WPYNameField.m
//  Webpay
//
//  Created by yohei on 4/16/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYNameField.h"

#import "WPYCreditCard.h"

@interface WPYNameField () <UITextFieldDelegate>
@end

@implementation WPYNameField

#pragma mark initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _textField.placeholder = @"Taro Yamada";
        _textField.keyboardType = UIKeyboardTypeASCIICapable;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.delegate = self;
        
        [self addSubview:_textField];
    }
    return self;
}


#pragma mark
- (WPYFieldKey)key
{
    return WPYNameFieldKey;
}



#pragma mark textfield delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *name = self.textField.text;
    if (name.length == 0)
    {
        return;
    }
    
    WPYCreditCard *creditCard = [[WPYCreditCard alloc] init];
    NSError *error = nil;
    if ([creditCard validateName:&name error:&error])
    {
        [self notifySuccess];
    }
    else
    {
        [self notifyError:error];
    }
}

@end