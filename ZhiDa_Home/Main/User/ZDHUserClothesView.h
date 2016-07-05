//
//  ZDHUserClothesView.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHUserClothesView : UIView

@property (copy, nonatomic) StringTransBlock ClothStringID;
//获取首页数据
- (void)getData;
//根据头部Index获取数据(用以点击返回时候，定位布料列表位置)
- (void)getDataWithIndex:(int)index;

// 加载布分类列表
- (void) addClothPlateViewWithKey:(NSString *)keyWord;

@end
