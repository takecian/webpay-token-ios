//
//  WPYExpiryField.m
//  Webpay
//
//  Created by yohei on 4/16/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYExpiryField.h"

#import "WPYExpiryPickerView.h"

@interface WPYExpiryField () <WPYExpiryPickerViewDelegate>
- (void)didSelectExpiryYear:(NSString *)year month:(NSString *)month;
@end


@implementation WPYExpiryField
{
    UITextField *_expiryField;
}


#pragma mark initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _expiryField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _expiryField.placeholder = @"01/15";
    
        WPYExpiryPickerView *expiryPicker = [[WPYExpiryPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        expiryPicker.expiryDelegate = self;
        _expiryField.inputView = expiryPicker;
        
        [self addSubview:_expiryField];
    }
    return self;
}

- (NSString *)text
{
    return _expiryField.text;
}

#pragma mark expiry picker delegate
- (void)didSelectExpiryYear:(NSString *)year month:(NSString *)month
{
    NSString *expiry = [NSString stringWithFormat:@"%@/%@", month, year];
    _expiryField.text = expiry;
}
@end
