//
//  ZDHProductView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHProductView.h"
#import "ZDHProductCell.h"
//Libs
#import "Masonry.h"
//ViewModel
#import "ZDHProductViewViewModel.h"
//Model
#import "ZDHProductViewShopListModel.h"
//Macros
#define kTopLabelFont 22
#define kCellHeight 255
@interface ZDHProductView()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (assign, nonatomic) BOOL isSearch;
@property (strong, nonatomic) NSMutableArray *searchArray;
@property (strong, nonatomic) UILabel *topLabel;
@property (strong, nonatomic) UITextField *topTextField;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ZDHProductViewViewModel *vcViewModel;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger footCount;
@end
@implementation ZDHProductView
#pragma mark - Init methods
- (void)initData{
    //vcViewModel
    _vcViewModel = [[ZDHProductViewViewModel alloc] init];
    //搜索列表
    _searchArray = [NSMutableArray array];
}
- (instancetype)init{
    if (self = [super init]) {
        [self initData];
        [self createUI];
        [self setSubViewLayout];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    _isSearch = NO;
    __block ZDHProductView *selfView = self;
    self.backgroundColor = WHITE;
    //TopLabel
    _topLabel = [[UILabel alloc] init];
    _topLabel.text = @"商品订单";
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
    _topTextField.placeholder = @"请输入商品订单编号";
    _topTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _topTextField.returnKeyType = UIReturnKeySearch;
    _topTextField.delegate = self;
    [self addSubview:_topTextField];
    //TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag | UIScrollViewKeyboardDismissModeInteractive;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed)];
    [_tableView addGestureRecognizer:tap];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[ZDHProductCell class] forCellReuseIdentifier:@"ProductCell"];
    [self addSubview:_tableView];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfView getProductListData];
    }];
    [_tableView.header beginRefreshing];
    
    //------------添加一个手势到搜索图标，客户说要点击能够搜索-----------------------
    UITapGestureRecognizer *Searchtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchClick)];
    [rightBackView addGestureRecognizer:Searchtap];
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
#pragma mark - Event response
//收起键盘
- (void)tapPressed{
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
        //按商品订单编号
        for (ZDHProductViewShopListModel *listModel in _vcViewModel.dataListArray) {
            NSRange orderRange = [listModel.orderid rangeOfString:searchKey];
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
//获取商品订单列表
- (void)getProductListData{
    __block ZDHProductView *selfView = self;
    _page = 1;
    _footCount = 0;
    [_vcViewModel getProductListWithMemberID:[ZDHSellMan shareInstance].sellManID page:_page success:^(NSMutableArray *resultArray) {
        //获取成功
        [selfView.tableView reloadData];
        [selfView.tableView.header endRefreshing];
    } fail:^(NSError *error) {
        //获取失败
        [selfView.tableView reloadData];
        [selfView.tableView.header endRefreshing];
    }];
}
//上拉加载
- (void)getFooterDataWithPage:(NSInteger)page{
    
    _page ++;
    __block ZDHProductView *selfView = self;
    __block ZDHProductViewViewModel *selfViewModel = _vcViewModel;
    [_vcViewModel getProductListWithMemberID:[ZDHSellMan shareInstance].sellManID page:_page success:^(NSMutableArray *resultArray) {
        [selfView.tableView reloadData];
        if (_footCount!=selfViewModel.dataListArray.count) {
            _footCount = selfViewModel.dataListArray.count;
            //获取成功
            [selfView.tableView.footer endRefreshing];
            [selfView.tableView.header endRefreshing];
        }else{
            [selfView.tableView.footer endRefreshingWithNoMoreData];
        }
    } fail:^(NSError *error) {
        //获取失败
        [selfView.tableView reloadData];
        [selfView.tableView.footer endRefreshing];
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
        if (_vcViewModel.dataListArray.count > 0) {
            return _vcViewModel.dataListArray.count;
        }else{
            return 0;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDHProductCell *productCell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell"];
    productCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_isSearch) {
        //搜索
        if (_searchArray.count > 0) {
            //载入数据
            ZDHProductViewShopListModel *listModel = _searchArray[indexPath.section];
            NSArray *dataArray = [NSArray arrayWithObjects:listModel.orderid,listModel.status,listModel.adddate,listModel.addman,listModel.ordertype,listModel.store, nil];
            [productCell reloadCellWithArray:dataArray];
            productCell.orderID = listModel.orderid;
        }
    }else{
        if (_vcViewModel.dataListArray.count > 0) {
            //载入数据
            ZDHProductViewShopListModel *listModel = _vcViewModel.dataListArray[indexPath.section];
            NSArray *dataArray = [NSArray arrayWithObjects:listModel.orderid,listModel.status,listModel.adddate,listModel.addman,listModel.ordertype,listModel.store, nil];
            [productCell reloadCellWithArray:dataArray];
            productCell.orderID = listModel.orderid;
        }
    }
    return productCell;
}
//UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}
#pragma mark - Other methods

//-------------添加手势触发搜索,最笨的方法--------
- (void)searchClick {
    
    //收起键盘
    [_topTextField resignFirstResponder];
     __block ZDHProductView *selfView = self;
    __block ZDHProductViewViewModel *selfViewModel = _vcViewModel;
    for(int i=0;i<15;i++){
        _page ++;
        [_vcViewModel getProductListWithMemberID:[ZDHSellMan shareInstance].sellManID page:_page success:^(NSMutableArray *resultArray) {
            //获取成功
            [selfView searchResultData];
            if (_footCount!=selfViewModel.dataListArray.count) {
                _footCount = selfViewModel.dataListArray.count;
                //获取成功
                [selfView.tableView.footer endRefreshing];
            }else{
                [selfView.tableView.footer endRefreshingWithNoMoreData];
            }
        } fail:^(NSError *error) {
            //获取失败
            [selfView.tableView reloadData];
            [selfView.tableView.footer endRefreshing];
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
        //按商品订单编号
        for (ZDHProductViewShopListModel *listModel in _vcViewModel.dataListArray) {
            NSRange orderRange = [listModel.orderid rangeOfString:searchKey];
            if (orderRange.location != NSNotFound) {
                [_searchArray addObject:listModel];
            }
        }
        [_tableView reloadData];
    }

}

@end
