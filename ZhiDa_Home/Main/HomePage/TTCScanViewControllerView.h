
//
//  TTCScanViewControllerView.h
//  TTC_Broadband
//
//  Created by 曾梓麟 on 16/1/3.
//  Copyright © 2016年 TTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height
@interface TTCScanViewControllerView : UIView
//! 扫描区域边长
@property (nonatomic, assign) CGFloat   scanAreaEdgeLength;
//! 扫描区域，用作修正扫描
@property (nonatomic, assign, readonly) CGRect scanAreaRect;
@end
