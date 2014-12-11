//
//  WPYCardFormCell.m
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYCardFormCell.h"

#import "WPYDeviceSettings.h"

@interface WPYCardFormCell ()
@property(nonatomic, strong) UILabel *titleLabel;// default textlabel of cell has weird behaviors with frame size.
@property(nonatomic, strong) UIView *field;
@end

static const float WPYLabelX = 15.0f;
static const float WPYLabelY = 1.0f;

@implementation WPYCardFormCell

// created from storyboard
- (void)awakeFromNib
{
    [self addTitleLabel];
}

//created from code
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self addTitleLabel];
    }
    return self;
}

- (void)addTitleLabel
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPYLabelX, WPYLabelY, 80, 48)];
    self.titleLabel.font = [WPYDeviceSettings isJapanese] ? [UIFont fontWithName:@"HiraKakuProN-W3" size:13.0f] : [UIFont fontWithName:@"Avenir-Roman" size:16.0f];
    self.titleLabel.textColor = [UIColor colorWithRed:0 green:0.48 blue:1.0 alpha:1.0];
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
}

- (void)setTitle:(NSString *)title
{
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setLineSpacing:5];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, [title length])];
    self.titleLabel.attributedText = attributedString;
}

- (void)addField:(UIView *)field
{
    if (!self.field)
    {
        self.field = field;
        [self.contentView addSubview: field];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
