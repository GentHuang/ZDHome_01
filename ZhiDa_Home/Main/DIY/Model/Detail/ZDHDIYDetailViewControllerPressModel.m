//
//  ZDHDIYDetailViewControllerPressModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/16.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHDIYDetailViewControllerPressModel.h"
@implementation ZDHDIYDetailViewControllerPressModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    key = nil;
}
- (id)valueForUndefinedKey:(NSString *)key{
    return key;
}
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"diy_getdiypro"]) {
        _diy_getdiypro = [[ZDHDIYDetailViewControllerPressDiyGetdiyproModel alloc] init];
        [_diy_getdiypro setValuesForKeysWithDictionary:value];
    }else{
        [super setValue:value forKey:key];
    }
}
@end
