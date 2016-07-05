//
//  ZDHLogViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/20.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHLogViewModel.h"
#import "ZDHLogViewOrderLogsModel.h"

@implementation ZDHLogViewModel
- (instancetype)init{
    if (self = [super init]) {
        _order_logs = [NSMutableArray array];
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
    if ([key isEqualToString:@"order_logs"]) {
        for (NSDictionary *dic in value) {
            ZDHLogViewOrderLogsModel *logsModel = [[ZDHLogViewOrderLogsModel alloc] init];
            [logsModel setValuesForKeysWithDictionary:dic];
            [_order_logs addObject:logsModel];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end
