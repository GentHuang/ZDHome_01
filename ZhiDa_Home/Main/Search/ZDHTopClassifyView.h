//
//  ZDHTopClassifyView.h
//  ZhiDa_Home
//
//  Created by apple on 16/3/13.
//  Copyright (c) 2016年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHTopClassifyView : UIView


@property (copy, nonatomic) ButtonBlock  pressButton;
// 刷新button的标题
- (void) loadLeftButtonTitleWithString:(NSString *)title;
// 恢复按钮的默认设置
- (void) recoverSettingButtonSelected;

@end
