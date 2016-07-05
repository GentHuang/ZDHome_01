//
//  ZDHProductCenterBrandBottomView.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    kSingleRightUpType,
    kSingleRightDownType,
}SingleRightType;
@interface ZDHProductCenterSingleRightView : UIView
//刷新UpView的数据
- (void)reloadUpViewWithString:(NSString *)contentString;
//刷新DownView的数据
- (void)reloadDownViewWithArray:(NSArray *)array;
//选择模块的模式
- (void)setSingleRightViewType:(SingleRightType)type;
@end
