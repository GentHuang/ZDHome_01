//
//  ZDHNewsViewControllerTitleTypeListModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/11.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHNewsViewControllerTitleTypeListModel.h"

@implementation ZDHNewsViewControllerTitleTypeListModel
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