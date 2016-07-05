//
//  ZDHProductDetailViewCell.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    kFirstCellType,
    kOtherCellType,
    kBaseCellType,
    kLogisticsType,
    kFurnitureType
}CellType;
@interface ZDHProductDetailViewCell : UITableViewCell
//选择Cell的模式
- (void)selectCellType:(CellType)type;
//载入基本信息
- (void)loadBaseInfoWithDataArray:(NSArray *)dataArray;
//载入物流信息
- (void)loadExpressInfoWithDataArray:(NSArray *)dataArray;
//载入家具信息
- (void)loadFurnitureInfoWithDataArray:(NSArray *)dataArray;
//载入其他信息
- (void)loadOtherInfoWithDataArray:(NSArray *)dataArray;
//载入窗帘信息
- (void)loadCurtainDetailWithDataArray:(NSArray *)dataArray index:(NSInteger)index image:(NSString *)imageString name:(NSString *)name remark:(NSString *)remark;

//需要隐藏"其他"商品订单的最后两个label
@property (strong, nonatomic) UIView *lastBackView;
@property (strong, nonatomic) NSMutableArray *lastNameArray;
@end
