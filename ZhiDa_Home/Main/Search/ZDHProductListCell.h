//
//  ZDHProductListCell.h
//  ZhiDa_Home
//
//  Created by apple on 15/9/1.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHProductListCell : UICollectionViewCell
//刷新图片
- (void)reloadImageView:(NSString *)image;
//刷新名称
- (void)reloadName:(NSString *)dataString;
//刷新品牌
- (void)reloadBrand:(NSString *)dataString;
//刷新编号
- (void)reloadNum:(NSString *)dataString;

@end
