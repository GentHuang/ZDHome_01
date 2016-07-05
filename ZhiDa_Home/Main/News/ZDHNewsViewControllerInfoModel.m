//
//  ZDHNewsViewControllerInfoModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/11.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHNewsViewControllerInfoModel.h"
#import "ZDHNewsViewControllerInfoListModel.h"
@implementation ZDHNewsViewControllerInfoModel
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
            ZDHNewsViewControllerInfoListModel *listModel = [[ZDHNewsViewControllerInfoListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dic];
            [_news_list addObject:listModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
