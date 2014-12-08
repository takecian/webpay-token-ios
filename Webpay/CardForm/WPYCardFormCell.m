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
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;// default textlabel of cell has weird behaviors with frame size.
@property(nonatomic, strong) UIView *field;
@end

@implementation WPYCardFormCell

- (void)awakeFromNib
{
    if ([WPYDeviceSettings isJapanese])
    {
        self.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:13.0f];
    }
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
