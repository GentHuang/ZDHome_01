//
//  ZDHProductViewDetailShopDetailModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductViewDetailShopDetailModel.h"
#import "ZDHProductViewDetailShopDetailExpresslistModel.h"
#import "ZDHProductViewDetailShopDetailOtherlistModel.h"
#import "ZDHProductViewDetailShopDetailCurtainlistModel.h"
#import "ZDHProductViewDetailShopDetailFurniturelistModel.h"

@implementation ZDHProductViewDetailShopDetailModel
- (instancetype)init{
    if (self = [super init]) {
        _expresslist = [NSMutableArray array];
        _otherlist = [NSMutableArray array];
        _curtainlist = [NSMutableArray array];
        _furniturelist = [NSMutableArray array];
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
    if ([key isEqualToString:@"expresslist"]) {
        for (NSDictionary *dic in value) {
            ZDHProductViewDetailShopDetailExpresslistModel *infoModel = [[ZDHProductViewDetailShopDetailExpresslistModel alloc] init];
            [infoModel setValuesForKeysWithDictionary:dic];
            [_expresslist addObject:infoModel];
        }
    }else if([key isEqualToString:@"otherlist"]){
        for (NSDictionary *dic in value) {
            ZDHProductViewDetailShopDetailOtherlistModel *listModel = [[ZDHProductViewDetailShopDetailOtherlistModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dic];
            [_otherlist addObject:listModel];
        }
    }else if([key isEqualToString:@"curtainlist"]){
        for (NSDictionary *dic in value) {
            ZDHProductViewDetailShopDetailCurtainlistModel *curModel = [[ZDHProductViewDetailShopDetailCurtainlistModel alloc] init];
            [curModel setValuesForKeysWithDictionary:dic];
            [_curtainlist addObject:curModel];
        }
    }else if([key isEqualToString:@"furniturelist"]){
        for (NSDictionary *dic in value) {
            ZDHProductViewDetailShopDetailFurniturelistModel *furModel = [[ZDHProductViewDetailShopDetailFurniturelistModel alloc] init];
            [furModel setValuesForKeysWithDictionary:dic];
            [_furniturelist addObject:furModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
