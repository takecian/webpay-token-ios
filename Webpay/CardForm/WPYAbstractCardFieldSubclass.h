//
//  WPYAbstractCardFieldSubclass.h
//  Webpay
//
//  Created by yohei on 4/17/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WPYAbstractCardField.h"

@interface WPYAbstractCardField ()<UITextFieldDelegate>

@property(nonatomic, strong) UITextField *textField;

- (void)setErrorColor;
- (void)setNormalColor;
- (WPYFieldKey)key;

- (void)textFieldDidBeginEditing:(UITextField *)textField;
@end
