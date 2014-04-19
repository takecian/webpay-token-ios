//
//  WPYExpiryField.m
//  Webpay
//
//  Created by yohei on 4/16/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYExpiryField.h"

#import "WPYExpiryPickerView.h"
#import "WPYMenuDisabledTextField.h"
#import "WPYCreditCard.h"

@interface WPYExpiryField () <UITextFieldDelegate, WPYExpiryPickerViewDelegate>
- (void)didSelectExpiryYear:(NSString *)year month:(NSString *)month;
@end

@implementation WPYExpiryField

#pragma mark initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        WPYExpiryPickerView *expiryPicker = [[WPYExpiryPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        expiryPicker.expiryDelegate = self;
        
        _textField = [[WPYMenuDisabledTextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _textField.placeholder = @"01 / 15";
        _textField.tintColor = [UIColor clearColor]; // hide cursor
        _textField.inputView = expiryPicker;
        _textField.delegate = self;
        
        [self addSubview:_textField];
    }
    return self;
}



#pragma mark
- (WPYFieldKey)key
{
    return WPYExpiryFieldKey;
}



#pragma mark expiry picker delegate
- (void)didSelectExpiryYear:(NSString *)year month:(NSString *)month
{
    NSString *expiry = [NSString stringWithFormat:@"%@ / %@", month, year];
    self.textField.text = expiry;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *expiry = textField.text;
    if (expiry.length != 9) // don't validate if not both selected
    {
        return;
    }
    
    NSError *error = nil;
    WPYCreditCard *creditCard = [[WPYCreditCard alloc] init];
    NSInteger month = [[expiry substringToIndex:2] integerValue];
    NSInteger year = [[expiry substringFromIndex:5] integerValue];
    if ([creditCard validateExpiryYear:year month:month error:&error])
    {
        [self notifySuccess];
    }
    else
    {
        [self notifyError:error];
    }
}

@end