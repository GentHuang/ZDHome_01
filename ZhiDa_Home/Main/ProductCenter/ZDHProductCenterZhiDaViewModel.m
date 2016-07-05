//
//  ZDHProductCenterZhiDaViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductCenterZhiDaViewModel.h"
#import "ZDHProductCenterZhiDaViewThemeModel.h"
@implementation ZDHProductCenterZhiDaViewModel
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
            ZDHProductCenterZhiDaViewThemeModel *themeModel = [[ZDHProductCenterZhiDaViewThemeModel alloc] init];
            [themeModel setValuesForKeysWithDictionary:dic];
            [_themeyear addObject:themeModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end


