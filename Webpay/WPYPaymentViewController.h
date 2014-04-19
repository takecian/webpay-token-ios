//
//  WPYPaymentViewController.h
//  Webpay
//
//  Created by yohei on 4/11/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPYToken;
typedef void (^WPYPaymentViewCallback)(WPYToken *, NSError *);


@interface WPYPaymentViewController : UIViewController

// designated initializer
// default button title is 'Confirm Payment'
- (instancetype)initWithButtonTitle:(NSString *)title
                           callback:(WPYPaymentViewCallback)callback;
@end