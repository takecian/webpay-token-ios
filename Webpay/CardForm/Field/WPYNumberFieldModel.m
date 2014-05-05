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

static BOOL isSpace(NSUInteger place, BOOL isAmex)
{
    if (isAmex)
    {
        return (place == 5 || place == 12);
    }
    else
    {
        return (place % 5 == 0);
    }
}



#pragma mark public methods
#pragma mark string manipulation
+ (NSString *)stripWhitespaces:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (NSString *)removeAllWhitespaces:(NSString *)string
{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}



#pragma mark number
+ (NSString *)addPaddingToNumber:(NSString *)number
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

+ (BOOL)isValidLength:(NSString *)number
{
    NSString *canonicalizedNumber = [self removeAllWhitespaces:number];
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
    return [UIImage imageNamed:[self removeAllWhitespaces:brand]];
}



#pragma mark textfield
+ (NSString *)spacedNumberFromTextFieldValue:(NSString *)value place:(NSUInteger)place deleted:(BOOL)isDeleted
{
    NSString *canonicalizedNumber = [self removeAllWhitespaces:value];
    NSString *brand = [WPYCreditCard brandNameFromPartialNumber:canonicalizedNumber];
    BOOL isAmex = [brand isEqualToString:@"American Express"];
    
    if (!isDeleted)
    {
        if ([self isValidLength:canonicalizedNumber])
        {
            return [self addPaddingToNumber:canonicalizedNumber];
        }
        else
        {
            // remove the new input
            return [value substringToIndex:value.length - 1];
        }
    }
    
    if (isSpace(place, isAmex) && isDeleted)
    {
        // remove space & character if the place delete commanded was space
        return [value substringToIndex:value.length - 1];
    }
    return value;
}



#pragma mark validation
+ (BOOL)validateNumber:(NSString *)number
                 error:(NSError * __autoreleasing *)error
{
    WPYCreditCard *card = [[WPYCreditCard alloc] init];
    return [card validateNumber:&number error:error];
}

+ (BOOL)shouldValidateWithText:(NSString *)text
{
    return text.length != 0; // don't valididate if length is 0
}
@end