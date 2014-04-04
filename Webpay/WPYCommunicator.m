//
//  WPYHTTPRequestSerializer.m
//  Webpay
//
//  Created by yohei on 4/3/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYCommunicator.h"

#import "WPYCreditCard.h"

@implementation WPYCommunicator

static NSString *const apiURL = @"https://api.webpay.jp/v1/tokens";


static NSString *base64Encode(NSString *string)
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if ([data respondsToSelector:@selector(base64EncodedStringWithOptions:)])
    {
        //ios 7
        return [data base64EncodedStringWithOptions:0];
    }
    else
    {
        // pre ios 7
        return [data base64Encoding];
    }
}

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
                @"name"  : card.name,
                @"number": card.number,
                @"cvc"   : card.cvc,
                @"exp_month": [NSString stringWithFormat:@"%lu", card.expiryMonth],
                @"exp_year": [NSString stringWithFormat:@"%lu", card.expiryYear]
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

- (NSURLRequest *)requestFromPublicKey:(NSString *)publicKey card:(WPYCreditCard *)card
{
    NSParameterAssert(publicKey);
    NSParameterAssert(card);
    
    if (![card validate:nil])
    {
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:apiURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    request.HTTPMethod = @"POST";

    // set header
    NSString *credentials = [NSString stringWithFormat:@"%@:", publicKey];
    NSString *base64EncodedCredentials = base64Encode(credentials);
    [request addValue:[NSString stringWithFormat:@"Basic %@", base64EncodedCredentials]
   forHTTPHeaderField:@"Authorization"];
    
    // set body
    NSDictionary *cardInfo = dictionaryFromCard(card);
    request.HTTPBody = requestParametersFromDictionary(cardInfo);
    
    return request;
}
@end
