//
//  WPYNumberFieldModel.h
//  Webpay
//
//  Created by yohei on 5/4/14.
//  Copyright (c) 2014 yohei, YasuLab. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WPYAbstractFieldModel.h"

@interface WPYNumberFieldModel : WPYAbstractFieldModel
// brand
+ (UIImage *)brandLogoFromNumber:(NSString *)number;
+ (NSString *)reformatNumber:(NSString *)number isDeleted:(BOOL)isDeleted;
@end
