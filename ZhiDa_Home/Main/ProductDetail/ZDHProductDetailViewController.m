//
//  ZDHProductDetailViewController.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Controller
#import "ZDHProductDetailViewController.h"
//View
#import "ZDHProductCommonBigImageView.h"
#import "ZDHProductDetailRightView.h"
#import "ZDHCommonButton.h"
#import "ZDHProductCommonTopScrollView.h"
#import "ZDHProductDetailRightTableViewHeaderCell.h"
#import "ZDHProductDetailDescCell.h"
#import "ZDHProductTypeCell.h"
#import "ZDHProductRecommendCell.h"
//ViewModel
#import "ZDHProductDetailViewControllerViewModel.h"
//Model
#import "ZDHProductDetailViewProductModel.h"
#import "ZDHAllSingleProinfoModel.h"
//Lib
#import "Masonry.h"
#import "MBProgressHUD.h"
//Macro
#define kTopScrollViewHeight 50
#define kRightTableViewWidht 365
#define kHeaderViewHeight 43
#define kDescCellHeight 133
#define kTypeCellHeight 230
#define kRecommendCellHeight 258
@interface ZDHProductDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) ZDHProductCommonTopScrollView *topScrollView;
@property (strong, nonatomic) ZDHProductCommonBigImageView *bigImageView;
@property (strong, nonatomic) ZDHProductDetailRightView *rightTableView;
@property (strong, nonatomic) ZDHProductDetailViewControllerViewModel *vcViewModel;
@property (strong, nonatomic) MBProgressHUD *progressHud;
@property (strong, nonatomic) NSArray *titleButtonNameArray;
@property (strong, nonatomic) UIView *progressBackView;
//top selected
@property (assign, nonatomic) int selectedTopImage;
@end
@implementation ZDHProductDetailViewController
#pragma mark - Init methods
-(instancetype)init{
    if (self = [super init]) {
        [self initData];
    }
    return self;
}
- (void)initData{
    //vcViewModel
    _vcViewModel = [[ZDHProductDetailViewControllerViewModel alloc] init];
    //titleButtonNameArray
    _titleButtonNameArray = @[@"脱底图",@"局部图",@"场景图",@"尺寸图"];
}
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    //视图初始化
    self.selectedTopImage = 0;
    [self createUI];
    [self setSubViewsLayout];
    [self addObserver];
    [self notificationRecieve];
    [self startDownload];
    //change
    [self getDataWithPID:_pid];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBar];
    
    if (_bigImageView) {
         _bigImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
//----------------添加通知销毁在视图消失的时候(该对象一直被强引用着，没有走dealloc方法)--------------------------
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)dealloc{
    [_topScrollView removeObserver:self forKeyPath:@"selectedIndex"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Getters and setters
- (void)setNavigationBar{
    [self.currNavigationController setNavigationBarMode:kNavigationBarDetailMode];
    [self.currNavigationController setDetailTitleLabelWithString:@"产品中心"];
}
- (void)createUI{
    //第一次加载
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //顶部ScrollView
    _topScrollView = [[ZDHProductCommonTopScrollView alloc] init];
//    [_topScrollView reloadTopScrollViewWithArray:_titleButtonNameArray withIndex:0];
    [self.view addSubview:_topScrollView];
    //右边TableView
    _rightTableView = [[ZDHProductDetailRightView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    [_rightTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_rightTableView registerClass:[ZDHProductDetailRightTableViewHeaderCell class] forCellReuseIdentifier:@"HeaderCell"];
    [_rightTableView registerClass:[ZDHProductDetailDescCell class] forCellReuseIdentifier:@"DescCell"];
    [_rightTableView registerClass:[ZDHProductTypeCell class] forCellReuseIdentifier:@"TypeCell"];
    [_rightTableView registerClass:[ZDHProductRecommendCell class] forCellReuseIdentifier:@"RecommendCell"];
    [self.view addSubview:_rightTableView];
    //大图
    _bigImageView = [[ZDHProductCommonBigImageView alloc] init];
    _bigImageView.clipsToBounds = YES;
    _bigImageView.layer.borderWidth = 1;
    _bigImageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _bigImageView.backgroundColor = [UIColor whiteColor];
//------------添加图片合适模式 不拉伸不压缩------------------------
    _bigImageView.contentMode = UIViewContentModeScaleAspectFit;
//-------------------------------------------------------------
    [self.view addSubview:_bigImageView];
    //下载等待背景
    _progressBackView = [[UIView alloc] init];
    _progressBackView.backgroundColor = WHITE;
    _progressBackView.hidden = YES;
    [self.view addSubview:_progressBackView];
    //等待下载
    _progressHud = [[MBProgressHUD alloc] initWithView:_progressBackView];
    _progressHud.dimBackground = NO;
    _progressHud.backgroundColor = WHITE;
    [_progressBackView addSubview:_progressHud];
}
- (void)setSubViewsLayout{
    [super setSuperSubViewLayout];
    //顶部ScrollView
    [_topScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NAV_HEIGHT+STA_HEIGHT));
        make.left.equalTo(0);
    }];
    //右边TableView
    [_rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topScrollView.mas_bottom);
        make.bottom.equalTo(@0);
        make.width.equalTo(@kRightTableViewWidht);
        make.right.equalTo(@0);
    }];
    //大图
    [_bigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topScrollView.mas_bottom);
        make.left.equalTo(@0);
        make.right.equalTo(_rightTableView.mas_left).with.offset(1);
        make.bottom.equalTo(@0);
    }];
    //下载等待背景
    [_progressBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - Event response
//添加观察者
- (void)addObserver{
    //观察头部ScrollView
    [_topScrollView addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
}
//观察反馈
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    NSString *selectedIndexString = [change valueForKey:@"new"];
    int selectedIndex = [selectedIndexString intValue];
    //观察顶部ScrollView
    if (object == _topScrollView) {
        self.selectedTopImage = selectedIndex;
        [self.bigImageView reloadImageView:_vcViewModel.dataTopTitleArray[selectedIndex]];
    }
}
//接收通知
- (void)notificationRecieve{
    //观察TypeCell
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"ZDHProductTypeDescCell" object:nil];
}
//通知反馈
- (void)notificationAction:(NSNotification *)notification{
    //点击TypeCell
    if ([notification.name isEqualToString:@"ZDHProductTypeDescCell"]) {
        NSString *pid = [notification.userInfo valueForKey:@"selectedIndex"];
        _pid = pid;
        [self getDataWithPID:_pid];
    }
}
//点击推荐
- (void)recommmendCellPressed:(NSString *)pid{
    _pid = pid;
    [self getDataWithPID:_pid];
}
#pragma mark - Network request
//根据ID获取产品详情
- (void)getDataWithPID:(NSString *)pid{
    __weak __typeof(self)wself = self;
    __block ZDHProductDetailViewControllerViewModel *selfViewModel = _vcViewModel;
    [_vcViewModel getDataWithPID:pid success:^(NSMutableArray *resultArray) {
        
        [wself.topScrollView reloadTopScrollViewWithArray:selfViewModel.titleButtonNameArray withIndex:0];
        //获取成功
        //刷新顶部Title
        [wself.topScrollView reloadTopScrollViewWithImageUrlArray:selfViewModel.dataTopTitleArray];
        //默认加载第一张大图
        [wself.bigImageView reloadImageView:[selfViewModel.dataTopTitleArray firstObject]];
        //获取相关单品
        [selfViewModel getAboutSingleWithPID:pid pronumber:selfViewModel.pronumber success:^(NSMutableArray *resultArray) {
            //获取成功
            [wself stopDownload];
            //刷新对应的段
            [wself.rightTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        } fail:^(NSError *error) {
            //获取失败
            [wself stopDownload];
        }];
        //获取推荐与组合
        [selfViewModel getAboutProductWithPID:pid success:^(NSMutableArray *resultArray) {
            //获取成功
            //刷新对应的段
            [wself.rightTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        } fail:^(NSError *error) {
            //获取失败
            [wself stopDownload];
        }];
        //刷新对应的段
        [wself.rightTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0],[NSIndexPath indexPathForItem:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } fail:^(NSError *error) {
        //获取失败
        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络开小差" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alView show];
    }];
}
#pragma mark - Protocol methods
//TableView DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZDHProductDetailViewProductModel *productModel = [_vcViewModel.dataProductArray firstObject];
    UITableViewCell *returnCell;
    if (_vcViewModel.dataProductArray.count > 0) {
        switch (indexPath.row) {
            case 0:{
                //产品名称
                ZDHProductDetailRightTableViewHeaderCell *HeaderCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
                [HeaderCell reloadCellWithString:productModel.proname];
                returnCell = HeaderCell;
            }
                break;
            case 1:{
                //产品描述
                ZDHProductDetailDescCell *descCell = [tableView dequeueReusableCellWithIdentifier:@"DescCell"];
                [descCell reloadDescCellWithWidth:kRightTableViewWidht content:productModel.stuffinfo];
                returnCell = descCell;
            }
                break;
            case 2:{
                //规格详情
                ZDHProductTypeCell *typeCell = [tableView dequeueReusableCellWithIdentifier:@"TypeCell"];
                //文字规格
                [typeCell reloadCellContent:@[productModel.ProShowInfo]];
                //相关产品图片                
                [typeCell reloadCellImageView:_vcViewModel.dataAboutSingleImageArray pidArray:_vcViewModel.dataAboutSingleIDArray selectedPid:_pid];
                returnCell = typeCell;
            }
                break;
            case 3:{
                //推荐与组合
                ZDHProductRecommendCell *RecommendCell = [tableView dequeueReusableCellWithIdentifier:@"RecommendCell"];
                //加载数据
                [RecommendCell reloadCellImageView:_vcViewModel.dataAboutProductImageArray pidArray:_vcViewModel.dataAboutProductIDArray selectedPid:_pid];
                __weak __typeof(self)wself = self;
                RecommendCell.pressedBlock = ^(id sender){
                    [wself recommmendCellPressed:sender];
                };
                returnCell = RecommendCell;
            }
                break;
            default:{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                returnCell = cell;
            }
                break;
        }
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        returnCell = cell;
    }
    returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return returnCell;
}
//TableView Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            return kHeaderViewHeight;
        }
            break;
        case 1:{
            return kDescCellHeight;
        }
            break;
        case 2:{
            return kTypeCellHeight;
        }
            break;
        case 3:{
            return kRecommendCellHeight;
        }
            break;
        default:{
            return 0;
        }
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
//UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Other methods
//开始下载
- (void)startDownload{
    _progressBackView.hidden = NO;
    [_progressHud show:YES];
}
//停止下载
- (void)stopDownload{
    _progressBackView.hidden = YES;
    [_progressHud show:NO];
}
@end
