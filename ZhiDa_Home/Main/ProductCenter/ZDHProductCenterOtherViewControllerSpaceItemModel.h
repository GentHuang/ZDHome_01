//
//  ZDHProductCenterOtherViewControllerSpaceItemModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/11/6.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHProductCenterOtherViewControllerSpaceItemModel : NSObject
@property (strong, nonatomic) NSString *id_conflict;
@property (strong, nonatomic) NSString *intro;
@property (strong, nonatomic) NSString *otherimg;
@property (strong, nonatomic) NSString *spaceimg;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *tid;

//add ----
@property (strong, nonatomic) NSMutableArray *aboutproduct;
@end
