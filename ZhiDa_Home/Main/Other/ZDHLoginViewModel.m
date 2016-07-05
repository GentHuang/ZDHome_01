//
//  ZDHLoginViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/19.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHLoginViewModel.h"
#import "ZDHLoginViewLoginresultModel.h"
@implementation ZDHLoginViewModel
- (instancetype)init{
    if (self = [super init]) {
        _loginresult = [NSMutableArray array];
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
    if ([key isEqualToString:@"loginresult"]) {
        for (NSDictionary *dic in value) {
            ZDHLoginViewLoginresultModel *resultModel = [[ZDHLoginViewLoginresultModel alloc] init];
            [resultModel setValuesForKeysWithDictionary:dic];
            [_loginresult addObject:resultModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
