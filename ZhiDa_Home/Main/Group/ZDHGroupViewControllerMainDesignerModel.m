//
//  ZDHGroupViewControllerMainDesignerModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/17.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHGroupViewControllerMainDesignerModel.h"

@implementation ZDHGroupViewControllerMainDesignerModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    key = nil;
}
- (id)valueForUndefinedKey:(NSString *)key{
    return key;
}
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"designteam_top1"]) {
        _designteam_top1 = [[ZDHGroupViewControllerMainDesignerTopModel alloc] init];
        [_designteam_top1 setValuesForKeysWithDictionary:value];
    }else{
        [super setValue:value forKey:key];
    }
}
@end
