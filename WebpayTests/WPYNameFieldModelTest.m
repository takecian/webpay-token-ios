//
//  WPYNameFieldModelTest.m
//  Webpay
//
//  Created by yohei on 5/6/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WPYNameFieldModel.h"

@interface WPYNameFieldModelTest : XCTestCase

@end

@implementation WPYNameFieldModelTest
{
    WPYNameFieldModel *_model;
}

- (void)setUp
{
    [super setUp];
    
    WPYCreditCard *card = [[WPYCreditCard alloc] init];
    _model = [[WPYNameFieldModel alloc] initWithCard:card];
}

- (void)tearDown
{
    _model = nil;
    [super tearDown];
}



#pragma mark shouldValidateOnFocusLost
- (void)testShouldNotValidateWhenNameIsNil
{
    _model.card.name = nil;
    XCTAssertFalse([_model shouldValidateOnFocusLost], @"It should not validate when name is nil.");
}

- (void)testShouldValidateWhenNameIsSet
{
    _model.card.name = @"Yohei Okada";
    XCTAssertTrue([_model shouldValidateOnFocusLost], @"It should validate when name exists.");
}



#pragma mark initialValueForTextField
- (void)testInitialExpiry
{
    _model.card.name = @"Yohei";
    XCTAssertEqualObjects([_model formattedTextFieldValue], @"Yohei", @"It should return card.name.");
}
@end
