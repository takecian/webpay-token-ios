//
//  WPYNumberField.m
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYNumberField.h"

@interface WPYNumberField () <UITextFieldDelegate>
@end

@implementation WPYNumberField

static NSUInteger const WPYNumberMaxLength = 16;

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
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
                                int place = substringRange.location + 1;
                                if (place % 4 == 0)
                                {
                                    [spacedString appendString:[NSString stringWithFormat:@"%@ ", substring]];
                                }
                                else
                                {
                                    [spacedString appendString:substring];
                                }
                                
    }];
    
    return spacedString;
}

#pragma mark initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.delegate = self;
        self.placeholder = @"1234 5678 9012 3456";
        self.keyboardType = UIKeyboardTypeNumberPad;
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *newValue = [textField.text stringByReplacingCharactersInRange:range withString:replacementString];
    BOOL isCharactedDeleted = replacementString.length == 0;
    NSUInteger place = range.location + 1;
    
    NSString *canonicalizedNumber = removeAllWhitespaces(newValue);
    if ([self isTooLongNumber:canonicalizedNumber])
    {
        return NO;
    }
    
    NSString *spacedNumber = [self spacedNumberFromNumber:canonicalizedNumber
                                                    place:place
                                                isDeleted:isCharactedDeleted];
    self.text = spacedNumber;
    return NO;
}

- (BOOL)isTooLongNumber:(NSString *)canonicalizedNumber
{
    return canonicalizedNumber.length > WPYNumberMaxLength;
}

- (NSString *)spacedNumberFromNumber:(NSString *)number
                               place:(NSUInteger)place
                           isDeleted:(BOOL)isDeleted;
{
    NSString *spacedNumber = addSpacesPerFourCharacters(number);
    if (number.length == WPYNumberMaxLength)
    {
        spacedNumber = stripWhitespaces(spacedNumber);
    }
    
    BOOL isSpace = place != 1 && place % 5 == 0;
    if (isSpace && isDeleted)
    {
        NSString *strippedString = stripWhitespaces(spacedNumber);
        spacedNumber = [strippedString substringToIndex:strippedString.length - 1];
    }
    
    return spacedNumber;
}
@end
