//
//  ZDHSearchViewControllerListModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/12/2.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHSearchViewControllerNewListModel.h"
#import "ZDHSearchViewControllerNewListProtypelistModel.h"
@implementation ZDHSearchViewControllerNewListModel
- (instancetype)init{
    if (self = [super init]) {
        _protypelist = [NSMutableArray array];
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
    if ([key isEqualToString:@"protypelist"]) {
        for (NSDictionary *dic in value) {
            ZDHSearchViewControllerNewListProtypelistModel *protypelistModel = [[ZDHSearchViewControllerNewListProtypelistModel alloc] init];
            [protypelistModel setValuesForKeysWithDictionary:dic];
            [_protypelist addObject:protypelistModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
