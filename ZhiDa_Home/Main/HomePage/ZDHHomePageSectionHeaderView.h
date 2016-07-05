//
//  ZDHHomePageSectionHeaderView.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    kDIYViewType,
    kProductViewType,
    kOtherViewType
}ViewType;
@interface ZDHHomePageSectionHeaderView : UIView
//刷新HeaderView
- (void)reloadSectionHeaderViewWithName:(NSString *)name;
//选择HeaderView模式
- (void)selectHeaderViewType:(ViewType)type;
@end
