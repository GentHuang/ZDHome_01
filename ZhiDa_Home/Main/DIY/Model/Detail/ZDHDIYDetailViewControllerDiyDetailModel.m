//
//  ZDHDIYDetailViewControllerDiyDetailModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/13.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHDIYDetailViewControllerDiyDetailModel.h"
#import "ZDHDIYDetailViewControllerDiyDetailDiyproListModel.h"
#import "ZDHDIYDetailViewControllerDiyDetailProListModel.h"
#import "ZDHDIYDetailViewControllerDiyDetailTypeListModel.h"

@implementation ZDHDIYDetailViewControllerDiyDetailModel
- (instancetype)init{
    if (self = [super init]) {
        _diypro_list = [NSMutableArray array];
        _pro_list = [NSMutableArray array];
        _type_list = [NSMutableArray array];
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
    
    if ([key isEqualToString:@"diypro_list"]) {
        for (NSDictionary *dic in value) {
            ZDHDIYDetailViewControllerDiyDetailDiyproListModel *listModel = [[ZDHDIYDetailViewControllerDiyDetailDiyproListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dic];
            [_diypro_list addObject:listModel];
        }
    }else if([key isEqualToString:@"pro_list"]){
        for (NSDictionary *dic in value) {
            ZDHDIYDetailViewControllerDiyDetailProListModel *listModel = [[ZDHDIYDetailViewControllerDiyDetailProListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dic];
            [_pro_list addObject:listModel];
        }
    }else if([key isEqualToString:@"type_list"]){
        for (NSDictionary *dic in value) {
            ZDHDIYDetailViewControllerDiyDetailTypeListModel *listModel = [[ZDHDIYDetailViewControllerDiyDetailTypeListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dic];
            [_type_list addObject:listModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
