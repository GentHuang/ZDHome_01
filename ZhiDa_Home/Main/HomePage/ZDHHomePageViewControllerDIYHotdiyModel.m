//
//  ZDHHomePageViewControllerDIYHotdiyModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/16.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHHomePageViewControllerDIYHotdiyModel.h"

@implementation ZDHHomePageViewControllerDIYHotdiyModel
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _id_conflict = value;
    }else{
        [super setValue:value forKey:key];
    }
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    key = nil;
}
- (id)valueForUndefinedKey:(NSString *)key{
    return key;
}
@end
