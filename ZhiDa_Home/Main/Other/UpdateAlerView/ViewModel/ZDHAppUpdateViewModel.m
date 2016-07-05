//
//  ZDHAppUpdateViewModel.m
//  
//
//  Created by apple on 16/4/8.
//
//

#import "ZDHAppUpdateViewModel.h"

@implementation ZDHAppUpdateViewModel

- (void) getAppUpdateDataSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    _updateModelArray =  [NSMutableArray array];
    [[ZDHNetworkManager sharedManager] GET:kUpdateAppRemindAPI parameters:nil success:^(AFHTTPRequestOperation *operation , id responseObject){
        
        NSArray *responseArray = responseObject;
        ZDHAppUpdateModel *updateModel = [[ZDHAppUpdateModel alloc]init];
        [updateModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        [_updateModelArray addObject:updateModel];
        if (_updateModelArray.count > 0) {
            
            success(nil);
        }
        else{
            
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation *operation,NSError *error){
    
        fail(nil);
    }];
}

@end
