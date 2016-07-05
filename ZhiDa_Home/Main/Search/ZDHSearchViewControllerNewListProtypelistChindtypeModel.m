//
//  ZDHSearchViewControllerListProtypelistChindtypeModel.m
//  ZhiDa_Home
//
//  Created by apple on 16/1/21.
//  Copyright (c) 2016年 软碟技术. All rights reserved.
//

#import "ZDHSearchViewControllerNewListProtypelistChindtypeModel.h"
#import "ZDHSearchViewControllerNewListProtypelistChindtypeChindtypeModel.h"
@implementation ZDHSearchViewControllerNewListProtypelistChindtypeModel
- (instancetype)init{
    if (self = [super init]) {
        _chindtype = [NSMutableArray array];
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
    
    if ([key isEqualToString:@"chindtype"]) {
        _chindtype = [NSMutableArray array];
        for (NSDictionary *dic in value) {
            
            ZDHSearchViewControllerNewListProtypelistChindtypeChindtypeModel *chindModel = [[ZDHSearchViewControllerNewListProtypelistChindtypeChindtypeModel alloc]init];
            [chindModel setValuesForKeysWithDictionary:dic];
            [_chindtype addObject:chindModel];
        }
       
    }else if([key isEqualToString:@"typeid"]){
        _typeid_conflict = value;
    }else if([key isEqualToString:@"typename"]){
        _typename_conflict = value;
    }else{
        [super setValue:value forKey:key];
    }
    
}
@end
