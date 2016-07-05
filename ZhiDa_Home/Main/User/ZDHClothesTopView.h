//
//  ZDHClothesTopView.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kTopViewShowScrollerButtonModel,
    kTopViewShowtitleLableModel
}ZDHClothesTopViewModel;

@interface ZDHClothesTopView : UIView
//数据刷新
- (void)reloadScrollViewWithArray:(NSArray *)array;
// 使用button
- (void) reloadScrollViewWithButtonArray:(NSArray *)array;
//收起键盘
- (void)packUpKeyboard;
//清除搜索文字
- (void)cleanSearchText;
// 选择性显示顶部标题或者滚动按钮
- (void) showClothTitleLabelScrollerViewModel:(ZDHClothesTopViewModel)model;
//  刷新标题
- (void) reflashClothTitle:(NSString *) titile;
//根据index 选择按钮
- (void)selectWithIndex:(NSInteger)index;
//是否隐藏searchView
- (void)IshidenSearchView:(BOOL)hidenString;
//
- (void) topViewShowClothTitleModel;
@end
