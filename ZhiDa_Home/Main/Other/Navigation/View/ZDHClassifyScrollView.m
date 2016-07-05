//
//  ZDHClassifyScrollView.m
//  
//
//  Created by apple on 16/3/28.
//
//

#import "ZDHClassifyScrollView.h"
#import "Masonry.h"
#import "ZDHNaviClassifyView.h"
#import "ZDHSearchViewControllerNewListProtypelistChindtypeChindtypeModel.h"
#import "ZDHSearchViewControllerNewListProtypelistChindtypeModel.h"

@interface ZDHClassifyScrollView()

@property (strong, nonatomic) UIView *contentView;
//@property (strong, nonatomic) ZDHNaviClassifyView *classifyView;

@end
@implementation ZDHClassifyScrollView
- (void) initData{
    
    
}
-(instancetype)init{
    if (self = [super init]) {
        [self initData];
        [self createAutolayout];
    }
    return self;
}

- (void)createUI{
    
    
}
- (void) createAutolayout{
    
    
    [self mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.edges.equalTo(self);
    }];
}
/**
 *  <#Description#>
 *
 *  @param SectionArray 组头模型
 *  @param cellArray    cell模型数组
 *  @param vcModel      ViewModel
 */
- (void) reloadSectionCellWithSectionArray:(NSMutableArray *)SectionArray cellArray:(NSMutableArray *)cellArray withVCModel:(ZDHSearchViewControllerViewModel *)vcModel {
    
    ZDHNaviClassifyView *lastClassifyView = nil;
    
    for (NSInteger i = 0; i < SectionArray.count; i ++) {
        
        ZDHNaviClassifyView *classifyView = [[ZDHNaviClassifyView alloc]init];
        [self addSubview:classifyView];
        [classifyView mas_makeConstraints:^(MASConstraintMaker *make){
        
            make.left.right.equalTo(self).offset(0);
            make.top.equalTo(lastClassifyView?lastClassifyView.mas_bottom:self.mas_top).offset(lastClassifyView?-3:0);
            make.width.mas_equalTo(334);
        }];
        lastClassifyView = classifyView;
        ZDHSearchViewControllerNewListProtypelistChindtypeModel *listChindTypeModel = SectionArray[i];
        [classifyView reflashSectionImageTitle:listChindTypeModel];
        [classifyView loadSelectedButtonWithArray:cellArray[i] sectionIndex:i withViewModel:vcModel];
    }
    
    [self mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.bottom.equalTo(lastClassifyView.mas_bottom).offset(0);
    }];
}

@end
