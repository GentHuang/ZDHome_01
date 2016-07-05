//
//  ZDHClothedCell.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHClothedCell : UICollectionViewCell
//刷新标题
- (void)reloadNameWithString:(NSString *)nameString;
//刷新图片
- (void)reloadImageWithImage:(id)imageString;
@end
