//
//  ZDHProductCenterZhiDaCell.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHProductCenterZhiDaCell : UICollectionViewCell
//刷新图片
- (void)reloadCellWithImage:(id)imageString;
//刷新标题
- (void)reloadCellWithTitleName:(NSString *)titleName;
@end
