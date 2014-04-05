//
//  WPYHTTPRequestSerializerTest.m
//  Webpay
//
//  Created by yohei on 4/3/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WPYCommunicator.h"
#import "WPYCreditCard.h"

@interface WPYCommunicatorTest : XCTestCase

@end

static NSString *const publicKey = @"public key";

@implementation WPYCommunicatorTest
{
    WPYCommunicator *_communicator;
    
    WPYCreditCard *_card;
}

- (void)setUp
{
    [super setUp];
    _communicator = [[WPYCommunicator alloc] init];
    
    _card = [[WPYCreditCard alloc] init];
    _card.name = @"Yohei Okada";
    _card.number = @"4111111111111111";
    _card.cvc = @"123";
    _card.expiryYear = 2014;
    _card.expiryMonth = 12;
}

- (void)tearDown
{
    _communicator = nil;
    _card = nil;
    [super tearDown];
}

@end
