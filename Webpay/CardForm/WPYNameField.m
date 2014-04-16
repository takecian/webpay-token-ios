//
//  WPYNameField.m
//  Webpay
//
//  Created by yohei on 4/16/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYNameField.h"

@implementation WPYNameField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.placeholder = @"Taro Yamada";
        self.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return self;
}

@end
