//
//  ZDHUserProductListViewController.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHUserProductListViewController.h"
//View
#import "ZDHUserProductListCell.h"
#import "ZDHUserProductListHeader.h"
#import "ZDHUserProductListFooter.h"
#import "ZDHUserProductListSectionFooter.h"
//ViewModel
#import "ZDHUserProductListViewControllerViewModel.h"
//Lib
#import "Masonry.h"
//Model
#import "ZDHUserProductListViewControllerItemproinfoModel.h"
#import "ZDHUserProductListViewControllerItemproinfoSpaceproinfoModel.h"
#import "ZDHUserProductListViewControllerItemproinfoSpaceproinfoProdetailModel.h"
@interface ZDHUserProductListViewController()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ZDHUserProductListFooter *footerView;
@property (strong, nonatomic) ZDHUserProductListViewControllerViewModel *vcViewModel;
//偏移位置
@property (assign, nonatomic) CGFloat oldOffset;
@end

@implementation ZDHUserProductListViewController
#pragma mark - Init methods
- (void)initData{
    //vcViewModel
    _vcViewModel = [[ZDHUserProductListViewControllerViewModel alloc] init];
    _oldOffset = 20.0;
}
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createUI];
    [self setSubViewLayout];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Getters and setters
- (void)createUI{
    __block ZDHUserProductListViewController *selfVC = self;
    self.view.backgroundColor = WHITE;
    //TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = WHITE;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[ZDHUserProductListCell class] forCellReuseIdentifier:@"ListCell"];
    [self.view addSubview:_tableView];
    [super createSuperUI];
    //下拉刷新
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfVC getData];
    }];
    [_tableView.header beginRefreshing];
    //尾部  固定在尾部
//    _footerView = [[ZDHUserProductListFooter alloc] initWithFrame:CGRectMake(0, 0, SCREEN_MAX_WIDTH, 200)];
    _footerView = [[ZDHUserProductListFooter alloc] init];
    [self.view addSubview:_footerView];
    _footerView.buttonBlock = ^(UIButton *button){
        [selfVC buttonPressed:button];
    };
}
- (void)setSubViewLayout{
    //尾部说明
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.right.equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    //TableView
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NAV_HEIGHT);
        make.left.and.right.equalTo(0);
        make.bottom.equalTo(_footerView.mas_bottom).offset(-50);
        
    }];
    
}
- (void)setNavigationBar{
    [self.currNavigationController setNavigationBarMode:kNavigationBarDetailMode];
    [self.currNavigationController setDetailTitleLabelWithString:@"产品清单"];
}
#pragma mark - Event response
//点击返回
- (void)buttonPressed:(UIButton *)button{
    [self.currNavigationController popViewControllerAnimated:YES];
}
#pragma mark - Network request
//获取清单列表
- (void)getData{
    __block ZDHUserProductListViewControllerViewModel *selfView = _vcViewModel;
    __block ZDHUserProductListViewController *selfVC = self;
    [_vcViewModel getDataWithPlanID:_planID success:^(NSMutableArray *resultArray) {
        //获取成功
        ZDHUserProductListViewControllerItemproinfoModel *infoModel = [selfView.dataItemInfoArray firstObject];
        [selfVC.footerView reloadDiscountPrice:[NSString stringWithFormat:@"￥%@",infoModel.paymoney]];
        [selfVC.footerView reloadTotalPrice:[NSString stringWithFormat:@"￥%@",infoModel.totalmoney]];
        [selfVC.tableView reloadData];
        [selfVC.tableView.header endRefreshing];
    } fail:^(NSError *error) {
        //获取失败
        [selfVC.tableView reloadData];
        [selfVC.tableView.header endRefreshing];
    }];
    
}
#pragma mark - Protocol methods
//UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_vcViewModel.dataSpaceArray.count > 0) {
        return _vcViewModel.dataSpaceArray.count;
    }else{
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ZDHUserProductListViewControllerItemproinfoSpaceproinfoModel *infoModel = _vcViewModel.dataSpaceArray[section];
    NSArray *prodetailArray = (NSArray *)infoModel.prodetail;
    if (prodetailArray.count > 0) {
        return prodetailArray.count;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDHUserProductListCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    listCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //加载数据
    if (_vcViewModel.dataSpaceArray.count > 0) {
        
        ZDHUserProductListViewControllerItemproinfoSpaceproinfoModel *infoModel = _vcViewModel.dataSpaceArray[indexPath.section];
        NSArray *prodetailArray = (NSArray *)infoModel.prodetail;
        ZDHUserProductListViewControllerItemproinfoSpaceproinfoProdetailModel *prodetailModel = prodetailArray[indexPath.row];
        //加载图片
        [listCell loadImageWithImage:prodetailModel.proimg];
        //加载名称，单价，数量，价格
        NSArray *upArray = [NSArray arrayWithObjects:prodetailModel.proname,[NSString stringWithFormat:@"￥%@",prodetailModel.proprice],[NSString stringWithFormat:@"%@(件)",prodetailModel.pronum],[NSString stringWithFormat:@"￥%@",prodetailModel.promoney],nil];

        [listCell loadUpContentWithDataArray:upArray];
        //加载型号，规格  ---- 》 添加了切割字符串
        NSArray *downArray = [NSArray arrayWithObjects:[[prodetailModel.pronumber componentsSeparatedByString:@"<"]firstObject],nil];
        [listCell loadDownContentWithDataArray:downArray];
    }
    return listCell;
}
//UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 220/2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 220/2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 232/2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ZDHUserProductListHeader *header = [[ZDHUserProductListHeader alloc] init];
     if (_vcViewModel.dataSpaceArray.count > 0) {
    ZDHUserProductListViewControllerItemproinfoSpaceproinfoModel *infoModel = _vcViewModel.dataSpaceArray[section];
//    ZDHUserProductListHeader *header = [[ZDHUserProductListHeader alloc] init];
    [header reloadTitle:infoModel.spacename];
     }
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    ZDHUserProductListSectionFooter *footer = [[ZDHUserProductListSectionFooter alloc] init];
    if (_vcViewModel.dataSpaceArray.count > 0) {
        ZDHUserProductListViewControllerItemproinfoSpaceproinfoModel *infoModel = _vcViewModel.dataSpaceArray[section];
        //加载数据
        [footer reloadPriceTitle:[NSString stringWithFormat:@"￥%@",infoModel.spacemoney]];
        [footer reloadNameTitle:[NSString stringWithFormat:@"%@小计:",infoModel.spacename]];
    }
    return footer;
}
//滑动判断 隐藏底部视图
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //向下滑动的时候才隐藏
    if(scrollView.contentOffset.y >40){
        if (scrollView.contentOffset.y>_oldOffset) {
            
            [UIView animateWithDuration:1 animations:^{
                _footerView.alpha = 0.0;
            }];
        }
        else{
            _footerView.hidden = NO;
            [UIView animateWithDuration:1 animations:^{
                _footerView.alpha = 1.0;
            }];
            
        }
        _oldOffset =scrollView.contentOffset.y;
        
    }
    //    if (scrollView.contentOffset.y == scrollView.contentSize.height - self.tableView.frame.size.height) {
    //        NSLog(@"tableView位置 %f  ===最大距离%f",_tableView.contentOffset.y,scrollView.contentSize.height - self.tableView.frame.size.height);
    
    //    }
    
    
}


#pragma mark - Other methods

@end
