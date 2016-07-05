//
//  ZDHHomePageHotSellCellView.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    kBigSize,
    kMidSize,
    kSmallRightSize,
    kSmallLeftSize,
}ViewSize;
@interface ZDHHomePageHotSellCellView : UIView
//选择View的大小
- (void)setViewSize:(ViewSize)size;
//刷新图片
- (void)reloadPhotoView:(UIImage *)photoImage;
//刷新文字
- (void)reloadTitle:(NSString *)title desc:(NSString *)desc;
@end
