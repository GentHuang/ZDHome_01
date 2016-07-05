//
//  ZDHClothDetailViewController.h
//  ZhiDa_Home
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHParentViewController.h"
@class ZDHUserViewController;

@interface ZDHClothDetailViewController : ZDHParentViewController
@property (strong, nonatomic) NSString *cid;
@property (strong, nonatomic) NSString *clothid;
@property (strong, nonatomic) NSString *titileName;
@property (assign, nonatomic) BOOL isFirstPage;
@property (strong, nonatomic) NSArray *titleArray;
@end
