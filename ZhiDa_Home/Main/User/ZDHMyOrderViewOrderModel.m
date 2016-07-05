//
//  ZDHMyOrderViewOrderModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/20.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHMyOrderViewOrderModel.h"
#import "ZDHMyOrderViewOrderBespokeListModel.h"

@implementation ZDHMyOrderViewOrderModel
- (instancetype)init{
    if (self = [super init]) {
        _bespoke_list = [NSMutableArray array];
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
    if ([key isEqualToString:@"bespoke_list"]) {
        for (NSDictionary *dic in value) {
            ZDHMyOrderViewOrderBespokeListModel *listModel = [[ZDHMyOrderViewOrderBespokeListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dic];
            [_bespoke_list addObject:listModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
