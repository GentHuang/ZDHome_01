//
//  ZDHOrderDetailView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHOrderDetailView.h"
#import "ZDHOrderDetailViewBaseCell.h"
#import "ZDHOrderDetailViewClientCell.h"
//Libs
#import "Masonry.h"
//ViewModel
#import "ZDHMyOrderViewOrderViewModel.h"
//Model
#import "ZDHMyOrderViewOrderDetailBespokeDetailModel.h"
#import "ZDHMyOrderViewOrderDetailBespokeDetailOpinionModel.h"
#import "ZDHMyOrderViewOrderDetailResponseBespokePoinionModel.h"
//Macros
#define kTopLabelFont 18
#define kFirstCellHeight 303
#define kSecondCellHeight 152
@interface ZDHOrderDetailView()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UILabel *topLabel;
@property (strong, nonatomic) UILabel *topContentLabel;
@property (strong, nonatomic) UIButton *responseButton;
@property (strong, nonatomic) UIButton *logButton;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) ZDHMyOrderViewOrderViewModel *vcViewModel;

@property (strong, nonatomic) NSString *remarks;//客户备注信息
@end
@implementation ZDHOrderDetailView
#pragma mark - Init methods
- (void)initData{
    //vcViewModel
    _vcViewModel = [[ZDHMyOrderViewOrderViewModel alloc] init];
}
-(instancetype)init{
    if (self = [super init]) {
        [self initData];
        [self createUI];
        [self setSubViewLayout];
        [self addObserver];
        [self notificationReceive];
    }
    return self;
}
- (void)dealloc{
    [self removeObserver:self forKeyPath:@"orderID"];
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    __block ZDHOrderDetailView *selfView = self;
    self.backgroundColor = WHITE;
    //分割线
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = LIGHTGRAY;
    [self addSubview:_lineView];
    //TopLabel
    _topLabel = [[UILabel alloc] init];
    _topLabel.text = @"预约单状态:";
    _topLabel.font = FONTSIZES(kTopLabelFont);
    [self addSubview:_topLabel];
    //TopContentLabel
    _topContentLabel = [[UILabel alloc] init];
    _topContentLabel.font = FONTSIZES(kTopLabelFont);
    [self addSubview:_topContentLabel];
    //ResponseButton
    _responseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_responseButton setBackgroundImage:[UIImage imageNamed:@"vip_feekback"] forState:UIControlStateNormal];
    [_responseButton addTarget:self action:@selector(topButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_responseButton];
//----------------------------------------------------
    //客户要求在“已接收”状态情况下才显示这个按钮
    _responseButton.enabled = NO;
//----------------------------------------------------
    
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
    [_tableView registerClass:[ZDHOrderDetailViewBaseCell class] forCellReuseIdentifier:@"BaseCell"];
    [_tableView registerClass:[ZDHOrderDetailViewClientCell class] forCellReuseIdentifier:@"ClientCell"];
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
        make.size.equalTo(_responseButton);
        make.right.equalTo(-19);
        make.top.equalTo(_responseButton.mas_top);
    }];
    //ResponseButton
    [_responseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.width.equalTo(150);
        make.height.equalTo(40);
        make.right.equalTo(_logButton.mas_left).with.offset(-26);
    }];
    //分割线
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(_responseButton.mas_bottom).with.offset(10);
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
//点击按钮
- (void)topButtonPressed:(UIButton *)button{
    NSString *name;
    if (button == _logButton) {
        //详细日志
        name = @"ZDHLogView";
    }else if(button == _responseButton){
        //客户反馈
        name = @"ZDHResponseView";
    }
    //发出通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:@{@"orderID":[NSString stringWithFormat:@"预约 %@",_orderID]}];
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:@{@"orderID":_orderID}];
}
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
//反馈成功刷新界面
- (void)notificationReceive {
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableView:) name:@"反馈成功刷新界面" object:nil];
}
- (void)reloadTableView:(NSNotification*)notif {
    if ([notif.name isEqualToString:@"反馈成功刷新界面"]) {
       [self.tableView.header beginRefreshing];
      [self.tableView reloadData];
    }
}

#pragma mark - Network request
//下拉刷新
- (void)getHeaderData{
    __block ZDHOrderDetailView *selfView = self;
    [_vcViewModel getOrderDetailWithOrderID:_orderID success:^(NSMutableArray *resultArray) {
        //获取成功
        ZDHMyOrderViewOrderDetailBespokeDetailModel *detailModel = [_vcViewModel.dataDetailArray firstObject];
        selfView.topContentLabel.text = detailModel.status;
        //------------------------------------------------------------
        if ([detailModel.status isEqualToString:@"已接收"])
            selfView. responseButton.enabled = YES;
        //-----------------------------------------------------------
        [_vcViewModel getOrderResponseWithOrderID:_orderID success:^(NSMutableArray *resultArray) {
            //获取成功
                [selfView.tableView reloadData];
                [selfView.tableView.header endRefreshing];
        } fail:^(NSError *error) {
                //刷新详情数据
                [selfView.tableView reloadData];
                [selfView.tableView.header endRefreshing];
        }];
    } fail:^(NSError *error) {
        //获取失败
            ZDHMyOrderViewOrderDetailBespokeDetailModel *detailModel = [_vcViewModel.dataDetailArray firstObject];
            selfView.topContentLabel.text = detailModel.status;
            //刷新详情数据
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
            //客户信息
            ZDHOrderDetailViewBaseCell *baseCell = [tableView dequeueReusableCellWithIdentifier:@"BaseCell"];
            if (_vcViewModel.dataDetailArray.count > 0) {
                //加载数据
                ZDHMyOrderViewOrderDetailBespokeDetailModel *detailModel = [_vcViewModel.dataDetailArray firstObject];
                      self.remarks = detailModel.remarks;//客户备注信息
                NSArray *dataArray = [NSArray arrayWithObjects:detailModel.houselayout,detailModel.housetype,detailModel.housearea,detailModel.decorate,detailModel.orderid,detailModel.adddate,detailModel.linkman,detailModel.linkmobile,detailModel.orderfrom,detailModel.comedate, detailModel.city,detailModel.store,detailModel.checkman,detailModel.cometype,detailModel.propertyhourse,nil];
                [baseCell reloadCellWithArray:dataArray];
                
            }
            cell = baseCell;
        }
            break;
        case 1:{
            //客户意见
            ZDHOrderDetailViewClientCell *clientCell = [tableView dequeueReusableCellWithIdentifier:@"ClientCell"];
            if (_vcViewModel.dataResponseArray.count > 0||self.remarks) {
                //加载数据
                ZDHMyOrderViewOrderDetailResponseBespokePoinionModel *opinionModel = [_vcViewModel.dataResponseArray firstObject];
//                NSArray *dataArray = [NSArray arrayWithObjects:_remarks,opinionModel.addtype,opinionModel.content,nil];
                NSString *clientRespon = [NSString stringWithFormat:@"%@  %@",opinionModel.addtype?opinionModel.addtype:@"",opinionModel.content?opinionModel.content:@""];
                NSArray *dataArray = [NSArray arrayWithObjects:_remarks,clientRespon,nil];
                [clientCell reloadCellWithArray:dataArray];
            }
            cell = clientCell;
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
            nameLabel.text = @"预约基本信息";
            break;
        case 1:
            nameLabel.text = @"客户反馈信息";
            break;
        default:
            break;
    }
    return backView;
}
#pragma mark - Other methods
@end
