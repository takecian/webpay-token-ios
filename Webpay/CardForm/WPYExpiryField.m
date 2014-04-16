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
#pragma mark initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.placeholder = @"01/15";
    
        WPYExpiryPickerView *expiryPicker = [[WPYExpiryPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        expiryPicker.expiryDelegate = self;
        self.inputView = expiryPicker;
    }
    return self;
}


#pragma mark expiry picker delegate
- (void)didSelectExpiryYear:(NSString *)year month:(NSString *)month
{
    NSString *expiry = [NSString stringWithFormat:@"%@/%@", year, month];
    self.text = expiry;
}
@end
