//
//  ZDHDIYDetailViewControllerPressModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/16.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZDHDIYDetailViewControllerPressDiyGetdiyproModel.h"

@interface ZDHDIYDetailViewControllerPressModel : NSObject
@property (strong, nonatomic) NSString *diyProbytype_List;
@property (strong, nonatomic) NSString *diy_detail;
@property (strong, nonatomic) ZDHDIYDetailViewControllerPressDiyGetdiyproModel *diy_getdiypro;
@property (strong, nonatomic) NSString *diy_list;
@property (strong, nonatomic) NSString *error_;
@property (strong, nonatomic) NSString *hint;
@property (strong, nonatomic) NSString *type_list;
@end
