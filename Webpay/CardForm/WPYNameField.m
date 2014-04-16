//
//  WPYNameField.m
//  Webpay
//
//  Created by yohei on 4/16/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYNameField.h"

@interface WPYNameField () <UITextFieldDelegate>
@end

@implementation WPYNameField
{
    UITextField *_nameField;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _nameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _nameField.placeholder = @"Taro Yamada";
        _nameField.keyboardType = UIKeyboardTypeASCIICapable;
        _nameField.autocorrectionType = UITextAutocorrectionTypeNo;
        _nameField.delegate = self;
        
        [self addSubview:_nameField];
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
