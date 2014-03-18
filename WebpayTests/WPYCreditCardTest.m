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

#pragma mark brandName
- (void)testBrandNameReturnsNilForEmptyNumber
{
    _creditCard.number = nil;
    XCTAssertNil([_creditCard brandName], @"brandName should return nil for empty card number");
}

- (void)testBrandNameDiscernsVisa
{
    NSString *visaCardNumber = @"4111111111111111";
    _creditCard.number = visaCardNumber;
    XCTAssertEqualObjects([_creditCard brandName], @"Visa", @"it should be recongnized as visa");
}

- (void)testBrandNameDiscernsAmex
{
    NSString *amexCardNumber = @"378282246310005";
    _creditCard.number = amexCardNumber;
    XCTAssertEqual([_creditCard brandName], @"American Express", @"it should be recognized as amex");
}

- (void)testBrandNameDiscernsMasterCard
{
    NSString *masterCardNumber = @"5555555555554444";
    _creditCard.number = masterCardNumber;
    XCTAssertEqual([_creditCard brandName], @"MasterCard", @"it should be recognized as master card");
}

- (void)testBrandNameDiscernsDiscover
{
    NSString *discoverCardNumber = @"6011111111111117";
    _creditCard.number = discoverCardNumber;
    XCTAssertEqual([_creditCard brandName], @"Discover", @"it should be recognized as discover");
}

- (void)testBrandNameDiscernsJCB
{
    NSString *JCBCardNumber = @"3530111333300000";
    _creditCard.number = JCBCardNumber;
    XCTAssertEqual([_creditCard brandName], @"JCB", @"it should be recognized as JCB");
}

- (void)testBrandNameDiscernsDiners
{
    NSString *dinersCardNumber = @"30569309025904";
    _creditCard.number = dinersCardNumber;
    XCTAssertEqual([_creditCard brandName], @"Diners", @"it should be recognized as diners");
}

- (void)testBrandNameDicernsUnknown
{
    NSString *unknownCardNumber = @"9876543210123456";
    _creditCard.number = unknownCardNumber;
    XCTAssertEqual([_creditCard brandName], @"Unknown", @"it should be recognized as unknown");
}



@end
