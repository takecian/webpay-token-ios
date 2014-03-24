//
//  WPYErrors.m
//  Webpay
//
//  Created by yohei on 3/18/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYErrors.h"

// apple's recommendation com.company.framework_or_app.ErrorDomain
// https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/ErrorHandling/ErrorHandling.html
NSString *const WPYErrorDomain = @"com.webpay.webpay-token-ios";

static NSString *const WPYLocalizedStringTable = @"WebpayiOSTokenizer";

NSString * LocalizedDescriptionFromErrorCode(WPYErrorCode errorCode)
{
    switch (errorCode)
    {
        case WPYInvalidNumber:
            return NSLocalizedStringFromTable(@"", WPYLocalizedStringTable, nil);
        case WPYIncorrectNumber:
            return NSLocalizedStringFromTable(@"", WPYLocalizedStringTable, nil);
        case WPYInvalidName:
            return NSLocalizedStringFromTable(@"", WPYLocalizedStringTable, nil);
        case WPYInvalidExpiryMonth:
            return NSLocalizedStringFromTable(@"", WPYLocalizedStringTable, nil);
        case WPYInvalidExpiryYear:
            return NSLocalizedStringFromTable(@"", WPYLocalizedStringTable, nil);
        case WPYInvalidExpiry:
            return NSLocalizedStringFromTable(@"", WPYLocalizedStringTable, nil);
        case WPYIncorrectExpiry:
            return NSLocalizedStringFromTable(@"", WPYLocalizedStringTable, nil);
        case WPYInvalidCvc:
            return NSLocalizedStringFromTable(@"", WPYLocalizedStringTable, nil);
        case WPYIncorrectCvc:
            return NSLocalizedStringFromTable(@"", WPYLocalizedStringTable, nil);
        case WPYCardDeclined:
            return NSLocalizedStringFromTable(@"", WPYLocalizedStringTable, nil);
        case WPYMissing:
            return NSLocalizedStringFromTable(@"", WPYLocalizedStringTable, nil);
        case WPYProcessingError:
            return NSLocalizedStringFromTable(@"", WPYLocalizedStringTable, nil);
        case WPYInvalidRequestError:
            return NSLocalizedStringFromTable(@"", WPYLocalizedStringTable, nil);
        case WPYAPIError:
            return NSLocalizedStringFromTable(@"", WPYLocalizedStringTable, nil);
            
    }
}
