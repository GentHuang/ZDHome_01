//
//  ZDHDesignCell.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    kFirstCellType,
    kSecondCellType
}CellType;
@interface ZDHDesignCell : UITableViewCell
@property (strong, nonatomic) NSString *orderID;
@property (strong, nonatomic) NSString *planID;
//刷新设计方案列表
- (void)reloadMethodListCellWithArray:(NSArray *)dataArray;
//刷新设计单列表
- (void)reloadDesignListCellWithArray:(NSArray *)dataArray;
//选择CellType
- (void)selectCellType:(CellType)type;
//是否存在设计方案
- (void)enableCaseButton:(BOOL)isEnable;
@end
