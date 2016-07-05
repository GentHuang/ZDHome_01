//
//  ZDHDesignDetailView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHDesignDetailView.h"
#import "ZDHDesignDetailUpCell.h"
#import "ZDHDesignDetailDownCell.h"
//Libs
#import "Masonry.h"
//ViewModel
#import "ZDHDesignDetailViewViewModel.h"
//Model
#import "ZDHDesignDetailViewDesignDetailModel.h"
#import "ZDHDesignDetailViewDesignDetailPlanitemModel.h"
#import "ZDHDesignDetailViewDesignDetailAboutproductModel.h"
//Macros
#define kTopLabelFont 18
#define kFirstCellHeight 790
#define kSecondCellHeight 200
@interface ZDHDesignDetailView()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UILabel *topLabel;
@property (strong, nonatomic) UILabel *topContentLabel;
@property (strong, nonatomic) UIButton *logButton;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) ZDHDesignDetailViewViewModel *vcViewModel;
@end
@implementation ZDHDesignDetailView
#pragma mark - Init methods
- (void)initData{
    //vcViewModel
    _vcViewModel = [[ZDHDesignDetailViewViewModel alloc] init];
}
-(instancetype)init{
    if (self = [super init]) {
        [self initData];
        [self createUI];
        [self setSubViewLayout];
        [self addObserver];
    }
    return self;
}
- (void)dealloc{
    [self removeObserver:self forKeyPath:@"orderID"];
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    __block ZDHDesignDetailView *selfView = self;
    self.backgroundColor = WHITE;
    //分割线
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = LIGHTGRAY;
    [self addSubview:_lineView];
    //TopLabel
    _topLabel = [[UILabel alloc] init];
    _topLabel.text = @"设计单状态:";
    _topLabel.font = FONTSIZES(kTopLabelFont);
    [self addSubview:_topLabel];
    //TopContentLabel
    _topContentLabel = [[UILabel alloc] init];
    _topContentLabel.text = @"";
    _topContentLabel.font = FONTSIZES(kTopLabelFont);
    [self addSubview:_topContentLabel];
    //LogButton
    _logButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_logButton setBackgroundImage:[UIImage imageNamed:@"vip_det_btn"] forState:UIControlStateNormal];
    [_logButton addTarget:self action:@selector(topButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_logButton];
    //TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = WHITE;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[ZDHDesignDetailUpCell class] forCellReuseIdentifier:@"UpCell"];
    [_tableView registerClass:[ZDHDesignDetailDownCell class] forCellReuseIdentifier:@"DownCell"];
    [self addSubview:_tableView];
    //下拉刷新
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfView getHeaderData];
    }];
}
- (void)setSubViewLayout{
    //TopLabel
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(25);
        make.left.equalTo(16);
        make.height.equalTo(@kTopLabelFont);
    }];
    //TopContentLabel
    [_topContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(25);
        make.left.equalTo(_topLabel.mas_right);
        make.height.equalTo(@kTopLabelFont);
    }];
    //LogButton
    [_logButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-19);
        make.top.equalTo(10);
        make.width.equalTo(150);
        make.height.equalTo(40);
    }];
    //分割线
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(_logButton.mas_bottom).with.offset(10);
        make.height.equalTo(1);
    }];
    //TableView
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.mas_bottom);
        make.left.and.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
}
#pragma mark - Event response
//观察者
- (void)addObserver{
    //刷新数据
    [self addObserver:self forKeyPath:@"orderID" options:NSKeyValueObservingOptionNew context:nil];
}
//观察反馈
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"orderID"]) {
        //刷新数据
        if (_orderID.length > 0) {
            [_tableView.header beginRefreshing];
        }
    }
}
//点击按钮
- (void)topButtonPressed:(UIButton *)button{
    if (_orderID.length > 0) {
        //详细日志
        NSString *name = @"ZDHLogView";
        //发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:@{@"orderID":[NSString stringWithFormat:@"设计 %@",_orderID]}];
    }
}
#pragma mark - Network request
//下拉刷新
- (void)getHeaderData{
    __block ZDHDesignDetailView *selfView = self;
    [_vcViewModel getDetailWithOrderID:_orderID success:^(NSMutableArray *resultArray) {
        //获取成功
        [selfView.tableView reloadData];
        [selfView.tableView.header endRefreshing];
    } fail:^(NSError *error) {
        //获取失败
        [selfView.tableView reloadData];
        [selfView.tableView.header endRefreshing];
    }];
}
#pragma mark - Protocol methods
//UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_vcViewModel.dataDetailArray.count > 0) {
        return 2;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:{
            //基本信息
            ZDHDesignDetailUpCell *upCell = [tableView dequeueReusableCellWithIdentifier:@"UpCell"];
            cell = upCell;
            if (_vcViewModel.dataDetailArray.count > 0) {
                //加载基本信息
                //                _nameArray = @[@"设计单号:",@"门店:",@"客户:",@"客户联系电话:",@"省/市:",@"楼盘:",@"户型:",@"类型:",@"风格:",@"家庭状况:",@"客户预算:",@"期望完成时间:",@"提交日期:",@"",@"详细地址:",@"详细说明:",@"偏好产品:",@"附件:"];
                ZDHDesignDetailViewDesignDetailModel *detailModel = [_vcViewModel.dataDetailArray firstObject];
                NSArray *dataArray = [NSArray arrayWithObjects:detailModel.orderid,detailModel.store,detailModel.client,detailModel.mobile,[NSString stringWithFormat:@"%@/%@",detailModel.province,detailModel.city],detailModel.housename,detailModel.housemodule,detailModel.designtype,detailModel.designstyle,detailModel.familyinfo,detailModel.budget,detailModel.hopetime,detailModel.submittime,@"",detailModel.addrinfo,detailModel.remarks,@"",detailModel.aboutfile, nil];
                [upCell reloadCellWithArray:dataArray];
                _topContentLabel.text = detailModel.status;
            }
            if (_vcViewModel.dataAboutArray.count > 0) {
                //加载偏好产品
                NSMutableArray *imageArray = [NSMutableArray array];
                NSMutableArray *titleArray = [NSMutableArray array];
                for (ZDHDesignDetailViewDesignDetailAboutproductModel *aboutModel in _vcViewModel.dataAboutArray) {
                    [imageArray addObject:aboutModel.proimg];
                    [titleArray addObject:aboutModel.pronumber];
                }
                [upCell loadAboutProductWithImageArray:imageArray titleArray:titleArray];
            }
        }
            break;
        case 1:{
            //设计方案
            ZDHDesignDetailDownCell *downCell = [tableView dequeueReusableCellWithIdentifier:@"DownCell"];
            cell = downCell;
            ZDHDesignDetailViewDesignDetailModel *detailModel = [_vcViewModel.dataDetailArray firstObject];
            downCell.orderID = detailModel.orderid;
            ZDHDesignDetailViewDesignDetailPlanitemModel *itemModel = detailModel.planitem;
            downCell.planID = itemModel.planid;
            //加载设计方案
            if (_vcViewModel.dataItemArray.count > 0) {
                ZDHDesignDetailViewDesignDetailPlanitemModel *itemModel = [_vcViewModel.dataItemArray firstObject];
                [downCell reloadCellWithImage:itemModel.planimg];
            }
        }
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return kFirstCellHeight;
            break;
        case 1:
            return kSecondCellHeight;
            break;
        default:
            return 0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, 50, SCREEN_MAX_WIDTH);
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont boldSystemFontOfSize:25];
    [backView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.left.equalTo(12);
        make.height.equalTo(50);
    }];
    switch (section) {
        case 0:
            nameLabel.text = @"设计单基本信息";
            break;
        case 1:
            nameLabel.text = @"";
            break;
        default:
            break;
    }
    return backView;
}
#pragma mark - Other methods
@end
