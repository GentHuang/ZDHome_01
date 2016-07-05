//
//  ZDHDIYBottomRightButton.h
//  ZhiDa_Home
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    kBigButtonMode,
    kMidButtonMode,
    kSmallButtonMode
}ButtonMode;
@interface ZDHDIYBottomRightButton : UIButton
//选择Button模式
- (void)setButtonMode:(ButtonMode)mode;
//刷新图片
- (void)reloadImageView:(NSString *)image;
//刷新型号标签
- (void)reloadNumberTitle:(NSString *)title;
//选中模式
- (void)selected;
//未选中模式
- (void)unSelected;
@end
