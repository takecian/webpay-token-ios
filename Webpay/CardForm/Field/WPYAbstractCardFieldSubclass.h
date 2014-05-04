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

- (void)setInitialText:(NSString *)text;

- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidChange:(id)sender;

// methods expected to be overridden
- (UITextField *)createTextFieldWithFrame:(CGRect)frame;
- (WPYFieldKey)key;
- (BOOL)shouldValidateOnFocusLost;
- (BOOL)validate:(NSError * __autoreleasing *)error;

- (BOOL)canInsertNewValue:(NSString *)newValue place:(NSUInteger)place charactedDeleted:(BOOL)isCharacterDeleted;
- (void)updateValue:(NSString *)newValue
              place:(NSUInteger)place
   charactedDeleted:(BOOL)isCharacterDeleted;
- (void)textFieldWillLoseFocus;
@end
