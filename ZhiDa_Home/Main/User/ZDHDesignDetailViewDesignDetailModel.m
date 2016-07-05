//
//  ZDHDesignDetailViewDesignDetailModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHDesignDetailViewDesignDetailModel.h"
#import "ZDHDesignDetailViewDesignDetailAboutproductModel.h"
@implementation ZDHDesignDetailViewDesignDetailModel
- (instancetype)init{
    if (self = [super init]) {
        _aboutproduct = [NSMutableArray array];
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
    if ([key isEqualToString:@"aboutproduct"]) {
        for (NSDictionary *dic in value) {
            ZDHDesignDetailViewDesignDetailAboutproductModel *aboutModel = [[ZDHDesignDetailViewDesignDetailAboutproductModel alloc] init];
            [aboutModel setValuesForKeysWithDictionary:dic];
            [_aboutproduct addObject:aboutModel];
        }
    }else if([key isEqualToString:@"planitem"]){
        _planitem = [[ZDHDesignDetailViewDesignDetailPlanitemModel alloc] init];
        [_planitem setValuesForKeysWithDictionary:value];
    }else{
        [super setValue:value forKey:key];
    }
}
@end
