//
//  ZDHInterNewsDetailModel.m
//  ZhiDa_Home
//
//  Created by 曾梓麟 on 15/9/4.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHInterNewsDetailModel.h"
#import "ZDHInterNewsDetailListModel.h"
@implementation ZDHInterNewsDetailModel
- (instancetype)init{
    if (self = [super init]) {
        _news_list = [NSMutableArray array];
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
    if ([key isEqualToString:@"news_list"]) {
        for (NSDictionary *dic in value) {
            ZDHInterNewsDetailListModel *listModel = [[ZDHInterNewsDetailListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dic];
            [_news_list addObject:listModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end


