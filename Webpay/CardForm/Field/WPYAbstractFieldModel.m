//
//  WPYAbstractFieldModel.m
//  Webpay
//
//  Created by yohei on 5/5/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYAbstractFieldModel.h"

@implementation WPYAbstractFieldModel

#pragma mark initialization
- (instancetype)initWithCard:(WPYCreditCard *)card
{
    if (self = [super init])
    {
        _card = card;
    }
    
    return self;
}


#pragma mark accessor
- (WPYFieldKey)key
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark validation
- (BOOL)shouldValidateOnFocusLost
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (BOOL)validate:(NSError * __autoreleasing *)error
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}


#pragma mark textfield
- (NSString *)initialValueForTextField
{
    return nil;
}

- (BOOL)canInsertNewValue:(NSString *)newValue
{
    return YES;
}

- (NSString *)textFieldValueFromValue:(NSString *)value characterDeleted:(BOOL)isDeleted
{
    return value;
}
@end
