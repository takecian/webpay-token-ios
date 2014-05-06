//
//  WPYExpiryField.m
//  Webpay
//
//  Created by yohei on 4/16/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYExpiryField.h"

#import "WPYExpiryPickerView.h"
#import "WPYExpiryAccessoryView.h"
#import "WPYMenuDisabledTextField.h"
#import "WPYExpiryFieldModel.h"
#import "WPYConstants.h"

@interface WPYExpiryField () <UITextFieldDelegate, WPYExpiryPickerViewDelegate, WPYExpiryAccessoryViewDelegate>
@property(nonatomic, strong) WPYExpiryPickerView *expiryPickerView;
@end

@implementation WPYExpiryField



#pragma mark override methods
- (UITextField *)createTextFieldWithFrame:(CGRect)frame
{
    self.expiryPickerView = [[WPYExpiryPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    self.expiryPickerView.expiryDelegate = self;
        
    WPYExpiryAccessoryView *accessoryView = [[WPYExpiryAccessoryView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 44)];
    accessoryView.delegate = self;
        
    UITextField *textField = [[WPYMenuDisabledTextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    textField.placeholder = @"01 / 2018";
    
    textField.inputView = self.expiryPickerView;
    textField.inputAccessoryView = accessoryView;
    
    textField.delegate = self;
        
    return textField;
}

- (UIImageView *)createRightView
{
    UIImageView *checkMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [checkMarkView setImage:[UIImage imageNamed:@"checkmark"]];
    checkMarkView.hidden = YES;
    
    return checkMarkView;
}

- (WPYAbstractFieldModel *)createFieldModelWithCard:(WPYCreditCard *)card
{
    return [[WPYExpiryFieldModel alloc] initWithCard:card];
}



#pragma mark textfield
- (void)updateValidityView:(BOOL)valid
{
    self.rightView.hidden = !valid;
}

- (void)textFieldDidFocus
{
    self.rightView.hidden = YES;
}

- (void)textFieldWillLoseFocus
{
    [self setExpiry:[self.expiryPickerView selectedExpiry]];
}



#pragma mark expiry picker delegate
- (void)didSelectExpiryYear:(NSString *)year month:(NSString *)month
{
    NSString *expiry = [NSString stringWithFormat:@"%@ / %@", month, year];
    [self setExpiry:expiry];
}



#pragma mark expiry accessory view delegate
- (void)doneButtonTapped
{
    [self setExpiry:[self.expiryPickerView selectedExpiry]];
    [self.textField resignFirstResponder];
}



#pragma mark private methods
- (void)setExpiry:(NSString *)expiry
{
    [self setText:expiry];
}

@end