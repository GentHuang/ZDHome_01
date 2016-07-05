//
//  ZDHUserSuggestViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHUserSuggestViewModel.h"
#import "ZDHUserSuggestViewOrderOpinionsModel.h"

@implementation ZDHUserSuggestViewModel
- (instancetype)init{
    if (self = [super init]) {
        _order_opinions = [NSMutableArray array];
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
    if ([key isEqualToString:@"order_opinions"]) {
        for (NSDictionary *dic in value) {
            ZDHUserSuggestViewOrderOpinionsModel *opModel = [[ZDHUserSuggestViewOrderOpinionsModel alloc] init];
            [opModel setValuesForKeysWithDictionary:dic];
            [_order_opinions addObject:opModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}

@end
