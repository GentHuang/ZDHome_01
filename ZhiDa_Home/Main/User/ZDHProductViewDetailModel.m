//
//  ZDHProductViewDetailModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductViewDetailModel.h"

@implementation ZDHProductViewDetailModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    key = nil;
}
- (id)valueForUndefinedKey:(NSString *)key{
    return key;
}
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"shop_detail"]) {
        _shop_detail = [[ZDHProductViewDetailShopDetailModel alloc] init];
        [_shop_detail setValuesForKeysWithDictionary:value];
    }else{
        [super setValue:value forKey:key];
    }
}
@end
