//
//  ZDHProductCenterBrandBigImageView.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/13.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHProductCommonBigImageView : UIImageView
//获取图片
- (void)reloadImageView:(id)image;
//获取图片(设计方案)
- (void)reloadDesignImageView:(NSString *)imageString;

@end
