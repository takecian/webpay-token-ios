//
//  WPYExpiryFieldModel.m
//  Webpay
//
//  Created by yohei on 5/5/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYExpiryFieldModel.h"

@implementation WPYExpiryFieldModel

#pragma mark accessor
- (WPYFieldKey)key
{
    return WPYExpiryFieldKey;
}

- (void)setCardValue:(NSString *)value
{
    if (value.length > 0)
    {
        NSInteger month = [[value substringToIndex:2] integerValue];
        self.card.expiryMonth = month;
        
        NSInteger year = [[value substringFromIndex:5] integerValue];
        self.card.expiryYear = year;
    }
}

- (NSString *)cardValue
{
    return [self.card expiryInString];
}


#pragma mark textfield
- (NSString *)initialValueForTextField
{
    return [self.card expiryInString];
}



#pragma mark validation
- (BOOL)shouldValidateOnFocusLost
{
    NSString *expiry = [self.card expiryInString];
    return expiry.length == 9; // don't valid if both not selected
}

- (BOOL)validate:(NSError * __autoreleasing *)error
{
    return [self.card validateExpiryYear:self.card.expiryYear month:self.card.expiryMonth error:error];
}

@end