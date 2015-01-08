//
//  WPYHTTPRequestSerializer.m
//  Webpay
//
//  Created by yohei on 4/3/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYCommunicator.h"

#import "WPYCreditCard.h"
#import "WPYConstants.h"
#import "WPYErrors.h"
#import "WPYDeviceSettings.h"

@interface WPYCommunicator () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property(nonatomic, copy) WPYCommunicatorCompBlock completionBlock;
@property(nonatomic, copy) NSString *pubKey;
@property(nonatomic, copy) NSString *acceptLanguage;

@property(nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSURLResponse *receivedResponse;
@end

@implementation WPYCommunicator

static NSString *const WPYBaseURL = @"https://api.webpay.jp/v1";

#pragma mark helpers
// stringByAddingPercentEscapesUsingEncoding won't encode '&'
// https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/URLLoadingSystem/WorkingwithURLEncoding/WorkingwithURLEncoding.html#//apple_ref/doc/uid/10000165i-CH12-SW1
static NSString *urlEncode(NSString *string)
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
            kCFAllocatorDefault,
            (CFStringRef)string,
            NULL,
            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
            kCFStringEncodingUTF8
        )
    );
}

static NSDictionary *dictionaryFromCard(WPYCreditCard *card)
{
    return @{ 
                @"name"     : card.name,
                @"number"   : card.number,
                @"cvc"      : card.cvc,
                @"exp_month": [@(card.expiryMonth) stringValue],
                @"exp_year" : [@(card.expiryYear) stringValue]
           };
}

static NSData *requestParametersFromDictionary(NSDictionary *dictionary)
{
    __block NSMutableArray *parameters = [[NSMutableArray alloc] init];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        NSString *urlEncodedKey = urlEncode(key);
        NSString *urlEncodedValue = urlEncode(obj);
        NSString *parameter = [NSString stringWithFormat:@"card[%@]=%@", urlEncodedKey, urlEncodedValue];
        [parameters addObject:parameter];
    }];
    
    return [[parameters componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding];
}

static BOOL isTrustedHost(NSString *host)
{
    NSArray *trustedHosts = @[@"api.webpay.jp"];
    return [trustedHosts containsObject:host];
}

static NSMutableURLRequest *templateRequest(NSString *endPoint, NSString *publicKey, NSString *acceptLanguage)
{
    NSURL *url = [NSURL URLWithString:[WPYBaseURL stringByAppendingString:endPoint]];
    NSMutableURLRequest *templateRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [templateRequest addValue:[NSString stringWithFormat:@"Bearer %@", publicKey]
           forHTTPHeaderField:@"Authorization"];
    [templateRequest addValue:acceptLanguage forHTTPHeaderField:@"Accept-Language"];
    
    NSString *userAgent = [NSString stringWithFormat:@"WebPayTokeniOS/%@ %@/%@", WPYSDKVersion, [WPYDeviceSettings device], [WPYDeviceSettings osVersion]];
    [templateRequest addValue:userAgent forHTTPHeaderField:@"User-Agent"];

    return templateRequest;
}



#pragma mark public method
- (instancetype)initWithPublicKey:(NSString *)publicKey
                   acceptLanguage:(NSString *)acceptLanguage
{
    if (self = [super init])
    {
        _pubKey = publicKey;
        _acceptLanguage = acceptLanguage;
        
        _receivedData = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)requestTokenWithCard:(WPYCreditCard *)card
             completionBlock:(WPYCommunicatorCompBlock)compBlock
{
    self.completionBlock = compBlock;
    
    NSMutableURLRequest *request = templateRequest(@"/tokens", self.pubKey, self.acceptLanguage);
    request.HTTPMethod = @"POST";
    
    // set body
    NSDictionary *cardInfo = dictionaryFromCard(card);
    request.HTTPBody = requestParametersFromDictionary(cardInfo);
    
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)fetchAvailabilityWithCompletionBlock:(WPYCommunicatorCompBlock)compBlock
{
    self.completionBlock = compBlock;
    NSMutableURLRequest *request = templateRequest(@"/account/availability", self.pubKey, self.acceptLanguage);
    request.HTTPMethod = @"GET";
    
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}


#pragma mark NSURLConnection/Data Delegate - Download
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.receivedResponse = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.completionBlock(self.receivedResponse, self.receivedData, nil);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.completionBlock(self.receivedResponse, nil, error);
}



#pragma mark NSURLConnection Delegate - Authentication
/*
 https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/URLLoadingSystem/Articles/AuthenticationChallenges.html#//apple_ref/doc/uid/TP40009507-SW9
 */

// TODO: add ssl pinning
// pinning SubjectPublicKeyInfo is the way to go.
// Extracting info will be the hard part, if not using openssl

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    // If the request is asking to verify the server’s authenticity
    if ([[[challenge protectionSpace] authenticationMethod] isEqualToString: NSURLAuthenticationMethodServerTrust])
    {
        if (isTrustedHost(challenge.protectionSpace.host))
        {
            SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
            NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrust];
            [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        }
        else
        {
            [[challenge sender] cancelAuthenticationChallenge:challenge];
        }
    }
}

@end
