//
//  ZDHDesignMethodsViewControllerDesignplanIteminfoModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/30.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHDesignMethodsViewControllerDesignplanIteminfoModel.h"
#import "ZDHDesignMethodsViewControllerDesignplanIteminfoListModel.h"

@implementation ZDHDesignMethodsViewControllerDesignplanIteminfoModel
- (instancetype)init{
    if (self = [super init]) {
        _spacelist = [NSMutableArray array];
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
    if ([key isEqualToString:@"spacelist"]) {
        for (NSDictionary *dic in value) {
            ZDHDesignMethodsViewControllerDesignplanIteminfoListModel *listModel = [[ZDHDesignMethodsViewControllerDesignplanIteminfoListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dic];
            [_spacelist addObject:listModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
