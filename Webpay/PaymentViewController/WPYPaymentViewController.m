//
//  WPYPaymentViewController.m
//  Webpay
//
//  Created by yohei on 4/11/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYPaymentViewController.h"

#import "WPYCardFormView.h"
#import "WPYTokenizer.h"

@interface WPYPaymentViewController ()<WPYCardFormViewDelegate>
@property(nonatomic, strong) WPYCreditCard *card;
@property(nonatomic, strong) WPYCardFormView *cardForm;

@property(nonatomic, copy) NSString *buttonTitle;
@property(nonatomic, copy) WPYPaymentViewCallback callback;

@property(nonatomic, strong) UIButton *payButton;
@property(nonatomic, strong) UIActivityIndicatorView *indicator;
@end



static float const WPYCardFormViewHeight = 300.0f; // for covering up non keyboard & expiry picker area.


@implementation WPYPaymentViewController
#pragma mark initializer
- (instancetype)initWithButtonTitle:(NSString *)title
                           callback:(WPYPaymentViewCallback)callback
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
        _callback = callback;
        _buttonTitle = title ? title : NSLocalizedString(@"Confirm Payment", nil);
    }
    
    return self;
}

// override designated initializer of super
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithButtonTitle:nil callback:nil];
}



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
    
    self.cardForm = [[WPYCardFormView alloc] initWithFrame:CGRectMake(0, 0, 320, WPYCardFormViewHeight)];
    self.cardForm.delegate = self;
    [self.view addSubview: self.cardForm];
    
    
    self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payButton.frame = CGRectMake(40, 320, 240, 44);
    self.payButton.layer.cornerRadius = 2;
    self.payButton.backgroundColor = [UIColor colorWithRed:0 green:0.478 blue:1.0 alpha:1.0];
    [self.payButton setTitle:self.buttonTitle forState:UIControlStateNormal];
    [self.payButton setTitle:@" " forState:UIControlStateSelected];
    [self.payButton addTarget:self
                       action:@selector(payButtonPushed:)
             forControlEvents:UIControlEventTouchUpInside];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.indicator setCenter:CGPointMake(120, 22)];
    [self.payButton addSubview:self.indicator];
    
    [self.view addSubview:self.payButton];
}


#pragma mark pay button
- (void)payButtonPushed:(id)sender
{
    [self startIndicator];
    WPYTokenizerCompletionBlock compBlock = ^(WPYToken *token, NSError *error)
    {
        [self stopIndicator];
        self.callback(token, error);
    };
    [WPYTokenizer createTokenFromCard:self.card completionBlock: compBlock];
}

- (void)startIndicator
{
    [self.payButton setSelected:YES];
    [self.indicator startAnimating];
}

- (void)stopIndicator
{
    [self.payButton setSelected:NO];
    [self.indicator stopAnimating];
}


#pragma mark WPYCardFormDelegate
- (void)invalidFieldName:(NSString *)fieldName error:(NSError *)error
{
}

- (void)validFormWithCard:(WPYCreditCard *)creditCard
{
    self.card = creditCard;
}



#pragma mark memory management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end