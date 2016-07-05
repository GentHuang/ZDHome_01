//
//  ZDHRightViewRoomView.h
//  ZhiDa_Home
//
//  Created by apple on 15/9/16.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHRightViewRoomView : UIView
//刷新
- (void)reloadCell:(NSArray *)array;
//更新标题
- (void)reloadTitle:(NSString *)title;
@end
