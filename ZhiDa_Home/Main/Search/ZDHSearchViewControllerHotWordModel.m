//
//  ZDHSearchViewControllerHotWordModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/12/2.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHSearchViewControllerHotWordModel.h"
#import "ZDHSearchViewControllerHotWordHotsearchWordModel.h"

@implementation ZDHSearchViewControllerHotWordModel
- (instancetype)init{
    if (self = [super init]) {
        _hotsearch_word = [NSMutableArray array];
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
    if ([key isEqualToString:@"hotsearch_word"]) {
        for (NSDictionary *dic in value) {
            ZDHSearchViewControllerHotWordHotsearchWordModel *wordModel = [[ZDHSearchViewControllerHotWordHotsearchWordModel alloc] init];
            [wordModel setValuesForKeysWithDictionary:dic];
            [_hotsearch_word addObject:wordModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
