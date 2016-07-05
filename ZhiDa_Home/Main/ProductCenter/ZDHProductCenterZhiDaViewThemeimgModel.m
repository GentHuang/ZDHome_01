//
//  ZDHProductCenterZhiDaViewThemeimgModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/6.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductCenterZhiDaViewThemeimgModel.h"
#import "ZDHProductCenterZhiDaViewThemeimgThemeModel.h"
@implementation ZDHProductCenterZhiDaViewThemeimgModel
- (instancetype)init{
    if (self = [super init]) {
        _theme = [NSMutableArray array];
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
    if ([key isEqualToString:@"theme"]) {
        for (NSDictionary *dic in value) {
            ZDHProductCenterZhiDaViewThemeimgThemeModel *themeModel = [[ZDHProductCenterZhiDaViewThemeimgThemeModel alloc] init];
            [themeModel setValuesForKeysWithDictionary:dic];
            [_theme addObject:themeModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
