//
//  ZDHSearchViewControllerListModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/12/2.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHSearchViewControllerListModel.h"
#import "ZDHSearchViewControllerListNewsSearchModel.h"

@implementation ZDHSearchViewControllerListModel
- (instancetype)init{
    if (self = [super init]) {
        _news_search = [NSMutableArray array];
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
    if ([key isEqualToString:@"news_search"]) {
        for (NSDictionary *dic in value) {
            ZDHSearchViewControllerListNewsSearchModel *searchModel = [[ZDHSearchViewControllerListNewsSearchModel alloc] init];
            [searchModel setValuesForKeysWithDictionary:dic];
            [_news_search addObject:searchModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}

@end
