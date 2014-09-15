//
//  WPYAvailabilityFetchTest.m
//  Webpay
//
//  Created by Okada Yohei on 9/2/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OHHTTPStubs.h"
#import "TRVSMonitor.h"

#import "WPYTokenizer.h"
#import "WPYErrors.h"

static NSString *const publicKey = @"test_public_a";
static NSString *const apiURL = @"https://api.webpay.jp/v1/account/availability";
static NSString *const acceptLanguage = @"en";

static NSString *const availabilityJSONString = @"{"
    @"\"currencies_supported\":["
        @"\"jpy\""
    @"],"
    @"\"card_types_supported\":["
        @"\"Visa\","
        @"\"American Express\","
        @"\"MasterCard\","
        @"\"JCB\","
        @"\"Diners Club\""
    @"]"
@"}";

static NSString *const errorJSONString = @"{"
    @"\"error\": {"
        @"\"type\": \"api_error\","
        @"\"caused_by\": \"service\","
        @"\"message\": \"Server busy\""
    @"}"
@"}";

static NSString *const nonJSONString = @"nonJSONString";
@interface WPYSupportedCardBrandsFetchTest : XCTestCase

@end

@implementation WPYSupportedCardBrandsFetchTest

- (void)setUp
{
    [super setUp];
    
    [WPYTokenizer setPublicKey:publicKey];
}

- (void)tearDown
{
    [WPYTokenizer setPublicKey:nil];
    
    [super tearDown];
}


#pragma mark public key
- (void)testFetchSupportedCardBrandsWithoutSettingPublicKeyRaisesException
{
    [WPYTokenizer setPublicKey:nil];
    XCTAssertThrows([WPYTokenizer fetchSupportedCardBrandsWithAcceptLanguage:acceptLanguage
                                                             completionBlock:^(NSArray *supportedCardBrands, NSError *error) {
    }], @"It should throw exception if public key is nil.");
}

- (void)testFetchSupportedCardBrandsWithInvalidPublicKeyRaisesException
{
    [WPYTokenizer setPublicKey:@"live_secret_a"];
    XCTAssertThrows([WPYTokenizer fetchSupportedCardBrandsWithAcceptLanguage:acceptLanguage
                                                             completionBlock:^(NSArray *supportedCardBrands, NSError *error) {
    }], @"It should throw exception if public key is invalid.");
}

- (void)testFetchSupportedCardBrandsWithValidPublicKeyDoesNotRaiseException
{
    [WPYTokenizer setPublicKey:publicKey];
    XCTAssertNoThrow([WPYTokenizer fetchSupportedCardBrandsWithAcceptLanguage:acceptLanguage
                                                              completionBlock:^(NSArray *supportedCardBrands, NSError *error) {
    }], @"It should not throw exception if public key is valid.");
}

#pragma mark completion block
- (void)testFetchSupportedCardBrandsWithoutCompletionBlockRaisesException
{
    XCTAssertThrows([WPYTokenizer fetchSupportedCardBrandsWithAcceptLanguage:acceptLanguage
                                                             completionBlock:nil], @"It should raise exception if completion block is nil.");
}

- (void)testFetchSupportedCardBrandsWithCompletionBlockDoesntRaiseException
{
    XCTAssertNoThrow([WPYTokenizer fetchSupportedCardBrandsWithAcceptLanguage:acceptLanguage
                                                              completionBlock:^(NSArray *supportedCardBrands, NSError *error) {
                                                              }], @"It should not raise exception if completin block is provided.");
}

#pragma mark network error
- (void)testFetchSupportedCardBrandsWhenNetworkError
{
    NSError *networkError = [NSError errorWithDomain:NSURLErrorDomain
                                                code:NSURLErrorNotConnectedToInternet
                                            userInfo:nil];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSString *urlString = [request.URL absoluteString];
        if ([urlString isEqualToString:apiURL])
        {
            return YES;
        }
        return NO;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithError:networkError];
    }];
    
    TRVSMonitor *monitor = [TRVSMonitor monitor];
    
    __block NSArray *returnedArray = nil;
    __block NSError *returnedError = nil;
    [WPYTokenizer fetchSupportedCardBrandsWithAcceptLanguage:acceptLanguage
                                             completionBlock:^(NSArray *supportedCardBrands, NSError *error) {
        returnedArray = supportedCardBrands;
        returnedError = error;
        [monitor signal];
    }];
    
    [monitor wait];
    
    XCTAssertNil(returnedArray, @"It should return nil if there is a network error.");
    
    XCTAssertNotNil(returnedError, @"It should not be nil.");
    XCTAssertEqualObjects([returnedError domain], NSURLErrorDomain, @"It should be NSURLErrorDomain.");
    XCTAssertEqual([returnedError code], NSURLErrorNotConnectedToInternet, @"Error code should be NSURLErrorNotConnectedToInternet.");
}

#pragma mark availability returned from api server
- (void)testFetchSupportedCardBrandsWhenFailedBuildingAvailability
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSString *urlString = [request.URL absoluteString];
        if ([urlString isEqualToString:apiURL])
        {
            return YES;
        }
        return NO;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:[nonJSONString dataUsingEncoding:NSUTF8StringEncoding]
                                          statusCode:200
                                             headers:nil];
    }];

    TRVSMonitor *monitor = [TRVSMonitor monitor];
    
    __block NSArray *returnedArray = nil;
    __block NSError *returnedError = nil;
    [WPYTokenizer fetchSupportedCardBrandsWithAcceptLanguage:acceptLanguage
                                             completionBlock:^(NSArray *supportedCardBrands, NSError *error) {
        returnedArray = supportedCardBrands;
        returnedError = error;
        [monitor signal];
    }];

    [monitor wait];
    
    XCTAssertNil(returnedArray, @"It should return nil when received data is not json.");
    XCTAssertNotNil(returnedError, @"It should return error object.");
}

- (void)testFetchSupportedCardBrandsWhenFetchedSuccessfully
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSString *urlString = [request.URL absoluteString];
        if ([urlString isEqualToString:apiURL])
        {
            return YES;
        }
        return NO;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:[availabilityJSONString dataUsingEncoding:NSUTF8StringEncoding]
                                          statusCode:200
                                             headers:nil];
    }];

    TRVSMonitor *monitor = [TRVSMonitor monitor];
    
    __block NSArray *returnedArray = nil;
    __block NSError *returnedError = nil;
    [WPYTokenizer fetchSupportedCardBrandsWithAcceptLanguage:acceptLanguage
                                             completionBlock:^(NSArray *supportedCardBrands, NSError *error) {
        returnedArray = supportedCardBrands;
        [monitor signal];
    }];

    [monitor wait];
    
    NSArray *expectedArray = @[@"Visa", @"American Express", @"MasterCard", @"JCB", @"Diners Club"];
    XCTAssertEqualObjects(returnedArray, expectedArray, @"It should be the same as items in json.");
    XCTAssertNil(returnedError, @"It should not return error if supported brand cards are fetched successfully.");
}

#pragma mark error returned from api server
- (void)testFetchSupportedCardBrandsWhenFailedBuildingErrorObject
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSString *urlString = [request.URL absoluteString];
        if ([urlString isEqualToString:apiURL])
        {
            return YES;
        }
        return NO;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:[nonJSONString dataUsingEncoding:NSUTF8StringEncoding]
                                          statusCode:500
                                             headers:nil];
    }];

    TRVSMonitor *monitor = [TRVSMonitor monitor];
    
    __block NSArray *returnedArray = nil;
    __block NSError *returnedError = nil;
    
    [WPYTokenizer fetchSupportedCardBrandsWithAcceptLanguage:acceptLanguage
                                             completionBlock:^(NSArray *supportedCardBrands, NSError *error) {
        returnedArray = supportedCardBrands;
        returnedError = error;
        [monitor signal];
    }];
    [monitor wait];
    
    XCTAssertNil(returnedArray, @"It should return nil.");
    XCTAssertNotNil(returnedError, @"It should not be nil.");
}

- (void)testFetchSupportedCardBrandsWhenErrorReturned
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSString *urlString = [request.URL absoluteString];
        if ([urlString isEqualToString:apiURL])
        {
            return YES;
        }
        return NO;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:[errorJSONString dataUsingEncoding:NSUTF8StringEncoding]
                                          statusCode:500
                                             headers:nil];
    }];

    TRVSMonitor *monitor = [TRVSMonitor monitor];
    
    __block NSArray *returnedArray = nil;
    __block NSError *returnedError = nil;
    
    [WPYTokenizer fetchSupportedCardBrandsWithAcceptLanguage:acceptLanguage
                                             completionBlock:^(NSArray *supportedCardBrands, NSError *error) {
        returnedArray = supportedCardBrands;
        returnedError = error;
        [monitor signal];
    }];
    [monitor wait];
    
    XCTAssertNil(returnedArray, @"It should return nil.");
    XCTAssertNotNil(returnedError, @"It should not be nil.");
    XCTAssertEqualObjects([returnedError domain], WPYErrorDomain, @"It should be WPYErrorDomain.");
    XCTAssertEqual([returnedError code], WPYAPIError, @"It should be WPYInvalidExpiryYear.");
}

@end
