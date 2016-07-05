//
//  ZDHChangePSWViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/20.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHChangePSWViewModel.h"
#import "ZDHChangePSWViewResultModel.h"

@implementation ZDHChangePSWViewModel
- (instancetype)init{
    if (self = [super init]) {
        _result = [NSMutableArray array];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    key = nil;
}
- (id)valueForUndefinedKey:(NSString *)key{
    return key;
}
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"result"]) {
        for (NSDictionary *dic in value) {
            ZDHChangePSWViewResultModel *resultModel  = [[ZDHChangePSWViewResultModel alloc] init];
            [resultModel setValuesForKeysWithDictionary:dic];
            [_result addObject:resultModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
