//
//  WPYAbstractCardField.h
//  Webpay
//
//  Created by yohei on 4/17/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

// This class acts as a view & a controller.

#import <UIKit/UIKit.h>

#import "WPYAbstractFieldModel.h"

@class WPYCreditCard;
@interface WPYAbstractCardField : UIView
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UIImageView *rightView;

//designated initializer
- (instancetype)initWithFrame:(CGRect)frame card:(WPYCreditCard *)card;
- (void)setFocus:(BOOL)focus;
@end