//
//  ZDHDIYListViewControllerSpaceTypeListModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/13.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHDIYListViewControllerSpaceTypeListModel.h"

@implementation ZDHDIYListViewControllerSpaceTypeListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    key = nil;
}
- (id)valueForUndefinedKey:(NSString *)key{
    return key;
}
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"typeid"]) {
        _typeid_conflict = value;
    }else{
        [super setValue:value forKey:key];
    }
}
@end
