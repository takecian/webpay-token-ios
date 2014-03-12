//
//  WPYCreditCard.h
//  Webpay
//
//  Created by yohei on 3/11/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WPYMonth) {
    WPYJanuary = 1,
    WPYFebruary,
    WPYMarch,
    WPYApril,
    WPYMay,
    WPYJune,
    WPYJuly,
    WPYAugust,
    WPYSeptember,
    WPYOctober,
    WPYNovember,
    WPYDecember
};

@interface WPYCreditCard : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *number;
@property(nonatomic, copy) NSString *cvc;
@property(nonatomic, assign) WPYMonth expiryMonth;
@property(nonatomic, assign) NSUInteger expiryYear;

@end
