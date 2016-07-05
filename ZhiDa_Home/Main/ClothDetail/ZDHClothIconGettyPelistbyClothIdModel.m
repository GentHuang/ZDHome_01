//
//  ZDHClothIconGettyPelistbyClothIdModel.m
//  
//
//  Created by apple on 16/4/9.
//
//

#import "ZDHClothIconGettyPelistbyClothIdModel.h"

@implementation ZDHClothIconGettyPelistbyClothIdModel

- (void) setValue:(id)value forUndefinedKey:(NSString *)key{
    
    key = nil;
}

- (id) valueForUndefinedKey:(NSString *)key{
    
    return key;
}

- (void) setValue:(id)value forKey:(NSString *)key{
    
    if ([key isEqualToString:@"typeid"]) {
        
        _typeid_config = value;
    }else if ([key isEqualToString:@"typename"]){
        
        _typename_config = value;
    }else{
        
        [super setValue:value forKey:key];
    }
}

@end
