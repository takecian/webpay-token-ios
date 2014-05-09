//
//  WPYCvcExplanationView.m
//  Webpay
//
//  Created by yohei on 5/8/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYCvcExplanationView.h"

@interface WPYCvcExplanationView ()
@property(nonatomic, strong) UIImageView *imageView;
@end

@implementation WPYCvcExplanationView

// create singleton and show/hide

#pragma mark public methods
+ (void)showAmexCvcExplanation
{
    WPYCvcExplanationView *cvcView = [self sharedView];
    [cvcView.imageView setImage:[UIImage imageNamed:@"cvcamex"]];
    
    [self showOverlay:cvcView];
}

+ (void)showNonAmexCvcExplanation
{
    WPYCvcExplanationView *cvcView = [self sharedView];
    [cvcView.imageView setImage:[UIImage imageNamed:@"cvc"]];
    
    [self showOverlay:cvcView];
}

+ (void)showOverlay:(WPYCvcExplanationView *)overlay
{
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview: overlay];
}



#pragma mark private methods
// singleton
+ (WPYCvcExplanationView *)sharedView
{
    static dispatch_once_t once;
    static WPYCvcExplanationView *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    
    return sharedView;
}

- (void)dismissOverlay
{
    [[WPYCvcExplanationView sharedView] removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        // add uiimageview
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 130, 280, 168)];
        [self addSubview:self.imageView];
        
        // add gesture
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissOverlay)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
    }
    
    return self;
}
@end