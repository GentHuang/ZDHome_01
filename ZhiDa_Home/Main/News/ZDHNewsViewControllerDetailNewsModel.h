//
//  ZDHNewsViewControllerDetailNewsModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/11.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHNewsViewControllerDetailNewsModel : NSObject
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *pubdate;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *nid;
@property (assign, nonatomic) NSInteger newsIndex;
@end
