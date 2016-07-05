//
//  ZDHHomePageViewControllerDesignerModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/16.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHHomePageViewControllerDesignerModel.h"
#import "ZDHHomePageViewControllerDesignerListModel.h"

@implementation ZDHHomePageViewControllerDesignerModel
- (instancetype)init{
    if (self = [super init]) {
        _designteam_list = [NSMutableArray array];
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
    if ([key isEqualToString:@"designteam_list"]) {
        for (NSDictionary *dic in value) {
            ZDHHomePageViewControllerDesignerListModel *listModel = [[ZDHHomePageViewControllerDesignerListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dic];
            [_designteam_list addObject:listModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
