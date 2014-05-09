//
//  WPYCvcField.m
//  Webpay
//
//  Created by yohei on 4/16/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYCvcField.h"

#import "WPYTextField.h"
#import "WPYCvcExplanationView.h"
#import "WPYCvcFieldModel.h"

@interface WPYCvcField () <UITextFieldDelegate>
@property(nonatomic, strong) UIButton *transparentButton;
@end

@implementation WPYCvcField


#pragma mark initialization
- (UITextField *)createTextFieldWithFrame:(CGRect)frame
{
    UITextField *textField = [[WPYTextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    textField.placeholder = @"123";
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.clearsOnBeginEditing = NO;
    [textField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents: UIControlEventEditingChanged];
    textField.delegate = self;
    
    return textField;
}

- (UIImageView *)createRightView
{
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    rightView.userInteractionEnabled = YES;
    return rightView;
}

- (WPYAbstractFieldModel *)createFieldModelWithCard:(WPYCreditCard *)card
{
    return [[WPYCvcFieldModel alloc] initWithCard:card];
}

- (void)setup
{
    self.transparentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.transparentButton.frame = CGRectMake(170, 0, 40, 44);
    [self.transparentButton addTarget:self action:@selector(showCvcInfoView) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.transparentButton];
    
    [self showQuestionIcon];
}



#pragma mark textField
- (void)textFieldDidFocus
{
    [self showQuestionIcon];
    
    // avoid firing textFieldDidChange
    self.textField.text = [self.model cardValue];
}

- (void)textFieldWillLoseFocus
{
    // avoid firing textFieldDidChange so that masks will not be assigned to card value.
    self.textField.text = [WPYCvcFieldModel maskedCvc:[self.model cardValue]];
}

- (void)updateValidityView:(BOOL)valid
{
    if (valid)
    {
        [self showCheckMark];
    }
    else
    {
        [self showQuestionIcon];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *newValue = [textField.text stringByReplacingCharactersInRange:range withString:replacementString];
    return [self.model canInsertNewValue:newValue];
}



#pragma mark right view private methods
- (void)showCheckMark
{
    [self.rightView setImage:[UIImage imageNamed:@"checkmark"]];
    self.transparentButton.enabled = NO;
}

- (void)showQuestionIcon
{
    [self.rightView setImage:[UIImage imageNamed:@"question"]];
    self.transparentButton.enabled = YES;
}



#pragma mark cvc info
- (void)showCvcInfoView
{
    // This should belong to a model.
    NSString *brand = [WPYCreditCard brandNameFromPartialNumber:self.model.card.number];
    if ([brand isEqualToString:WPYAmex])
    {
        [WPYCvcExplanationView showAmexCvcExplanation];
    }
    else
    {
        [WPYCvcExplanationView showNonAmexCvcExplanation];
    }
}

@end