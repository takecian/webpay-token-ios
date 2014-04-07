//
//  WPYTokenizer.m
//  Webpay
//
//  Created by yohei on 3/30/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

// This class is a Facade.
// A common pattern for using 3rd party libraries is
// 1. initialize library at appdelegate
// 2. call method in where it's needed
// This allows applicaiton to initialize all the 3rd party libraries
// in one place. Since the places of initialization and method call
// are different, to avoid the hassle of passing around a pointer of an
// instance, a lot of the libraries are implemented as static class or singleton.

// 1. static class
// [Class setKey:@"key"]; (usually at app delegate)
// [Class method:parameter]; (usually at somewhere else from app delegate)

// 2. singleton
// [[Class sharedInstance] setKey:@"key"]; (at app delegate)
// [[Class sharedInstance] method:parameter];

// Static class has cleaner interface, but it has to hold state as static variable.
// Singleton has uglier interface, and it is hard to test.
// This library is implemented as static class for the benifit of the interface.

#import "WPYTokenizer.h"

#import "WPYCreditCard.h"
#import "WPYCommunicator.h"
#import "WPYTokenBuilder.h"
#import "WPYToken.h"
#import "WPYErrorBuilder.h"




@implementation WPYTokenizer

static NSString *publicKey = nil;

#pragma mark setters
+ (void)setPublicKey:(NSString *)key
{
    publicKey = key;
}

+ (NSString *)publicKey
{
    return publicKey;
}

+ (void)createTokenFromCard:(WPYCreditCard *)card
            completionBlock:(WPYTokenizerCompletionBlock)completionBlock
{
    NSParameterAssert(publicKey);
    NSParameterAssert(card);
    NSParameterAssert(completionBlock);
    
    NSError *cardError = nil;
    if (![card validate:&cardError])
    {
        completionBlock(nil, cardError);
        return;
    }
    
    WPYCommunicator *communicator = [[WPYCommunicator alloc] init];
    [communicator requestTokenWithPublicKey:publicKey
                                       card:card
                            completionBlock:^(NSURLResponse *response, NSData *data, NSError *networkError){
                                if (networkError)
                                {
                                    completionBlock(nil, networkError);
                                }
                                else // response recieved
                                {
                                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                    if (httpResponse.statusCode == 201)
                                    {
                                        WPYTokenBuilder *tokenBuilder = [[WPYTokenBuilder alloc] init];
                                        NSError *tokenBuildError = nil;
                                        WPYToken *token = [tokenBuilder buildTokenFromData:data error:&tokenBuildError];
                                        completionBlock(token, tokenBuildError);
                                    }
                                    else
                                    {
                                        WPYErrorBuilder *errorBuilder = [[WPYErrorBuilder alloc] init];
                                        NSError *buildError = [errorBuilder buildErrorFromData:data];
                                        completionBlock(nil, buildError);
                                    }
                                }
    }];
}

@end