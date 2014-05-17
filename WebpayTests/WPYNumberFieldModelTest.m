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

static NSString *const kDinersNumber = @"38520000023237";
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



#pragma mark reformatNumber:position:isDeleted:
- (void)testDigitAddedBeforeSpaceToVisaNumber
{
    // 424 -> 4242
    NSString *newInput = @"4242";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:3 isDeleted:NO], @"4242 ", @"It should add a padding.");
}

- (void)testDigitAddedBeforeSpaceToAmexNumber
{
    // 3714_12345 -> 3714_123456
    NSString *newInput = @"3714 123456";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:10 isDeleted:NO], @"3714 123456 ", @"It should add a padding.");
}

- (void)testDigitAddedBeforeSpaceToDinersNumber
{
    //3852_12345 -> 3852_123456
    NSString *newInput = @"3852 123456";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:10 isDeleted:NO], @"3852 123456 ", @"It should add a padding at end.");
}

- (void)testDigitAddedAtSpaceToVisaNumber
{
    // 4242_ -> 42421_
    NSString *newInput = @"42421 ";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:4 isDeleted:NO], @"4242 1", @"It should add a space in between.");
}

- (void)testDigitAddedAtSpaceToAmexNumber
{
    // 3714_123456_ -> 3714_1234561_
    NSString *newInput = @"3714 1234561 ";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:11 isDeleted:NO], @"3714 123456 1", @"It should add a space in between.");
}

- (void)testDigitAddedAtSpaceToDinersNumber
{
    //3852_123456_ -> 3852_1234561_
    NSString *newInput = @"3852 1234561 ";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:11 isDeleted:NO], @"3852 123456 1", @"It should add a space in between.");
}

- (void)testDigitAddedAfterSpaceToVisaNumber
{
    // 4242_ -> 4242_1
    NSString *newInput = @"4242 1";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:5 isDeleted:NO], @"4242 1", @"It should not add a padding.");
}

- (void)testDigitAddedAfterSpaceToAmexNumber
{
    // 3714_123456_ -> 3714_123456_1
    NSString *newInput = @"3714 123456 1";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:12 isDeleted:NO], @"3714 123456 1", @"It should not add a padding.");
}

- (void)testDigitAddedAfterSpaceToDinersNumber
{
    //3852_123456_ -> 3852_123456_1
    NSString *newInput = @"3852 123456 1";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:12 isDeleted:NO], @"3852 123456 1", @"It should not add a padding.");
}

- (void)testDigitAfterSpaceDeletedFromVisaNumber
{
    // 4242_4242_1 -> 4242_4242_
    NSString *newInput = @"4242 4242 ";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:10 isDeleted:YES], @"4242 4242", @"It should remove padding at end.");
}

- (void)testDigitAfterSpaceDeletedFromAmexNumber
{
    // 3714_123456_1 -> 3714_123456_
    NSString *newInput = @"3714 123456 ";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:12 isDeleted:YES], @"3714 123456", @"It should remove padding at end.");
}

- (void)testDigitAfterSpaceDeletedFromDinersNumber
{
    // 3852_123456_1 -> 3852_123456_
    NSString *newInput = @"3852 123456 ";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:12 isDeleted:YES], @"3852 123456", @"It should remove padding at end.");
}

- (void)testSpaceDeletedAtVisaNumber
{
    // 4242_4242_ -> 4242_4242
    NSString *newInput = @"4242 4242";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:9 isDeleted:YES], @"4242 424", @"It should remove the number before space.");
}

- (void)testSpaceDeletedAtAmexNumber
{
    // 3714_123456_ -> 3714_123456
    NSString *newInput = @"3714 123456";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:11 isDeleted:YES], @"3714 12345", @"it should remove the number before space.");
}

- (void)testSpaceDeletedAtDinersNumber
{
    // 3852_123456_ -> 3852_123456
    NSString *newInput = @"3852 123456";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:11 isDeleted:YES], @"3852 12345", @"it should remove the number before space.");
}

- (void)testDigitBeforeSpaceDeletedFromVisaNumber
{
    // 4242_4242 -> 4242_424
    NSString *newInput = @"4242 424";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:8 isDeleted:YES], @"4242 424", @"It should leave at as is.");
}

- (void)testDigitBeforeSpaceDeletedFromAmexNumber
{
    // 3714_123456 -> 3714_12345
    NSString *newInput = @"3714 12345";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:10 isDeleted:YES], @"3714 12345", @"It should leave at as is.");
}

- (void)testDigitBeforeSpaceDeletedFromDinersNumber
{
    // 3852_123456 -> 3852_12345
    NSString *newInput = @"3852 12345";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:10 isDeleted:YES], @"3852 12345", @"It should leave at as is.");
}

- (void)testDigitInsertedBeforeSpaceToVisaNumber
{
    // 4242_42 -> 42421_42
    NSString *newInput = @"42421 42";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:4 isDeleted:NO], @"4242 142", @"It should adjust the position of padding.");
}

- (void)testDigitInsertedBeforeSpaceToAmexNumber
{
    // 3714_123456_ -> 37140_123456_
    NSString *newInput = @"37140 123456 ";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:4 isDeleted:NO], @"3714 012345 6", @"It should adjust the position of padding.");
}

- (void)testDigitInsertedBeforeSpaceToDinersNumber
{
    // 3852_123456_ -> 38520_123456_
    NSString *newInput = @"38520 123456 ";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:4 isDeleted:NO], @"3852 012345 6", @"It should adjust the position of padding.");
}

- (void)testDigitInsertedAfterSpaceToVisaNumber
{
    // 4242_42 -> 4242_142
    NSString *newInput = @"4242 142";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:4 isDeleted:NO], @"4242 142", @"It should keep it as is.");
}

- (void)testDigitInsertedAfterSpaceToAmexNumber
{
    // 3714_123456_ -> 3714_0123456_
    NSString *newInput = @"3714 0123456 ";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:5 isDeleted:NO], @"3714 012345 6", @"It should reformat padding.");
}

- (void)testDigitInsertedAfterSpaceToDinersNumber
{
    // 3852_123456_ -> 3852_0123456_
    NSString *newInput = @"3852 0123456 ";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:5 isDeleted:NO], @"3852 012345 6", @"It should reformat padding.");
}

- (void)testDigitRemovedAfterSpaceFromVisaNumber
{
    // 4242_12 -> 4242_2
    NSString *newInput = @"4242 2";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:5 isDeleted:YES], @"4242 2", @"It should keep it as is.");
}

- (void)testDigitRemovedAfterSpaceFromAmexNumber
{
    // 3714_123456_ -> 3714_23456_
    NSString *newInput = @"3714 23456 ";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:5 isDeleted:YES], @"3714 23456", @"It should reformat.");
}

- (void)testDigitRemovedAfterSpaceFromDinersNumber
{
    // 3852_123456_ -> 3852_23456_
    NSString *newInput = @"3852 23456 ";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:5 isDeleted:YES], @"3852 23456", @"It should reformat.");
}

- (void)testSpaceRemovedFromVisaNumber
{
    // 4242_42 -> 424242
    NSString *newInput = @"424242";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:4 isDeleted:YES], @"4244 2", @"It should remove number before space and reformat.");
}

- (void)testSpaceRemovedFromAmexNumber
{
    // 3714_123456_ -> 3714123456_
    NSString *newInput = @"3714123456 ";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:4 isDeleted:YES], @"3711 23456", @"It should remove number before space and reformat.");
}

- (void)testSpaceRemovedFromDinersNumber
{
    // 3852_123456_ -> 3852123456_
    NSString *newInput = @"3852123456 ";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:4 isDeleted:YES], @"3851 23456", @"It should remove number before space and reformat.");
}

- (void)testDigitRemovedBeforeSpaceFromVisaNumber
{
    // 4242_42 -> 424_42
    NSString *newInput = @"424 42";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:3 isDeleted:YES], @"4244 2", @"It should reformat.");
}

- (void)testDigitRemovedBeforeSpaceFromAmexNumber
{
    // 3714_123456_ -> 371_123456_
    NSString *newInput = @"371 123456 ";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:3 isDeleted:YES], @"3711 23456", @"It should reformat.");
}

- (void)testDigitRemovedBeforeSpaceFromDinersNumber
{
    // 3852_123456_ -> 385_123456_
    NSString *newInput = @"385 123456 ";
    XCTAssertEqualObjects([WPYNumberFieldModel reformatNumber:newInput position:3 isDeleted:YES], @"3851 23456", @"It should reformat.");
}


#pragma mark isDigitAfterSpace:position:
- (void)testIsDigitAfterSpaceForZeroPosition
{
    XCTAssertFalse([WPYNumberFieldModel isDigitAfterSpace:@"" position:0], @"It should return No.");
}

- (void)testDigitNotAfterSpaceForMasterCard
{
    XCTAssertFalse([WPYNumberFieldModel isDigitAfterSpace:@"5105 1051 0510 51" position:16], @"It should return false.");
}

- (void)testDigitAfterSpaceForMasterCard
{
    XCTAssertTrue([WPYNumberFieldModel isDigitAfterSpace:@"5105 1051 0510 5" position:15], @"It should return true.");
}

- (void)testDigitNotAfterSpaceForAmex
{
    XCTAssertFalse([WPYNumberFieldModel isDigitAfterSpace:@"3782 822463 12" position:13], @"It should return false.");
}

- (void)testDigitAfterSpaceForAmex
{
    XCTAssertTrue([WPYNumberFieldModel isDigitAfterSpace:@"3782 822463 1" position:12], @"It should return true.");
}



#pragma mark isSpaceWithNumber:position:
- (void)testIsSpaceForZeroPosition
{
    XCTAssertFalse([WPYNumberFieldModel isSpaceWithNumber:@"" position:0], @"It should return No.");
}

- (void)testNonSpace
{
    XCTAssertFalse([WPYNumberFieldModel isSpaceWithNumber:@"424" position:2], @"It should return false.");
    XCTAssertFalse([WPYNumberFieldModel isSpaceWithNumber:@"3782 822" position:7], @"It should return false.");
}

- (void)testSpace
{
    XCTAssertTrue([WPYNumberFieldModel isSpaceWithNumber:@"4242 1234 " position:9], @"It should return true.");
    XCTAssertTrue([WPYNumberFieldModel isSpaceWithNumber:@"3782 123456 " position:11], @"It should return true.");
}



#pragma mark isDigitBeforeSpace:position:
- (void)testIsDigitBeforeSpaceForZeroPosition
{
    XCTAssertFalse([WPYNumberFieldModel isDigitBeforeSpace:@"" position:0], @"It should return No.");
}

- (void)testDigitNotBeforeSpaceForMasterCard
{
    XCTAssertFalse([WPYNumberFieldModel isDigitBeforeSpace:@"5105 1051 0" position:10], @"It should return false.");
}

- (void)testDigitBeforeSpaceForMasterCard
{
    XCTAssertTrue([WPYNumberFieldModel isDigitBeforeSpace:@"5105 1051" position:8], @"It should return true.");
}

- (void)testDigitNotBeforeSpaceForAmex
{
    XCTAssertFalse([WPYNumberFieldModel isDigitBeforeSpace:@"3782 822463 1" position:12], @"It should return false.");
}

- (void)testDigitBeforeSpaceForAmex
{
    XCTAssertTrue([WPYNumberFieldModel isDigitBeforeSpace:@"3782 822463" position:10], @"It should return true.");
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
    XCTAssertNil([_model formattedTextFieldValue], @"It should return nil if number is nil.");
}

- (void)testAmexNumberAsInitialNumber
{
    _model.card.number = kAmexNumber;
    XCTAssertEqualObjects([_model formattedTextFieldValue], @"3714 496353 98431", @"It should be padded");
}

- (void)testMasterCardAsInitialNumber
{
    _model.card.number = kMasterCardNumber;
    XCTAssertEqualObjects([_model formattedTextFieldValue], @"5105 1051 0510 5100", @"It should be padded");
}



#pragma mark canInsertNewNumber
- (void)testAmexNumber
{
    XCTAssertTrue([_model canInsertNewValue:kAmexNumber], @"15 digits amex number is a valid length.");
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

- (void)testDinersNumber
{
    XCTAssertTrue([_model canInsertNewValue:kDinersNumber], @"14 digits diners number is a valid length.");
}

- (void)testTooLongDinersNumber
{
    XCTAssertFalse([_model canInsertNewValue:@"385200000232371"], @"15 digits diners number is not valid.");
}


@end