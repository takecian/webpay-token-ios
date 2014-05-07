//
//  WPYAbstractCardField.m
//  Webpay
//
//  Created by yohei on 4/17/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

// didFocus
// 1. set color to normal color
// 2. hide checkmark if necessary

// new input ** setting value to textfield is the responsibility of subclass **
// if automatic update
//   textFieldDidChanged: will be called
// else
//   subclass will update the textfield value
//   subclass will call textFieldDidChanged:

// LostFocus
// 1. if shouldValidate validate
// 2. change text color
// 3. change validity view
// 4. if error show error animation

#import "WPYAbstractCardField.h"

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

- (void)setText:(NSString *)text
{
    if (text)
    {
        self.textField.text = text;
        [self textFieldDidChanged:self.textField];
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
    [self textFieldDidFocus];
}

- (void)textFieldDidChanged:(UITextField *)textField
{
    [self.model setCardValue:textField.text];
    [self textFieldValueChanged];
}

- (void)textFieldValueChanged
{
    // called when textfield value changed
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
- (void)textFieldDidFocus
{

}

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
    NSString *initialValue = [self.model initialValueForTextField];
    if (initialValue)
    {
        [self setText:initialValue];
    }
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