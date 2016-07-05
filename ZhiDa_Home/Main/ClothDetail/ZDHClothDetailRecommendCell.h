//
//  ZDHClothDetailRecommendCell.h
//  ZhiDa_Home
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHClothDetailRecommendCell : UITableViewCell
@property (copy, nonatomic) PressedBlock pressedBlock;
//刷新图片
- (void)reloadCellImageView:(NSArray *)array idArray:(NSArray *)idArray selectedID:(NSString *)ID;
@end
