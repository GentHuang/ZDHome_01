//
//  ZDHCollectionViewCell.h
//  ZhiDa_Home
//
//  Created by apple on 16/3/4.
//  Copyright (c) 2016年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHProductCenterBrandBottomCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *ImageView;
/**
 *  加载cell中的图片
 *
 *  @param image 链接或这image对象
 *  @param index 标志位
 */
- (void)loadImageViewWithImage:(id)image withIndexTag:(NSString *)indexString;

@end
