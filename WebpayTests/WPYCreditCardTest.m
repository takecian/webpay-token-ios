//
//  WPYCreditCardTest.m
//  Webpay
//
//  Created by yohei on 3/14/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WPYCreditCard.h"

@interface WPYCreditCardTest : XCTestCase

@end

@implementation WPYCreditCardTest
{
    WPYCreditCard *_creditCard;
}

- (void)setUp
{
    [super setUp];
    
    _creditCard = [[WPYCreditCard alloc] init];
}

- (void)tearDown
{
    _creditCard = nil;
    
    [super tearDown];
}

@end
