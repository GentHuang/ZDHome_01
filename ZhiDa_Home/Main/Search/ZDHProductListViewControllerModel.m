//
//  ZDHProductListViewControllerModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/12/2.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductListViewControllerModel.h"
#import "ZDHProductListViewControllerSearchProductModel.h"

@implementation ZDHProductListViewControllerModel
- (instancetype)init{
    if (self = [super init]) {
        _search_product = [NSMutableArray array];
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
    if ([key isEqualToString:@"search_product"]) {
        for (NSDictionary *dic in value) {
            ZDHProductListViewControllerSearchProductModel *proModel = [[ZDHProductListViewControllerSearchProductModel alloc] init];
            [proModel setValuesForKeysWithDictionary:dic];
            [_search_product addObject:proModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
