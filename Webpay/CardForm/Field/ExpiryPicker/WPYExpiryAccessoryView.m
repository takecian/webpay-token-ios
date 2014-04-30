//
//  WPYExpiryAccessoryView.m
//  Webpay
//
//  Created by yohei on 4/25/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYExpiryAccessoryView.h"

#import "WPYConstants.h"

@interface WPYExpiryAccessoryView ()
@end

@implementation WPYExpiryAccessoryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = [[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1] CGColor];
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        doneButton.frame = CGRectMake(250, 0, 70, 44);
        [doneButton setTitle:NSLocalizedStringFromTable(@"Done", WPYLocalizedStringTable, nil)
                     forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(doneTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:doneButton];
    }
    return self;
}

- (void)doneTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(doneButtonTapped)])
    {
        [self.delegate doneButtonTapped];
    }
}

@end