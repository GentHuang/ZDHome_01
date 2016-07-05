//
//  ZDHDesignDetailViewDesignDetailModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZDHDesignDetailViewDesignDetailPlanitemModel.h"
@interface ZDHDesignDetailViewDesignDetailModel : NSObject
@property (strong, nonatomic) NSString *aboutfile;
@property (strong, nonatomic) NSMutableArray *aboutproduct;
@property (strong, nonatomic) NSString *addrinfo;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *client;
@property (strong, nonatomic) NSString *designstyle;
@property (strong, nonatomic) NSString *designtype;
@property (strong, nonatomic) NSString *hopetime;
@property (strong, nonatomic) NSString *housemodule;
@property (strong, nonatomic) NSString *housename;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *orderid;
@property (strong, nonatomic) ZDHDesignDetailViewDesignDetailPlanitemModel *planitem;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *remarks;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *store;
@property (strong, nonatomic) NSString *submittime;

//添加的字段
@property (strong, nonatomic) NSString *familyinfo; //家庭状况
@property (strong, nonatomic) NSString *budget; //客户预算

//@property (strong, nonatomic) NSString *
//@property (strong, nonatomic) NSString *
//@property (strong, nonatomic) NSString *
@end
