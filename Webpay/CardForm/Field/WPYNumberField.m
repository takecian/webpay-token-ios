//
//  WPYNumberField.m
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYNumberField.h"

#import "WPYTextField.h"
#import "WPYCreditCard.h"
#import "WPYNumberFieldModel.h"


@interface WPYNumberField () <UITextFieldDelegate>
@end

@implementation WPYNumberField

#pragma mark initialization
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

- (WPYAbstractFieldModel *)createFieldModelWithCard:(WPYCreditCard *)card
{
    return [[WPYNumberFieldModel alloc] initWithCard:card];
}



#pragma mark
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *newValue = [textField.text stringByReplacingCharactersInRange:range withString:replacementString];
    BOOL isCharacterDeleted = replacementString.length == 0;
    
    if ([self.model canInsertNewValue:newValue])
    {
        [self setText:[WPYNumberFieldModel reformatNumber:newValue isDeleted:isCharacterDeleted]];
        [self updateBrand];
    }
    
    return NO;
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
    UIImage *brandLogo = [WPYNumberFieldModel brandLogoFromNumber: self.textField.text];
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