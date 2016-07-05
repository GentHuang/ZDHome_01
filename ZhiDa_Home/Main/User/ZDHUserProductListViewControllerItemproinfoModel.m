//
//  ZDHUserProductListViewControllerItemproinfoModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/30.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHUserProductListViewControllerItemproinfoModel.h"
#import "ZDHUserProductListViewControllerItemproinfoSpaceproinfoModel.h"

@implementation ZDHUserProductListViewControllerItemproinfoModel
- (instancetype)init{
    if (self = [super init]) {
        _spaceproinfo = [NSMutableArray array];
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
    if ([key isEqualToString:@"spaceproinfo"]) {
        for (NSDictionary *dic in value) {
            ZDHUserProductListViewControllerItemproinfoSpaceproinfoModel *prodetailModel = [[ZDHUserProductListViewControllerItemproinfoSpaceproinfoModel alloc] init];
            [prodetailModel setValuesForKeysWithDictionary:dic];
            [_spaceproinfo addObject:prodetailModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
