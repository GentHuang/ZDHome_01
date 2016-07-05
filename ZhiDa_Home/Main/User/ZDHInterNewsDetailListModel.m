//
//  ZDHInterNewsDetailListModel.m
//  ZhiDa_Home
//
//  Created by 曾梓麟 on 15/9/4.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHInterNewsDetailListModel.h"

@implementation ZDHInterNewsDetailListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    key = nil;
}
- (id)valueForUndefinedKey:(NSString *)key{
    return key;
}
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"id_conflict"];
    }else{
        [super setValue:value forKey:key];
    }
}
@end


