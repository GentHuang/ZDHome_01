//
//  ZDHNewsViewControllerTitleModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/11.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHNewsViewControllerTitleModel.h"
#import "ZDHNewsViewControllerTitleTypeListModel.h"
@implementation ZDHNewsViewControllerTitleModel
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
            ZDHNewsViewControllerTitleTypeListModel *listModel = [[ZDHNewsViewControllerTitleTypeListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dic];
            [_type_list addObject:listModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
