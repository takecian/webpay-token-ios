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
@property(nonatomic, weak) IBOutlet UIImageView *visaImage;
@property(nonatomic, weak) IBOutlet UIImageView *masterCardImage;
@property(nonatomic, weak) IBOutlet UIImageView *amexImage;
@property(nonatomic, weak) IBOutlet UIImageView *jcbImage;
@property(nonatomic, weak) IBOutlet UIImageView *dinersImage;
@end

@implementation WPYSupportedBrandsView

- (void)showBrands:(NSArray *)brands
{
    self.visaImage.hidden = ![brands containsObject:@"Visa"];
    self.masterCardImage.hidden = ![brands containsObject:@"MasterCard"];
    self.amexImage.hidden = ![brands containsObject:@"American Express"];
    self.jcbImage.hidden = ![brands containsObject:@"JCB"];
    self.dinersImage.hidden = ![brands containsObject:@"Diners Club"];
}
@end
