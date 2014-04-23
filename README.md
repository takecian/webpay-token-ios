# webpay-token-ios

webpay-token-ios is an ios library for creating a token from a credit card.

## Requirements
webpay-token-ios supports iOS 5 and above.


## Installation

You can either install using cocoapods(recommended) or copy files manually.
1. Cocoapods

2. copy files manually

## Overview

webpay-token-ios consists of 3 components.
1. WPYTokenizer(model)
2. WPYCardFormView(view)
3. WPYPaymentViewController(view controller)

Each component is independent, which leaves a flexible option on which component
to make on your own.

## How to use

### Initialization
``` objective-c
#import "Webpay.h"

[WPYTokenizer setPublicKey:@"test_public_YOUR_PUBLIC_KEY"];
```

### WPYTokenizer (Using your own view)
```
#import "WPYTokenizer.h"
#import "WPYCreditCard.h"
#import "WPYToken.h"

// create a credit card model and populate with data
WPYCreditCard *card = [[WPYCreditCard alloc] init];
card.number = @"4242424242424242";
card.expiryYear = 2015;
card.expiryMonth = 12;
card.cvc = @"123";
card.name = @"Yohei Okada";
    
// pass card and callback
[WPYTokenizer createTokenFromCard:card completionBlock:^(WPYToken *token, NSError *error)
{
  if (token)
  {
    NSLog(@"token:%@", token.tokenId);
  }
  else
  {
    NSLog(@"error:%@", [error localizedDescription]);
  }
}];
```

### WPYCardFormView (Combining form with your own UIControls such as UIButton)
```
// create view
WPYCardFormView *cardForm = [[WPYCardFormView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
cardForm.delegate = self;
[self.view addSubview: cardForm];

// WPYCardFormDelegate methods
- (void)invalidFieldName:(NSString *)fieldName error:(NSError *)error
{
  // called when a field lost focus and the non-nil input is invalid
}

- (void)validFormWithCard:(WPYCreditCard *)creditCard
{
  // called when the form is valid.  
  self.card = creditCard;
}
```


### WPYPaymentViewController
WPYPaymentViewController is a combination of WPYTokenizer and WPYPaymentVIewController.

```
WPYPaymentViewController *paymentViewController = [[WPYPaymentViewController alloc] initWithButtonTitle:@"Pay" callback:^(WPYToken *token, NSError *error){
  if(token)
  {
    //post token to your server
  }
  else
  { 
    NSLog(@"error:%@", [error localizedDescription]);
  }
}];
    
[self.navigationController pushViewController:paymentViewController animated:YES];
```

### Other classes
#### WPYCreditCard
WPYCreditCard offers various validation methods.
For validating the whole card, use `- (BOOL)validate:`
```
NSError *cardError = nil;
if (![card validate:&cardError])
{
  NSLog(@"error:%@", [cardError localizedDescription]);
}
```

For validating each property, use `- (BOOL)validatePROPERTY:error:`
```
NSString *number = @"4242424242424242";
NSError *cardError = nil;
WPYCreditCard *card = [[WPYCreditCard alloc] init];
if (![card validateNumber:&number error:&cardError])
{
  NSLog(@"error:%@", [cardError localizedDescription]);
}
```

#### WPYToken
WPYToken holds token data returned from Webpay API.

#### WPYError
This class defines all the errors originating from webpay-ios-token.

