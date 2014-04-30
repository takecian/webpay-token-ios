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
- (void)notifyValidity;
- (void)notifyError:(NSError *)error;

// should override
- (WPYFieldKey)key;
- (BOOL)shouldValidate;
- (BOOL)validate:(NSError * __autoreleasing *)error;

- (void)textFieldDidBeginEditing:(UITextField *)textField;

- (BOOL)canInsertNewValue:(NSString *)newValue place:(NSUInteger)place charactedDeleted:(BOOL)isCharacterDeleted;
- (void)updateValue:(NSString *)newValue
              place:(NSUInteger)place
   charactedDeleted:(BOOL)isCharacterDeleted;
- (void)textFieldDidChange:(id)sender;
@end
