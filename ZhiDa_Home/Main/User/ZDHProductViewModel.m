//
//  ZDHProductViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductViewModel.h"
#import "ZDHProductViewShopListModel.h"

@implementation ZDHProductViewModel
- (instancetype)init{
    if (self = [super init]) {
        _shop_list = [NSMutableArray array];
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
    if ([key isEqualToString:@"shop_list"]) {
        for (NSDictionary *dic in value) {
            ZDHProductViewShopListModel *listModel = [[ZDHProductViewShopListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dic];
            [_shop_list addObject:listModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
