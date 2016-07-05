//
//  ZDUserClothesPlateView.h
//  ZhiDa_Home
//
//  Created by apple on 16/3/13.
//  Copyright (c) 2016年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ZDUserClothesPlateView : UIView
@property (copy, nonatomic) NSString *ClothID;
@property (copy, nonatomic) NSString *titleName;
@property (assign, nonatomic) BOOL isSearch;
@property (copy, nonatomic) NSString *keyword;
//刷新获取数据
- (void)getDataWithClothID:(NSString*)stringID;
// 搜索框搜索后获取数据
- (void) searchViewWithKeyword:(NSString *) keyWord isSearch:(BOOL)isSearch;
@end
