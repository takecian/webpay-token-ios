//
//  WPYPaymentViewController.h
//  Webpay
//
//  Created by yohei on 4/11/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPYToken;
@class WPYCreditCard;
@interface WPYPaymentViewController : UIViewController

typedef void (^WPYPaymentViewCallback)(WPYPaymentViewController *paymentViewController, WPYToken *token, NSError *error);

// designated initializer
- (instancetype)initWithButtonTitle:(NSString *)title // default button title is 'Confirm Payment'
                               card:(WPYCreditCard *)card // card properties will be used to populate textfield
                           callback:(WPYPaymentViewCallback)callback;

// If you don't need to provide initial values for form fields, use this initializer
- (instancetype)initWithButtonTitle:(NSString *)title
                           callback:(WPYPaymentViewCallback)callback;

- (void)setPayButtonComplete;
- (void)dismissAfterDelay:(NSTimeInterval)delay;
- (void)popAfterDelay:(NSTimeInterval)delay;
@end