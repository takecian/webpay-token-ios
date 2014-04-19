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

static NSString *brandFromNumber(NSString *number)
{
    if (number.length < 2)
    {
        return @"Unknown";
    }
    
    NSInteger prefix = [[number substringWithRange:NSMakeRange(0, 2)] integerValue];
    
    if (40 <= prefix && prefix < 50)
    {
        return @"Visa";
    }
    
    if (50 <= prefix && prefix <= 55)
    {
        return @"Master Card";
    }
    
    if (prefix == 34 || prefix == 37)
    {
        return @"American Express";
    }
    
    if (prefix == 30 || prefix == 36 || prefix == 38 || prefix == 39)
    {
        return @"Diners";
    }
    
    if (prefix == 35)
    {
        return @"JCB";
    }
    
    if (prefix == 60 || prefix == 62 || prefix == 64 || prefix == 65)
    {
        return @"Discover";
    }
    
    return @"Unknown";
}


@interface WPYNumberField () <UITextFieldDelegate>
@end

@implementation WPYNumberField

#pragma mark initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _textField.placeholder = @"1234 5678 9012 3456";
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.delegate = self;
        [self addSubview:_textField];
    }
    return self;
}



#pragma mark 
- (WPYFieldKey)key
{
    return WPYNumberFieldKey;
}



#pragma mark textfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *newValue = [textField.text stringByReplacingCharactersInRange:range withString:replacementString];
    BOOL isCharacterDeleted = replacementString.length == 0;
    NSUInteger place = range.location + 1;
    
    [self updateNumberFieldWithNumber:newValue
                                place:place
                     charactedDeleted:isCharacterDeleted];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *number = textField.text;
    if (number.length == 0) // don't validate if the textfield is empty
    {
        return;
    }
    
    NSError *error = nil;
    WPYCreditCard *creditCard = [[WPYCreditCard alloc] init];
    if ([creditCard validateNumber:&number error:&error])
    {
        [self notifySuccess];
    }
    else
    {
        [self notifyError:error];
    }
}

#pragma mark private methods
- (void)updateNumberFieldWithNumber:(NSString *)number
                              place:(NSUInteger)place
                   charactedDeleted:(BOOL)isCharacterDeleted
{
    NSString *canonicalizedNumber = removeAllWhitespaces(number);
    if (isTooLongNumber(canonicalizedNumber)) // don't set number if more than 16 digits
    {
        return;
    }
    
    NSString *spacedNumber = spacedNumberFromNumber(canonicalizedNumber, place, isCharacterDeleted);
    self.textField.text = spacedNumber;
    [self updateBrand];
}

- (void)updateBrand
{
    NSString *brandName = brandFromNumber(self.textField.text);
}


@end