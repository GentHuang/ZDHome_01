//
//  ZDHDIYDetailViewController.m
//  ZhiDa_Home
//
//  Created by 曾梓麟 on 15/8/22.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Controllers
#import "ZDHDIYDetailViewController.h"
#import "ZDHProductDetailViewController.h"
//Views
#import "ZDHDIYDetailBottomLeftView.h"
#import "ZDHDIYBottomRightView.h"
//ViewsModel
#import "ZDHDIYDetailViewControllerViewModel.h"
//Libs
#import "Masonry.h"
//Model
#import "ZDHDIYDetailViewControllerChangeListDiyProbytypeListModel.h"
#import "ZDHDIYDetailViewControllerDiyDetailDiyproListModel.h"
#import "ZDHNetworkManager.h"
//Macros
#define kRightButtonWidth 0//46
#define kBottomViewHeight 162
#define kChangeImageViewTag 30000
#define kInitChangeImageViewTag 40000

@interface ZDHDIYDetailViewController ()<UIAlertViewDelegate>
@property (assign, nonatomic) int lastUpIndex;
@property (assign, nonatomic) NSInteger lastTypeIndex;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) ZDHDIYDetailBottomLeftView *bottomLeftView;
@property (strong, nonatomic) ZDHDIYBottomRightView *bottomRightView;
@property (strong, nonatomic) ZDHDIYDetailViewControllerViewModel *vcViewModel;
@property (strong, nonatomic) UIView *progressBackView;
@property (strong, nonatomic) MBProgressHUD *progressView;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *changeImageView;

@property (strong, nonatomic) NSMutableArray *backup;
@property (strong, nonatomic) NSMutableArray *urlArray;
@property (assign, nonatomic) NSInteger isSameIndex;
//产品清单对应的ID
@property (assign, nonatomic) NSMutableArray *dataProductArray;

// 是否移除默认组合
@property (assign, nonatomic) BOOL isLoad;

@end

@implementation ZDHDIYDetailViewController
- (NSMutableArray*)backup {
    if (!_backup) {
        _backup = [NSMutableArray array];
    }
    return _backup;
}

- (NSMutableArray *)urlArray{
    
    if (!_urlArray) {
        _urlArray = [NSMutableArray array];
    }
    return _urlArray;
}
- (NSMutableArray*)dataProductArray {
    if (!_dataProductArray) {
        _dataProductArray = [NSMutableArray array];
    }
    return _dataProductArray;
}
#pragma mark - Init methods
- (void)initData{
    //vcViewModel
    _vcViewModel = [[ZDHDIYDetailViewControllerViewModel alloc] init];
    _isLoad = NO;
}
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createUI];
    [self setSubViewLayout];
    [self getData];
    [self addObserver];
    [self startDownload];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBar];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)dealloc{
    
    [_bottomLeftView removeObserver:self forKeyPath:@"selectedIndex"];
    [_bottomRightView removeObserver:self forKeyPath:@"upSelectedIndex"];
    [_bottomRightView removeObserver:self forKeyPath:@"downSelectedIndex"];
    [_bottomRightView removeObserver:self forKeyPath:@"typeSelectedIndex"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Getters and setters
- (void)createUI{
    _lastUpIndex = 0;
    _lastTypeIndex = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WHITE;
    //左边后退按钮
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.backgroundColor = [UIColor blackColor];
    [_rightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setImage:[UIImage imageNamed:@"DIY_img_back"] forState:UIControlStateNormal];
    [_rightButton setImageEdgeInsets:UIEdgeInsetsMake(150, 0, 140, 0)];
    [self.view addSubview:_rightButton];
    //背景大图
    _backgroundImageView = [[UIImageView alloc] init];
    [self.view addSubview:_backgroundImageView];
    //零点图
//    _changeImageView = [[UIImageView alloc] init];
//    [self.view addSubview:_changeImageView];
    //左下图
    _bottomLeftView = [[ZDHDIYDetailBottomLeftView alloc] init];
    [self.view addSubview:_bottomLeftView];
    //右下图
    _bottomRightView = [[ZDHDIYBottomRightView alloc] init];
    [_bottomRightView setBottomRightViewMode:kUpMode];
    [self.view addSubview:_bottomRightView];
    //开始加载
    _progressBackView = [[UIView alloc] init];
    _progressBackView.hidden = YES;
    _progressBackView.backgroundColor = WHITE;
    [self.view addSubview:_progressBackView];
    //开始加载
    _progressView = [[MBProgressHUD alloc] initWithView:_progressBackView];
    [_progressView show:NO];
    [_progressBackView addSubview:_progressView];
    [super createSuperUI];
}
- (void)setSubViewLayout{
    [super setSuperSubViewLayout];
    //左边后退按钮
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@NAV_HEIGHT);
        make.bottom.equalTo(0);
        make.left.equalTo(0);
        make.width.equalTo(@kRightButtonWidth);
    }];
    //左下图
    [_bottomLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(0);
        make.left.equalTo(_rightButton.mas_right);
    }];
    //右下图
    [_bottomRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_bottomLeftView.mas_top);
        make.left.equalTo(_bottomLeftView.mas_right);
        make.bottom.and.right.equalTo(0);
    }];
    //背景大图
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightButton.mas_top);
        make.left.equalTo(_rightButton.mas_right);
        make.right.equalTo(0);
        make.bottom.equalTo(_bottomLeftView.mas_top);
    }];
    //零点图
//    [_changeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_rightButton.mas_top);
//        make.left.equalTo(_rightButton.mas_right);
//        make.right.equalTo(0);
//        make.bottom.equalTo(_bottomLeftView.mas_top);
//    }];
    //开始加载
    [_progressBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_rightButton.mas_right);
        make.top.bottom.right.mas_equalTo(0);
    }];
    //开始加载
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_progressBackView);
    }];
}
- (void)setNavigationBar{
    [self.currNavigationController setNavigationBarMode:kNavigationBarDIYMode];
    [self.currNavigationController setDetailTitleLabelWithString:_DIYNaviTitle];
    [self.appDelegate.tabBarVC hideTabBar];
}
#pragma mark - Event response
//点击左边后退按钮
- (void)rightButtonPressed:(UIButton *)button{
    
    [self.currNavigationController popViewControllerAnimated:YES];
}
//添加观察者
- (void)addObserver{
    //选择产品清单或者产品类型
    [_bottomLeftView addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
    //点击替换类型，产品清单中的产品列表
    [_bottomRightView addObserver:self forKeyPath:@"typeSelectedIndex" options:NSKeyValueObservingOptionNew context:nil];
    //产品清单
    [_bottomRightView addObserver:self forKeyPath:@"upSelectedIndex" options:NSKeyValueObservingOptionNew context:nil];
    //产品替换
    [_bottomRightView addObserver:self forKeyPath:@"downSelectedIndex" options:NSKeyValueObservingOptionNew context:nil];
    
}
//观察反馈
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == _bottomLeftView) {
        
        //选择产品清单或者产品类型的按钮View
        int selectedIndex = [[change valueForKey:@"new"]intValue];
        switch (selectedIndex) {
            case 0:
                [_bottomRightView setBottomRightViewMode:kDownMode];
                break;
            case 1:
                [_bottomRightView setBottomRightViewMode:kUpMode];
                break;
            default:
                break;
        }
    }else if([keyPath isEqualToString:@"upSelectedIndex"]){
        
        //产品清单
        _lastUpIndex = [[change valueForKey:@"new"]intValue];
        ZDHProductDetailViewController *detailVC = [[ZDHProductDetailViewController alloc] init];
        detailVC.currNavigationController = self.currNavigationController;
        detailVC.appDelegate = self.appDelegate;
        
//        detailVC.pid = _vcViewModel.dataProIDArray[_lastUpIndex];
        detailVC.pid = _dataProductArray[_lastUpIndex];
        
        [self.currNavigationController pushViewController:detailVC animated:YES];
        
    }else if([keyPath isEqualToString:@"typeSelectedIndex"]){
        
        //点击替换类型，获取产品搭配小图列表
        _lastTypeIndex = [[change valueForKey:@"new"]intValue];
        //先寻找protype
        NSString *protype = _vcViewModel.dataTypeIDArray[_lastTypeIndex];
        //加载替换图片和标题
        [_vcViewModel getDataWithProType:protype changeArray:_vcViewModel.dataChangeArray];
       
        [_bottomRightView reloadDownRightScrollViewWithImageArray:_vcViewModel.dataChangeImageArray titleArray:_vcViewModel.dataChangeTitleArray];
    }else if([keyPath isEqualToString:@"downSelectedIndex"]){
        
        
        int selectedIndex = [[change valueForKey:@"new"]intValue];
        //场景搭配产品图片替换，从小图列表中获取某一个图片，提换大图中某一个image
        [self createChangeImageViewWithPID:[_vcViewModel.dataChangeIDArray objectAtIndex:selectedIndex] typeIndex:_lastTypeIndex olddiyproid:_vcViewModel.olddiyproid];
        
        // 替换场景清单中某一个小图
        [_vcViewModel.dataProImageArray replaceObjectAtIndex:_lastTypeIndex withObject:_vcViewModel.dataChangeImageArray[selectedIndex]];
        [self.bottomRightView reloadUpScrollViewWithArray:_vcViewModel.dataProImageArray StringArray:_vcViewModel.dataProTitleArray index:selectedIndex];//之前的_lastTypeIndex
        
        //替换对应的ID
        if (_vcViewModel.dataEveryImageIDArray.count>0) {
            [_dataProductArray replaceObjectAtIndex:_lastTypeIndex withObject:_vcViewModel.dataEveryImageIDArray[selectedIndex]];
        }
    }
}
#pragma mark - Network request
//获取数据
- (void)getData{

    __block ZDHDIYDetailViewControllerViewModel *selfViewModel = _vcViewModel;
    __block ZDHDIYDetailViewController *selfVC = self;
    __block int index = 0;
    //http://183.238.196.216:8088/diy.ashx?m=diy_detail&id=13
    [_vcViewModel getDataWithID:_ID success:^(NSMutableArray *resultArray) {
        //刷新背景大图
        [selfVC.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:TESTIMGEURL,selfViewModel.backgroundImageString]]];
        //刷新场景清单小图列表
        [selfVC.bottomRightView reloadUpScrollViewWithArray:selfViewModel.dataProImageArray StringArray:selfViewModel.dataProTitleArray index:_lastUpIndex];
        //刷新产品替换
        [selfVC.bottomRightView reloadDownLeftScrollViewWithArray:selfViewModel.dataTypeTitleArray];
        //赋值数据
        selfVC.dataProductArray =  selfViewModel.dataProIDArray;
        // 加载默认组合数据
        for (NSInteger i = 0; i < selfViewModel.dataTypeIDArray.count; i ++) {
            for (NSInteger j = 0; j < selfViewModel.dataDiyproArray.count; j ++) {
                ZDHDIYDetailViewControllerDiyDetailDiyproListModel *diyproModel = selfViewModel.dataDiyproArray[j];
                if ([diyproModel.ProType isEqualToString:selfViewModel.dataTypeIDArray[i]]) {
                    [self diyImageGrupWithUrl:diyproModel.AppImg withIndex:i];
                }
            }
        }
        //获取所有替换小图http://183.238.196.216:8088/diy.ashx?m=diy_diyprobytype&id=13&protype=101001002
        [selfViewModel getDataWIthTypeIDArray:selfViewModel.dataTypeIDArray ID:selfVC.ID success:^(NSMutableArray *resultArray) {
            //获取成功
            //默认加载第一个
            //先寻找protype
            NSString *protype1 =_vcViewModel.dataTypeIDArray[0];
           //加载替换图片和标题
            [selfViewModel getDataWithProType:protype1 changeArray:selfViewModel.dataChangeArray];
           // 刷新scrollView
            [selfVC.bottomRightView reloadDownRightScrollViewWithImageArray:selfViewModel.dataChangeImageArray titleArray:selfViewModel.dataChangeTitleArray];
            NSArray *imageIDArray = [[[selfViewModel.olddiyproid componentsSeparatedByString:@"|"] reverseObjectEnumerator]allObjects];
            if (selfViewModel.dataTypeIDArray.count > 0) {
                
                index ++;
            }
             if (index == imageIDArray.count) {
                 [selfVC stopDownload];
             }
            } fail:^(NSError *error) {
            //获取失败
        }];
    } fail:^(NSError *error) {
        
        //获取失败
        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络开小差" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alView show];
    }];
}
// 加载组合图片
- (void) diyImageGrupWithUrl:(NSString *)url withIndex:(NSInteger)typeIndex{
    
        [self createChangeImage:typeIndex];
        [self.backup addObject:[NSString stringWithFormat:@"%zd",typeIndex]];
        [_changeImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:TESTIMGEURL,url]]];
}

//获取覆盖在背景图上面的产品替换图
- (void)createChangeImageViewWithPID:(NSString *)PID typeIndex:(NSInteger)typeIndex olddiyproid:(NSString *)olddiyproid{
    
    __block ZDHDIYDetailViewControllerViewModel *selfViewModel = _vcViewModel;
    __block ZDHDIYDetailViewController *selfVC = self;
    __block BOOL isExist = YES;
    [_vcViewModel getDataWithPID:PID typeIndex:_lastTypeIndex olddiyproid:selfViewModel.olddiyproid success:^(NSMutableArray *resultArray) {
        //获取成功
        [selfVC stopDownload];
        isExist = [_backup containsObject:[NSString stringWithFormat:@"%zd",typeIndex]];
        
        if (isExist==NO) {
            [self createChangeImage:typeIndex];
            [selfVC.backup addObject:[NSString stringWithFormat:@"%zd",typeIndex]];
            [_changeImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:TESTIMGEURL,selfViewModel.dataUpImageArray[0]]]];
        }
        // 淡入淡出
        _changeImageView = (UIImageView*)[selfVC.view viewWithTag:kChangeImageViewTag+typeIndex];
        _changeImageView.alpha = 1.0;
        [UIView animateWithDuration:0.7f animations:^{
            
               _changeImageView.alpha = 0;
        } completion:^(BOOL isSuccess){
            
            _changeImageView.alpha = 0;
            [_changeImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:TESTIMGEURL,[selfViewModel.dataUpImageArray firstObject]]]];
            [UIView animateWithDuration:1.5f animations:^{
                
                _changeImageView.alpha = 1.0;
            } completion:^(BOOL isSuccess){
                
                _changeImageView.alpha = 1.0;
            }];
        }];
        
    } fail:^(NSError *error) {
        //获取失败
    }];
}

#pragma mark - Protocol methods
//UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Other methods
//开始加载
- (void)startDownload{
    _progressBackView.hidden = NO;
    [_progressView show:YES];
}
//停止加载
- (void)stopDownload{
    _progressBackView.hidden = YES;
    [_progressView show:NO];
}
- (void)createChangeImage:(NSInteger)typeIndex {
        //零点图
        _changeImageView = [[UIImageView alloc] init];
        [self.view addSubview:_changeImageView];
        _changeImageView.tag = kChangeImageViewTag+typeIndex;
        [_changeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_rightButton.mas_top);
            make.left.equalTo(_rightButton.mas_right);
            make.right.equalTo(0);
            make.bottom.equalTo(_bottomLeftView.mas_top);
        }];
}

@end
