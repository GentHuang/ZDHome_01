//
//  ZDHNavigationClassifyPullView.m
//  
//
//  Created by apple on 16/3/23.
//
//

#import "ZDHNavigationClassifyPullView.h"
#import "Masonry.h"
// view
#import "ZDHNavClassifyScrollerContainView.h"
// viewmodel
#import "ZDHSearchViewControllerViewModel.h"
// model
#import "ZDHSearchViewControllerNewListProtypelistModel.h"
#import "ZDHSearchViewControllerNewListProtypelistChindtypeModel.h"
#import "ZDHSearchViewControllerNewListProtypelistChindtypeChindtypeModel.h"

#define PULLVIEWNAV_HEIGHT    70
#define kTableViewTag   30000
#define kScanButtonTag  20000

@interface ZDHNavigationClassifyPullView()<UITextFieldDelegate,UIAlertViewDelegate>

// 收起VivewButton
@property (strong , nonatomic) UIButton *packUPViewButton;
// 搜索框
@property (strong, nonatomic) UITextField *pullViewSearchTextField;
// 放大镜
@property (strong, nonatomic) UIImageView *pullSearchImageView;
// 二维码扫描按钮
@property (strong, nonatomic) UIButton *searchViewScanButton;
// 数据模型
@property (strong, nonatomic) ZDHSearchViewControllerViewModel *vcViewModel;
// 弹出键盘后的view
@property (strong, nonatomic) UIView *backGroundView;
// 取消编辑
@property (strong, nonatomic) UIButton *cancelButton;

@end

@implementation ZDHNavigationClassifyPullView

// 获取数据
- (void) initData{
   
    _vcViewModel = [[ZDHSearchViewControllerViewModel alloc]init];
    [self getListData];
}

- (instancetype) init{
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
        [self createAutolayout];
        [self initData];
    }
    return self;
}

- (void) createUI{
    
    //NavigationBar
    _bar = [[UIView alloc] init];
    _bar.backgroundColor = GRAY;
    [self addSubview:_bar];
    //背景
    UIView *blackView = [[UIView alloc] init];
    blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
    [self addSubview:blackView];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(0);
        make.width.equalTo(@SCREEN_MAX_WIDTH);
        make.height.equalTo(@STA_HEIGHT);
    }];
  
    //放大镜
    UIImage *searchImage = [UIImage imageNamed:@"nav_search"];
    _pullSearchImageView = [[UIImageView alloc] initWithImage:searchImage];
    [_bar addSubview:_pullSearchImageView];
        //搜索条
    _pullViewSearchTextField = [[UITextField alloc] init];
    _pullViewSearchTextField.backgroundColor = WHITE;
    _pullViewSearchTextField.placeholder = @"产品查找";
    _pullViewSearchTextField.delegate = self;
    _pullViewSearchTextField.returnKeyType = UIReturnKeySearch;
    [_bar addSubview:_pullViewSearchTextField];
    [_pullViewSearchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bar.mas_centerY);
        make.centerX.equalTo(_bar.mas_centerX);
        make.height.equalTo(searchImage.size.height);
        make.width.equalTo(250);
    }];
    
    [_pullSearchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(searchImage.size);
        make.centerY.equalTo(_bar.mas_centerY);
        make.right.equalTo(_pullViewSearchTextField.mas_left).offset(0);
    }];
    
    // 收起按钮
    _packUPViewButton = [[UIButton alloc]init];
    _packUPViewButton.tag = kScanButtonTag + 1;
    [_packUPViewButton setImage:[UIImage imageNamed:@"nav_pull_cancel"] forState:0];
    [_packUPViewButton setTitleColor:[UIColor blackColor] forState:0];
    [_packUPViewButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_packUPViewButton];
    
    //搜索的二维码
    _searchViewScanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchViewScanButton setImage:[UIImage imageNamed:@"nav_scan"] forState:UIControlStateNormal];
    _searchViewScanButton.tag = kScanButtonTag + 2;
    [_searchViewScanButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_bar addSubview:_searchViewScanButton];
    [_searchViewScanButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.equalTo([UIImage imageNamed:@"nav_scan"].size);
        make.height.equalTo([UIImage imageNamed:@"nav_scan"].size.height);
        make.width.mas_equalTo(50);
        make.left.equalTo(_pullViewSearchTextField.mas_right).with.offset(@27);
        make.centerY.equalTo(_bar.mas_centerY);
    }];
    // 取消按钮
    _cancelButton = [[UIButton alloc]init];
    [_cancelButton setTitle:@"取消" forState:0];
    _cancelButton.tag = kScanButtonTag + 3;
    [_cancelButton setTitleColor:[UIColor blackColor] forState:0];
    _cancelButton.hidden = YES;
    [_cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bar addSubview:_cancelButton];
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.left.equalTo(_pullViewSearchTextField.mas_right).with.offset(@27);
        make.centerY.equalTo(_bar.mas_centerY);
    }];
}

- (void) createAutolayout{
    
    [_bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(STA_HEIGHT);
        make.left.equalTo(0);
        make.width.equalTo(@SCREEN_MAX_WIDTH);
        make.height.equalTo(@(PULLVIEWNAV_HEIGHT));
    }];
    
    [_packUPViewButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_bar.mas_left).offset(5);
        make.width.height.mas_equalTo(60);
        make.centerY.equalTo(_bar.mas_centerY);
    }];
}
// 获取到数据以后创建
- (void) createTableView{
    
    // 创建分类列表
    ZDHNavClassifyScrollerContainView *lastScrollContainView = nil;
    for (NSInteger i = 0; i < 3; i ++) {
        
        ZDHNavClassifyScrollerContainView *scrollContainView = [[ZDHNavClassifyScrollerContainView alloc]init];
        scrollContainView.layer.borderWidth = 0.8;
        scrollContainView.layer.borderColor = GRAY.CGColor;
        scrollContainView.tag = kTableViewTag + i;
        [self addSubview:scrollContainView];
        [scrollContainView reflashContentesView:_vcViewModel.dataProdutArray[i] withViewModel:_vcViewModel];
        
        [scrollContainView mas_makeConstraints:^(MASConstraintMaker *make){
        
            make.top.equalTo(_bar.mas_bottom).offset(0);
            make.width.mas_equalTo(334);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.left.equalTo(lastScrollContainView?lastScrollContainView.mas_right:self.mas_left).offset(lastScrollContainView?11:0);
        }];
        lastScrollContainView = scrollContainView;
    }
}
#define NetWorkRequest
//获取搜索列表信息
- (void)getListData{
    __block ZDHSearchViewControllerViewModel *selfViewModel = _vcViewModel;
    __block ZDHNavigationClassifyPullView *pullView = self;
    //获取产品分类
    [_vcViewModel getSearchListSuccess:^(NSMutableArray *resultArray) {
        //获取商品分类
        [selfViewModel getSearchPruductCategorySuccess:^(NSMutableArray *resultArray) {
            //获取成功
            [pullView createTableView];
        } fail:^(NSError *error) {
            
        }];
    } fail:^(NSError *error) {
        
        //获取失败
        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络开小差" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alView show];
       
    }];
}
#define mark event
- (void)buttonClick:(UIButton *)btn{
    // 收起下拉
    if (btn.tag == kScanButtonTag + 1) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"packUpViewButtonClick" object:nil];
    }
    // 扫描二维码前，收起下拉
    else if(btn.tag == kScanButtonTag + 2){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"packUpViewButtonClick" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TwoDimensionCode" object:self userInfo:nil];
    }
    // 取消编辑
    else if (btn.tag == kScanButtonTag + 3){
        
        [self.backGroundView removeFromSuperview];
        [_pullViewSearchTextField mas_updateConstraints:^(MASConstraintMaker *make){
            
            make.width.mas_equalTo(250);
        }];
        _cancelButton.hidden = YES;
        _searchViewScanButton.hidden = NO;
        _packUPViewButton.hidden = NO;
        [self.backGroundView removeFromSuperview];
        [_pullViewSearchTextField resignFirstResponder];
    }
}

#define UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UIAlertView" object:nil];
}
#define  UITexfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _pullViewSearchTextField) {
        
        [self endUseUITexfiledModel];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"packUpViewButtonClick" object:nil];
        if (_vcViewModel.dataProdutArray > 0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"关键字" object:self userInfo:@{@"keyword":textField.text,@"dataProdutArray":_vcViewModel.dataProdutArray,@"dataListArray":_vcViewModel.dataListArray}];
        }
    }
    return YES;
}
- (void) textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _pullViewSearchTextField) {
        
        [self useUITexfiledModel];
    }
}
- (void) backgroundTap:(UITapGestureRecognizer *)tap{
    
    [self endUseUITexfiledModel];
}

// 使用输入框
- (void) useUITexfiledModel{
    
    _backGroundView = [[UIView alloc]init];
    _backGroundView.alpha = 0.7;
    _backGroundView.backgroundColor = [UIColor blackColor];
    [self addSubview:_backGroundView];
    [_backGroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)]];
    [_backGroundView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.right.bottom.equalTo(self).offset(0);
        make.top.equalTo(_bar.mas_bottom).offset(0);
    }];
    
    // 更新texfild
    [_pullViewSearchTextField mas_updateConstraints:^(MASConstraintMaker *make){
        
        make.width.mas_equalTo(400);
        
    }];
    _cancelButton.hidden = NO;
    _searchViewScanButton.hidden = YES;
    _packUPViewButton.hidden = YES;
}
// 搜索框输入完成
- (void) endUseUITexfiledModel{
    
    _cancelButton.hidden = YES;
    _searchViewScanButton.hidden = NO;
    _packUPViewButton.hidden = NO;
    [self.backGroundView removeFromSuperview];
    [_pullViewSearchTextField mas_updateConstraints:^(MASConstraintMaker *make){
        
        make.width.mas_equalTo(250);
    }];
    [_pullViewSearchTextField resignFirstResponder];
}

@end
















