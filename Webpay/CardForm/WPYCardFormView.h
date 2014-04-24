//
//  WPYCardFormView.h
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPYCreditCard;
@protocol WPYCardFormViewDelegate <NSObject>
@optional
// called when a field is invalid
- (void)invalidFieldName:(NSString *)fieldName error:(NSError *)error;

// called when the whole form is valid
- (void)validFormWithCard:(WPYCreditCard *)creditCard;
@end


@interface WPYCardFormView : UIView
@property(nonatomic, weak) id <WPYCardFormViewDelegate> delegate;
@end
