//
//  ZDHClothDetailLeftBigImageView.h
//  ZhiDa_Home
//
//  Created by apple on 16/3/13.
//  Copyright (c) 2016年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHClothDetailLeftBigImageView : UIView

//刷新视图
-(void)reloadCellWithArray:(NSArray *)imageArray;

//重新设置视图适合显示
- (void)reloadImageContentModeScaleAspectFit;
//加载本地图片
- (void)reloadCellLocalWithImage:(id)image;
@end
