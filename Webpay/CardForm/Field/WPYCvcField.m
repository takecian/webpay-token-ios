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
@property(nonatomic) BOOL isFirstEdit;
@end

@implementation WPYCvcField


#pragma mark initialization
- (UITextField *)createTextFieldWithFrame:(CGRect)frame
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    textField.placeholder = @"123";
    textField.secureTextEntry = YES;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.clearsOnBeginEditing = NO;
    [textField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents: UIControlEventEditingChanged];
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

- (void)setup
{
    self.isFirstEdit = YES;
}



#pragma mark textField
- (void)textFieldDidFocus
{
    [self.rightView setImage:[UIImage imageNamed:@"question"]];
}

- (void)textFieldWillLoseFocus
{
    self.isFirstEdit = NO;
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
    BOOL canInsertNewValue = [self.model canInsertNewValue:newValue];
    
    // It has to set value manually, otherwise textfield will clear all the value
    // NOTICE: for the second edit, new input value will be masked.
    if (!self.isFirstEdit && canInsertNewValue)
    {
        // set value by ourselves
        [self setText:newValue];
        return NO;
    }
   
    // It has return to YES so that the input value won't be masked
    return canInsertNewValue;
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