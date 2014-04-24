//
//  ItemDetailViewController.m
//  Webpay
//
//  Created by yohei on 4/11/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "ItemDetailViewController.h"

#import "WPYPaymentViewController.h"
#import "WPYToken.h"

@interface ItemDetailViewController ()

@end

@implementation ItemDetailViewController

#pragma mark view lifecycle
- (void)loadView
{
	[super loadView];
	UIView *theView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
	theView.backgroundColor = [UIColor whiteColor];
	self.view = theView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.frame = CGRectMake(40, 280, 240, 44);
    payButton.layer.cornerRadius = 2;
    payButton.backgroundColor = [UIColor colorWithRed:0.18 green:0.8 blue:0.44 alpha:1];
    [payButton setTitle:@"Pay with Card" forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(showPaymentView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];
}


#pragma mark event handler
- (void)showPaymentView:(id)sender
{
    NSString *buttonTitle = @"Confirm and pay $1.00";
    WPYPaymentViewCallback callback = ^(WPYToken *token, NSError *error)
    {
        if (token)
        {
            [[[UIAlertView alloc] initWithTitle:@"success!"
                                        message:[NSString stringWithFormat:@"token:%@", token.tokenId]
                                       delegate:nil
                              cancelButtonTitle:@"ok"
                              otherButtonTitles:nil, nil]
             show];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"error"
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:@"ok"
                              otherButtonTitles:nil, nil]
             show];
        }
    };
    
    WPYPaymentViewController *paymentViewController = [[WPYPaymentViewController alloc] initWithButtonTitle:buttonTitle callback:callback];
    
    [self.navigationController pushViewController:paymentViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end