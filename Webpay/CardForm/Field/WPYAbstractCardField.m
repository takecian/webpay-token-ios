//
//  WPYAbstractCardField.m
//  Webpay
//
//  Created by yohei on 4/17/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYAbstractCardFieldSubclass.h"


static float const WPYShakeWidth = 1.0f;
static float const WPYShakeDuration = 0.03f;
static NSInteger const WPYMaxShakes = 8;


@interface WPYAbstractCardField ()
@end


@implementation WPYAbstractCardField
@synthesize textField = _textField;

#pragma mark initialization
- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _textField = [self createTextFieldWithFrame:frame];
        [self setupTextField];
        [self setText:text];
        [self addSubview:_textField];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame text:nil];
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



#pragma mark protected methods
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
}

- (void)setText:(NSString *)text
{
    // setting nil appears as (null).
    if (text)
    {
        self.textField.text = text;
    }
}

- (void)notifyValidity
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(validValue:forKey:)])
    {
        [self.delegate validValue:self.textField.text forKey:[self key]];
    }
}

- (void)notifyError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(invalidValue:forKey:error:)])
    {
        [self.delegate invalidValue:self.textField.text forKey:[self key] error:error];
    }
}



#pragma mark textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setNormalColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![self shouldValidateOnFocusLost])
    {
        return;
    }
    
    NSError *error = nil;
    if ([self validate:&error])
    {
        [self setNormalColor];
        [self notifyValidity];
    }
    else
    {
        [self setErrorColor];
        [self startErrorAnimation];
        [self notifyError:error];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *newValue = [textField.text stringByReplacingCharactersInRange:range withString:replacementString];
    NSUInteger place = range.location + 1;
    BOOL isCharacterDeleted = replacementString.length == 0;
    
    [self updateValue:newValue place:place charactedDeleted:isCharacterDeleted];
    
    BOOL canInsertNewValue = [self canInsertNewValue:newValue place:place charactedDeleted:isCharacterDeleted];
    
    return canInsertNewValue;
}

// called when value of textfield updated. called from textfield or manually
- (void)textFieldDidChange:(id)sender
{
    NSError *error = nil;
    if ([self validate:&error])
    {
        [self notifyValidity];
    }
    else
    {
        [self notifyError:error];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



#pragma mark expected to overriden in subclass
- (UITextField *)createTextFieldWithFrame:(CGRect)frame
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (WPYFieldKey)key
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (BOOL)shouldValidateOnFocusLost
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (BOOL)validate:(NSError * __autoreleasing *)error
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (BOOL)canInsertNewValue:(NSString *)newValue place:(NSUInteger)place charactedDeleted:(BOOL)isCharacterDeleted
{
    return YES;
}

- (void)updateValue:(NSString *)newValue
              place:(NSUInteger)place
   charactedDeleted:(BOOL)isCharacterDeleted
{
    
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