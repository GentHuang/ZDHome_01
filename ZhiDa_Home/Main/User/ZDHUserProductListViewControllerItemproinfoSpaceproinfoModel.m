//
//  ZDHUserProductListViewControllerItemproinfoSpaceproinfoModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/30.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHUserProductListViewControllerItemproinfoSpaceproinfoModel.h"
#import "ZDHUserProductListViewControllerItemproinfoSpaceproinfoProdetailModel.h"

@implementation ZDHUserProductListViewControllerItemproinfoSpaceproinfoModel
- (instancetype)init{
    if (self = [super init]) {
        _prodetail = [NSMutableArray array];
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
    if ([key isEqualToString:@"prodetail"]) {
        for (NSDictionary *dic in value) {
            ZDHUserProductListViewControllerItemproinfoSpaceproinfoProdetailModel *proModel = [[ZDHUserProductListViewControllerItemproinfoSpaceproinfoProdetailModel alloc] init];
            [proModel setValuesForKeysWithDictionary:dic];
            [_prodetail addObject:proModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
