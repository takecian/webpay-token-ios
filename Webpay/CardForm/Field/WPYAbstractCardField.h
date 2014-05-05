//
//  WPYAbstractCardField.h
//  Webpay
//
//  Created by yohei on 4/17/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WPYFieldKey)
{
    WPYNumberFieldKey,
    WPYExpiryFieldKey,
    WPYCvcFieldKey,
    WPYNameFieldKey
};

@protocol WPYCardFieldDelegate <NSObject>
@optional
- (void)validValue:(NSString *)value forKey:(WPYFieldKey)key;
- (void)invalidValue:(NSString *)value forKey:(WPYFieldKey)key error:(NSError *)error;
@end

@interface WPYAbstractCardField : UIView
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UIImageView *rightView;
@property(nonatomic, weak) id <WPYCardFieldDelegate> delegate;

//designated initializer
- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text;
- (void)setFocus:(BOOL)focus;
- (NSString *)text;
@end