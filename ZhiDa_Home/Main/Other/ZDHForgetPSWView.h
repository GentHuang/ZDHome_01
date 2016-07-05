//
//  ZDHForgetPSWView.h
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHForgetPSWView : UIView
@property (strong, nonatomic) NSString *statusMsg;
//点击提交按钮
- (void)ForgetPSWCommitEmail:(NSNotification*)notif success:(SuccessBlock)success fail:(FailBlock)fail;
@end
