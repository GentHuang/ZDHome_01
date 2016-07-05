//
//  ZDHLoginViewViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/19.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHLoginViewViewModel.h"
//Model
#import "ZDHLoginViewModel.h"
#import "ZDHLoginViewLoginresultModel.h"
@implementation ZDHLoginViewViewModel
//用户登录
- (void)getLoginWithName:(NSString *)name PSW:(NSString *)psw Success:(SuccessBlock)success fail:(FailBlock)fail{
    ZDHSellMan *sellMan = [ZDHSellMan shareInstance];
//    NSString *urlstring = [NSString stringWithFormat:@"%@m=login&name=%@&pwd=%@",kUserLoginAPI,name,psw];
    [[ZDHNetworkManager sharedManager] POST:kUserLoginAPI parameters:@{@"m":@"login",@"name":name,@"pwd":psw} success:^void(AFHTTPRequestOperation * opertarion, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHLoginViewModel *vcModel = [[ZDHLoginViewModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHLoginViewLoginresultModel *resultModel in vcModel.loginresult) {
            //加载用户信息
            sellMan.sellManID = resultModel.rolecode;
            sellMan.sellManName = name;
            sellMan.realName = resultModel.realname;
            //存入数据库
            [[FMDBManager sharedInstace] deleteModelAllInDatabase:sellMan];
            [[FMDBManager sharedInstace] creatTable:sellMan];
            [[FMDBManager sharedInstace] insertAndUpdateModelToDatabase:sellMan];
            //检测是否登录成功
            if (![resultModel.logincode isEqualToString:@"0"]) {//[resultModel.logincode isEqualToString:@"1"]
                success(nil);
            }else{
                fail(nil);
            }
            break;
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//        NSLog(@"%@",error);
        fail(nil);
    }];
}
@end
