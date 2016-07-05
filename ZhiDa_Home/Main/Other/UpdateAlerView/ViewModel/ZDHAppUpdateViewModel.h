//
//  ZDHAppUpdateViewModel.h
//  
//
//  Created by apple on 16/4/8.
//
//

#import <Foundation/Foundation.h>
#import "ZDHAppUpdateModel.h"

@interface ZDHAppUpdateViewModel : NSObject

@property (strong, nonatomic) NSMutableArray *updateModelArray;

- (void) getAppUpdateDataSuccess:(SuccessBlock)success fail:(FailBlock)fail;

@end
