//
//  ZDHListViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHListViewModel.h"
#import "ZDHListViewSceneModel.h"
#import "ZDHListViewClothesModel.h"

@implementation ZDHListViewModel
// 初始化
- (instancetype)init{
    if (self = [super init]) {
        _scene = [NSMutableArray array];
        _cloths = [NSMutableArray array];
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
    if ([key isEqualToString:@"scene"]) {
        for (NSDictionary *dic in value) {
            ZDHListViewSceneModel *sceneModel = [[ZDHListViewSceneModel alloc] init];
            [sceneModel setValuesForKeysWithDictionary:dic];
            [_scene addObject:sceneModel];
        }
    }else if([key isEqualToString:@"cloths"]){
        for (NSDictionary *dic in value) {
            ZDHListViewClothesModel *clothModel = [[ZDHListViewClothesModel alloc] init];
            [clothModel setValuesForKeysWithDictionary:dic];
            [_cloths addObject:clothModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end


