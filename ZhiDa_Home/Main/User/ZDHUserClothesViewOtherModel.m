//
//  ZDHUserClothesViewOtherModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHUserClothesViewOtherModel.h"
#import "ZDHUserClothesViewOtherClothListModel.h"

@implementation ZDHUserClothesViewOtherModel
- (instancetype)init{
    if (self = [super init]) {
        _cloth_list = [NSMutableArray array];
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
    if ([key isEqualToString:@"cloth_list"]) {
        for (NSDictionary *dic in value) {
            ZDHUserClothesViewOtherClothListModel *listModel = [[ZDHUserClothesViewOtherClothListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dic];
            [_cloth_list addObject:listModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}

@end


