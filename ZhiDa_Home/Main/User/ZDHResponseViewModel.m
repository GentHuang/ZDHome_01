//
//  ZDHResponseViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/20.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHResponseViewModel.h"

@implementation ZDHResponseViewModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    key = nil;
}
- (id)valueForUndefinedKey:(NSString *)key{
    return key;
}
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"addresult"]) {
        _addresult = [[ZDHResponseViewAddresultModel alloc] init];
        [_addresult setValuesForKeysWithDictionary:value];
    }else{
        [super setValue:value forKey:key];
    }
}
@end
