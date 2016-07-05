//
//  ZDHProductCenterBrandRightScrollView.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    kDirectionUp,
    kDirectionDown,
}ScrollDirection;
@interface ZDHProductCenterBrandBottomScrollView : UIView
//加载图片
- (void)reloadRightScrollViewWithArray:(NSArray *)array index:(int)selectedIndex;
@end
