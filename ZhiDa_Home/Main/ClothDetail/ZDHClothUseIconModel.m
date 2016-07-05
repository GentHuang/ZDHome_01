//
//  ZDHClothUseIconModel.m
//  
//
//  Created by apple on 16/4/9.
//
//

#import "ZDHClothUseIconModel.h"
#import "ZDHClothIconGettyPelistbyClothIdModel.h"

@implementation ZDHClothUseIconModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    key = nil;
}

- (id)valueForUndefinedKey:(NSString *)key{
    
    return key;
}

- (void) setValue:(id)value forKey:(NSString *)key{
    
    if ([key isEqualToString:@"gettypelistbyclothid"]) {
        _gettypelistbyclothid = [NSMutableArray array];
        for (NSDictionary *dic in value) {

            ZDHClothIconGettyPelistbyClothIdModel *GettyPelistbyClothIdModel = [[ZDHClothIconGettyPelistbyClothIdModel alloc]init];
            [GettyPelistbyClothIdModel setValuesForKeysWithDictionary:dic];
            [_gettypelistbyclothid addObject:GettyPelistbyClothIdModel];
        }
        
    }else{
        
        [super setValue:value forKey:key];
    }
}

@end
