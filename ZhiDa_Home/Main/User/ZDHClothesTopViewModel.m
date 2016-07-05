//
//  ZDHClothesTopViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHClothesTopViewModel.h"
#import "ZDHClothesTopViewTypeListModel.h"

@implementation ZDHClothesTopViewModel
- (instancetype)init{
    if (self = [super init]) {
        _tyle_list = [NSMutableArray array];
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
    if ([key isEqualToString:@"tyle_list"]) {
        for (NSDictionary *dic in value) {
            ZDHClothesTopViewTypeListModel *typeModel  = [[ZDHClothesTopViewTypeListModel alloc] init];
            [typeModel setValuesForKeysWithDictionary:dic];
            [_tyle_list addObject:typeModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}


@end


