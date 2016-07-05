//
//  ZDHClassifyScrollView.h
//  
//
//  Created by apple on 16/3/28.
//
//

#import <UIKit/UIKit.h>
@class ZDHSearchViewControllerViewModel;

@interface ZDHClassifyScrollView : UIScrollView

/**
 *  
 *
 *  @param SectionArray 组头模型
 *  @param cellArray    cell模型数组
 *  @param vcModel      ViewModel
 */
- (void) reloadSectionCellWithSectionArray:(NSMutableArray *)SectionArray cellArray:(NSMutableArray *)cellArray withVCModel:(ZDHSearchViewControllerViewModel *)vcModel;

@end
