//
//  ZDHUserProductListCell.h
//  ZhiDa_Home
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHUserProductListCell : UITableViewCell
//加载名称，单价，数量，价格
- (void)loadUpContentWithDataArray:(NSArray *)dataArray;
//加载型号，规格
- (void)loadDownContentWithDataArray:(NSArray *)dataArray;
//加载图片
- (void)loadImageWithImage:(NSString *)imageString;
@end
