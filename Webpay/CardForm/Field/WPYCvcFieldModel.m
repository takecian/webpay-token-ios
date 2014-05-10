//
//  WPYCvcFieldModel.m
//  Webpay
//
//  Created by yohei on 5/5/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYCvcFieldModel.h"

#import "WPYCreditCard.h"

static NSUInteger const WPYValidAmexCvcLength = 4;
static NSUInteger const WPYValidNonAmexCvcLength = 3;

@implementation WPYCvcFieldModel

#pragma mark public method
- (NSString *)maskedCvc
{
    NSString *dot = @"●";//unicode
    NSUInteger cvcLength = [self cardValue].length;
    NSMutableString *mask = [[NSMutableString alloc] init];
    for (int i = 0; i < cvcLength; i++)
    {
        [mask appendString:dot];
    }
    
    return mask;
}

- (BOOL)isAmex
{
    NSString *brand = [WPYCreditCard brandNameFromPartialNumber:self.card.number];
    return [brand isEqualToString:WPYAmex];
}


#pragma mark accessor
- (void)setCardValue:(NSString *)value
{
    self.card.cvc = value;
}

- (NSString *)rawCardValue
{
    return self.card.cvc;
}


#pragma mark textfield
- (NSString *)initialValueForTextField
{
    return self.card.cvc;
}

- (BOOL)canInsertNewValue:(NSString *)newValue
{
    NSString *brand = [WPYCreditCard brandNameFromPartialNumber:self.card.number];
    if ([brand isEqualToString:WPYAmex])
    {
        return newValue.length <= WPYValidAmexCvcLength;
    }
    else
    {
        return newValue.length <= WPYValidNonAmexCvcLength;
    }
}



#pragma mark validation
- (BOOL)shouldValidateOnFocusLost
{
    NSString *cvc = self.card.cvc;
    return cvc.length != 0; // don't valididate if length is 0
}

- (BOOL)validate:(NSError * __autoreleasing *)error
{
    NSString *cvc = self.card.cvc;
    return [self.card validateCvc:&cvc error:error];
}

@end