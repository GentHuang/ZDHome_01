//
//  ZDHDIYBottomRightView.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    kUpMode,
    kDownMode,
}RightViewMode;
@interface ZDHDIYBottomRightView : UIView
//选择上下视图的模式
- (void)setBottomRightViewMode:(RightViewMode)mode;
//刷新清单图片和标题数据
- (void)reloadUpScrollViewWithArray:(NSArray *)imageArray StringArray:(NSArray *)stringArray index:(int)index;
//刷新替换产品图片和标题
- (void)reloadDownRightScrollViewWithImageArray:(NSArray *)imageArray titleArray:(NSArray *)titleArray;
//刷新替换标题
- (void)reloadDownLeftScrollViewWithArray:(NSArray *)array;
@end
