//
//  WPYNameField.m
//  Webpay
//
//  Created by yohei on 4/16/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYNameField.h"

#import "WPYTextField.h"
#import "WPYNameFieldModel.h"

@interface WPYNameField () <UITextFieldDelegate>
@end

@implementation WPYNameField

#pragma mark override methods
- (UITextField *)createTextFieldWithFrame:(CGRect)frame
{
    UITextField *textField = [[WPYTextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    textField.placeholder = @"Taro Yamada";
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [textField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents: UIControlEventEditingChanged];
    textField.delegate = self;
    
    return textField;
}

- (UIImageView *)createRightView
{
    UIImageView *checkMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [checkMarkView setImage:[UIImage imageNamed:@"checkmark"]];
    checkMarkView.hidden = YES;
    
    return checkMarkView;
}

- (WPYAbstractFieldModel *)createFieldModelWithCard:(WPYCreditCard *)card
{
    return [[WPYNameFieldModel alloc] initWithCard:card];
}

- (void)textFieldDidFocus
{
    self.rightView.hidden = YES;
}

- (void)updateValidityView:(BOOL)valid
{
    self.rightView.hidden = !valid;
}

@end