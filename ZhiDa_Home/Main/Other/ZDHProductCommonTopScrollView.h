//
//  ZDHProductCenterBrandTopScrollView.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHProductCommonTopScrollView : UIScrollView
//刷新数据
- (void)reloadTopScrollViewWithArray:(NSArray *)array withIndex:(int)selectedIndex;
//刷新带地址的Title数据
- (void)reloadTopScrollViewWithImageUrlArray:(NSArray *)imageUrlArray;
@end
