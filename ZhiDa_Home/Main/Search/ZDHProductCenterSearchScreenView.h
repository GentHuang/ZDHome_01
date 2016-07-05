//
//  ZDHProductCenterSearchScreenView.h
//  TableView二级联动Demo
//
//  Created by apple on 16/3/11.
//  Copyright (c) 2016年 TTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHProductCenterSearchScreenView : UIView

@property (strong, nonatomic) NSMutableArray *goodsDataListArray;
// 打开和收起筛选
-(void) openOrCloseScreenBarWithFlag:(BOOL)flag
                        withListData:(NSMutableArray *)array
                        withSelected:(NSMutableArray *)selectedArray;

/**
 *  打开和收起筛选view
 *
 *  @param flag yes:打开，no：收起
 */
- (void) openSearchClassifyWithFlag:(BOOL)flag;
// 加载数据
- (void) loadClassifyViewWithDataArray:(NSMutableArray *)array
                         selectedArray:(NSMutableArray *)selectedArray;

// 清空已选的title
- (void) cleanAllTheSelectedTitle;
@end
