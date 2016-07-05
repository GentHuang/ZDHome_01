//
//  ZDHDesignDetailViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHDesignDetailViewModel.h"

@implementation ZDHDesignDetailViewModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    key = nil;
}
- (id)valueForUndefinedKey:(NSString *)key{
    return key;
}
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"design_detail"]) {
        _design_detail = [[ZDHDesignDetailViewDesignDetailModel alloc] init];
        [_design_detail setValuesForKeysWithDictionary:value];
    }else{
        [super setValue:value forKey:key];
    }
}
@end
