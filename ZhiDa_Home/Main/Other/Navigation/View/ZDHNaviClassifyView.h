//
//  ZDHNaviClassifyView.h
//  
//
//  Created by apple on 16/3/28.
//
//

#import <UIKit/UIKit.h>
#import "ZDHSearchViewControllerNewListProtypelistChindtypeChindtypeModel.h"
#import "ZDHSearchViewControllerNewListProtypelistChindtypeModel.h"
#import "ZDHSearchViewControllerViewModel.h"

@interface ZDHNaviClassifyView : UIView

- (void) loadSelectedButtonWithArray:(NSMutableArray *)buttonArray sectionIndex:(NSInteger)indexPath withViewModel:(ZDHSearchViewControllerViewModel *)viewModel;
// 跟新组头以及标题
- (void) reflashSectionImageTitle:(ZDHSearchViewControllerNewListProtypelistChindtypeModel *)listChindtypeModel;
@end
