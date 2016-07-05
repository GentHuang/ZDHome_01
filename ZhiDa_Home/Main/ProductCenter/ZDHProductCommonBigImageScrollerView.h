//
//  ZDHProductCommonBigImageScrollerView.h
//  
//
//  Created by apple on 16/3/21.
//
//

#import <UIKit/UIKit.h>

@interface ZDHProductCommonBigImageScrollerView : UIView


// 刷新图片的数量以及目前的张数
- (void) reflashImagePageWithPage:(NSInteger)index sumPage:(NSInteger)sum;
// 添加图片的滚动
- (void) loadBigImageWithImageArray:(NSArray *) imageArray;
// 根据collectionView改变scrollView当前显示的视图
- (void) loadContentViewWithIndex:(NSInteger)index;
@end
