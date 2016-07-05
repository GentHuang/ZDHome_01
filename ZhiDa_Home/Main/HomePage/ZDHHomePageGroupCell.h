//
//  ZDHHomePageGroupCell.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/18.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHHomePageGroupCell : UITableViewCell
//加载设计师图片
- (void)reloadImageWithImageArray:(NSArray *)imageArray;
//加载设计师名字和简介
- (void)reloadNameWithNameArray:(NSArray *)nameArray introArray:(NSArray *)introArray;
@end
