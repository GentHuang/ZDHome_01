//
//  ZDHGroupViewControllerBannerModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/17.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZDHGroupViewControllerBannerDesignteamBannerModel.h"

@interface ZDHGroupViewControllerBannerModel : NSObject
@property (strong, nonatomic) ZDHGroupViewControllerBannerDesignteamBannerModel *designteam_banner;
@property (strong, nonatomic) NSString *designteam_list;
@property (strong, nonatomic) NSString *designteam_top1;
@property (strong, nonatomic) NSString *error_;
@property (strong, nonatomic) NSString *hint;
@end
