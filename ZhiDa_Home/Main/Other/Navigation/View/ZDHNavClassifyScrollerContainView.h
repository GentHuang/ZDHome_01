//
//  ZDHNavClassifyScrollerContainView.h
//  
//
//  Created by apple on 16/3/28.
//
//

#import <UIKit/UIKit.h>

@class ZDHSearchViewControllerNewListProtypelistModel;
@class ZDHSearchViewControllerViewModel;
@interface ZDHNavClassifyScrollerContainView : UIView
/**
 *  <#Description#>
 *
 *  @param classifyModel 一级分类模型
 *  @param viewModel     ViewModel
 */
- (void) reflashContentesView:(ZDHSearchViewControllerNewListProtypelistModel *)classifyModel
                withViewModel:(ZDHSearchViewControllerViewModel *)viewModel;

@end
