//
//  WPYAbstractFieldModel.h
//  Webpay
//
//  Created by yohei on 5/5/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WPYCreditCard.h"

typedef NS_ENUM(NSInteger, WPYFieldKey)
{
    WPYNumberFieldKey,
    WPYExpiryFieldKey,
    WPYCvcFieldKey,
    WPYNameFieldKey
};

@interface WPYAbstractFieldModel : NSObject
@property(nonatomic, strong) WPYCreditCard *card;

- (instancetype)initWithCard:(WPYCreditCard *)card;

// methods to be overriden
- (WPYFieldKey)key;

// called at did end editing & textfield did change
- (BOOL)shouldValidateOnFocusLost;
- (BOOL)validate:(NSError * __autoreleasing *)error;

- (NSString *)initialValueForTextField;
- (BOOL)canInsertNewValue:(NSString *)newValue;
- (NSString *)textFieldValueFromValue:(NSString *)value characterDeleted:(BOOL)isDeleted;
@end