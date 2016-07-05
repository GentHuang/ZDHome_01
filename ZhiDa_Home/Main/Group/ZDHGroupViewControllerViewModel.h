//
//  ZDHGroupViewControllerViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/17.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHGroupViewControllerViewModel : NSObject
@property (strong, nonatomic) NSString *dataBannerString;
@property (strong, nonatomic) NSString *dataMainImageString;
@property (strong, nonatomic) NSString *dataMainNameString;
@property (strong, nonatomic) NSString *dataMainJobString;
@property (strong, nonatomic) NSString *dataMainIntroString;

@property (strong, nonatomic) NSMutableArray *dataGroupImageArray;
@property (strong, nonatomic) NSMutableArray *dataGroupNameArray;
@property (strong, nonatomic) NSMutableArray *dataGroupJobArray;
@property (strong, nonatomic) NSMutableArray *dataGroupIntroArray;


//获取Banner
- (void)getBannerSuccess:(SuccessBlock)success fail:(FailBlock)fail;
//获取首席设计师信息
- (void)getMainDesignerSuccess:(SuccessBlock)success fail:(FailBlock)fail;
//获取设计师团队信息
- (void)getDesignerGroupSuccess:(SuccessBlock)success fail:(FailBlock)fail;
@end
