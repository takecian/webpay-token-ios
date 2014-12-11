//
//  WPYSupportedBrandsView.m
//  Webpay
//
//  Created by Okada Yohei on 12/3/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import "WPYSupportedBrandsView.h"

#import "WPYBundleManager.h"

@interface WPYSupportedBrandsView ()
@end

@implementation WPYSupportedBrandsView

- (void)showBrands:(NSArray *)brands
{
    [brands enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *brand = (NSString *)obj;
        NSString *imageFileName = [NSString stringWithFormat:@"Small%@", [brand stringByReplacingOccurrencesOfString:@" " withString:@""]];
        UIImage *brandImage = [WPYBundleManager imageNamed:imageFileName];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + (brandImage.size.width + 10) * idx + 5, 0, brandImage.size.width, brandImage.size.height)];
        imageView.image = brandImage;
        [self addSubview:imageView];
    }];
}
@end
