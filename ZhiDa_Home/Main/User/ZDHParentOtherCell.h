//
//  ZDHParentOtherCell.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHParentOtherCell : UITableViewCell
//红色小提示图标
@property (strong, nonatomic) UIImageView *promptImage;

//刷新Cell
- (void)reloadCellWithName:(NSString *)name;

//创建一个提示view
- (void)creatUpdateImageView;
@end
