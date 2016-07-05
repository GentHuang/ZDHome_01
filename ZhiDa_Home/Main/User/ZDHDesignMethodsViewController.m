//
//  ZDHDesignMethodsViewController.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Controllers
#import "ZDHDesignMethodsViewController.h"
#import "ZDHUserProductListViewController.h"
//View
#import "ZDHProductCommonTopScrollView.h"
#import "ZDHProductCommonBigImageView.h"
#import "ZDDesignMethodsCollectionView.h"
//Libs
#import "Masonry.h"
//ViewModel
#import "ZDHDesignMethodsViewControllerViewModel.h"
@interface ZDHDesignMethodsViewController ()
@property (assign, nonatomic) int imageIndex;
@property (assign, nonatomic) int topIndex;
@property (strong, nonatomic) ZDHProductCommonTopScrollView *topScrollView;
//@property (strong, nonatomic) ZDHProductCommonBigImageView *bigView;
@property (strong, nonatomic) ZDDesignMethodsCollectionView *bigView;

@property (strong, nonatomic) ZDHDesignMethodsViewControllerViewModel *vcViewModel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *contentTitleLabel;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) UIButton *listButton;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) MBProgressHUD *progressHUB;
@property (strong, nonatomic) NSArray *TempArray;
@end

@implementation ZDHDesignMethodsViewController
#pragma mark - Init methods
- (void)initData{
    //vcViewModel
    _vcViewModel = [[ZDHDesignMethodsViewControllerViewModel alloc] init];
}
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createUI];
    [self setSubViewLayout];
    [self addObserver];
    [self getDataWithPlanID:_planID itemID:@""];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBar];
}
- (void)dealloc{
    [_topScrollView removeObserver:self forKeyPath:@"selectedIndex"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Getters and setters
- (void)createUI{
    _topIndex = 0;
    self.view.backgroundColor = WHITE;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //TopScrollView
    _topScrollView = [[ZDHProductCommonTopScrollView alloc] init];
    [self.view addSubview:_topScrollView];
    //产品清单
    _listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _listButton.layer.borderColor = [UIColor colorWithRed:143/256.0 green:143/256.0 blue:143/256.0 alpha:1].CGColor;
    _listButton.layer.borderWidth = 1;
    _listButton.layer.masksToBounds = YES;
    _listButton.layer.cornerRadius = 4;
    _listButton.backgroundColor = WHITE;
    [_listButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_listButton setTitle:@"产品清单>>" forState:UIControlStateNormal];
    [_listButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_listButton];
    //BigView
//    _bigView = [[ZDHProductCommonBigImageView alloc] init];
    _bigView = [[ZDDesignMethodsCollectionView alloc] init];
    _bigView.clipsToBounds = YES;
    [self.view addSubview:_bigView];
    
//    _bigImageScrollerView = [[ZDHProductCommonBigImageScrollerView alloc]init];
//    [self.view addSubview:_bigImageScrollerView];
    /*
    //LeftButton
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"diy_btn_left"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftButton];
    [super createSuperUI];
    //RightButton
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"diy_btn_right"] forState:UIControlStateNormal];
    [self.view addSubview:_rightButton];
    [super createSuperUI];
     */
    //BottomView
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = WHITE;
    [self.view addSubview:_bottomView];
   
    //设计说明:
    _contentTitleLabel = [[UILabel alloc] init];
    _contentTitleLabel.text = @"设计说明:";
    _contentTitleLabel.textColor = [UIColor darkGrayColor];
    _contentTitleLabel.font = [UIFont boldSystemFontOfSize:45/2];
    [_bottomView addSubview:_contentTitleLabel];
    //设计说明(内容)
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.text = @"设计说明:";
    _contentLabel.textColor = [UIColor lightGrayColor];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont boldSystemFontOfSize:30/2];
    [_bottomView addSubview:_contentLabel];
    //等待下载
    _progressHUB = [[MBProgressHUD alloc] initWithView:self.view];
    [_progressHUB show:NO];
}
- (void)setSubViewLayout{
    [super setSuperSubViewLayout];
    //TopScrollView
    [_topScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NAV_HEIGHT+STA_HEIGHT));
        make.left.equalTo(0);
        make.right.equalTo(0);
    }];
    //产品清单
    [_listButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_topScrollView.mas_centerY);
        make.right.equalTo(-20);
        make.width.equalTo(295/2);
        make.height.equalTo(40);
    }];
    //BottomView
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(0);
        make.bottom.equalTo(0);
        make.height.equalTo(133);
    }];
    //LeftButton
//    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(0);
//        make.top.equalTo(_topScrollView.mas_bottom);
//        make.width.equalTo(57);
//        make.bottom.equalTo(_bottomView.mas_top);
//    }];
//    //RightButton
//    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(0);
//        make.top.equalTo(_topScrollView.mas_bottom);
//        make.width.equalTo(57);
//        make.bottom.equalTo(_bottomView.mas_top);
//    }];
    //BigView
//    [_bigView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_topScrollView.mas_bottom);
//        make.left.equalTo(_leftButton.mas_right);
//        make.right.equalTo(_rightButton.mas_left);
//        make.bottom.equalTo(_bottomView.mas_top);
//    }];
    // _bigImageScrollerView
    [_bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topScrollView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
    //设计说明
    [_contentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(45/2);
        make.left.equalTo(self.view.mas_left).offset(57);

    }];
    //设计说明(内容)
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentTitleLabel.mas_bottom).with.offset(32/2);
//        make.left.mas_equalTo(_leftButton.mas_right);
        make.left.equalTo(_contentTitleLabel.mas_left);
    }];
}
- (void)setNavigationBar{
    [self.currNavigationController setNavigationBarMode:kNavigationBarDetailMode];
    [self.currNavigationController setDetailTitleLabelWithString:@"设计方案展示"];
}
#pragma mark - Event response
//点击产品清单按钮
- (void)buttonPressed:(UIButton *)button{
    ZDHUserProductListViewController *listVC = [[ZDHUserProductListViewController alloc] init];
    listVC.currNavigationController = self.currNavigationController;
    listVC.appDelegate = self.appDelegate;
    listVC.planID = _planID;
    [self.currNavigationController pushViewController:listVC animated:YES];
}
//点击左右图片
- (void)changeImage:(UIButton *)button{
    if (_vcViewModel.dataImageArray.count > 0) {
        if (button == _leftButton) {
            //向左
            if (_imageIndex > 0) {
                _imageIndex --;
            }
        }
        if (button == _rightButton) {
            //向右
            if (_imageIndex < (int)(_vcViewModel.dataImageArray.count-1)) {
                _imageIndex ++;
            }
        }
//        [_bigView reloadDesignImageView:_vcViewModel.dataImageArray[_imageIndex]];
    }
}
//观察顶部Title
- (void)addObserver{
    //顶部Title
    [_topScrollView addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
}
//观察反馈
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == _topScrollView) {
        //顶部Title
        if(_TempArray.count > 0){
            int selectedIndex = [[change valueForKey:@"new"] intValue];
            _topIndex = selectedIndex;
            //        [self getDataWithPlanID:_planID itemID:_vcViewModel.dataItemIDArray[selectedIndex]];
            
            [self getDataWithPlanID:_planID itemID:_TempArray[selectedIndex]];
        }
    }
}
#pragma mark - Network request
//获取设计方案信息
- (void)getDataWithPlanID:(NSString *)planID itemID:(NSString *)itemID{
    _imageIndex = 0;
    __block ZDHDesignMethodsViewControllerViewModel *selfViewModel = _vcViewModel;
    __block ZDHDesignMethodsViewController *selfVC = self;
    [_progressHUB show:YES];
    [_vcViewModel getDesignMethodWithPlanID:planID itemID:itemID success:^(NSMutableArray *resultArray) {
        //获取成功
//   [selfVC.bigView reloadDesignImageView:selfViewModel.dataImageArray[selfVC.imageIndex]];
        [selfVC.bigView loadBigImageWithImageArray:selfViewModel.dataImageArray];
        [selfVC.topScrollView reloadTopScrollViewWithArray:selfViewModel.dataTitleArray withIndex:_topIndex];
        selfVC.contentLabel.text = selfViewModel.contentString;
        [selfVC.progressHUB show:NO];
        _TempArray = selfViewModel.dataItemIDArray;
    } fail:^(NSError *error) {
        //获取失败
        [selfVC.progressHUB show:NO];
    }];
}
#pragma mark - Protocol methods
#pragma mark - Other methods

@end
