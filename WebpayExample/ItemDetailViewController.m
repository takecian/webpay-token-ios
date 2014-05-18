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
    payButton.backgroundColor = [UIColor colorWithRed:0.98 green:0.41 blue:0.05 alpha:1];
    [payButton setTitle:@"Pay with Card" forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(showPaymentView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];
}


#pragma mark event handler
- (void)showPaymentView:(id)sender
{
    WPYPaymentViewCallback callback = ^(WPYPaymentViewController *paymentViewController, WPYToken *token, NSError *error)
    {
        if (token)
        {
            [[[UIAlertView alloc] initWithTitle:@"Success!"
                                        message:[NSString stringWithFormat:@"token:%@", token.tokenId]
                                       delegate:nil
                              cancelButtonTitle:@"dismiss"
                              otherButtonTitles:nil, nil]
             show];
            [paymentViewController setPayButtonComplete];
//            [paymentViewController popAfterDelay:1.0f];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:@"dismiss"
                              otherButtonTitles:nil, nil]
             show];
        }
    };
    
    WPYPaymentViewController *paymentViewController = [[WPYPaymentViewController alloc] initWithPriceTag:@"¥350" callback:callback];
    paymentViewController.title = @"Payment Info";
    
    [self.navigationController pushViewController:paymentViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end