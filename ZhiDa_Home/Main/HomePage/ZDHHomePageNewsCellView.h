//
//  ZDHHomePageNewsCellView.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHHomePageNewsCellView : UIView
@property (strong, nonatomic) UILabel *typeLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *descLabel;
@property (strong, nonatomic) UIImageView *photoView;
//刷新图片
- (void)reloadPhotoView:(UIImage *)photoImage;
//刷新文字
- (void)reloadTypeName:(NSString *)typeName name:(NSString *)name desc:(NSString *)desc;
@end
