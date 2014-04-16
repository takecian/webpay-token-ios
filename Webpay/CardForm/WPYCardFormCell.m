//
//  WPYCardFormCell.m
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYCardFormCell.h"

@implementation WPYCardFormCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
          textField:(UITextField *)textField
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textLabel.textColor = [UIColor grayColor];
        _textField = textField;
        [self.contentView addSubview:_textField];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier textField:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
