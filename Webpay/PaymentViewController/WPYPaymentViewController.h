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
@class WPYPaymentViewController;
typedef void (^WPYPaymentViewCallback)(WPYPaymentViewController *paymentViewController, WPYToken *token, NSError *error);


@interface WPYPaymentViewController : UIViewController
// If you don't need to provide initial values for form fields, use this initializer
+ (WPYPaymentViewController *)paymentViewControllerWithPriceTag:(NSString *)priceTag // price tag should include currency unit. i.e) $1.00
                                                       callback:(WPYPaymentViewCallback)callback;

+ (WPYPaymentViewController *)paymentViewControllerWithPriceTag:(NSString *)priceTag
                                                           card:(WPYCreditCard *)card // card properties will be used to populate textfield
                                                       callback:(WPYPaymentViewCallback)callback;

+ (WPYPaymentViewController *)paymentViewControllerWithPriceTag:(NSString *)priceTag
                                                supportedBrands:(NSArray *)brands // if you've prefetched supported brands, pass them here
                                                       callback:(WPYPaymentViewCallback)callback;

+ (WPYPaymentViewController *)paymentViewControllerWithPriceTag:(NSString *)priceTag
                                                           card:(WPYCreditCard *)card
                                                supportedBrands:(NSArray *)brands
                                                       callback:(WPYPaymentViewCallback)callback;

- (void)setPayButtonComplete;
- (void)dismissAfterDelay:(NSTimeInterval)delay;
- (void)popAfterDelay:(NSTimeInterval)delay;
@end
