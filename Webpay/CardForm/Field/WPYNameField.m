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

#pragma mark override methods
- (UITextField *)createTextFieldWithFrame:(CGRect)frame
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    textField.placeholder = @"Taro Yamada";
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.delegate = self;
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    return textField;
}

- (UIImageView *)createRightView
{
    UIImageView *checkMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [checkMarkView setImage:[UIImage imageNamed:@"checkmark"]];
    checkMarkView.hidden = YES;
    
    return checkMarkView;
}

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

- (void)updateValidityView:(BOOL)valid
{
    self.rightView.hidden = !valid;
}

@end