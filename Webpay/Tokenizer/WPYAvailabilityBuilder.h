//
//  WPYAvailabilityBuilder.h
//  Webpay
//
//  Created by Okada Yohei on 9/1/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPYAvailabilityBuilder : NSObject
- (NSDictionary *)buildAvailabilityFromData:(NSData *)data error:(NSError * __autoreleasing *)outError;
@end
