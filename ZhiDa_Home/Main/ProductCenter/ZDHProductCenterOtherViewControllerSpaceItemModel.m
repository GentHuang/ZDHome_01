//
//  ZDHProductCenterOtherViewControllerSpaceItemModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/6.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductCenterOtherViewControllerSpaceItemModel.h"
//add------
#import "ZDHProductCenterOtherViewControllerListProductModel.h"
@implementation ZDHProductCenterOtherViewControllerSpaceItemModel

- (instancetype)init {
    if (self = [super init]) {
        _aboutproduct = [NSMutableArray array];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    key = nil;
}
- (id)valueForUndefinedKey:(NSString *)key{
    return key;
}
//- (void)setValue:(id)value forKey:(NSString *)key{
//    if ([key isEqualToString:@"id"]) {
//        _id_conflict = value;
//    }
//    else{
//        [super setValue:value forKey:key];
//    }
//}
//----add 
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _id_conflict = value;
    }else if ([key isEqualToString:@"aboutproduct"]){
        for (NSDictionary *dic in value) {
            ZDHProductCenterOtherViewControllerListProductModel *productModel =[[ZDHProductCenterOtherViewControllerListProductModel alloc]init];
            [productModel setValuesForKeysWithDictionary:dic];
            [_aboutproduct addObject:productModel];
        }
    }
    else{
        [super setValue:value forKey:key];
    }
}
@end
