//
//  ZDHDIYListViewControllerListModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/13.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHDIYListViewControllerListModel.h"
#import "ZDHDIYListViewControllerListDiyListModel.h"

@implementation ZDHDIYListViewControllerListModel
- (instancetype)init{
    if (self = [super init]) {
        _diy_list = [NSMutableArray array];
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
    if ([key isEqualToString:@"diy_list"]) {
        for (NSDictionary *dic in value) {
            ZDHDIYListViewControllerListDiyListModel *listModel = [[ZDHDIYListViewControllerListDiyListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dic];
            [_diy_list addObject:listModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
