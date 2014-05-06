//
//  WPYCvcField.m
//  Webpay
//
//  Created by yohei on 4/16/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYCvcField.h"

#import "WPYCvcFieldModel.h"

@interface WPYCvcField () <UITextFieldDelegate>
@end

@implementation WPYCvcField


#pragma mark initialization
- (UITextField *)createTextFieldWithFrame:(CGRect)frame
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    textField.placeholder = @"123";
    textField.secureTextEntry = YES;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    
    textField.delegate = self;
    
    return textField;
}

- (UIImageView *)createRightView
{
    UIImageView *checkMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [checkMarkView setImage:[UIImage imageNamed:@"question"]];
    
    return checkMarkView;
}

- (WPYAbstractFieldModel *)createFieldModelWithCard:(WPYCreditCard *)card
{
    return [[WPYCvcFieldModel alloc] initWithCard:card];
}



#pragma mark textField
- (void)textFieldDidFocus
{
    [self.rightView setImage:[UIImage imageNamed:@"question"]];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *newValue = [textField.text stringByReplacingCharactersInRange:range withString:replacementString];
    
    return [self.model canInsertNewValue:newValue];
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