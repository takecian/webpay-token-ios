//
//  WPYNumberField.m
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYNumberField.h"

#import "WPYCreditCard.h"

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
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
                                {
                                        int place = substringRange.location + 1;
                                        if (place % 4 == 0)
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

static BOOL isTooLongNumber(NSString *canonicalizedNumber)
{
    return canonicalizedNumber.length > WPYNumberMaxLength;
}

static NSString *spacedNumberFromNumber(NSString *canonicalizedNumber, NSUInteger place, BOOL isDeleted)
{
    NSString *spacedNumber = addSpacesPerFourCharacters(canonicalizedNumber);
    if (canonicalizedNumber.length == WPYNumberMaxLength) // strip trailing whitespace if 16 digits
    {
        spacedNumber = stripWhitespaces(spacedNumber);
    }
    
    BOOL isSpace = (place != 1) && (place % 5 == 0);
    if (isSpace && isDeleted)
    {
        //delete space and the number before
        NSString *strippedString = stripWhitespaces(spacedNumber);
        spacedNumber = [strippedString substringToIndex:strippedString.length - 1];
    }
    
    return spacedNumber;
}



@interface WPYNumberField () <UITextFieldDelegate>
@end

@implementation WPYNumberField

#pragma mark override methods
- (UITextField *)createTextFieldWithFrame:(CGRect)frame
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    textField.placeholder = @"1234 5678 9012 3456";
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.delegate = self;
    
    return textField;
}

- (void)setInitialText:(NSString *)text
{
    NSString *initialText = text ? addSpacesPerFourCharacters(text) : nil;
    [super setInitialText:initialText];
}

- (WPYFieldKey)key
{
    return WPYNumberFieldKey;
}

- (BOOL)shouldValidateOnFocusLost
{
    NSString *number = self.textField.text;
    return number.length != 0; // don't valididate if length is 0
}

- (BOOL)validate:(NSError * __autoreleasing *)error
{
    NSString *number = self.textField.text;
    WPYCreditCard *card = [[WPYCreditCard alloc] init];
    return [card validateNumber:&number error:error];
}

- (BOOL)canInsertNewValue:(NSString *)newValue place:(NSUInteger)place charactedDeleted:(BOOL)isCharacterDeleted
{
    // intercept values to add/remove spaces
    return NO;
}

- (void)updateValue:(NSString *)newValue place:(NSUInteger)place charactedDeleted:(BOOL)isCharacterDeleted
{
    NSString *canonicalizedNumber = removeAllWhitespaces(newValue);
    if (isTooLongNumber(canonicalizedNumber))
    {
        return; // don't set number if more than 16 digits
    }
    NSString *spacedNumber = spacedNumberFromNumber(canonicalizedNumber, place, isCharacterDeleted);
    self.textField.text = spacedNumber;
    [self textFieldDidChange:self.textField];
    
    [self updateBrand];
}



#pragma mark brand animation
- (void)updateBrand
{
    NSString *brand = [WPYCreditCard brandNameFromPartialNumber:self.textField.text];
}


@end