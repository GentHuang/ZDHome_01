//
//  ZDHSearchRightView.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHSearchRightView : UIScrollView
@property (strong, nonatomic) NSArray *firstArray;
@property (strong, nonatomic) NSArray *secondArray;
@property (strong, nonatomic) NSArray *thirdArray;
@property (strong, nonatomic) NSArray *fourthArray;
//刷新ScrollView
- (void)reloadScrollView;
//刷新商品分类
- (void)reloadProductWithArray:(NSArray *)dataArray;
@end
