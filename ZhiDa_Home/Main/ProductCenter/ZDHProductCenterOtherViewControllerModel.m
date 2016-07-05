//
//  ZDHProductCenterOtherViewControllerModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/6.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductCenterOtherViewControllerModel.h"
#import "ZDHProductCenterOtherViewControllerSpaceModel.h"

@implementation ZDHProductCenterOtherViewControllerModel
- (instancetype)init{
    if (self = [super init]) {
        _space = [NSMutableArray array];
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
    if ([key isEqualToString:@"space"]) {
        for (NSDictionary *dic in value) {
            ZDHProductCenterOtherViewControllerSpaceModel *spaceModel = [[ZDHProductCenterOtherViewControllerSpaceModel alloc] init];
            [spaceModel setValuesForKeysWithDictionary:dic];
            [_space addObject:spaceModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}

@end
