//
//  WPYNumberField.m
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYNumberField.h"

#import "WPYTextField.h"
#import "WPYNumberFieldModel.h"


@interface WPYNumberField () <UITextFieldDelegate>
@end

@implementation WPYNumberField

#pragma mark override methods
- (UITextField *)createTextFieldWithFrame:(CGRect)frame
{
    WPYTextField *textField = [[WPYTextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    textField.placeholder = @"1234 5678 9012 3456";
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.delegate = self;
    
    return textField;
}

- (UIImageView *)createRightView
{
    UIImageView *brandView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    return brandView;
}

// public setter
// This setter will add spaces per group of text
// handling deleted character requires a different setter just assigning value and firing events.
- (void)setText:(NSString *)text
{
    if (text)
    {
        NSString *paddedNumber = [WPYNumberFieldModel addPaddingToNumber:text];
        [self setNumber:paddedNumber];
    }
}

// private setter just assigning number
- (void)setNumber:(NSString *)number
{
    self.textField.text = number;
    [self textFieldDidChange:self.textField];
}

- (NSString *)text
{
    return [WPYNumberFieldModel removeAllWhitespaces:self.textField.text];
}

- (WPYFieldKey)key
{
    return WPYNumberFieldKey;
}

- (BOOL)shouldValidateOnFocusLost
{
    return [WPYNumberFieldModel shouldValidateWithText:[self text]];
}

- (BOOL)validate:(NSError * __autoreleasing *)error
{
    return [WPYNumberFieldModel validateNumber:[self text] error:error];
}

- (BOOL)canInsertNewValue:(NSString *)newValue place:(NSUInteger)place charactedDeleted:(BOOL)isCharacterDeleted
{
    // intercept values to add/remove spaces
    return NO;
}

- (void)updateValue:(NSString *)newValue place:(NSUInteger)place charactedDeleted:(BOOL)isCharacterDeleted
{
    NSString *spacedNumber = [WPYNumberFieldModel spacedNumberFromTextFieldValue:newValue place:place deleted:isCharacterDeleted];
    [self setNumber:spacedNumber];
    
    [self updateBrand];
}

// called at textdidediting. Brand logo will be displayed if prefix matches any brand
// if validation fails, hide logo
- (void)updateValidityView:(BOOL)valid
{
    if (!valid)
    {
        [self hideBrandLogo];
    }
}



#pragma mark brand animation
// brand logo also work as checkmark.
- (void)updateBrand
{
    UIImage *brandLogo = [WPYNumberFieldModel brandLogoFromNumber:[self text]];
    if (brandLogo)
    {
        [self showBrandLogo:brandLogo];
    }
    else
    {
        [self hideBrandLogo];
    }
}

- (void)showBrandLogo:(UIImage *)logo
{
    self.rightView.hidden = NO;
    [self.rightView setImage:logo];
}

- (void)hideBrandLogo
{
    self.rightView.hidden = YES;
}

@end