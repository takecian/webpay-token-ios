//
//  WPYExpiryFieldModel.m
//  Webpay
//
//  Created by yohei on 5/5/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYExpiryFieldModel.h"

@implementation WPYExpiryFieldModel

- (WPYFieldKey)key
{
    return WPYExpiryFieldKey;
}

// called at did end editing & textfield did change
- (BOOL)shouldValidateOnFocusLost
{
    NSString *expiry = [self.card expiryInString];
    return expiry.length == 9; // don't valid if both not selected
}

- (BOOL)validate:(NSError * __autoreleasing *)error
{
    return [self.card validateExpiryYear:self.card.expiryYear month:self.card.expiryMonth error:error];
}

- (NSString *)initialValueForTextField
{
    return [self.card expiryInString];
}

@end