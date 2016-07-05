//
//  ZDHUserProductListFooter.h
//  ZhiDa_Home
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHUserProductListFooter : UIView
//点击回调
@property (copy, nonatomic) ButtonBlock buttonBlock;
//刷新折后价
- (void)reloadDiscountPrice:(NSString *)discountPrice;
//刷新总价
- (void)reloadTotalPrice:(NSString *)totalPrice;
@end
