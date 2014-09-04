//
//  WPYAvailabilityBuilder.m
//  Webpay
//
//  Created by Okada Yohei on 9/1/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYAvailabilityBuilder.h"

@implementation WPYAvailabilityBuilder
- (NSDictionary *)buildAvailabilityFromData:(NSData *)data
                                      error:(NSError * __autoreleasing *)outError
{
    NSError *serializeError = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data
                                                options:0
                                                  error:&serializeError];
    
    if (object == nil)
    {
        if (outError)
        {
            *outError = serializeError;
        }
        return nil;
    }
    
    if ([object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *json = object;
        return json;
    }
    
    return nil;
}
@end
