//
//  ZDHGroupViewControllerBannerModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/17.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHGroupViewControllerBannerModel.h"

@implementation ZDHGroupViewControllerBannerModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    key = nil;
}
- (id)valueForUndefinedKey:(NSString *)key{
    return key;
}
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"designteam_banner"]) {
        _designteam_banner = [[ZDHGroupViewControllerBannerDesignteamBannerModel alloc] init];
        [_designteam_banner setValuesForKeysWithDictionary:value];
    }else{
        [super setValue:value forKey:key];
    }
}
@end
