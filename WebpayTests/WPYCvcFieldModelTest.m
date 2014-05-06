//
//  WPYCvcFieldModelTest.m
//  Webpay
//
//  Created by yohei on 5/6/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WPYCvcFieldModel.h"

static NSString *const kAmexNumber = @"371449635398431";
static NSString *const kMasterCardNumber = @"5105105105105100";

@interface WPYCvcFieldModelTest : XCTestCase

@end

@implementation WPYCvcFieldModelTest
{
    WPYCvcFieldModel *_model;
}

- (void)setUp
{
    [super setUp];
    WPYCreditCard *card = [[WPYCreditCard alloc] init];
    _model = [[WPYCvcFieldModel alloc] initWithCard:card];
}

- (void)tearDown
{
    _model = nil;
    [super tearDown];
}



#pragma mark test key
- (void)testFieldKey
{
    XCTAssertEqual([_model key], WPYCvcFieldKey, @"Key should be WPYCvcFieldKey.");
}



#pragma mark shouldValidateOnFocusLost
- (void)testShouldNotValidateWhenCvcIsNil
{
    _model.card.cvc = nil;
    XCTAssertFalse([_model shouldValidateOnFocusLost], @"It should not validate when cvc is nil.");
}

- (void)testShouldValidateWhenCvcSet
{
    _model.card.cvc = @"123";
    XCTAssertTrue([_model shouldValidateOnFocusLost], @"It should validate when cvc is set.");
}


#pragma mark initialValueForTextField
- (void)testInitialCvc
{
    _model.card.cvc = @"123";
    XCTAssertEqualObjects([_model initialValueForTextField], @"123", @"It should return cvc as is.");
}



#pragma mark canInsertNewValue
- (void)test4DigitsCvcForAmexNumber
{
    _model.card.number = kAmexNumber;
    XCTAssertTrue([_model canInsertNewValue: @"1234"], @"4 digits cvc is valid for amex number.");
}

- (void)test5DigitsCvcForAmexNumber
{
    _model.card.number = kAmexNumber;
    XCTAssertFalse([_model canInsertNewValue:@"12345"], @"5 digits cvc is invalid for amex number.");
}

- (void)test3DigitsCvcForMasterCard
{
    _model.card.number = kMasterCardNumber;
    XCTAssertTrue([_model canInsertNewValue:@"123"], @"3 digits cvc is valid for non-amex number.");
}

- (void)test4DigitsCvcForMasterCard
{
    _model.card.number = kMasterCardNumber;
    XCTAssertFalse([_model canInsertNewValue:@"1234"], @"4 digits cvc is invalid for non-amex number.");
}


@end