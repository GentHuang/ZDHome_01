//
//  ZDHUserProductListSectionFooter.h
//  ZhiDa_Home
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHUserProductListSectionFooter : UIView
//刷新小计
- (void)reloadNameTitle:(NSString *)title;
//刷新花费
- (void)reloadPriceTitle:(NSString *)title;
@end
