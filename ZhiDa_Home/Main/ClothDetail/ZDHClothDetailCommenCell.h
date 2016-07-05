//
//  ZDHClothDetailCommenCell.h
//  ZhiDa_Home
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHClothDetailCommenCell : UICollectionViewCell
//选择状态
- (void)setIsSelected:(BOOL)status;
//填入图片
- (void)reloadImageView:(id)imageString;
@end
