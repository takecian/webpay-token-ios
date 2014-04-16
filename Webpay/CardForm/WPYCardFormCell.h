//
//  WPYCardFormCell.h
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPYCardFormCell : UITableViewCell

@property(readonly, strong) UITextField *textField;
// designated initializer
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
          textField:(UITextField *)textField;
@end
