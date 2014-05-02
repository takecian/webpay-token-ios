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
- (void)didSelectExpiryYear:(NSString *)year month:(NSString *)month;
@end

@implementation WPYExpiryField

#pragma mark initialization
- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text
{
    if (self = [super initWithFrame:frame text:text])
    {
        WPYExpiryPickerView *expiryPicker = [[WPYExpiryPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        expiryPicker.expiryDelegate = self;
        
        WPYExpiryAccessoryView *accessoryView = [[WPYExpiryAccessoryView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 44)];
        accessoryView.delegate = self;
        
        _textField = [[WPYMenuDisabledTextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _textField.placeholder = @"01 / 15";
        if (isiOS7())
        {
            _textField.tintColor = [UIColor clearColor]; // hide cursor
        }
        _textField.inputView = expiryPicker;
        _textField.inputAccessoryView = accessoryView;
        _textField.delegate = self;
        
        [self setupTextField];
        [self setText:text];
        [self addSubview:_textField];
    }
    return self;
}



#pragma mark override methods
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



#pragma mark expiry picker delegate
- (void)didSelectExpiryYear:(NSString *)year month:(NSString *)month
{
    NSString *expiry = [NSString stringWithFormat:@"%@ / %@", month, year];
    self.textField.text = expiry;
    [self textFieldDidChange:self.textField];
}



#pragma mark expiry accessory view delegate
- (void)doneButtonTapped
{
    [self.textField resignFirstResponder];
}

@end