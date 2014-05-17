//
//  WPYExpiryFieldModelTtest.m
//  Webpay
//
//  Created by yohei on 5/5/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WPYExpiryFieldModel.h"

@interface WPYExpiryFieldModelTtest : XCTestCase

@end

@implementation WPYExpiryFieldModelTtest
{
    WPYExpiryFieldModel *_model;
}

- (void)setUp
{
    [super setUp];
    WPYCreditCard *card = [[WPYCreditCard alloc] init];
    _model = [[WPYExpiryFieldModel alloc] initWithCard:card];
}

- (void)tearDown
{
    _model = nil;
    [super tearDown];
}



#pragma mark accessor
- (void)testSetCardValueWithPartialExpiry
{
    [_model setCardValue:@" / 2019"];
    XCTAssertEqual(_model.card.expiryMonth, (NSUInteger)0, @"It should set 0 when empty.");
    XCTAssertEqual(_model.card.expiryYear, (NSUInteger)2019, @"It should assign proper value.");
}

- (void)testSetCardValue
{
    [_model setCardValue:@"04 / 2020"];
    XCTAssertEqual(_model.card.expiryMonth, (NSUInteger)4, @"It should assign proper value.");
    XCTAssertEqual(_model.card.expiryYear, (NSUInteger)2020, @"It should assign proper value.");
}


#pragma mark shouldValidateOnFocusLost
- (void)testShouldNotValidateWhenExpiryIsNil
{
    XCTAssertFalse([_model shouldValidateOnFocusLost], @"It should not validate when expiry is nil.");
}

- (void)testShouldNotValidateNilExpiryYear
{
    _model.card.expiryMonth = 11;
    XCTAssertFalse([_model shouldValidateOnFocusLost], @"It should not validate when year is nil");
}

- (void)testShouldNotValidateNilExpiryMonth
{
    _model.card.expiryYear = 2020;
    XCTAssertFalse([_model shouldValidateOnFocusLost], @"It should not validate when month is nil");
}

- (void)testShouldValidateWhenExpiryExists
{
    _model.card.expiryMonth = 11;
    _model.card.expiryYear = 2020;
    XCTAssertTrue([_model shouldValidateOnFocusLost], @"It should validate if expiry is set.");
}


#pragma mark initialValueForTextField
- (void)testInitialExpiry
{
    _model.card.expiryYear = 2018;
    _model.card.expiryMonth = 2;
    XCTAssertEqualObjects([_model formattedTextFieldValue], @"02 / 2018", @"It should format expiry as MM / YYYY.");
}

@end