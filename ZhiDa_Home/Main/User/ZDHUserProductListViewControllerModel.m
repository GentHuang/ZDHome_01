//
//  ZDHUserProductListViewControllerModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/30.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHUserProductListViewControllerModel.h"

@implementation ZDHUserProductListViewControllerModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    key = nil;
}
- (id)valueForUndefinedKey:(NSString *)key{
    return key;
}
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"designplan_itemproinfo"]) {
        _designplan_itemproinfo = [[ZDHUserProductListViewControllerItemproinfoModel alloc] init];
        [_designplan_itemproinfo setValuesForKeysWithDictionary:value];
    }else{
        [super setValue:value forKey:key];
    }
}
@end
