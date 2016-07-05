//
//  ZDHProductDetailViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductDetailViewModel.h"
#import "ZDHProductDetailViewProductModel.h"
@implementation ZDHProductDetailViewModel
-(instancetype)init{
    if (self = [super init]) {
        _product = [NSMutableArray array];
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
    if ([key isEqualToString:@"product"]) {
        for (NSDictionary *dic in value) {
            ZDHProductDetailViewProductModel *productModel = [[ZDHProductDetailViewProductModel alloc] init];
            [productModel setValuesForKeysWithDictionary:dic];
            [_product addObject:productModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}

@end


