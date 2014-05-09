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


#pragma mark accessor
- (WPYFieldKey)key
{
    return WPYCvcFieldKey;
}

- (void)setCardValue:(NSString *)value
{
    self.card.cvc = value;
}

- (NSString *)cardValue
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