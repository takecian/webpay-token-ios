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
        NSRange visaRange = [cardNum rangeOfString:@"4[0-9]{12}(?:[0-9]{3})?" options:NSRegularExpressionSearch];
        if (visaRange.location != NSNotFound)
        {
            return @"Visa";
        }
        
        NSRange amexRange = [cardNum rangeOfString:@"3[47][0-9]{13}" options:NSRegularExpressionSearch];
        if (amexRange.location != NSNotFound)
        {
            return @"American Express";
        }
        
        NSRange masterRange = [cardNum rangeOfString:@"5[1-5][0-9]{14}" options:NSRegularExpressionSearch];
        if (masterRange.location != NSNotFound)
        {
            return @"MasterCard";
        }
        
        NSRange discoverRange = [cardNum rangeOfString:@"6(?:011|5[0-9]{2})[0-9]{12}" options:NSRegularExpressionSearch];
        if (discoverRange.location != NSNotFound)
        {
            return @"Discover";
        }
        
        NSRange JCBRange = [cardNum rangeOfString:@"(?:2131|1800|35\\d{3})\\d{11}" options:NSRegularExpressionSearch];
        if (JCBRange.location != NSNotFound)
        {
            return @"JCB";
        }
        
        NSRange dinersRange = [cardNum rangeOfString:@"3(?:0[0-5]|[68][0-9])[0-9]{11}" options:NSRegularExpressionSearch];
        if (dinersRange.location != NSNotFound)
        {
            return @"Diners";
        }
        
        return @"Unknown";
    }
}


@end