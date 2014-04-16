//
//  WPYCardFormView.h
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPYNumberField;
@class WPYExpiryField;
@class WPYCvcField;
@class WPYNameField;

@interface WPYCardFormView : UIView

@property(nonatomic, strong) WPYNumberField *numberField;
@property(nonatomic, strong) WPYExpiryField *expiryField;
@property(nonatomic, strong) WPYCvcField *cvcField;
@property(nonatomic, strong) WPYNameField *nameField;
@end
