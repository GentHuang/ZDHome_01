//
//  ZDHChangePSWViewViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/20.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHChangePSWViewViewModel.h"
//Model
#import "ZDHChangePSWViewModel.h"
#import "ZDHChangePSWViewResultModel.h"
@implementation ZDHChangePSWViewViewModel
//修改密码
- (void)changePSWWithName:(NSString *)name psw:(NSString *)psw newpsd:(NSString *)newpsd success:(SuccessBlock)success fail:(FailBlock)fail{
    
    [[ZDHNetworkManager sharedManager] POST:kUserChangePSWAPI parameters:@{@"m":@"changepwd",@"name":name,@"pwd":psw,@"newpwd":newpsd} success:^void(AFHTTPRequestOperation * opertarion, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHChangePSWViewModel *vcModel = [[ZDHChangePSWViewModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHChangePSWViewResultModel *resultModel in vcModel.result) {
            if ([resultModel.code isEqualToString:@"success"]) {
                //修改成功
                success(nil);
                break;
            }else{
                //修改失败
                fail(nil);
                break;
            }
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
        NSLog(@"%@",error);
        fail(nil);
    }];
}
@end
