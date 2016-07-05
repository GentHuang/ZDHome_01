//
//  ZDHClothesTopView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//View
#import "ZDHClothesTopView.h"
#import "ZDHCommonButton.h"
//Lib
#import "Masonry.h"
//Macro
#define kLabelTag 31000
#define kTopScrollViewHeight 45
#define kTitleButtonWidth 100
#define kTitleButtonTag 3200
@interface ZDHClothesTopView()<UITextFieldDelegate>
@property (assign, nonatomic) int selectedIndex;
@property (strong, nonatomic) UIImageView *searchImageView;
@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *searchBackView;
@property (assign, nonatomic) int buttonCount;
// 布列表标题背景
@property (strong, nonatomic) UIView *labelBackgroundView;
// 布列表标题
@property (strong, nonatomic) UILabel *clothLabel;

//临时数据
@property (strong, nonatomic) NSArray *array;
@end

@implementation ZDHClothesTopView
#pragma mark - Init methods
- (void)initData{
    _buttonCount = 0;
    _array = @[@"镭射",@"色织",@"染色",@"绣花",@"绒布",@"印花",@"数码印花",@"数码印花",@"数码印花",@"数码印花"];
}
-(instancetype)init{
    if (self = [super init]) {
        [self initData];
        [self createUI];
        [self setSubViewLayout];
        //        [self reloadScrollViewWithArray:_array];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    self.backgroundColor = LIGHTGRAY;
    //searchBackView
    _searchBackView = [[UIView alloc] init];
    _searchBackView.backgroundColor = CLEAR;
    _searchBackView.layer.borderColor = [[UIColor colorWithRed:153/256.0 green:153/256.0 blue:153/256.0 alpha:1] CGColor];
    _searchBackView.layer.borderWidth = 1;
    [self addSubview:_searchBackView];
    //放大镜
    UIImage *searchImage = [UIImage imageNamed:@"nav_search"];
    _searchImageView = [[UIImageView alloc] initWithImage:searchImage];
    _searchImageView.userInteractionEnabled  = YES;
    [self addSubview:_searchImageView];
    //添加手势点击搜索
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchKeyWork)];
    [_searchImageView addGestureRecognizer:tap];
    
    [_searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(searchImage.size);
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(@19);
    }];
    //搜索条
    _searchTextField = [[UITextField alloc] init];
    _searchTextField.delegate = self;
    _searchTextField.backgroundColor = WHITE;
    _searchTextField.placeholder = @"搜索：布的编码";
    _searchTextField.returnKeyType = UIReturnKeySearch;
    [self addSubview:_searchTextField];
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(_searchImageView.mas_right);
        make.height.equalTo(searchImage.size.height);
        make.width.equalTo(154);
    }];
    //ScrollView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    //ContentView
    _contentView = [[UIView alloc] init];
    [_scrollView addSubview:_contentView];
    
    // 布列表标题背景
    _labelBackgroundView = [[UIView alloc]init];
    _labelBackgroundView.hidden = YES;
    [self addSubview:_labelBackgroundView];
    
    _clothLabel = [[UILabel alloc]init];
    _clothLabel.textColor = [UIColor blackColor];
    _clothLabel.textAlignment = NSTextAlignmentCenter;
    _clothLabel.font = [UIFont systemFontOfSize:24.0f];
    [self.labelBackgroundView addSubview:_clothLabel];
    
}
- (void)setSubViewLayout{
    //searchBackView
    [_searchBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchTextField.mas_top).with.offset(-1);
        make.right.equalTo(_searchTextField.mas_right).with.offset(1);
        make.bottom.equalTo(_searchTextField.mas_bottom).with.offset(1);
        make.left.equalTo(_searchImageView.mas_left).with.offset(-1);
    }];
    
    //ScrollView
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.right.equalTo(0);
        make.left.equalTo(_searchTextField.mas_right);
    }];
    //ContentView
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.height.equalTo(_scrollView);
    }];
    
    [_labelBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.right.equalTo(0);
        make.left.equalTo(_searchTextField.mas_right);
    }];
    
    [_clothLabel mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.height.equalTo(_labelBackgroundView);
        make.centerY.equalTo(_labelBackgroundView.mas_centerY);
        make.left.equalTo(_labelBackgroundView.mas_left).offset(200);
    }];
}
#pragma mark - Event response
//收起键盘
- (void)packUpKeyboard{
    [_searchTextField resignFirstResponder];
}
//手势点击标题
- (void)labelTapPressed:(UITapGestureRecognizer *)tap{
    
    UILabel *label = (UILabel *)[tap view];
    self.selectedIndex = (int)(label.tag - kLabelTag);
}
#pragma mark - Network request
#pragma mark - Protocol methods
//UITextFieldDelegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _searchTextField) {
        
        NSString *keyWord = [textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"搜索布料" object:self userInfo:@{@"keyword":keyWord}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"回退到布料列表" object:self userInfo:nil];
        [textField resignFirstResponder];
    }
    return YES;
}
//点击搜索按钮 搜索
- (void)searchKeyWork{
    if ( _searchTextField.text.length>0) {
        NSString *keyWord = [_searchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"搜索布料" object:self userInfo:@{@"keyword":keyWord}];
    }
}

#pragma mark - Other methods
//数据刷新
- (void)reloadScrollViewWithArray:(NSArray *)array{
    //先清除旧数据
    [self deleteSubView:_contentView];
    UIView *lastView;
    for (int i = 0; i < array.count; i ++) {
        
        //背景
        UIView *backView = [[UIView alloc] init];
        [_contentView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(0);
            make.width.equalTo(100);
            make.left.equalTo(@(i*100));
        }];
        //分隔线
        UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_img_line"]];
        [backView addSubview:lineImageView];
        [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.height.equalTo(backView);
            make.width.equalTo(2);
            make.top.equalTo(0);
        }];
        //标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.userInteractionEnabled = YES;
        titleLabel.text = array[i];
        titleLabel.tag = i + kLabelTag;
        titleLabel.font = FONTSIZES(17);
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapPressed:)];
        [titleLabel addGestureRecognizer:tap];
        [backView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.bottom.equalTo(0);
            make.right.equalTo(lineImageView.mas_left);
        }];
        lastView = backView;
    }
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView.mas_right);
    }];
}
//清除旧数据
- (void)deleteSubView:(UIView *)view{
    for (UIView *subView in [view subviews]) {
        [subView removeFromSuperview];
    }
}

/*******************************button********************************************/

#define mark eventResponse
- (void) buttonClik:(ZDHCommonButton *)commonButton{
    for (int i = 0; i < _buttonCount; i ++) {
        
        ZDHCommonButton *tmpButton = (ZDHCommonButton *)[self viewWithTag:i+kTitleButtonTag];
        [tmpButton setIsSelected:NO];
    }
    [commonButton setIsSelected:YES];
    self.selectedIndex = (int)(commonButton.tag - kTitleButtonTag);
}
//根据index 选择按钮
- (void)selectWithIndex:(NSInteger)index {
    for (int i = 0; i < _buttonCount; i ++) {
        
        ZDHCommonButton *tmpButton = (ZDHCommonButton *)[self viewWithTag:i+kTitleButtonTag];
        [tmpButton setIsSelected:NO];
    }
    ZDHCommonButton *tmpButton = (ZDHCommonButton *)[self viewWithTag:index+kTitleButtonTag];
    [tmpButton setIsSelected:YES];
    
}
- (void) reloadScrollViewWithButtonArray:(NSArray *)array{
    //先清除旧数据
    //    [self deleteSubView:_contentView];
    [self deleteSubView];
    _buttonCount = (int)array.count;
    UIView *lastView;
    for (int i = 0; i < array.count; i ++) {
        //背景
        ZDHCommonButton *backView = [[ZDHCommonButton alloc] init];
        [backView setButtonWithTitleName:array[i]];
        if (i == 0) {
            
            [backView setIsSelected:YES];
        }else{
            
            [backView setIsSelected:NO];
        }
        [_contentView addSubview:backView];
        [backView setTag:i+kTitleButtonTag];
        [backView addTarget:self action:@selector(buttonClik:) forControlEvents:UIControlEventTouchUpInside];
        
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(0);
            make.width.equalTo(100);
            make.left.equalTo(@(i*100));
        }];
        //分隔线
        UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_img_line"]];
        [backView addSubview:lineImageView];
        [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.height.equalTo(backView);
            make.width.equalTo(2);
            make.top.equalTo(0);
        }];
        lastView = backView;
    }
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView.mas_right);
    }];
    
}
// 使用button
/*
- (void) reloadScrollViewWithButtonArray:(NSArray *)array{
    
    //清除旧数据
    [self deleteSubView];
    if (array.count > 0) {
        
        ZDHCommonButton *lastButton = nil;
        _buttonCount += array.count;
        for (int i = 0; i < array.count; i ++) {
            
            ZDHCommonButton *commonButton = [[ZDHCommonButton alloc] init];
            [commonButton setButtonWithTitleName:array[i]];
            if (i == 0) {
                
                [commonButton setIsSelected:YES];
            }else{
                
                [commonButton setIsSelected:NO];
            }
            [commonButton setTag:i+kTitleButtonTag];
            [commonButton addTarget:self action:@selector(buttonClik:) forControlEvents:UIControlEventTouchUpInside];
            
            [_contentView addSubview:commonButton];
            
            //分隔线
            UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_img_line"]];
            [_contentView addSubview:lineImageView];
            
            [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                //                make.right.equalTo(0);
                make.height.equalTo(self.contentView.mas_height);
                make.left.equalTo(lastButton?lastButton.mas_right:_searchTextField.mas_right).offset(0);
                make.width.equalTo(2);
                make.top.equalTo(0);
            }];
            
            [commonButton mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(0);
                make.left.equalTo(lineImageView.mas_right);
                make.width.equalTo(@kTitleButtonWidth);
                make.bottom.equalTo(@0);
            }];
            
            
            lastButton = commonButton;
        }
        
        //分隔线
        UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_img_line"]];
        [_contentView addSubview:lineImageView];
        [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            //                make.right.equalTo(0);
            make.height.equalTo(self.contentView.mas_height);
            make.left.equalTo(lastButton.mas_right).offset(0);
            make.width.equalTo(2);
            make.top.equalTo(0);
        }];
        
        [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(lastButton.mas_right);
            
        }];
    }
}
*/
//清除旧数据
- (void)deleteSubView{
    
    for (UIView *view in [_contentView subviews]) {
        
        [view removeFromSuperview];
    }
}
/***********************************x显示模式*****************************/
// 选择性显示顶部标题或者滚动按钮
- (void) showClothTitleLabelScrollerViewModel:(ZDHClothesTopViewModel)model{
    
    switch (model) {
        case 0:
            [self topViewShowScrollerViewButtonModel];
            break;
        case 1:
            [self topViewShowClothTitleModel];
            break;
            
        default:
            break;
    }
}
// 显示布列的标题
- (void) topViewShowClothTitleModel{
    
    _labelBackgroundView.hidden = NO;
    _clothLabel.hidden = NO;
    _scrollView.hidden = YES;
}
// 显示顶部滚动按钮
- (void) topViewShowScrollerViewButtonModel{
    
    _labelBackgroundView.hidden = YES;
    _clothLabel.hidden = YES;
    _scrollView.hidden = NO;
}
//  刷新标题
- (void) reflashClothTitle:(NSString *) titile{
    _clothLabel.text = titile;
}
//清除搜索文字
- (void)cleanSearchText {
    _searchTextField.text = @"";
}
//是否隐藏searchView
- (void)IshidenSearchView:(BOOL)hidenString{
    _searchTextField.hidden = hidenString;
    _searchBackView.hidden= hidenString;
    _searchImageView.hidden = hidenString;
}


@end
