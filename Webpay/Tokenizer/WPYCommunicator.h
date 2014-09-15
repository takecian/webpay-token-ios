//
//  WPYHTTPRequestSerializer.h
//  Webpay
//
//  Created by yohei on 4/3/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

// During a request, NSURLConnection maintains a strong reference to its delegate.
#import <Foundation/Foundation.h>

@class WPYCreditCard;

typedef void (^WPYCommunicatorCompBlock)(NSURLResponse *, NSData *, NSError *);

@interface WPYCommunicator : NSObject

- (instancetype)initWithPublicKey:(NSString *)publicKey
                   acceptLanguage:(NSString *)acceptLanguage;

- (void)requestTokenWithCard:(WPYCreditCard *)card
             completionBlock:(WPYCommunicatorCompBlock)compBlock;

- (void)fetchAvailabilityWithCompletionBlock:(WPYCommunicatorCompBlock)compBlock;
@end
