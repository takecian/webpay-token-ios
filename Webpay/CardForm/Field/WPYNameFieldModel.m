//
//  WPYNameFieldModel.m
//  Webpay
//
//  Created by yohei on 5/5/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYNameFieldModel.h"

@implementation WPYNameFieldModel

- (WPYFieldKey)key
{
    return WPYNameFieldKey;
}

- (BOOL)shouldValidateOnFocusLost
{
    NSString *name = self.card.name;
    return name.length != 0; // don't valididate if length is 0
}

- (BOOL)validate:(NSError * __autoreleasing *)error
{
    NSString *name = self.card.name;
    return [self.card validateName:&name error:error];
}

- (NSString *)initialValueForTextField
{
    return self.card.name;
}

@end