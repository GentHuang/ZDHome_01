//
//  ZDHDIYDetailViewControllerModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/13.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHDIYDetailViewControllerModel.h"

@implementation ZDHDIYDetailViewControllerModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    key = nil;
}
- (id)valueForUndefinedKey:(NSString *)key{
    return key;
}
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"diy_detail"]) {
        _diy_detail = [[ZDHDIYDetailViewControllerDiyDetailModel alloc] init];
        [_diy_detail setValuesForKeysWithDictionary:value];
    }else{
        [super setValue:value forKey:key];
    }
}
@end
