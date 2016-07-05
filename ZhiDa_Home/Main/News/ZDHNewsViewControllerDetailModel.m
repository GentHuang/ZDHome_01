//
//  ZDHNewsViewControllerDetailModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/11.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHNewsViewControllerDetailModel.h"
#import "ZDHNewsViewControllerDetailNewsModel.h"
@implementation ZDHNewsViewControllerDetailModel
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
            ZDHNewsViewControllerDetailNewsModel *newsModel = [[ZDHNewsViewControllerDetailNewsModel alloc] init];
            [newsModel setValuesForKeysWithDictionary:dic];
            [_news_news addObject:newsModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
