//
//  ZDHDesignMethodsViewControllerModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/30.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHDesignMethodsViewControllerModel.h"

@implementation ZDHDesignMethodsViewControllerModel
- (instancetype)init{
    if (self  = [super init]) {
        _designplan_iteminfo = [[ZDHDesignMethodsViewControllerDesignplanIteminfoModel alloc] init];
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
    if ([key isEqualToString:@"designplan_iteminfo"]) {
        [_designplan_iteminfo setValuesForKeysWithDictionary:value];
    }else{
        [super setValue:value forKey:key];
    }
}
@end
