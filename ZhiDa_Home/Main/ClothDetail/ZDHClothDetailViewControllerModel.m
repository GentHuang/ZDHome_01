//
//  ZDHClothDetailViewControllerModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/10.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHClothDetailViewControllerModel.h"
#import "ZDHClothDetailViewControllerClothModel.h"
@implementation ZDHClothDetailViewControllerModel
- (instancetype)init{
    if (self = [super init]) {
        _cloth = [NSMutableArray array];
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
    if ([key isEqualToString:@"cloth"]) {
        for (NSDictionary *dic in value) {
            ZDHClothDetailViewControllerClothModel *clothModel = [[ZDHClothDetailViewControllerClothModel alloc] init];
            [clothModel setValuesForKeysWithDictionary:dic];
            [_cloth addObject:clothModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
