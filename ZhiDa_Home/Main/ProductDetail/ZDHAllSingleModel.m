//
//  ZDHAllSingleModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHAllSingleModel.h"
#import "ZDHAllSingleProinfoModel.h"
@implementation ZDHAllSingleModel
- (instancetype)init{
    if (self = [super init]) {
        _proinfo = [NSMutableArray array];
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
    if ([key isEqualToString:@"proinfo"]) {
        for (NSDictionary *dic in value) {
            ZDHAllSingleProinfoModel *proinfoModel = [[ZDHAllSingleProinfoModel alloc] init];
            [proinfoModel setValuesForKeysWithDictionary:dic];
            [_proinfo addObject:proinfoModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end


