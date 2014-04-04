//
//  WPYHTTPRequestSerializerTest.m
//  Webpay
//
//  Created by yohei on 4/3/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WPYHTTPRequestSerializer.h"
#import "WPYCreditCard.h"

@interface WPYHTTPRequestSerializerTest : XCTestCase

@end

static NSString *const publicKey = @"public key";

@implementation WPYHTTPRequestSerializerTest
{
    WPYHTTPRequestSerializer *_serializer;
    
    WPYCreditCard *_card;
}

- (void)setUp
{
    [super setUp];
    _serializer = [[WPYHTTPRequestSerializer alloc] init];
    
    _card = [[WPYCreditCard alloc] init];
    _card.name = @"岡田洋平";
    _card.number = @"4111111111111111";
    _card.cvc = @"123";
    _card.expiryYear = 2014;
    _card.expiryMonth = 12;
}

- (void)tearDown
{
    _serializer = nil;
    _card = nil;
    [super tearDown];
}

#pragma mark requestFromPublicKey:card:
- (void)testNilPublicKeyRaisesException
{
    XCTAssertThrows([_serializer requestFromPublicKey:nil card:_card], @"It should raise exception when public key is nil.");
}

- (void)testNilCardRaisesException
{
    XCTAssertThrows([_serializer requestFromPublicKey:publicKey card:nil], @"It should raise exception when card is nil.");
}

- (void)testValidParametersDoesNotThrowException
{
    XCTAssertNoThrow([_serializer requestFromPublicKey:publicKey card:_card], @"It should not raise exception if non nil parameters are passed.");
}

- (void)testInvalidCardReturnsNil
{
    WPYCreditCard *invalidCard = [[WPYCreditCard alloc] init];
    XCTAssertNil([_serializer requestFromPublicKey:publicKey card: invalidCard], @"It should return nil for invalid card.");
}

- (void)testValidCardReturnsExpectedRequest
{
    NSURLRequest *request = [_serializer requestFromPublicKey:publicKey card:_card];
    XCTAssertNotNil(request, @"Request should not be nil.");
    
    XCTAssertEqualObjects([request.URL absoluteString], @"https://api.webpay.jp/v1/tokens", @"It should set url to expected endpoint.");
    
    XCTAssertEqualObjects(request.HTTPMethod, @"POST", @"HTTP method should be set as POST.");
    
    XCTAssertEqualObjects([request valueForHTTPHeaderField:@"Authorization"], @"Basic cHVibGljIGtleTo=", @"It should base64 encode credentials");
    
    NSString *queryString = [[NSString alloc] initWithData:request.HTTPBody encoding: NSUTF8StringEncoding];
    NSArray *parameters = [queryString componentsSeparatedByString:@"&"];
    NSMutableDictionary *queryDic = [[NSMutableDictionary alloc] init];
    [parameters enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        NSArray *keyValuePair = [(NSString *)obj componentsSeparatedByString:@"="];
        queryDic[keyValuePair[0]] = keyValuePair[1];
    }];
    
    XCTAssertEqualObjects(queryDic[@"card[name]"], @"%E5%B2%A1%E7%94%B0%E6%B4%8B%E5%B9%B3", @"card[name] should be set as percent escaped name");
    XCTAssertEqualObjects(queryDic[@"card[number]"], @"4111111111111111", @"card[number] should be set as number.");
    XCTAssertEqualObjects(queryDic[@"card[cvc]"], @"123", @"card[cvc] should be set as 123.");
    XCTAssertEqualObjects(queryDic[@"card[exp_year]"], @"2014", @"card[exp_year] should be set as 2014.");
    XCTAssertEqualObjects(queryDic[@"card[exp_month]"], @"12", @"card[exp_month] should be set as 12.");
}
@end
