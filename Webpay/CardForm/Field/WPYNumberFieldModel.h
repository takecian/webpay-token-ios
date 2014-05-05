//
//  WPYNumberFieldModel.h
//  Webpay
//
//  Created by yohei on 5/4/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPYNumberFieldModel : NSObject

// string manipulation
+ (NSString *)stripWhitespaces:(NSString *)string;
+ (NSString *)removeAllWhitespaces:(NSString *)string;

// number
+ (NSString *)addPaddingToNumber:(NSString *)number;
+ (BOOL)isValidLength:(NSString *)number;

// brand
+ (UIImage *)brandLogoFromNumber:(NSString *)number;


// place expects to start from 1, instead of 0
+ (NSString *)spacedNumberFromTextFieldValue:(NSString *)value
                                       place:(NSUInteger)place
                                     deleted:(BOOL)isDeleted;

// validation
+ (BOOL)validateNumber:(NSString *)number
                 error:(NSError * __autoreleasing *)error;
+ (BOOL)shouldValidateWithText:(NSString *)text;
@end
