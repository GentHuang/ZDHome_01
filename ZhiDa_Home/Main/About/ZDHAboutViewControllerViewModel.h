//
//  ZDHAboutViewControllerViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/12/3.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHAboutViewControllerViewModel : NSObject
@property (strong, nonatomic) NSMutableArray *dataAboutArray;
//获取关于志达的信息
- (void)getAboutSuccess:(SuccessBlock)success fail:(FailBlock)fail;
@end
