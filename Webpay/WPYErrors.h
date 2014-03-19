//
//  WPYErrors.h
//  Webpay
//
//  Created by yohei on 3/18/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const WPYErrorDomain;

NS_ENUM(int, WPYErrorCode){
    WPYCardError = 1,
    WPYInvalidRequestError,
    WPYAPIError
};