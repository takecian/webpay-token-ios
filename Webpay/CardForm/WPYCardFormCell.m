//
//  WPYCardFormCell.m
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYCardFormCell.h"

@interface WPYCardFormCell ()
@property(nonatomic, strong) UILabel *titleLabel;// default textlabel of cell has weird behaviors with frame size.
@end

@implementation WPYCardFormCell
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
        contentView:(UIView *)contentView
              title:(NSString *)title
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // cell
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        // text label
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, 80, 48)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = title;
        _titleLabel.textColor = [UIColor colorWithRed:0 green:0.478 blue:1.0 alpha:1.0];
        _titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0f];
        [self.contentView addSubview:_titleLabel];
        
        [self.contentView addSubview: contentView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end