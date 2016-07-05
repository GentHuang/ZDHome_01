//
//  ZDHClothDetailViewControllerClothModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/10.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHClothDetailViewControllerClothModel.h"

@implementation ZDHClothDetailViewControllerClothModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    key = nil;
}
- (id)valueForUndefinedKey:(NSString *)key{
    return key;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        _id_conflict = value;
    }else if ([key isEqualToString:@"aboutbuban"]) {
        //数组初始化
        _aboutbuban = [NSMutableArray array];
        for (NSDictionary *dic in value) {
            ZDHClothDetailViewClothPlateModel *ListModel = [[ZDHClothDetailViewClothPlateModel alloc]init];
            [ListModel setValuesForKeysWithDictionary:dic];
            [_aboutbuban addObject:ListModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
    //
    if (_cloth_part) {
        _part = _cloth_part;
    }
    
}

@end

@implementation ZDHClothDetailViewClothPlateModel
@synthesize id_conflict = _id;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    key = nil;
}
- (id)valueForUndefinedKey:(NSString *)key{
    return key;
}


@end