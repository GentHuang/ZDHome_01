//
//  ZDHUserClothesViewOtherClothListModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHUserClothesViewOtherClothListModel.h"

@implementation ZDHUserClothesViewOtherClothListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    key = nil;
}
- (id)valueForUndefinedKey:(NSString *)key{
    return key;
}
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _id_conflict = value;
    }else{
        [super setValue:value forKey:key];
    }
}
@end