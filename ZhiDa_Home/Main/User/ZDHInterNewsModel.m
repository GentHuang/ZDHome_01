//
//  ZDHInterNewsModel.m
//  ZhiDa_Home
//
//  Created by 曾梓麟 on 15/9/4.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHInterNewsModel.h"
#import "ZDHInterNewNewsModel.h"

@implementation ZDHInterNewsModel
- (instancetype)init{
    if (self = [super init]) {
        _news_news = [NSMutableArray array];
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
    if ([key isEqualToString:@"news_news"]) {
        for (NSDictionary *dic in value) {
            ZDHInterNewNewsModel *newsModel = [[ZDHInterNewNewsModel alloc] init];
            [newsModel setValuesForKeysWithDictionary:dic];
            [_news_news addObject:newsModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}

@end


