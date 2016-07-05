//
//  ZDHProductCommonTopScrollViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductCommonTopScrollViewModel.h"
#import "ZDHProductCommonTopScrollViewYearModel.h"
@implementation ZDHProductCommonTopScrollViewModel
-(instancetype)init{
    if (self = [super init]) {
        _themeyear = [NSMutableArray array];
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
   
    if ([key isEqualToString:@"themeyear"]) {
        for (NSDictionary *dic in value) {
            ZDHProductCommonTopScrollViewYearModel *yearModel = [[ZDHProductCommonTopScrollViewYearModel alloc] init];
            [yearModel setValuesForKeysWithDictionary:dic];
            [_themeyear addObject:yearModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
