//
//  ZDHProductCenterBrandBigImageView.h
//  ZhiDa_Home
//
//  Created by apple on 16/3/25.
//  Copyright (c) 2016年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHProductCenterBrandBigImageView : UIView
//加载视图
- (void)loadBigImageWithImageArray:(NSArray *) imageArray;
//滚动到指定的位置
- (void)scrollWithIndex:(NSString*)index;
@end
