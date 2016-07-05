//
//  TTCScanViewController.h
//  TTC_Broadband
//
//  Created by 曾梓麟 on 16/1/3.
//  Copyright © 2016年 TTC. All rights reserved.
//

#import "ZDHParentViewController.h"

@interface TTCScanViewController : UIViewController
@property (nonatomic, copy) void (^SYQRCodeSuncessBlock) (NSString *goodsId,NSString *classifyId);//扫描结果
@end
