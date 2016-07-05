//
//  ZDHHomePageViewControllerDIYModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/16.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHHomePageViewControllerDIYModel.h"
#import "ZDHHomePageViewControllerDIYHotdiyModel.h"

@implementation ZDHHomePageViewControllerDIYModel
- (instancetype)init{
    if (self = [super init]) {
        _hotdiy = [NSMutableArray array];
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
    if ([key isEqualToString:@"hotdiy"]) {
        for (NSDictionary *dic in value) {
            ZDHHomePageViewControllerDIYHotdiyModel *diyModel = [[ZDHHomePageViewControllerDIYHotdiyModel alloc] init];
            [diyModel setValuesForKeysWithDictionary:dic];
            [_hotdiy addObject:diyModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
