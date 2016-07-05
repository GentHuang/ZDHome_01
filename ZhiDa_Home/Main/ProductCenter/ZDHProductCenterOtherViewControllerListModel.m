//
//  ZDHProductCenterOtherViewControllerListModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/7.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductCenterOtherViewControllerListModel.h"
#import "ZDHProductCenterOtherViewControllerListProductModel.h"
@implementation ZDHProductCenterOtherViewControllerListModel
- (instancetype)init{
    if (self = [super init]) {
        _product_list = [NSMutableArray array];
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
    if ([key isEqualToString:@"product_list"]) {
        for (NSDictionary *dic in value) {
            ZDHProductCenterOtherViewControllerListProductModel *productModel = [[ZDHProductCenterOtherViewControllerListProductModel alloc] init];
            [productModel setValuesForKeysWithDictionary:dic];
            [_product_list addObject:productModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
