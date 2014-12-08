//
//  WPYCardFormCell.h
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPYCardFormCell : UITableViewCell

// designated initializer
- (void)setTitle:(NSString *)title;
- (void)addField:(UIView *)field;
@end
