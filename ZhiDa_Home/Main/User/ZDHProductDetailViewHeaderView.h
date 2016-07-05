//
//  ZDHProductDetailViewHeaderView.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHProductDetailViewHeaderView : UIView
//刷新标题
- (void)reloadTitleName:(NSString *)title;
//使用大标题
- (void)useBigTitle;
//使用小标题
- (void)useSmallTitle;
@end
