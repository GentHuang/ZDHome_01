//
//  ZDHProductRecommendDescCell.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHProductRecommendCell : UITableViewCell
@property (copy, nonatomic) PressedBlock pressedBlock;
//刷新图片
- (void)reloadCellImageView:(NSArray *)array pidArray:(NSArray *)pidArray selectedPid:(NSString *)pid;
@end
