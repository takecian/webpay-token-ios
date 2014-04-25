//
//  WPYAbstractCardField.m
//  Webpay
//
//  Created by yohei on 4/17/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYAbstractCardFieldSubclass.h"

@interface WPYAbstractCardField ()
@end


@implementation WPYAbstractCardField
@synthesize textField = _textField;

#pragma mark initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
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

- (void)notifySuccess
{
    [self setNormalColor];
    if (self.delegate && [self.delegate respondsToSelector:@selector(validValue:forKey:)])
    {
        [self.delegate validValue:self.textField.text forKey:[self key]];
    }
}

- (void)notifyError:(NSError *)error
{
    [self setErrorColor];
    if (self.delegate && [self.delegate respondsToSelector:@selector(invalidValue:forKey:error:)])
    {
        [self.delegate invalidValue:self.textField.text forKey:[self key] error:error];
    }
}



#pragma mark protected methods
- (void)setErrorColor
{
    self.textField.textColor = [UIColor redColor];
}

- (void)setNormalColor
{
    self.textField.textColor = [UIColor darkGrayColor];
}



#pragma mark textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setNormalColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![self shouldValidate])
    {
        return;
    }
    
    NSError *error = nil;
    if ([self validate:&error])
    {
        [self notifySuccess];
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
- (WPYFieldKey)key
{
    return 100;
}

- (BOOL)shouldValidate
{
    return NO;
}

- (BOOL)validate:(NSError * __autoreleasing *)error
{
    return YES;
}

@end