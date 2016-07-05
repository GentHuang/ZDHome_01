//
//  ZDHMyOrderViewOrderDetailResponseModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/12/4.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHMyOrderViewOrderDetailResponseModel.h"
#import "ZDHMyOrderViewOrderDetailResponseBespokePoinionModel.h"

@implementation ZDHMyOrderViewOrderDetailResponseModel
- (instancetype)init{
    if (self = [super init]) {
        _bespoke_poinion = [NSMutableArray array];
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
    if ([key isEqualToString:@"bespoke_poinion"]) {
        for (NSDictionary *dic in value) {
            ZDHMyOrderViewOrderDetailResponseBespokePoinionModel *opModel = [[ZDHMyOrderViewOrderDetailResponseBespokePoinionModel alloc] init];
            [opModel setValuesForKeysWithDictionary:dic];
            [_bespoke_poinion addObject:opModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
