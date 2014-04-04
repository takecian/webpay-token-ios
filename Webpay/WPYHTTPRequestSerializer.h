//
//  WPYHTTPRequestSerializer.h
//  Webpay
//
//  Created by yohei on 4/3/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WPYCreditCard;
@interface WPYHTTPRequestSerializer : NSObject
- (NSURLRequest *)requestFromPublicKey:(NSString *)publicKey
                                  card:(WPYCreditCard *)card;
@end
