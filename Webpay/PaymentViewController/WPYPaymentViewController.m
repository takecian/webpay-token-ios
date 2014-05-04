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
#import "WPYCreditCard.h"

#import "WPYConstants.h"


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
                               card:(WPYCreditCard *)card
                           callback:(WPYPaymentViewCallback)callback
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
        _callback = callback;
        _buttonTitle = title ? title : NSLocalizedString(@"Confirm Payment", nil);
        _card = card;
    }
    
    return self;
}

- (instancetype)initWithButtonTitle:(NSString *)title
                           callback:(WPYPaymentViewCallback)callback
{
    WPYCreditCard *card = [[WPYCreditCard alloc] init];
    return [self initWithButtonTitle:title card:card callback:callback];
}

// override designated initializer of super
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithButtonTitle:nil callback:nil];
}



#pragma mark public methods: compeletion
- (void)setPayButtonComplete
{
    [self.payButton setTitle:@"Payment Confirmed!" forState:UIControlStateNormal];
    [self.payButton setBackgroundImage:imageFromColor([UIColor colorWithRed:0.18 green:0.8 blue:0.44 alpha:1]) forState:UIControlStateNormal];
    // TODO: add a check mark
}

- (void)dismissAfterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:delay];
}

- (void)dismiss
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)popAfterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(pop) withObject:nil afterDelay:delay];
}

- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark view lifecycle
- (void)loadView
{
	[super loadView];
	UIView *theView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    theView.backgroundColor = [UIColor whiteColor];
	self.view = theView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (isiOS7())
    {
        self.navigationController.navigationBar.translucent = NO;
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    }
    
    self.cardForm = [[WPYCardFormView alloc] initWithFrame:CGRectMake(0, 0, 320, WPYCardFormViewHeight) card:self.card];
    self.cardForm.backgroundColor = [UIColor clearColor];
    self.cardForm.delegate = self;
    [self.view addSubview: self.cardForm];
    
    self.payButton = [self createPayButton];
    [self.payButton setEnabled:NO];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.indicator setCenter:CGPointMake(140, 22)];
    [self.payButton addSubview:self.indicator];
    
    [self.view addSubview:self.payButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.cardForm setFocusToFirstNotfilledField];
}



#pragma mark pay button
- (UIButton *)createPayButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 320, 280, 44);
    button.titleLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:20.0f];
    button.layer.cornerRadius = 2.0f;
    button.layer.masksToBounds = YES;
    
    // normal
    [button setTitle:self.buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:imageFromColor([UIColor colorWithRed:0 green:0.478 blue:1.0 alpha:0.8]) forState:UIControlStateNormal];
    
    // highlighted
    [button setTitle:@" " forState:UIControlStateSelected];
    [button setBackgroundImage:imageFromColor([UIColor colorWithRed:0 green:0.478 blue:1.0 alpha:1]) forState:UIControlStateHighlighted];
    
    [button addTarget:self
                       action:@selector(payButtonPushed:)
             forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)payButtonPushed:(id)sender
{
    NSError *error = nil;
    if (![self.card validate:&error])
    {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[error localizedDescription]
                                   delegate:nil
                          cancelButtonTitle:@"dismiss"
                          otherButtonTitles:nil, nil] show];
        return;
    }
    
    [self startIndicator];
    
    [WPYTokenizer createTokenFromCard:self.card completionBlock:^(WPYToken *token, NSError *error){
        [self stopIndicator];
        self.callback(self, token, error);
    }];
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
    [self.payButton setEnabled:NO];
}

- (void)validFormWithCard:(WPYCreditCard *)creditCard
{
    self.card = creditCard;
    [self.payButton setEnabled:YES];
}



#pragma mark memory management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end