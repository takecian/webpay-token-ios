//
//  WPYAbstractCardFieldSubclass.h
//  Webpay
//
//  Created by yohei on 4/17/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WPYAbstractCardField.h"

@class WPYAbstractFieldModel;
@interface WPYAbstractCardField ()<UITextFieldDelegate>
@property(nonatomic, strong) WPYAbstractFieldModel *model;

- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldHasNewInput:(NSString *)newInput charactedDeleted:(BOOL)isDeleted;

// methods expected to be overridden
// initialization
- (UITextField *)createTextFieldWithFrame:(CGRect)frame;
- (UIImageView *)createRightView;
- (WPYAbstractFieldModel *)createFieldModelWithCard:(WPYCreditCard *)card;

- (void)textFieldChanged;

// did end editing
- (void)updateValidityView:(BOOL)valid;
- (void)textFieldWillLoseFocus;

@end