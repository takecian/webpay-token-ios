//
//  WPYErrorBuilderTest.m
//  Webpay
//
//  Created by yohei on 4/5/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WPYErrorBuilder.h"
#import "WPYErrors.h"

static NSString *const errorJSONString = @"{"
    @"\"error\": {"
        @"\"param\": \"exp_year\","
        @"\"code\": \"invalid_expiry_year\","
        @"\"message\": \"You must provide the card which is not expired\","
        @"\"type\": \"card_error\""
    @"}"
@"}";

static NSString *const nonJSONString = @"Not JSON";

@interface WPYErrorBuilderTest : XCTestCase

@end

@implementation WPYErrorBuilderTest
{
    WPYErrorBuilder *_builder;
    NSData *_errorJSONData;
    NSData *_nonJSONData;
}

- (void)setUp
{
    [super setUp];
    
    _builder = [[WPYErrorBuilder alloc] init];
    _errorJSONData = [errorJSONString dataUsingEncoding:NSUTF8StringEncoding];
    _nonJSONData = [nonJSONString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)tearDown
{
    _builder = nil;
    _errorJSONData = nil;
    _nonJSONData = nil;
    
    [super tearDown];
}

- (void)testNilDataRaisesException
{
    NSError *buildError = nil;
    XCTAssertThrows([_builder buildErrorFromData:nil error:&buildError], @"It should raise exception when data is nil.");
}

- (void)testNonJSONReturnsExpectedError
{
    NSError *buildError = nil;
    NSError *error = [_builder buildErrorFromData:_nonJSONData error:&buildError];
    XCTAssertNil(error, @"It should return nil.");
    XCTAssertEqualObjects([buildError domain], NSCocoaErrorDomain, @"It should be a json serialization error.");
}

- (void)testErrorJSONReturnsExpectedError
{
    NSError *buildError = nil;
    NSError *error = [_builder buildErrorFromData:_errorJSONData error:&buildError];
    XCTAssertEqualObjects([error domain], WPYErrorDomain, @"It should be WPYErrorDomain.");
    XCTAssertEqual([error code], WPYInvalidExpiryYear, @"It should be the same as json");
    XCTAssertEqualObjects([error localizedDescription], @"You must provide the card which is not expired", @"It should be the same as message field in json.");
    XCTAssertNil(buildError, @"It should stay as nil.");
}

@end