//
//  ZDHMyOrderViewOrderDetailBespokeDetailModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/20.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHMyOrderViewOrderDetailBespokeDetailModel.h"
#import "ZDHMyOrderViewOrderDetailBespokeDetailOpinionModel.h"

@implementation ZDHMyOrderViewOrderDetailBespokeDetailModel
- (instancetype)init{
    if (self = [super init]) {
        _opinion = [NSMutableArray array];
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
    if ([key isEqualToString:@"opinion"]) {
        for (NSDictionary *dic in value) {
            ZDHMyOrderViewOrderDetailBespokeDetailOpinionModel *opinionModel = [[ZDHMyOrderViewOrderDetailBespokeDetailOpinionModel alloc] init];
            [opinionModel setValuesForKeysWithDictionary:dic];
            [_opinion addObject:opinionModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
