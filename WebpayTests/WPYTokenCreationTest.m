//
//  WPYTokenCreationTest.m
//  Webpay
//
//  Created by yohei on 4/6/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

// Integration test of WPYTokenizer

#import <XCTest/XCTest.h>
#import "OHHTTPStubs.h"
#import "TRVSMonitor.h"

#import "WPYTokenizer.h"
#import "WPYCreditCard.h"
#import "WPYToken.h"
#import "WPYErrors.h"

// this is a public key for test purpose
static NSString *const publicKey = @"test_public_a";
static NSString *const apiURL = @"https://api.webpay.jp/v1/tokens";

// This is actual json response from api when using test card & test public key.
static NSString *const tokenJSONString = @"{"
    @"\"card\":{"
        @"\"last4\": \"4111\","
        @"\"object\": \"card\","
        @"\"exp_year\": 2014,"
        @"\"exp_month\": 12,"
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

static NSString *const errorJSONString = @"{"
    @"\"error\": {"
        @"\"param\": \"exp_year\","
        @"\"code\": \"invalid_expiry_year\","
        @"\"message\": \"You must provide the card which is not expired\","
        @"\"type\": \"card_error\""
    @"}"
@"}";

static NSString *const errorJSONStringInJapanese = @"{"
    @"\"error\": {"
        @"\"param\": \"exp_year\","
        @"\"code\": \"invalid_expiry_year\","
        @"\"message\": \"JAPANESE\","
        @"\"type\": \"card_error\""
    @"}"
@"}";

static NSString *const validName = @"Test Test";
static NSString *const dinersNumber   = @"30569309025904";
static NSString *const invalidVisaNumber   = @"4111111111111112";

static NSString *const acceptLanguage = @"en";

@interface WPYTokenCreationTest : XCTestCase

@end

@implementation WPYTokenCreationTest
{
    WPYCreditCard *_creditCard;
    WPYCreditCard *_invalidCard;
}

- (void)setUp
{
    [super setUp];
    
    [WPYTokenizer setPublicKey:publicKey];
    
    _creditCard = [[WPYCreditCard alloc] init];
    _creditCard.name = validName;
    _creditCard.number = dinersNumber;
    _creditCard.cvc = @"123";
    _creditCard.expiryYear = 2014;
    _creditCard.expiryMonth = 12;
    
    _invalidCard = [[WPYCreditCard alloc] init];
    _invalidCard.name = validName;
    _invalidCard.number = invalidVisaNumber;
    _invalidCard.cvc = @"123";
    _invalidCard.expiryYear = 2014;
    _invalidCard.expiryMonth = 12;
}

- (void)tearDown
{
    [WPYTokenizer setPublicKey:nil];
    _creditCard = nil;
    _invalidCard = nil;
    
    [OHHTTPStubs removeAllStubs];
    
    [super tearDown];
}

- (void)testCallingCreateTokenWithoutSettingPublicKeyRaisesException
{
    [WPYTokenizer setPublicKey:nil];
    XCTAssertThrows([WPYTokenizer createTokenFromCard:_creditCard
                                       acceptLanguage:acceptLanguage
                                      completionBlock:^(WPYToken *token, NSError *error){
    }], @"It should throw exception if public key is nil.");
}

- (void)testCallingCreateTokenWithInvalidPublicKeyRaisesException
{
    [WPYTokenizer setPublicKey:@"live_secret_a"];
    XCTAssertThrows([WPYTokenizer createTokenFromCard:_creditCard
                                       acceptLanguage:acceptLanguage
                                      completionBlock:^(WPYToken *token, NSError *error){
    }], @"It should throw exception if public key is invalid.");
}

- (void)testCallingCreateTokenWithValidPublicKeyDoesNotRaiseException
{
    [WPYTokenizer setPublicKey:@"live_public_a"];
    XCTAssertNoThrow([WPYTokenizer createTokenFromCard:_invalidCard
                                       acceptLanguage:acceptLanguage
                                       completionBlock:^(WPYToken *token, NSError *error){
                                           
    }], @"It should not throw exception if public key is valid.");
}

- (void)testCallingCreateTokenWithoutCardRaisesException
{
    XCTAssertThrows([WPYTokenizer createTokenFromCard:nil
                                       acceptLanguage:acceptLanguage
                                      completionBlock:^(WPYToken *token, NSError *error){
    }], @"It should throw exception if card is nil.");
}

- (void)testCallingCreateTokenWithoutCompletionBlockRaisesException
{
    XCTAssertThrows([WPYTokenizer createTokenFromCard:_creditCard
                                       acceptLanguage:acceptLanguage
                                      completionBlock:nil],
                     @"It should throw exception if completion block is nil.");
}

- (void)testCallingCreateTokenWithInvalidCardReturnsNil
{
    __block WPYToken *returnedToken = nil;
    [WPYTokenizer createTokenFromCard:_invalidCard
                       acceptLanguage:acceptLanguage
                      completionBlock:^(WPYToken *token, NSError *error){
                          returnedToken = token;
                      }];
    
    XCTAssertNil(returnedToken, @"It should return nil if invalid card is passed.");
}

- (void)testCallingCreateTokenWithInvalidCardReturnsExpectedError
{
    __block NSError *returnedError = nil;
    [WPYTokenizer createTokenFromCard:_invalidCard
                       acceptLanguage:acceptLanguage
                      completionBlock:^(WPYToken *token, NSError *error){
                          returnedError = error;
                      }];
    
    XCTAssertNotNil(returnedError, @"It should not be nil.");
    XCTAssertEqualObjects([returnedError domain], WPYErrorDomain, @"It should be WPYErrorDomain");
    XCTAssertEqual([returnedError code], WPYIncorrectNumber, @"Error code should be WPYIncorrectNumber.");
    XCTAssertEqualObjects([returnedError localizedDescription], @"The card number is incorrect. Make sure you entered the correct card number.", @"It should return expected localized description.");
    NSDictionary *userInfo = [returnedError userInfo];
    NSString *failureReason = [userInfo objectForKey:NSLocalizedFailureReasonErrorKey];
    XCTAssertEqualObjects(failureReason, @"This number is not Luhn valid string.", @"It should return expected failure reason.");
}

- (void)testCreateTokenReturnsNilForNetworkError
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
    __block WPYToken *returnedToken = nil;
    [WPYTokenizer createTokenFromCard:_invalidCard
                       acceptLanguage:acceptLanguage
                      completionBlock:^(WPYToken *token, NSError *error){
                          returnedToken = token;
                          [monitor signal];
                      }];
    [monitor wait];
    XCTAssertNil(returnedToken, @"It should return nil if there is a network error.");
}

- (void)testCreateTokenReturnsExpectedErrorForNetworkError
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
    
    __block NSError *returnedError = nil;
    [WPYTokenizer createTokenFromCard:_creditCard
                       acceptLanguage:acceptLanguage
                      completionBlock:^(WPYToken *token, NSError *error){
                          returnedError = error;
                          [monitor signal];
                      }];
    [monitor wait];
    
    XCTAssertNotNil(returnedError, @"It should not be nil.");
    XCTAssertEqualObjects([returnedError domain], NSURLErrorDomain, @"It should be NSURLErrorDomain.");
    XCTAssertEqual([returnedError code], NSURLErrorNotConnectedToInternet, @"Error code should be NSURLErrorNotConnectedToInternet.");
}

- (void)testCreateTokenCreatesExpectedToken
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSString *urlString = [request.URL absoluteString];
        if ([urlString isEqualToString:apiURL])
        {
            return YES;
        }
        return NO;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:[tokenJSONString dataUsingEncoding:NSUTF8StringEncoding]
                                          statusCode:201
                                             headers:nil];
    }];

    TRVSMonitor *monitor = [TRVSMonitor monitor];
    
    __block WPYToken *returnedToken = nil;

    [WPYTokenizer createTokenFromCard:_creditCard
                       acceptLanguage:acceptLanguage
                      completionBlock:^(WPYToken *token, NSError *error){
                          returnedToken = token;
                          [monitor signal];
                      }];
    [monitor wait];
    
    XCTAssertEqualObjects(returnedToken.tokenId, @"tok_4hB8eGcxL9KffML", @"Token should be the same as in json.");
    NSDictionary *cardInfo = returnedToken.cardInfo;
    NSDictionary *expectedCardInfo =
    @{
        @"last4": @"4111",
        @"object": @"card",
        @"exp_year": @2014,
        @"exp_month": @12,
        @"fingerprint": @"215b5b2fe460809b8bb90bae6eeac0e0e0987bd7",
        @"name": @"KEI KUBO",
        @"country": @"JP",
        @"type": @"Visa",
        @"cvc_check": @"pass"
    };
    
    XCTAssertEqualObjects(cardInfo, expectedCardInfo, @"cardInfo should be the same as card dictionary in json.");
}

- (void)testCreateTokenDoesNotReturnErrorWhenTokenIsCreated
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSString *urlString = [request.URL absoluteString];
        if ([urlString isEqualToString:apiURL])
        {
            return YES;
        }
        return NO;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:[tokenJSONString dataUsingEncoding:NSUTF8StringEncoding]
                                          statusCode:201
                                             headers:nil];
    }];

    TRVSMonitor *monitor = [TRVSMonitor monitor];
    
    __block NSError *returnedError = nil;

    [WPYTokenizer createTokenFromCard:_creditCard
                       acceptLanguage:acceptLanguage
                      completionBlock:^(WPYToken *token, NSError *error){
                          returnedError = error;
                          [monitor signal];
                      }];
    [monitor wait];
    
    XCTAssertNil(returnedError, @"It should not return any error.");
}

- (void)testCreateTokenReturnsNilWhenRecievedErrorJSON
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
                                          statusCode:402
                                             headers:nil];
    }];

    TRVSMonitor *monitor = [TRVSMonitor monitor];
    
    __block WPYToken *returnedToken = nil;

    [WPYTokenizer createTokenFromCard:_creditCard
                       acceptLanguage:acceptLanguage
                      completionBlock:^(WPYToken *token, NSError *error){
                          returnedToken = token;
                          [monitor signal];
                      }];
    [monitor wait];
    
    XCTAssertNil(returnedToken, @"It should return nil when error json is returned.");
}

- (void)testCreateTokenBuildsExpectedError
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
                                          statusCode:402
                                             headers:nil];
    }];

    TRVSMonitor *monitor = [TRVSMonitor monitor];
    
    __block NSError *returnedError = nil;

    [WPYTokenizer createTokenFromCard:_creditCard
                       acceptLanguage:acceptLanguage
                      completionBlock:^(WPYToken *token, NSError *error){
                          returnedError = error;
                          [monitor signal];
                      }];
    [monitor wait];
    
    XCTAssertNotNil(returnedError, @"It should not be nil.");
    XCTAssertEqualObjects([returnedError domain], WPYErrorDomain, @"It should be WPYErrorDomain.");
    XCTAssertEqual([returnedError code], WPYInvalidExpiryYear, @"It should be WPYInvalidExpiryYear.");
}



#pragma mark test accept language
- (void)testAcceptLanguage
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSString *urlString = [request.URL absoluteString];
        if ([urlString isEqualToString:apiURL])
        {
            return YES;
        }
        return NO;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        NSString *acceptLanguage = [request valueForHTTPHeaderField:@"Accept-Language"];
        if ([acceptLanguage isEqualToString:@"ja"])
        {
            return [OHHTTPStubsResponse responseWithData:[errorJSONStringInJapanese dataUsingEncoding:NSUTF8StringEncoding]
                                          statusCode:402
                                             headers:nil];
        }
        else
        {
            return [OHHTTPStubsResponse responseWithData:[errorJSONString dataUsingEncoding:NSUTF8StringEncoding]
                                          statusCode:402
                                             headers:nil];
        }

    }];

    TRVSMonitor *monitor = [TRVSMonitor monitor];
    
    __block NSError *returnedError = nil;

    [WPYTokenizer createTokenFromCard:_creditCard
                       acceptLanguage:@"ja"
                      completionBlock:^(WPYToken *token, NSError *error){
                          returnedError = error;
                          [monitor signal];
                      }];
    [monitor wait];
    
    XCTAssertEqual([returnedError code], WPYInvalidExpiryYear, @"It should be WPYInvalidExpiryYear.");
    XCTAssertEqualObjects([returnedError localizedDescription], @"JAPANESE", @"It should return error message in japanese.");
}


@end
