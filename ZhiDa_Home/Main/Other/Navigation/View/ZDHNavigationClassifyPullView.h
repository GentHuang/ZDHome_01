//
//  ZDHNavigationClassifyPullView.h
//  
//
//  Created by apple on 16/3/23.
//
//

#import <UIKit/UIKit.h>

@interface ZDHNavigationClassifyPullView : UIView

@property (strong, nonatomic) UIView *bar;
// 网络请求
- (void)getListData;
@end
