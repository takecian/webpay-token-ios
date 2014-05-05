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

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}



#pragma mark stripWhiteSpaces
- (void)testStripWhiteSpaces
{
    XCTAssertEqualObjects([WPYNumberFieldModel stripWhitespaces:@"123 "], @"123", @"It should strip space at the end.");
    XCTAssertEqualObjects([WPYNumberFieldModel stripWhitespaces:@" 123"], @"123", @"It should strip space at the beginning.");
    XCTAssertEqualObjects([WPYNumberFieldModel stripWhitespaces:@" 123 "], @"123", @"It should strip spaces at both end.");
    XCTAssertEqualObjects([WPYNumberFieldModel stripWhitespaces:@"1 23"], @"1 23", @"It should not remove whitespaces in between.");
}



#pragma mark removeAllWhiteSpaces
- (void)testRemoveAllWhiteSpaces
{
    XCTAssertEqualObjects([WPYNumberFieldModel removeAllWhitespaces:@" 1 2  3 "], @"123", @"It should remove all whitespaces.");
}



#pragma mark addPaddingToNumber
- (void)testAddPaddingToAmexNumber
{
    NSString *partialAmexNumber = @"3782822463";
    XCTAssertEqualObjects([WPYNumberFieldModel addPaddingToNumber:partialAmexNumber], @"3782 822463 ", @"It should add padding like 4-6.");
    
    XCTAssertEqualObjects([WPYNumberFieldModel addPaddingToNumber:kAmexNumber], @"3714 496353 98431", @"It should add padding like 4-6-5.");
}

- (void)testAddPaddingToNonAmexNumber
{
    NSString *partialVisaNumber = @"401288888888";
    XCTAssertEqualObjects([WPYNumberFieldModel addPaddingToNumber:partialVisaNumber], @"4012 8888 8888 ", @"It should add padding per 4 digits.");
    XCTAssertEqualObjects([WPYNumberFieldModel addPaddingToNumber:kMasterCardNumber], @"5105 1051 0510 5100", @"It should add padding per 4 digits.");
}



#pragma mark isValidLength
- (void)testAmexNumber
{
    XCTAssertTrue([WPYNumberFieldModel isValidLength:kAmexNumber], @"15 digits amex is a valid length.");
}

- (void)textTooLongAmexNumber
{
    XCTAssertFalse([WPYNumberFieldModel isValidLength:@"3782822463100051"], @"16 digits amex number is not valid.");
}

- (void)testMasterCardNumber
{
    XCTAssertTrue([WPYNumberFieldModel isValidLength:kMasterCardNumber], @"16 digits non-amex number is valid.");
}

- (void)testTooLongMasterCardNumber
{
    XCTAssertFalse([WPYNumberFieldModel isValidLength:@"55555555555544441"], @"17 digits non-amex card is not valid.");
}



#pragma mark spacedNumberFromTextFieldValue
- (void)testAddANumber
{
    NSString *number = @"1";
    XCTAssertEqualObjects([WPYNumberFieldModel spacedNumberFromTextFieldValue:number place:1 deleted:NO], @"1", @"It should not add any padding.");
}
- (void)testAddNumberBeforeFirstSpace
{
    NSString *partialVisaNumber = @"4242";
    XCTAssertEqualObjects([WPYNumberFieldModel spacedNumberFromTextFieldValue:partialVisaNumber place:4 deleted:NO], @"4242 ", @"It should add padding.");
    
    NSString *partialAmexNumber = @"3782";
    XCTAssertEqualObjects([WPYNumberFieldModel spacedNumberFromTextFieldValue:partialAmexNumber place:4 deleted:NO], @"3782 ", @"It should add padding.");
}

- (void)testAddNumberBeforeSecondSpace
{
    NSString *partialVisaNumber = @"4242 4242";
    XCTAssertEqualObjects([WPYNumberFieldModel spacedNumberFromTextFieldValue:partialVisaNumber place:9 deleted:NO], @"4242 4242 ", @"It should add padding.");
    
    NSString *partialAmexNumber = @"3782 822463";
    XCTAssertEqualObjects([WPYNumberFieldModel spacedNumberFromTextFieldValue:partialAmexNumber place:11 deleted:NO], @"3782 822463 ", @"It should add padding.");
}

- (void)testAddTooLongNumber
{
    NSString *tooLongNumber = @"4242 4242 4242 42424";
    XCTAssertEqualObjects([WPYNumberFieldModel spacedNumberFromTextFieldValue:tooLongNumber place:17 deleted:NO], @"4242 4242 4242 4242", @"It should not add number if longer than max.");
    
}

- (void)testDeleteNumber
{
    NSString *number = @"";
    XCTAssertEqualObjects([WPYNumberFieldModel spacedNumberFromTextFieldValue:number place:1 deleted:YES], @"", @"It should return a string");
}

- (void)testDeleteSpaceFromVisaNmuber
{
    NSString *partialVisaNumber1 = @"4242 4242 4242";
    XCTAssertEqualObjects([WPYNumberFieldModel spacedNumberFromTextFieldValue:partialVisaNumber1 place:15 deleted:YES], @"4242 4242 424", @"It should delete the number before the space too.");
    
    NSString *partialVisaNumber2 = @"4242 4242";
    XCTAssertEqualObjects([WPYNumberFieldModel spacedNumberFromTextFieldValue:partialVisaNumber2 place:10 deleted:YES], @"4242 424", @"It should delete the number before the space too.");
    
    NSString *partialVisaNumber3 = @"4242";
    XCTAssertEqualObjects([WPYNumberFieldModel spacedNumberFromTextFieldValue:partialVisaNumber3 place:5 deleted:YES], @"424", @"It should delete the number before the space too.");
}

- (void)testDeleteSpaceFromAmexNumber
{
    NSString *partialAmexNumber1 = @"3782 822463";
    XCTAssertEqualObjects([WPYNumberFieldModel spacedNumberFromTextFieldValue:partialAmexNumber1 place:12 deleted:YES], @"3782 82246", @"It should delete the number before the space too.");
    
    NSString *partialAmexNumber2 = @"3782";
    XCTAssertEqualObjects([WPYNumberFieldModel spacedNumberFromTextFieldValue:partialAmexNumber2 place:5 deleted:YES], @"378", @"It should delete the number before the space too.");
}



@end