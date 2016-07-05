//
//  ZDHNavClassifyScrollerContainView.m
//  
//
//  Created by apple on 16/3/28.
//
//

#import "ZDHNavClassifyScrollerContainView.h"
#import "Masonry.h"
// viewmodel
#import "ZDHSearchViewControllerViewModel.h"
// view
#import "ZDHClassifyScrollView.h"
// model
#import "ZDHSearchViewControllerNewListProtypelistModel.h"
#import "ZDHSearchViewControllerNewListProtypelistChindtypeModel.h"
#import "ZDHSearchViewControllerNewListProtypelistChindtypeChindtypeModel.h"
#define kTOPCONTENTSHEIGHT 60

@interface ZDHNavClassifyScrollerContainView()
// 顶部的title、图标以及背景
@property (strong, nonatomic) UIView *topContentsBackGround;
@property (strong, nonatomic) UILabel *topContentsLabel;
@property (strong, nonatomic) UIImageView *topContentsImage;
// 列表
@property (strong, nonatomic) ZDHClassifyScrollView *scrollView;
// 获取二级分类的数组
@property (strong, nonatomic) NSMutableArray *secondClassifyArray;
// 获取第三级分类
@property (strong, nonatomic) NSMutableArray *thirdClassifyArray;

@property (strong, nonatomic) ZDHSearchViewControllerViewModel *viewModel;

@end
@implementation ZDHNavClassifyScrollerContainView
- (void) initData{
    
    _secondClassifyArray = [NSMutableArray array];
    _thirdClassifyArray = [NSMutableArray array];
}

- (instancetype) init{
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initData];
        [self createUI];
        [self createAutolayout];
    }
    return self;
}

- (void) createUI{
    
    _topContentsBackGround = [[UIView alloc]init];
    _topContentsBackGround.backgroundColor = PINKISHRED;
    [self addSubview:_topContentsBackGround];
    
    _topContentsImage = [[UIImageView alloc]init];
    [_topContentsBackGround addSubview:_topContentsImage];
    
    _topContentsLabel                 = [[UILabel alloc] init];
    _topContentsLabel.textColor       = [UIColor whiteColor];
    _topContentsLabel.font            = [UIFont boldSystemFontOfSize:25.0f];
    _topContentsLabel.textAlignment   = NSTextAlignmentLeft;
    [_topContentsBackGround addSubview:_topContentsLabel];
    
    _scrollView = [[ZDHClassifyScrollView alloc]init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
}

- (void) createAutolayout{
    
    [_topContentsBackGround mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.left.right.equalTo(self).offset(0);
        make.height.mas_equalTo(kTOPCONTENTSHEIGHT);
    }];
    
    [_topContentsImage mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.centerY.equalTo(_topContentsBackGround.mas_centerY);
        make.right.equalTo(_topContentsBackGround.mas_centerX).offset(-5);
        make.height.width.mas_equalTo(30);
    }];
    [_topContentsLabel mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.centerY.equalTo(_topContentsBackGround.mas_centerY);
        make.left.equalTo(_topContentsBackGround.mas_centerX).offset(5);
        //        make.height.width.mas_equalTo(35);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.right.bottom.equalTo(self).offset(0);
        make.top.equalTo(_topContentsBackGround.mas_bottom).offset(0);
    }];
}

// 刷新标题
- (void) reflashContentesView:(ZDHSearchViewControllerNewListProtypelistModel *)classifyModel
                withViewModel:(ZDHSearchViewControllerViewModel *)viewModel{
    _viewModel = viewModel;
    // 一级分类，刷新title
    _topContentsLabel.text = classifyModel.typename_conflict;
    [_topContentsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:DESIGNIMGURL,classifyModel.img]] placeholderImage:nil];
    // 二级分类，获取section数据
    for (ZDHSearchViewControllerNewListProtypelistChindtypeModel *chindtypeModel in classifyModel.chindtype) {
        
        [_secondClassifyArray addObject:chindtypeModel];
        NSMutableArray *mutableArray = [NSMutableArray array];
        // 三级分类， 获取cell中的button
        for (ZDHSearchViewControllerNewListProtypelistChindtypeChindtypeModel *chindtypeChindtypeModel in chindtypeModel.chindtype) {
            
            [mutableArray addObject:chindtypeChindtypeModel];
        }
        [_thirdClassifyArray addObject:mutableArray];
    }
    // 获取数据
    [_scrollView reloadSectionCellWithSectionArray:_secondClassifyArray cellArray:_thirdClassifyArray withVCModel:_viewModel];
}

@end
