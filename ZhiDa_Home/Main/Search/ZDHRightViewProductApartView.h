//
//  ZDHRightViewProductApartView.h
//  ZhiDa_Home
//
//  Created by apple on 16/1/22.
//  Copyright (c) 2016年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHRightViewProductApartView : UIView
//刷新
- (void)reloadCell:(NSArray *)array;
//更新标题
- (void)reloadTitle:(NSString *)title;
@end
