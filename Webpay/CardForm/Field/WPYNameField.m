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
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        [self addSubview:_textField];
    }
    return self;
}


#pragma mark override methods
- (WPYFieldKey)key
{
    return WPYNameFieldKey;
}

- (BOOL)shouldValidateOnFocusLost
{
    NSString *name = self.textField.text;
    return name.length != 0; // don't valididate if length is 0
}

- (BOOL)validate:(NSError * __autoreleasing *)error
{
    NSString *name = self.textField.text;
    WPYCreditCard *creditCard = [[WPYCreditCard alloc] init];
    
    return [creditCard validateName:&name error:error];
}

@end