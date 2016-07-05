//
//  ZDHAppUpdateModel.m
//  
//
//  Created by apple on 16/4/8.
//
//

#import "ZDHAppUpdateModel.h"

@implementation ZDHAppUpdateModel
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _id_config = value;
    }
    else{
        
        [super setValue:value forKey:key];
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    key = nil;
}

- (id)valueForUndefinedKey:(NSString *)key{
    
    return key;
}


@end
