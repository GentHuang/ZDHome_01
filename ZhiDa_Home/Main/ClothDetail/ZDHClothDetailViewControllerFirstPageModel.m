//
//  ZDHClothDetailViewControllerFirstPageModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/11.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHClothDetailViewControllerFirstPageModel.h"
#import "ZDHClothDetailViewControllerFirstPageClothListModel.h"
@implementation ZDHClothDetailViewControllerFirstPageModel
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
            ZDHClothDetailViewControllerFirstPageClothListModel *listModel = [[ZDHClothDetailViewControllerFirstPageClothListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dic];
            [_cloth_list addObject:listModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
