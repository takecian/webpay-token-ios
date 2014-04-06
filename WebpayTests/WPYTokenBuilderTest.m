//
//  WPYTokenBuilderTest.m
//  Webpay
//
//  Created by yohei on 4/5/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WPYTokenBuilder.h"
#import "WPYToken.h"

static NSString *const successJSON = @"{"
    @"\"card\":{"
        @"\"last4\": \"4242\","
        @"\"object\": \"card\","
        @"\"exp_year\": 2014,"
        @"\"exp_month\": 11,"
        @"\"fingerprint\": \"215b5b2fe460809b8bb90bae6eeac0e0e0987bd7\","
        @"\"name\": \"KEI KUBO\","
        @"\"country\": \"JP\","
        @"\"type\": \"Visa\","
        @"\"cvc_check\": \"pass\""
    @"},"
    @"\"used\": false,"
    @"\"created\": 1396747899,"
    @"\"livemode\": false,"
    @"\"object\": \"token\","
    @"\"id\": \"tok_4hB8eGcxL9KffML\""
@"}";

static NSString *const invalidJSON = @"Not JSON";

@interface WPYTokenBuilderTest : XCTestCase

@end

@implementation WPYTokenBuilderTest
{
    WPYTokenBuilder *_builder;
    NSData *_successData;
    NSData *_invalidData;
}

- (void)setUp
{
    [super setUp];
    
    _builder = [[WPYTokenBuilder alloc] init];
    _successData = [successJSON dataUsingEncoding:NSUTF8StringEncoding];
    _invalidData = [invalidJSON dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)tearDown
{
    _builder = nil;
    _successData = nil;
    _invalidData = nil;
    
    [super tearDown];
}

#pragma mark buildTokenFromData:error:
- (void)testAcceptsNilAsNilArgument
{
    XCTAssertNoThrow([_builder buildTokenFromData:_successData error:nil], @"It accepts nil as error argument.");
}

- (void)testNilDataRaisesException
{
    XCTAssertThrows([_builder buildTokenFromData:nil error:nil], @"It should raise error when data is nil.");
}

- (void)testInvalidJSONReturnsNil
{
    XCTAssertNil([_builder buildTokenFromData:_invalidData error:nil], @"It should return nil if it fails building WPYToken.");
}

- (void)testInvalidJSONReturnsError
{
    NSError *error = nil;
    [_builder buildTokenFromData:_invalidData error:&error];
    XCTAssertNotNil(error, @"It should populate error object if json is invalid.");
}

- (void)testTokenCreatedFromSuccessJSON
{
    NSError *error = nil;
    WPYToken *token = [_builder buildTokenFromData:_successData error:&error];
    XCTAssertNotNil(token, @"It should populate error object if json is invalid.");
}

- (void)testCreatedTokenHasExpectedProperty
{
    NSError *error = nil;
    WPYToken *token = [_builder buildTokenFromData:_successData error:&error];
    
    XCTAssertEqualObjects(token.tokenId, @"tok_4hB8eGcxL9KffML", @"Token should be the same as in json.");
    NSDictionary *cardInfo = token.cardInfo;
    NSDictionary *expectedCardInfo =
    @{
        @"last4": @"4242",
        @"object": @"card",
        @"exp_year": @2014,
        @"exp_month": @11,
        @"fingerprint": @"215b5b2fe460809b8bb90bae6eeac0e0e0987bd7",
        @"name": @"KEI KUBO",
        @"country": @"JP",
        @"type": @"Visa",
        @"cvc_check": @"pass"
    };
    
    XCTAssertEqualObjects(cardInfo, expectedCardInfo, @"cardInfo should be the same as card dictionary in json.");
}

@end