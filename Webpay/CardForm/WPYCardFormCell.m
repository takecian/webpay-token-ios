//
//  WPYCardFormCell.m
//  Webpay
//
//  Created by yohei on 4/15/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYCardFormCell.h"

#import "WPYAbstractCardField.h"

@interface WPYCardFormCell ()
@property(nonatomic, strong) UILabel *titleLabel;// default textlabel of cell has weird behaviors with frame size.
@property(nonatomic, strong) WPYAbstractCardField *field;
@end

@implementation WPYCardFormCell
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
              field:(WPYAbstractCardField *)field
              title:(NSString *)title
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // cell
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // text label
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 44)];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = title;
        _titleLabel.textColor = [UIColor colorWithRed:0 green:0.478 blue:1.0 alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:_titleLabel];
        
        // field
        _field = field;
        [self.contentView addSubview:_field];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier field:nil title:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end