//
//  ZDHProductViewDetailShopDetailExpresslistModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductViewDetailShopDetailExpresslistModel.h"

@implementation ZDHProductViewDetailShopDetailExpresslistModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    key = nil;
}
- (id)valueForUndefinedKey:(NSString *)key{
    return key;
}
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"erpexpressinfo"]) {
        _erpexpressinfo = [[ZDHProductViewDetailShopDetailExpresslistErpexpressinfoModel alloc] init];
        //--------------
        NSDictionary *value1 = [value firstObject];
        //---------------
        [_erpexpressinfo setValuesForKeysWithDictionary:value1];
    }else{
        [super setValue:value forKey:key];
    }
}
@end
