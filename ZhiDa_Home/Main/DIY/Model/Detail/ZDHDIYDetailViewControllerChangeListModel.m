//
//  ZDHDIYDetailViewControllerChangeListModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/13.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHDIYDetailViewControllerChangeListModel.h"
#import "ZDHDIYDetailViewControllerChangeListDiyProbytypeListModel.h"

@implementation ZDHDIYDetailViewControllerChangeListModel
- (instancetype)init{
    if (self = [super init]) {
        _diyProbytype_List = [NSMutableArray array];
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
    if ([key isEqualToString:@"diyProbytype_List"]) {
        for (NSDictionary *dic in value) {
            ZDHDIYDetailViewControllerChangeListDiyProbytypeListModel *listModel = [[ZDHDIYDetailViewControllerChangeListDiyProbytypeListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dic];
            [_diyProbytype_List addObject:listModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
