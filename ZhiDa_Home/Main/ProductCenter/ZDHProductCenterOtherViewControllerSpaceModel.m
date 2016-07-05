//
//  ZDHProductCenterOtherViewControllerSpaceModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/6.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductCenterOtherViewControllerSpaceModel.h"
#import "ZDHProductCenterOtherViewControllerSpaceItemModel.h"
@implementation ZDHProductCenterOtherViewControllerSpaceModel
- (instancetype)init{
    if (self = [super init]) {
        _spaceitem = [NSMutableArray array];
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
    if ([key isEqualToString:@"spaceitem"]) {
        for (NSDictionary *dic in value) {
            ZDHProductCenterOtherViewControllerSpaceItemModel *itemModel = [[ZDHProductCenterOtherViewControllerSpaceItemModel alloc] init];
            [itemModel setValuesForKeysWithDictionary:dic];
            [_spaceitem addObject:itemModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
