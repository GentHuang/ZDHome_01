//
//  ZDHHomePageViewControllerHearScrollModel.m
//  ZhiDa_Home
//
//  Created by apple on 16/1/25.
//  Copyright (c) 2016年 软碟技术. All rights reserved.
//

#import "ZDHHomePageViewControllerHearScrollModel.h"

#import "ZDHHomePageViewControllerHearScrollBrannerModel.h"
@implementation ZDHHomePageViewControllerHearScrollModel


- (instancetype)init {
    if(self=[super init]){
        
        _banner_list = [NSMutableArray array];//存储品牌
        
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    key=nil;
}

- (id)valueForUndefinedKey:(NSString *)key{
    return key;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"banner_list"]) {
        for ( NSDictionary *dic in value) {
            ZDHHomePageViewControllerHearScrollBrannerModel *model = [[ZDHHomePageViewControllerHearScrollBrannerModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_banner_list addObject:model];
        }
        
    }
    else if([key isEqualToString:@"clothlist_list"]){
        
    }else if([key isEqualToString:@"designteam_list"]){
        
    }
    else{
        [super setValue:value forKey:key];
    }
}
@end
