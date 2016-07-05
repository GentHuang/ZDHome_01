//
//  ZDHVersionUpdateAlertView.h
//  
//
//  Created by apple on 16/4/8.
//
//

#import <UIKit/UIKit.h>

@protocol ZDHVersionUpdateAlertViewDelegate <NSObject>

@optional
- (void) alertViewToAppStoreUpdateApp;

@end

@interface ZDHVersionUpdateAlertView : UIView

@property (weak, nonatomic) id<ZDHVersionUpdateAlertViewDelegate>delegate;
/**
 *  <#Description#>
 *
 *  @param title    版本号
 *  @param message  版本信息
 *  @param delegate 回调协议
 *
 *  @return <#return value description#>
 */
-(instancetype)initWithTitle:(NSString *)title
               updateContent:(NSString *)message
                    delegate:(id)delegate;
/**
 *  显示alertView
 */
- (void)show;

@end
