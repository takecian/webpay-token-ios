//
//  WPYAbstractCardField.m
//  Webpay
//
//  Created by yohei on 4/17/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYAbstractCardFieldSubclass.h"

#import "WPYAbstractFieldModel.h"


static float const WPYShakeWidth = 1.0f;
static float const WPYShakeDuration = 0.03f;
static NSInteger const WPYMaxShakes = 8;


@interface WPYAbstractCardField ()
@end

@implementation WPYAbstractCardField

#pragma mark initialization
- (instancetype)initWithFrame:(CGRect)frame card:(WPYCreditCard *)card
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _model = [self createFieldModelWithCard:card];
        
        // textfield
        _textField = [self createTextFieldWithFrame:frame];
        [self setupTextField];
        [self addSubview:_textField];
        
        [self setIntialValueForTextField];
    }
    return self;
}



#pragma mark public methods
- (void)setFocus:(BOOL)focus
{
    if (focus)
    {
        [self.textField becomeFirstResponder];
    }
    else
    {
        [self.textField resignFirstResponder];
    }
}


#pragma mark expected to overriden in subclass
#pragma mark initialization
- (UITextField *)createTextFieldWithFrame:(CGRect)frame
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (UIImageView *)createRightView
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (WPYAbstractFieldModel *)createFieldModelWithCard:(WPYCreditCard *)card
{
    return nil;
}



#pragma mark textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setNormalColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self textFieldWillLoseFocus];
    
    if (![self.model shouldValidateOnFocusLost])
    {
        return;
    }
    
    NSError *error = nil;
    BOOL isValid = [self.model validate:&error];
    
    [self updateValidityView:isValid];
    
    if (isValid)
    {
        [self setNormalColor];
    }
    else
    {
        [self setErrorColor];
        [self startErrorAnimation];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *newValue = [textField.text stringByReplacingCharactersInRange:range withString:replacementString];
    BOOL isCharacterDeleted = replacementString.length == 0;
    
    [self textFieldHasNewInput:newValue charactedDeleted:isCharacterDeleted];
    
    return NO;
}

- (void)textFieldHasNewInput:(NSString *)newInput charactedDeleted:(BOOL)isDeleted
{
    if ([self.model canInsertNewValue:newInput])
    {
        [self setText:[self.model textFieldValueFromValue:newInput characterDeleted:isDeleted]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



#pragma mark update value
- (void)updateValidityView:(BOOL)valid
{

}



#pragma mark event handler
- (void)textFieldWillLoseFocus
{

}

- (void)textFieldChanged
{

}



#pragma mark private methods
- (void)setErrorColor
{
    self.textField.textColor = [UIColor redColor];
}

- (void)setNormalColor
{
    self.textField.textColor = [UIColor colorWithRed:0.01 green:0.04 blue:0.1 alpha:1.0];
}

- (UIFont *)font
{
    return [UIFont fontWithName:@"Avenir-Roman" size:16.0f];
}

- (void)setupTextField
{
    self.textField.font = [self font];
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    // rightview
    self.rightView = [self createRightView];
    _textField.rightView = self.rightView;
    _textField.rightViewMode = UITextFieldViewModeAlways;
}

- (void)setIntialValueForTextField
{
    NSString *value = [self.model initialValueForTextField];
    if (value)
    {
        [self setText:value];
    }
}

- (void)setText:(NSString *)text
{
    self.textField.text = text;
    [self textFieldChanged];
}



#pragma mark error notification animation
- (void)startErrorAnimation
{
    [self shake:WPYMaxShakes
      direction:1
       duration:WPYShakeDuration
     shakeWidth:WPYShakeWidth
  currentShakes:0];
}

- (void)shake:(NSInteger)times
    direction:(NSInteger)direction
     duration:(float)duration
   shakeWidth:(float)width
currentShakes:(NSInteger)shaked
{
    [UIView animateWithDuration:duration
                     animations:^{
                         self.transform = CGAffineTransformMakeTranslation(width * direction, 0);
                     }
                     completion:^(BOOL finished){
                         if (shaked == times)
                         {
                             self.transform = CGAffineTransformIdentity;
                             return;
                         }
                         
                         [self shake:times
                           direction:direction * -1
                            duration:duration
                          shakeWidth:width
                       currentShakes:shaked + 1];
    }];
}

@end