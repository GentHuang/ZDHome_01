//
//  ZDHOrderView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHOrderView.h"
#import "ZDHOrderCell.h"
//Libs
#import "Masonry.h"
//ViewModel
#import "ZDHMyOrderViewOrderViewModel.h"
//Model
#import "ZDHMyOrderViewOrderBespokeListModel.h"
//Macros
#define kTopLabelFont 22
#define kCellHeight 235
@interface ZDHOrderView()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (assign, nonatomic) BOOL isSearch;
@property (strong, nonatomic) NSMutableArray *searchArray;
@property (assign, nonatomic) NSInteger footCount;
@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) UILabel *topLabel;
@property (strong, nonatomic) UITextField *topTextField;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ZDHMyOrderViewOrderViewModel *vcViewModel;
@end
@implementation ZDHOrderView
#pragma mark - Init methods
- (void)initData{
    //vcViewModel
    _vcViewModel = [[ZDHMyOrderViewOrderViewModel alloc] init];
    //搜索列表
    _searchArray = [NSMutableArray array];
}
-(instancetype)init{
    if (self = [super init]) {
        [self initData];
        [self createUI];
        [self setSubViewLayout];
        //反馈成功后刷新界面
        [self notificationReceive];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    _isSearch = NO;
    __block ZDHOrderView *selfView = self;
    self.backgroundColor = WHITE;
    //TopLabel
    _topLabel = [[UILabel alloc] init];
    _topLabel.text = @"分配给我的预约单";
    _topLabel.font = [UIFont boldSystemFontOfSize:kTopLabelFont];
    [self addSubview:_topLabel];
    //TopTextField
    _topTextField = [[UITextField alloc] init];
    _topTextField.borderStyle = UITextBorderStyleNone;
    _topTextField.background = [UIImage imageNamed:@"vip_sch_border"];
    [_topTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    UIView *rightBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_sch_btn"]];
    rightImageView.center = rightBackView.center;
    rightImageView.bounds = CGRectMake(0, 0, 25, 25);
    [rightBackView addSubview:rightImageView];
    _topTextField.rightView = rightBackView;
    _topTextField.rightViewMode = UITextFieldViewModeAlways;
    _topTextField.placeholder = @"请输入预约单号/预约人手机";
    _topTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _topTextField.returnKeyType = UIReturnKeySearch;
    _topTextField.delegate = self;
    [self addSubview:_topTextField];
//------------添加一个手势到搜索图标，客户说要点击能够搜索-----------------------
    UITapGestureRecognizer *Searchtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchClick)];
    [rightBackView addGestureRecognizer:Searchtap];
    
    //TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag | UIScrollViewKeyboardDismissModeInteractive;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(packUpKeyBoard)];
    [_tableView addGestureRecognizer:tap];
    [_tableView registerClass:[ZDHOrderCell class] forCellReuseIdentifier:@"OrderCell"];
    [self addSubview:_tableView];
    //下拉刷新
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfView getHeaderData];
    }];
    [_tableView.header beginRefreshing];
    //上拉刷新
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [selfView getFooterDataWithPage:selfView.page];
    }];
}
- (void)setSubViewLayout{
    //TopLabel
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(25);
        make.left.equalTo(16);
        make.height.equalTo(@kTopLabelFont);
    }];
    //TopTextField
    [_topTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(12);
        make.right.equalTo(-20);
        make.width.equalTo(350);
        make.height.equalTo(37);
    }];
    //TableView
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(60);
        make.left.and.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
    
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
#pragma mark - Event response
//回收键盘
- (void)packUpKeyBoard{
    [_topTextField resignFirstResponder];
}
//
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_topTextField resignFirstResponder];
}
//搜索
- (void)textFieldChange:(UITextField *)textField{
    if (textField == _topTextField) {
        NSString *searchKey = textField.text;
        if (searchKey.length > 0) {
            _isSearch = YES;
        }else{
            _isSearch = NO;
        }
        [_searchArray removeAllObjects];
        //按预约单号和手机号码进行搜索
        for (ZDHMyOrderViewOrderBespokeListModel *listModel in _vcViewModel.dataOrderListArray) {
            NSRange orderRange = [listModel.orderid rangeOfString:searchKey];
            NSRange numRange = [listModel.mobile rangeOfString:searchKey];
            if (numRange.location != NSNotFound) {
                [_searchArray addObject:listModel];
            }
            if (orderRange.location != NSNotFound) {
                [_searchArray addObject:listModel];
            }
        }
        [_tableView reloadData];
    }
}
//模拟键盘return点击
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField==_topTextField) {
        [self searchClick];
    }
    return YES;
}
#pragma mark - Network request
//下拉刷新
- (void)getHeaderData{
    _footCount = 0;
    _page = 1;
    [_tableView.footer resetNoMoreData];
    __block ZDHOrderView *selfView = self;
    
    //add 添加搜索size
    _vcViewModel.searchSizeString = @"";
    
    [_vcViewModel getOrderListWithMemberid:[ZDHSellMan shareInstance].sellManID page:_page success:^(NSMutableArray *resultArray) {
        //获取成功
        [selfView.tableView reloadData];
        [selfView.tableView.header endRefreshing];
    } fail:^(NSError *error) {
        //获取失败
        [selfView.tableView reloadData];
        [selfView.tableView.header endRefreshing];
    }];
}
//上拉刷新
- (void)getFooterDataWithPage:(NSInteger)page{
    _page ++;
    __block ZDHOrderView *selfView = self;
    __block ZDHMyOrderViewOrderViewModel *selfViewModel = _vcViewModel;
    //add 添加搜索size
    _vcViewModel.searchSizeString = @"";
    [_vcViewModel getOrderListWithMemberid:[ZDHSellMan shareInstance].sellManID page:_page success:^(NSMutableArray *resultArray) {
        //获取成功
        [selfView.tableView reloadData];
        //检测是否已经完全读取数据
        if (_footCount != selfViewModel.dataOrderListArray.count) {
            _footCount = selfViewModel.dataOrderListArray.count;
            [selfView.tableView.footer endRefreshing];
        }else{
            [selfView.tableView.footer endRefreshingWithNoMoreData];
        }
    } fail:^(NSError *error) {
        //获取失败
        [selfView.tableView reloadData];
        [selfView.tableView.footer endRefreshingWithNoMoreData];
    }];
}
#pragma mark - Protocol methods
//UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_isSearch) {
        //搜索
        return _searchArray.count;
    }else{
        if (_vcViewModel.dataOrderListArray.count > 0) {
            return _vcViewModel.dataOrderListArray.count;
        }else{
            return 0;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDHOrderCell *orderCell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell"];
    orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_isSearch) {
        //搜索
        if (_searchArray.count > 0) {
            //加载数据（预约单号，预约状态，预约提交日期，所属城市，联系电话，所属楼盘，预约上门日期）
            ZDHMyOrderViewOrderBespokeListModel *listModel = _searchArray[indexPath.section];
            NSArray *dataArray = [NSArray arrayWithObjects:listModel.orderid,listModel.status,listModel.adddate,listModel.city,listModel.mobile,listModel.house,listModel.comedate, nil];
            [orderCell loadCellWithDataArray:dataArray];
        }
    }else{
        if (_vcViewModel.dataOrderListArray.count > 0) {
            //加载数据（预约单号，预约状态，预约提交日期，所属城市，联系电话，所属楼盘，预约上门日期）
            ZDHMyOrderViewOrderBespokeListModel *listModel = _vcViewModel.dataOrderListArray[indexPath.section];
            NSArray *dataArray = [NSArray arrayWithObjects:listModel.orderid,listModel.status,listModel.adddate,listModel.city,listModel.mobile,listModel.house,listModel.comedate, nil];
            [orderCell loadCellWithDataArray:dataArray];
        }
    }
    return orderCell;
}
//UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}

//-------------添加手势触发搜索,最笨的方法--------
- (void)searchClick {
    
    //收起键盘
    [_topTextField resignFirstResponder];
    
    if (_topTextField.text.length==0)return;

    __block ZDHOrderView *selfView = self;
    _page =1;
    __block ZDHMyOrderViewOrderViewModel *selfViewModel = _vcViewModel;
    
    _vcViewModel.searchSizeString = @"1000";
    for(int i=0;i<1;i++){
        [_vcViewModel getOrderListWithMemberid:[ZDHSellMan shareInstance].sellManID page:_page success:^(NSMutableArray *resultArray) {
            //获取成功
            [selfView searchResultData];
            //检测是否已经完全读取数据
            if (_footCount != selfViewModel.dataOrderListArray.count) {
                _footCount = selfViewModel.dataOrderListArray.count;

            }else{
                [selfView.tableView.footer endRefreshingWithNoMoreData];
            }
        } fail:^(NSError *error) {
            NSLog(@"获取数据失败");
        }];
        
    }
}
//点击搜索后刷新界面
- (void)searchResultData {
    
    if (_topTextField) {
        NSString *searchKey = _topTextField.text;
        if (searchKey.length > 0) {
            _isSearch = YES;
        }else{
            _isSearch = NO;
        }
        [_searchArray removeAllObjects];
        //按预约单号和手机号码进行搜索
        for (ZDHMyOrderViewOrderBespokeListModel *listModel in _vcViewModel.dataOrderListArray) {
            NSRange orderRange = [listModel.orderid rangeOfString:searchKey];
            NSRange numRange = [listModel.mobile rangeOfString:searchKey];
            if (numRange.location != NSNotFound) {
                [_searchArray addObject:listModel];
            }
            if (orderRange.location != NSNotFound) {
                [_searchArray addObject:listModel];
            }
        }
        [_tableView reloadData];
    }
}

#pragma mark - Other methods

@end
