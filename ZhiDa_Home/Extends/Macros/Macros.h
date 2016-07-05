//
//  Macros.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#ifndef ZhiDa_Home_Macros_h
#define ZhiDa_Home_Macros_h
//导航栏高度
#define NAV_HEIGHT (64)
//状态栏高度
#define STA_HEIGHT (20)
//首页头间隔
#define kHomePageFrontGap (18)
//屏幕宽高
#define SCREEN_MAX_Height (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)
#define SCREEN_MAX_WIDTH (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)
//字体大小
#define FONTSIZES(x) [UIFont fontWithName:@"Verdana" size:x]
#define FONTSIZESBOLD(x) [UIFont fontWithName:@"Helvetica-Bold" size:x]
//弹窗
#define ALERT(msg)  [[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil \
cancelButtonTitle:@"确定" otherButtonTitles:nil,nil] show]
//颜色
#define CurrentPageIndicatorTintColor [UIColor colorWithRed:218/256.0 green:0/256.0 blue:109/256.0 alpha:1]
#define YAHEI [UIColor colorWithRed:41.0/255 green:36.0/255 blue:33.0/255 alpha:0.9]
#define ORANGE [UIColor colorWithRed:255.0/255 green:140.0/255 blue:0.0/255 alpha:0.9]
#define LIGHTBLUE [UIColor colorWithRed:65.0/255 green:80.0/255 blue:255.0/255 alpha:0.9]
#define BROWN [UIColor colorWithRed:128.0/255 green:128.0/255 blue:105.0/255 alpha:0.9]
#define LIGHTORANGE [UIColor colorWithRed:245.0/255.0 green:205.0/255.0 blue:84.0/255.0 alpha:0.9]
#define LIGHTRED [UIColor colorWithRed:205.0/255.0 green:92.0/255.0 blue:92.0/255.0 alpha:0.9]
#define LIGHTBROWN [UIColor colorWithRed:195.0/255.0 green:152.0/255.0 blue:107.0/255.0 alpha:0.9]
#define CLEAR [UIColor clearColor]
#define WHITE [UIColor whiteColor]
#define LIGHTGRAY [UIColor colorWithRed:234/256.0 green:234/256.0 blue:234/256.0 alpha:1]
#define GREY [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1]
#define PINK [UIColor colorWithRed:189/256.0 green:0/256.0 blue:74/256.0 alpha:1]
#define GRAY [UIColor colorWithRed:238/256.0 green:238/256.0 blue:238/256.0 alpha:1]
#define KLINECOLOR [UIColor colorWithRed:228/256.0 green:228/256.0 blue:228/256.0 alpha:1]
#define SEGMENTLINECOLOR  [UIColor colorWithRed:203/256.0 green:203/256.0 blue:203/256.0 alpha:1]
#define CELLSELECTEDCOLOR [UIColor colorWithRed:250/256.0 green:250/256.0 blue:250/256.0 alpha:1]
#define PINKISHRED [UIColor colorWithRed:207/256.0 green:0/256.0 blue:92/256.0 alpha:1]
#define AlertViewColor [UIColor colorWithRed:236/256.0 green:244/256.0 blue:246/256.0 alpha:1]
//判断IOS版本
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//缓存地址
#define DocumentsDirectory [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Caches"]
//离线包下载地址
#define DownloadPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

// 友盟统计APPKey
#define kUMAnalyticsAppKey  @"55643e4467e58ea651003d91"
// 百度统计APPKey
#define kBDAnalyticsAppKey  @"014c0b421f"
//Block
typedef void(^ResultBlock)(NSMutableArray *resultArray,NSMutableArray *secondResultArray);
typedef void(^FailBlock)(NSError *error);
typedef void(^ImageDownloadBlock)(UIImage *image);
typedef void(^StartImageDownloadBlock)(CGFloat process);
typedef void(^PressedBlock)(NSString *string);
typedef void(^ButtonBlock)(UIButton *button);
typedef void(^DownloadBlock)(CGFloat process,NSString *urlString);

typedef void(^IndexTransBlock)(NSInteger index);
typedef void(^StringTransBlock)(NSString *string);
typedef void(^ButtonPressedBlock)(UIButton *button);
typedef void(^TapPressedBlock)(UITapGestureRecognizer *tap);
typedef void(^SuccessBlock)(NSMutableArray *resultArray);
typedef void(^FailBlock)(NSError *error);
typedef void(^SingleArrayBlock)(NSMutableArray *resultArray);
typedef void(^TextFieldBlock)(UITextField *textField);
#endif
