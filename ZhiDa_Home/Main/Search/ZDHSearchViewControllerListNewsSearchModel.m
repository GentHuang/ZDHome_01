//
//  ZDHSearchViewControllerListNewsSearchModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/12/2.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHSearchViewControllerListNewsSearchModel.h"
#import "ZDHSearchViewControllerListNewsSearchSearchTModel.h"

@implementation ZDHSearchViewControllerListNewsSearchModel
- (instancetype)init{
    if (self = [super init]) {
        _search_t = [NSMutableArray array];
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
    if ([key isEqualToString:@"typeid"]) {
        _typeid_conflict = value;
    }else if([key isEqualToString:@"search_t"]){
        
        for (NSDictionary *dic in value) {
            ZDHSearchViewControllerListNewsSearchSearchTModel *searchModel = [[ZDHSearchViewControllerListNewsSearchSearchTModel alloc] init];
            [searchModel setValuesForKeysWithDictionary:dic];
            [_search_t addObject:searchModel];
        }
    }else{
        
        [super setValue:value forKey:key];
    }
}
@end
