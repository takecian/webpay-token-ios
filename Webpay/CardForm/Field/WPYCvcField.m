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

static NSInteger const WPYCvcMaxDigits = 4;

@implementation WPYCvcField

#pragma mark override methods
- (UITextField *)createTextFieldWithFrame:(CGRect)frame
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    textField.placeholder = @"123";
    textField.secureTextEntry = YES;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    
    textField.delegate = self;
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    return textField;
}

- (UIImageView *)createRightView
{
    UIImageView *checkMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [checkMarkView setImage:[UIImage imageNamed:@"question"]];
    
    return checkMarkView;
}

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

- (BOOL)canInsertNewValue:(NSString *)newValue place:(NSUInteger)place charactedDeleted:(BOOL)isCharacterDeleted
{
    return NO; //workaround for stop clearing text when refocused
}

- (void)updateValue:(NSString *)newValue place:(NSUInteger)place charactedDeleted:(BOOL)isCharacterDeleted
{
    if (newValue.length > WPYCvcMaxDigits)
    {
        return;
    }
    self.textField.text = newValue;
    [self textFieldDidChange:self.textField];
}

- (void)updateValidityView:(BOOL)valid
{
    if (valid)
    {
        [self.rightView setImage:[UIImage imageNamed:@"checkmark"]];
    }
    else
    {
        [self.rightView setImage:[UIImage imageNamed:@"question"]];
    }
}



#pragma mark cvc info
- (void)showCvcInfoView:(id)sender
{
    // create overlay
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIView *overlay = [[UIView alloc] initWithFrame: screenRect];
    overlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview: overlay];
}
@end