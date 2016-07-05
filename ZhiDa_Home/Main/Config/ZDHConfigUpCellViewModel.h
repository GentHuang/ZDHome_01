//
//  ZDHConfigUpCellViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/9/1.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHConfigUpCellViewModel : NSObject
@property (strong, nonatomic) NSString *sizeString;
//获取缓存大小
- (void)getCacheSize;
//删除缓存
- (void)clearCache;
@end
