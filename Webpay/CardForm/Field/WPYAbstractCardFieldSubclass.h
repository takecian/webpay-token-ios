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

- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidChange:(id)sender;

// methods expected to be overridden
// view creation
- (UITextField *)createTextFieldWithFrame:(CGRect)frame;
- (UIImageView *)createRightView;

- (WPYFieldKey)key;

// did end editing
- (BOOL)shouldValidateOnFocusLost;
- (void)textFieldWillLoseFocus;
- (void)updateValidityView:(BOOL)valid;

// did end editing & textfield did change
- (BOOL)validate:(NSError * __autoreleasing *)error;

// new input
- (BOOL)canInsertNewValue:(NSString *)newValue place:(NSUInteger)place charactedDeleted:(BOOL)isCharacterDeleted;
- (void)updateValue:(NSString *)newValue
              place:(NSUInteger)place
   charactedDeleted:(BOOL)isCharacterDeleted;
@end
