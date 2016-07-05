//
//  ZDHInterNewTitleModel.m
//  ZhiDa_Home
//
//  Created by 曾梓麟 on 15/9/4.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHInterNewTitleModel.h"
#import "ZDHInterNewTitleListModel.h"
@implementation ZDHInterNewTitleModel
- (instancetype)init{
    if (self = [super init]) {
        _type_list = [NSMutableArray array];
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
    if ([key isEqualToString:@"type_list"]) {
        for (NSDictionary *dic in value) {
            ZDHInterNewTitleListModel *listModel = [[ZDHInterNewTitleListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dic];
            [_type_list addObject:listModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end


