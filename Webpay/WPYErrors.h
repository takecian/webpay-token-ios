//
//  WPYErrors.h
//  Webpay
//
//  Created by yohei on 3/18/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const WPYErrorDomain;

FOUNDATION_EXPORT NSString *const WPYLocalizedStringTable;

// https://webpay.jp/docs/api/curl
// Webpay returns 3 types of errors: card error, invalid request error, and api error
// error code 1xx is assigned to card error, 2xx to invalid request error, and 3xx to api error

typedef NS_ENUM(int, WPYErrorCode){
    // card errors
    WPYInvalidNumber = 100,
    WPYIncorrectNumber = 101,
    WPYInvalidName = 102,
    WPYInvalidExpiryMonth = 103,
    WPYInvalidExpiryYear = 104,
    WPYInvalidExpiry = 105,
    WPYIncorrectExpiry = 106,
    WPYInvalidCvc = 107,
    WPYIncorrectCvc = 108,
    WPYCardDeclined = 109,
    WPYMissing = 110,
    WPYProcessingError = 111,
    
    // invalid request error
    WPYInvalidRequestError = 200,
    
    // api error
    WPYAPIError = 300
};

// returns localized description for nserror returned from Webpay ios tokenizer
FOUNDATION_EXPORT NSString * LocalizedDescriptionFromErrorCode(WPYErrorCode errorCode);
