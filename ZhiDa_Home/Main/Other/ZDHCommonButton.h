//
//  ZDHCommonButton.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHCommonButton : UIButton
//设置Button名字
- (void)setButtonWithTitleName:(NSString *)titleName;
//设置Button的状态
- (void)setIsSelected:(BOOL)isSelected;
@end
