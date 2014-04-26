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

static UIImage *imageFromColor(UIColor *color)
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

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
    
    self.payButton = [self createPayButton];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.indicator setCenter:CGPointMake(120, 22)];
    [self.payButton addSubview:self.indicator];
    
    [self.view addSubview:self.payButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.cardForm setFocusToFirstField];
}


#pragma mark pay button
- (UIButton *)createPayButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(40, 320, 240, 44);
    button.layer.cornerRadius = 2;
    button.layer.masksToBounds = YES;
    
    [button setTitle:self.buttonTitle forState:UIControlStateNormal];
    [button setTitle:@" " forState:UIControlStateSelected];
    
    [button setBackgroundImage:imageFromColor([UIColor colorWithRed:0 green:0.478 blue:1.0 alpha:0.8]) forState:UIControlStateNormal];
    [button setBackgroundImage:imageFromColor([UIColor colorWithRed:0 green:0.478 blue:1.0 alpha:1]) forState:UIControlStateHighlighted];
    
    [button addTarget:self
                       action:@selector(payButtonPushed:)
             forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)payButtonPushed:(id)sender
{
    if (self.card == nil)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please fill in card info."
                                   delegate:nil
                          cancelButtonTitle:@"dismiss"
                          otherButtonTitles:nil, nil] show];
        return;
    }
    
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