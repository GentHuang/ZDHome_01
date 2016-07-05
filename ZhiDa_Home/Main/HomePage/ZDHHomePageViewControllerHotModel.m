//
//  ZDHHomePageViewControllerHotModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/12/2.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHHomePageViewControllerHotModel.h"
#import "ZDHHomePageViewControllerHotHotproductModel.h"

@implementation ZDHHomePageViewControllerHotModel
- (instancetype)init{
    if (self = [super init]) {
        _hotproduct = [NSMutableArray array];
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
    if ([key isEqualToString:@"hotproduct"]) {
        for (NSDictionary *dic in value) {
            ZDHHomePageViewControllerHotHotproductModel *hotModel = [[ZDHHomePageViewControllerHotHotproductModel alloc] init];
            [hotModel setValuesForKeysWithDictionary:dic];
            [_hotproduct addObject:hotModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
