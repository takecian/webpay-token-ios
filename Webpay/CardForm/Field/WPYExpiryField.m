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
#import "WPYCreditCard.h"
#import "WPYConstants.h"

@interface WPYExpiryField () <UITextFieldDelegate, WPYExpiryPickerViewDelegate, WPYExpiryAccessoryViewDelegate>
@property(nonatomic, strong) WPYExpiryPickerView *expiryPickerView;
@property(nonatomic, strong) UIImageView *checkMarkView;
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
    
    if (isiOS7())
    {
//        textField.tintColor = [UIColor clearColor]; // hide cursor
    }
    textField.inputView = self.expiryPickerView;
    textField.inputAccessoryView = accessoryView;
    
    self.checkMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [self.checkMarkView setImage:[UIImage imageNamed:@"checkmark"]];
    self.checkMarkView.hidden = YES;
    
    textField.rightView = self.checkMarkView;
    textField.rightViewMode = UITextFieldViewModeAlways;
    
    textField.delegate = self;
        
    return textField;
}

- (WPYFieldKey)key
{
    return WPYExpiryFieldKey;
}

- (BOOL)shouldValidateOnFocusLost
{
    NSString *expiry = self.textField.text;
    return expiry.length == 9; // don't valid if both not selected
}

- (BOOL)validate:(NSError * __autoreleasing *)error
{
    NSString *expiry = self.textField.text;
    NSInteger month = [[expiry substringToIndex:2] integerValue];
    NSInteger year = [[expiry substringFromIndex:5] integerValue];
    
    WPYCreditCard *creditCard = [[WPYCreditCard alloc] init];
    
    return [creditCard validateExpiryYear:year month:month error:error];
}

- (void)updateValidityView:(BOOL)valid
{
    self.checkMarkView.hidden = !valid;
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
    self.textField.text = [self.expiryPickerView selectedExpiry];
    [self textFieldDidChange:self.textField];
}

@end