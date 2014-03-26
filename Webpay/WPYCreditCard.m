//
//  WPYCreditCard.m
//  Webpay
//
//  Created by yohei on 3/11/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYCreditCard.h"
#import "WPYErrors.h"

@implementation WPYCreditCard

static NSError *createNSError(WPYErrorCode errorCode, NSString *failureReason)
{
    NSString *localizedDescription = LocalizedDescriptionFromErrorCode(errorCode);
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: localizedDescription,
        NSLocalizedFailureReasonErrorKey: failureReason
    };
    return [[NSError alloc] initWithDomain:WPYErrorDomain code:errorCode userInfo:userInfo];
}

static void handleValidationError(NSError * __autoreleasing * error, WPYErrorCode errorCode, NSString *failureReason)
{
    if (error)
    {
        *error = createNSError(errorCode, failureReason);
    }
}

static BOOL isNumericOnlyString(NSString *string)
{
    NSCharacterSet *setOfNumbers = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *setFromString = [NSCharacterSet characterSetWithCharactersInString: string];
    return [setOfNumbers isSupersetOfSet: setFromString];
}

static BOOL isMatchWithRegex(NSString *string, NSString *regex)
{
    NSRange range = [string rangeOfString:regex options:NSRegularExpressionSearch];
    return range.location != NSNotFound;
}

static NSString *removeWhiteSpaces(NSString *string)
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

static NSString *removeHyphens(NSString *string)
{
    return [[string componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
}


- (NSString *)brandName
{
    NSString *cardNum = self.number;
    if (!cardNum)
    {
        return nil;
    }
    else
    {
        if (isMatchWithRegex(cardNum, @"4[0-9]{12}(?:[0-9]{3})?"))
        {
            return @"Visa";
        }

        if (isMatchWithRegex(cardNum, @"3[47][0-9]{13}"))
        {
            return @"American Express";
        }
        
        if (isMatchWithRegex(cardNum, @"5[1-5][0-9]{14}"))
        {
            return @"MasterCard";
        }

        if (isMatchWithRegex(cardNum, @"6(?:011|5[0-9]{2})[0-9]{12}"))
        {
            return @"Discover";
        }

        if (isMatchWithRegex(cardNum, @"(?:2131|1800|35\\d{3})\\d{11}"))
        {
            return @"JCB";
        }
        
        if (isMatchWithRegex(cardNum, @"3(?:0[0-5]|[68][0-9])[0-9]{11}"))
        {
            return @"Diners";
        }
        
        return @"Unknown";
    }
}

#pragma mark validation methods
- (BOOL)validateName:(__autoreleasing id *)ioValue error:(NSError *__autoreleasing *)outError
{
    if (*ioValue == nil)
    {
        NSString *failureReason = NSLocalizedStringFromTable(@"Name should not be nil.", WPYLocalizedStringTable, nil);
        handleValidationError(outError, WPYInvalidName, failureReason);
        return NO;
    }
    
    NSString *trimmedStr = removeWhiteSpaces((NSString *) *ioValue);
    if (trimmedStr.length == 0)
    {
        NSString *failureReason = NSLocalizedStringFromTable(@"Name should not be empty.", WPYLocalizedStringTable, nil);
        handleValidationError(outError, WPYInvalidName, failureReason);
        return NO;
    }
    
    return YES;
}


- (BOOL)validateCvc:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil)
    {
        NSString *failureReason = NSLocalizedStringFromTable(@"cvc should not be nil.", WPYLocalizedStringTable, nil);
        handleValidationError(outError, WPYInvalidCvc, failureReason);
        return NO;
    }
    
    NSString *trimmedStr = removeWhiteSpaces((NSString *) *ioValue);
    
    // reject non-numeric string
    if (!(isNumericOnlyString(trimmedStr)))
    {
        NSString *failureReason = NSLocalizedStringFromTable(@"cvc should be numeric only.", WPYLocalizedStringTable, nil);
        handleValidationError(outError, WPYInvalidCvc, failureReason);
        return NO;
    }
    
    NSString *brand = [self brandName];
    BOOL isAmex = [brand isEqualToString:@"American Express"];
    
    if (!brand)
    {
        if (trimmedStr.length < 3 || trimmedStr.length > 4)
        {
            NSString *failureReason = NSLocalizedStringFromTable(@"cvc should be 3 or 4 digits.", WPYLocalizedStringTable, nil);
            handleValidationError(outError, WPYInvalidCvc, failureReason);
            return NO;
        }
    }
    else
    {
        if (isAmex && trimmedStr.length != 4)
        {
            NSString *failureReason = NSLocalizedStringFromTable(@"cvc for amex card should be 4 digits.", WPYLocalizedStringTable, nil);
            handleValidationError(outError, WPYInvalidCvc, failureReason);
            return NO;
        }
        
        if (!isAmex && trimmedStr.length != 3)
        {
            NSString *failureReason = NSLocalizedStringFromTable(@"cvc for non amex card should be 3 digits.", WPYLocalizedStringTable, nil);
            handleValidationError(outError, WPYInvalidCvc, failureReason);
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)validateExpiryMonth:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil)
    {
        NSString *failureReason = NSLocalizedStringFromTable(@"Expiry month should not be nil.", WPYLocalizedStringTable, nil);
        handleValidationError(outError, WPYInvalidExpiryMonth, failureReason);
        return NO;
    }
    
    NSUInteger expiryMonth = [(NSNumber *) *ioValue intValue];
    if (expiryMonth < 1 || expiryMonth > 12 )
    {
        NSString *failureReason = NSLocalizedStringFromTable(@"Expiry month should be a number between 1 to 12.", WPYLocalizedStringTable, nil);
        handleValidationError(outError, WPYInvalidExpiryMonth, failureReason);
        return NO;
    }
    return YES;
}

- (BOOL)validateExpiryYear:(__autoreleasing id *)ioValue error:(NSError *__autoreleasing *)outError
{
    if (*ioValue == nil)
    {
        NSString *failureReason = NSLocalizedStringFromTable(@"Expiry year should not be nil.", WPYLocalizedStringTable, nil);
        handleValidationError(outError, WPYInvalidExpiryYear, failureReason);
        return NO;
    }
    
    return YES;
}

- (BOOL)validateExpiryYear:(NSUInteger)year month:(WPYMonth)month
{
    // first day of expiry month's next month
    // i.e if expiry is 2014/2, expiryDate is 2014/3/1
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setYear:year];
    [dateComps setMonth:month + 1];
    [dateComps setDay: 1];

    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *expiryDate = [gregorianCal dateFromComponents:dateComps];
    NSDate *now = [NSDate date];

    return ([now compare: expiryDate] == NSOrderedAscending);
}





@end