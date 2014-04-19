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

- (BOOL)shouldValidate
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
}

@end