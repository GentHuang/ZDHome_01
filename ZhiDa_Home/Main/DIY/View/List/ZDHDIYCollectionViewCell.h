//
//  ZDHDIYCollectionViewCell.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHDIYCollectionViewCell : UICollectionViewCell
//刷新图片
- (void)reloadImageView:(NSString *)imageString;
//刷新标题
- (void)reloadTitle:(NSString *)title;
@end
