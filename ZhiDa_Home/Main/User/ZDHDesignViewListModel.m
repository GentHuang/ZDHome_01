//
//  ZDHDesignViewListModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHDesignViewListModel.h"
#import "ZDHDesignViewListDesignListModel.h"

@implementation ZDHDesignViewListModel
- (instancetype)init{
    if (self = [super init]) {
        _desgin_list = [NSMutableArray array];
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
    if ([key isEqualToString:@"desgin_list"]) {
        for (NSDictionary *dic in value) {
            ZDHDesignViewListDesignListModel *listModel = [[ZDHDesignViewListDesignListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dic];
            [_desgin_list addObject:listModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
