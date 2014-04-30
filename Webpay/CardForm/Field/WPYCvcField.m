//
//  WPYCvcField.m
//  Webpay
//
//  Created by yohei on 4/16/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYCvcField.h"

#import "WPYCreditCard.h"

@interface WPYCvcField () <UITextFieldDelegate>
@end

static NSInteger const WPYCvcMaxValue = 4;

@implementation WPYCvcField
#pragma mark initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _textField.placeholder = @"123";
        _textField.secureTextEntry = YES;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        [self addSubview:_textField];
    }
    return self;
}



#pragma mark
- (WPYFieldKey)key
{
    return WPYCvcFieldKey;
}

- (BOOL)shouldValidateOnFocusLost
{
    NSString *cvc = self.textField.text;
    return cvc.length != 0; // don't validiate if length is 0
}

- (BOOL)validate:(NSError * __autoreleasing *)error
{
    NSString *cvc = self.textField.text;
    WPYCreditCard *creditCard = [[WPYCreditCard alloc] init];
    
    return [creditCard validateCvc:&cvc error:error];
}


#pragma mark textfield delegate
- (BOOL)canInsertNewValue:(NSString *)newValue place:(NSUInteger)place charactedDeleted:(BOOL)isCharacterDeleted
{
    return newValue.length <= WPYCvcMaxValue;
}


@end