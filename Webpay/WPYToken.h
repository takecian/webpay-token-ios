//
//  WPYToken.h
//  Webpay
//
//  Created by yohei on 4/5/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPYToken : NSObject
@property(nonatomic, copy) NSString *tokenId; // id is a reserved word
@property(nonatomic, strong) NSDictionary *cardInfo;
@end
