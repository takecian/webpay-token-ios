//
//  WPYCreditCard.m
//  Webpay
//
//  Created by yohei on 3/11/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYCreditCard.h"

@implementation WPYCreditCard

- (NSString *)brandName
{
    NSString *cardNum = self.number;
    if (!cardNum)
    {
        return nil;
    }
    else
    {
        if ([self isMatchWithRegex:@"4[0-9]{12}(?:[0-9]{3})?" string:cardNum])
        {
            return @"Visa";
        }

        if ([self isMatchWithRegex:@"3[47][0-9]{13}" string:cardNum])
        {
            return @"American Express";
        }
        
        if ([self isMatchWithRegex:@"5[1-5][0-9]{14}" string:cardNum])
        {
            return @"MasterCard";
        }

        if ([self isMatchWithRegex:@"6(?:011|5[0-9]{2})[0-9]{12}" string:cardNum])
        {
            return @"Discover";
        }

        if ([self isMatchWithRegex:@"(?:2131|1800|35\\d{3})\\d{11}" string:cardNum])
        {
            return @"JCB";
        }
        
        if ([self isMatchWithRegex:@"3(?:0[0-5]|[68][0-9])[0-9]{11}" string:cardNum])
        {
            return @"Diners";
        }
        
        return @"Unknown";
    }
}

#pragma mark private methods
- (BOOL)isMatchWithRegex:(NSString *)regex string:(NSString *)string
{
    NSRange range = [string rangeOfString:regex options:NSRegularExpressionSearch];
    return range.location != NSNotFound;
}


@end