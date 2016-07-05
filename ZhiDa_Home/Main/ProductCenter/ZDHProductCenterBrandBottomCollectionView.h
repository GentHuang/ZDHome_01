//
//  TTCFirstPageBannerView.h
//  TTC_Broadband
//
//  Created by apple on 16/1/12.
//  Copyright (c) 2016年 TTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHProductCenterBrandBottomCollectionView : UIView
@property (copy, nonatomic) StringTransBlock stringBlock;
//获取数据
- (void)reloadRightScrollViewWithArray:(NSArray *)array index:(int)selectedIndex;
//滚动到指定的位置
- (void)scrollWithIndex:(NSString*)index;
@end
