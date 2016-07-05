//
//  ZDHDesignViewMethodListModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHDesignViewMethodListModel.h"
#import "ZDHDesignViewMethodListDesignplanListModel.h"

@implementation ZDHDesignViewMethodListModel
- (instancetype)init{
    if (self = [super init]) {
        _designplan_list = [NSMutableArray array];
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
    if ([key isEqualToString:@"designplan_list"]) {
        for (NSDictionary *dic in value) {
            ZDHDesignViewMethodListDesignplanListModel *listModel = [[ZDHDesignViewMethodListDesignplanListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dic];
            [_designplan_list addObject:listModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
