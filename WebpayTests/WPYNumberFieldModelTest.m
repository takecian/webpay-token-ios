//
//  WPYNumberFieldModelTest.m
//  Webpay
//
//  Created by yohei on 5/4/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WPYNumberFieldModel.h"

@interface WPYNumberFieldModelTest : XCTestCase

@end

static NSString *const kAmexNumber = @"371449635398431";
static NSString *const kMasterCardNumber = @"5105105105105100";

@implementation WPYNumberFieldModelTest
{
    WPYNumberFieldModel *_model;
}

- (void)setUp
{
    [super setUp];
    
    WPYCreditCard *card = [[WPYCreditCard alloc] init];
    _model = [[WPYNumberFieldModel alloc] initWithCard:card];
}

- (void)tearDown
{
    _model = nil;
    [super tearDown];
}



#pragma mark test key
- (void)testFieldKey
{
    XCTAssertEqual([_model key], WPYNumberFieldKey, @"Key should be WPYNumberFieldKey.");
}



#pragma mark shouldValidateOnFocusLost
- (void)testShouldNotValidateWhenNumberIsNil
{
    _model.card.number = nil;
    XCTAssertFalse([_model shouldValidateOnFocusLost], @"It should not validate when number is nil.");
}

- (void)testShouldValidateWhenNumberExists
{
    _model.card.number = @"4";
    XCTAssertTrue([_model shouldValidateOnFocusLost], @"It should not validate when number is nil.");
}



#pragma mark initialValueForTextField
- (void)testInitialNumberWithNilNumber
{
    _model.card.number = nil;
    XCTAssertNil([_model initialValueForTextField], @"It should return nil if number is nil.");
}

- (void)testAmexNumberAsInitialNumber
{
    _model.card.number = kAmexNumber;
    XCTAssertEqualObjects([_model initialValueForTextField], @"3714 496353 98431", @"It should be padded");
}

- (void)testMasterCardAsInitialNumber
{
    _model.card.number = kMasterCardNumber;
    XCTAssertEqualObjects([_model initialValueForTextField], @"5105 1051 0510 5100", @"It should be padded");
}



#pragma mark textFieldValueFromValue:characterDeleted:
- (void)testNumberAddedBeforeSpace
{
    NSString *partialVisaNumber = @"4242";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:partialVisaNumber isDeleted:NO], @"4242 ", @"It should add a padding.");
}

- (void)testNumberAddedAfterSpace
{
    NSString *partialVisaNumber = @"4242 5";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:partialVisaNumber isDeleted:NO], @"4242 5", @"It should not add a padding.");
}

- (void)testNumberBeforeSpaceDeleted
{
    NSString *partialVisaNumber = @"4242 5";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:partialVisaNumber isDeleted:YES], @"4242 5", @"It should not remove the padding.");
}

- (void)testNumberAfterSpaceDeleted
{
    NSString *partialVisaNumber = @"4242 ";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:partialVisaNumber isDeleted:YES], @"4242", @"It should remove the padding.");
}


#pragma mark canInsertNewNumber
- (void)testAmexNumber
{
    XCTAssertTrue([_model canInsertNewValue:kAmexNumber], @"15 digits amex is a valid length.");
}

- (void)textTooLongAmexNumber
{
    XCTAssertFalse([_model canInsertNewValue:@"3782822463100051"], @"16 digits amex number is not valid.");
}

- (void)testMasterCardNumber
{
    XCTAssertTrue([_model canInsertNewValue:kMasterCardNumber], @"16 digits non-amex number is valid.");
}

- (void)testTooLongMasterCardNumber
{
    XCTAssertFalse([_model canInsertNewValue:@"55555555555544441"], @"17 digits non-amex card is not valid.");
}


@end