//
//  WPYNumberFieldModel.m
//  Webpay
//
//  Created by yohei on 5/4/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYNumberFieldModel.h"

#import "WPYCreditCard.h"

static NSUInteger const WPYNonAmexNumberMaxLength = 16;
static NSUInteger const WPYAmexNumberMaxLength = 15;

@implementation WPYNumberFieldModel

#pragma mark helpers
static NSString *stripWhitespaces(NSString *string)
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

static NSString *removeAllWhitespaces(NSString *string)
{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

static NSString *addSpacesPerFourCharacters(NSString *string)
{
    NSMutableString *spacedString = [NSMutableString stringWithCapacity:string.length];
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length)
                               options:(NSStringEnumerationByComposedCharacterSequences)
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
                                {
                                        int place = (int)substringRange.location + 1;
                                        if (place % 4 == 0 && place != WPYNonAmexNumberMaxLength)
                                        {
                                            [spacedString appendString:[NSString stringWithFormat:@"%@ ", substring]];
                                        }
                                        else
                                        {
                                            [spacedString appendString:substring];
                                        }
                                }
    ];
    
    return spacedString;
}

static NSString *addSpacesToAmexNumber(NSString *number)
{
    NSMutableString *spacedString = [NSMutableString stringWithCapacity:number.length];
    [number enumerateSubstringsInRange:NSMakeRange(0, number.length)
                               options:(NSStringEnumerationByComposedCharacterSequences)
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         int place = (int)substringRange.location + 1;
         if (place == 4 || place == 10)
         {
             [spacedString appendString:[NSString stringWithFormat:@"%@ ", substring]];
         }
         else
         {
             [spacedString appendString:substring];
         }
     }
     ];
    
    return spacedString;
}

static BOOL isValidLength(NSString *number)
{
    NSString *canonicalizedNumber = removeAllWhitespaces(number);
    NSString *brand = [WPYCreditCard brandNameFromPartialNumber:number];
    if ([brand isEqualToString:WPYAmex])
    {
        return canonicalizedNumber.length <= WPYAmexNumberMaxLength;
    }
    else
    {
        return canonicalizedNumber.length <= WPYNonAmexNumberMaxLength;
    }
}

static NSString *addPaddingToNumber(NSString *number)
{
    NSString *brand = [WPYCreditCard brandNameFromPartialNumber:number];
    if ([brand isEqualToString:@"American Express"])
    {
        return addSpacesToAmexNumber(number);
    }
    else
    {
        return addSpacesPerFourCharacters(number);
    }
}



#pragma mark brand
+ (UIImage *)brandLogoFromNumber:(NSString *)number
{
    NSString *brandName = [self brandFromNumber:number];
    return [WPYNumberFieldModel imageOfBrand:brandName];
}

+ (NSString *)brandFromNumber:(NSString *)number
{
    return [WPYCreditCard brandNameFromPartialNumber:number];
}

+ (UIImage *)imageOfBrand:(NSString *)brand
{
    if (![WPYCreditCard isSupportedBrand:brand])
    {
        return nil;
    }
    return [UIImage imageNamed:removeAllWhitespaces(brand)];
}



#pragma mark accessors
- (WPYFieldKey)key
{
    return WPYNumberFieldKey;
}



#pragma mark validation
- (BOOL)shouldValidateOnFocusLost
{
    return self.card.number.length != 0; // don't valididate if length is 0
}

- (BOOL)validate:(NSError * __autoreleasing *)error
{
    NSString *number = self.card.number;
    return [self.card validateNumber:&number error:error];
}

- (NSString *)initialValueForTextField
{
    if (self.card.number)
    {
        return addPaddingToNumber(self.card.number);
    }
    return nil;
}

- (NSString *)textFieldValueFromValue:(NSString *)value characterDeleted:(BOOL)isDeleted
{
    NSString *canonicalizedNumber = removeAllWhitespaces(value);
    NSString *paddedNumber = addPaddingToNumber(canonicalizedNumber);
    if (isDeleted)
    {
        paddedNumber = stripWhitespaces(paddedNumber);
    }
    
    return paddedNumber;
}

- (BOOL)canInsertNewValue:(NSString *)newValue
{
    return isValidLength(newValue);
}

@end