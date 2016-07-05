//
//  ZDHDesignView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHDesignView.h"
#import "ZDHDesignCell.h"
//Libs
#import "Masonry.h"
//ViewModel
#import "ZDHDesignViewViewModel.h"
//Model
#import "ZDHDesignViewListDesignListModel.h"
#import "ZDHDesignViewMethodListDesignplanListModel.h"
//Macros
#define kCellHeight 239
@interface ZDHDesignView()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (assign, nonatomic) BOOL isSearch;
@property (strong, nonatomic) NSMutableArray *searchArray;
@property (strong, nonatomic) UIButton *allButton;
@property (strong, nonatomic) UIButton *caseButton;
@property (strong, nonatomic) UITextField *topTextField;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ZDHDesignViewViewModel *vcViewModel;
@property (assign, nonatomic) NSInteger ListPage;
@property (assign, nonatomic) NSInteger ListfootCount;

@property (assign ,nonatomic) NSInteger methodPage;
@property (assign, nonatomic) NSInteger methodfootCount;
@end

@implementation ZDHDesignView
#pragma mark - Init methods
- (void)initData{
    //vcViewModel
    _vcViewModel = [[ZDHDesignViewViewModel alloc] init];
    //搜索列表
    _searchArray = [NSMutableArray array];
}
-(instancetype)init{
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
    __block ZDHDesignView *selfView = self;
    self.backgroundColor = WHITE;
    //allButton
    _allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _allButton.selected = YES;
    _allButton.layer.borderWidth = 2;
    _allButton.layer.masksToBounds = YES;
    _allButton.layer.cornerRadius = 5;
    _allButton.layer.borderColor = [[UIColor colorWithRed:196/256.0 green:0 blue:73/256.0 alpha:1] CGColor];
    [_allButton setTitle:@"设计单" forState:UIControlStateNormal];
    [_allButton setTitleColor:[UIColor colorWithRed:91/256.0 green:91/256.0 blue:91/256.0 alpha:1] forState:UIControlStateNormal];
    [_allButton setTitleColor:[UIColor colorWithRed:196/256.0 green:0 blue:73/256.0 alpha:1] forState:UIControlStateSelected];
    //    [_allButton setBackgroundImage:[UIImage imageNamed:@"vip_all"] forState:UIControlStateNormal];
    //    [_allButton setBackgroundImage:[UIImage imageNamed:@"vip_all_selected"] forState:UIControlStateSelected];
    [_allButton addTarget:self action:@selector(topButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_allButton];
    //caseButton
    _caseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _caseButton.selected = NO;
    _caseButton.layer.masksToBounds = YES;
    _caseButton.layer.cornerRadius = 5;
    _caseButton.layer.borderWidth = 1;
    _caseButton.layer.borderColor = [[UIColor colorWithRed:166/256.0 green:166/256.0 blue:166/256.0 alpha:1] CGColor];
    [_caseButton setTitle:@"设计方案" forState:UIControlStateNormal];
    [_caseButton setTitleColor:[UIColor colorWithRed:91/256.0 green:91/256.0 blue:91/256.0 alpha:1] forState:UIControlStateNormal];
    [_caseButton setTitleColor:[UIColor colorWithRed:196/256.0 green:0 blue:73/256.0 alpha:1] forState:UIControlStateSelected];
    //    [_caseButton setBackgroundImage:[UIImage imageNamed:@"vip_design"] forState:UIControlStateNormal];
    //    [_caseButton setBackgroundImage:[UIImage imageNamed:@"vip_design_selected"] forState:UIControlStateSelected];
    [_caseButton addTarget:self action:@selector(topButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_caseButton];
    //TopTextField
    _topTextField = [[UITextField alloc] init];
    _topTextField.borderStyle = UITextBorderStyleNone;
    //键盘数字
    _topTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _topTextField.returnKeyType = UIReturnKeySearch;
    _topTextField.delegate = self;
    _topTextField.background = [UIImage imageNamed:@"vip_sch_border"];
    [_topTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    UIView *rightBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_sch_btn"]];
    rightImageView.center = rightBackView.center;
    rightImageView.bounds = CGRectMake(0, 0, 25, 25);
    [rightBackView addSubview:rightImageView];
    _topTextField.rightView = rightBackView;
    _topTextField.rightViewMode = UITextFieldViewModeAlways;
    _topTextField.placeholder = @"请输入设计单号/客户联系电话";
    [self addSubview:_topTextField];
    

    
    //TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag | UIScrollViewKeyboardDismissModeInteractive;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed)];
    [_tableView addGestureRecognizer:tap];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[ZDHDesignCell class] forCellReuseIdentifier:@"DesignCell"];
    [self addSubview:_tableView];
    //下拉刷新
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (selfView.allButton.selected) {
            //刷新设计单列表
            [selfView getDesignListHeaderData];
        }else{
            //刷新设计方案列表
            [selfView getMethodListHeaderData];
        }
    }];
    [_tableView.header beginRefreshing];
    
//-------------------------上拉加载----------------------
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (selfView.allButton.selected) {
            //加载设计单列表
            [selfView getDesignListFooterDataWithPage:selfView.ListPage];
        }else{
            //加载设计方案列表
            [selfView getDesignMethodFooterDataWithPage:selfView.ListPage];
        }
    }];
    //------------添加一个手势到搜索图标，客户说要点击能够搜索-----------------------
    UITapGestureRecognizer *Searchtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchClick)];
    [rightBackView addGestureRecognizer:Searchtap];
}
- (void)setSubViewLayout{
    //TopTextField
    [_topTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(12);
        make.right.equalTo(-20);
        make.width.equalTo(350);
        make.height.equalTo(37);
    }];
    //allButton
    [_allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_topTextField.mas_centerY);
        make.left.equalTo(12);
        make.width.equalTo(73);
        make.height.equalTo(37);
    }];
    //caseButton
    [_caseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_topTextField.mas_centerY);
        make.left.equalTo(_allButton.mas_right).with.offset(22);
        make.width.equalTo(100);
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_topTextField resignFirstResponder];
}
//
- (void)tapPressed{
    [_topTextField resignFirstResponder];
}
//点击按钮
- (void)topButtonPressed:(UIButton *)button{
//------------添加优化代码--------------
    _topTextField.text = @"";
    [self textFieldChange:_topTextField];
 
    [_tableView.header beginRefreshing];
    _allButton.selected = NO;
    _caseButton.selected = NO;
    _allButton.layer.borderWidth = 1;
    _allButton.layer.borderColor = [[UIColor colorWithRed:166/256.0 green:166/256.0 blue:166/256.0 alpha:1] CGColor];
    _caseButton.layer.borderWidth = 1;
    _caseButton.layer.borderColor = [[UIColor colorWithRed:166/256.0 green:166/256.0 blue:166/256.0 alpha:1] CGColor];
    //选中按钮
    button.selected = YES;
    button.layer.borderWidth = 2;
    button.layer.borderColor = [[UIColor colorWithRed:196/256.0 green:0 blue:73/256.0 alpha:1] CGColor];
    [_tableView reloadData];
    if (_allButton.selected) {
        _topTextField.placeholder = @"请输入设计单号/客户联系电话";
    }else{
        _topTextField.placeholder = @"请输入设计方案编号/联系电话";
    }
    
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
        if (_allButton.selected) {
            //请输入设计单号/客户联系电话
            for (ZDHDesignViewListDesignListModel *listModel in _vcViewModel.dataListArray) {
                NSRange orderRange = [listModel.orderid rangeOfString:searchKey];
                NSRange numRange = [listModel.mobile rangeOfString:searchKey];
                if (numRange.location != NSNotFound) {
                    [_searchArray addObject:listModel];
                }
                if (orderRange.location != NSNotFound) {
                    [_searchArray addObject:listModel];
                }
            }
        }else{
            //请输入设计方案编号/联系电话
            for (ZDHDesignViewMethodListDesignplanListModel *listModel in _vcViewModel.dataMethodListArray) {
                NSRange orderRange = [listModel.planid rangeOfString:searchKey];
                NSRange numRange = [listModel.mobile rangeOfString:searchKey];
                if (numRange.location != NSNotFound) {
                    [_searchArray addObject:listModel];
                }
                if (orderRange.location != NSNotFound) {
                    [_searchArray addObject:listModel];
                }
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
//设计单列表下拉刷新
- (void)getDesignListHeaderData{
//------------添加页码-------------------
    _ListfootCount = 0;
    _ListPage = 1;
    __block ZDHDesignView *selfView = self;
    [_vcViewModel getListWithMemberID:[ZDHSellMan shareInstance].sellManID  page:_ListPage success:^(NSMutableArray *resultArray) {
        //获取成功
        [selfView.tableView.header endRefreshing];
        [selfView.tableView reloadData];
    } fail:^(NSError *error) {
        //获取失败
        [selfView.tableView.header endRefreshing];
        [selfView.tableView reloadData];
    }];
}
//设计方案列表下拉刷新
- (void)getMethodListHeaderData{
    _methodfootCount = 0;
    _methodPage = 1;
    __block ZDHDesignView *selfView = self;
    [_vcViewModel getMethodListWithMemberID:[ZDHSellMan shareInstance].sellManID page:_methodPage success:^(NSMutableArray *resultArray) {
        //获取成功
        [selfView.tableView.header endRefreshing];
        [selfView.tableView reloadData];
    } fail:^(NSError *error) {
        //获取失败
        [selfView.tableView.header endRefreshing];
        [selfView.tableView reloadData];
    }];
}
#pragma mark - Protocol methods
//UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_allButton.selected) {
        if (_isSearch) {
            //搜索
            return _searchArray.count;
        }else{
            //设计单列表
            if (_vcViewModel.dataListArray.count > 0) {
                return _vcViewModel.dataListArray.count;
            }else{
                return 0;
            }
        }
    }else{
        if (_isSearch) {
            //搜索
            return _searchArray.count;
        }else{
            //设计单方案列表
            if (_vcViewModel.dataMethodListArray.count > 0) {
                return _vcViewModel.dataMethodListArray.count;
            }else{
                return 0;
            }
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDHDesignCell *designCell = [tableView dequeueReusableCellWithIdentifier:@"DesignCell"];
    if (_allButton.selected) {
        //设计单列表
        [designCell selectCellType:kFirstCellType];
        if (_isSearch) {
            //搜索
            //加载数据
            if (_searchArray.count > 0) {
                ZDHDesignViewListDesignListModel *listModel = _searchArray[indexPath.section];
                //后台返回的价格是"50000 100000",中间无"-",因此进行替换
               listModel.money = [listModel.money stringByReplacingOccurrencesOfString:@" " withString:@"-"];
                NSArray *dataArray = [NSArray arrayWithObjects:listModel.orderid,listModel.designername,listModel.status,listModel.adddate,listModel.client,listModel.mobile,listModel.store,listModel.money,nil];
                [designCell reloadDesignListCellWithArray:dataArray];
                designCell.orderID = listModel.orderid;
                if (listModel.planid.length > 0) {
                    designCell.planID = listModel.planid;
                    [designCell enableCaseButton:YES];
                }else{
                    [designCell enableCaseButton:NO];
                }
            }
        }else{
            //加载数据
            if (_vcViewModel.dataListArray.count > 0) {
                ZDHDesignViewListDesignListModel *listModel = _vcViewModel.dataListArray[indexPath.section];
                //后台返回的价格是"50000 100000",中间无"-",因此进行替换
                listModel.money = [listModel.money stringByReplacingOccurrencesOfString:@" " withString:@"-"];
                NSArray *dataArray = [NSArray arrayWithObjects:listModel.orderid,listModel.designername,listModel.status,listModel.adddate,listModel.client,listModel.mobile,listModel.store,listModel.money,nil];
                [designCell reloadDesignListCellWithArray:dataArray];
                designCell.orderID = listModel.orderid;
                if (listModel.planid.length > 0) {
                    designCell.planID = listModel.planid;
                    [designCell enableCaseButton:YES];
                }else{
                    [designCell enableCaseButton:NO];
                }
            }
        }
    }else{
        //设计单方案列表
        [designCell selectCellType:kSecondCellType];
        if (_isSearch) {
            //搜索
            //加载数据
            if(_searchArray.count > 0){
                ZDHDesignViewMethodListDesignplanListModel *listModel = _searchArray[indexPath.section];
                NSArray *dataArray = [NSArray arrayWithObjects:listModel.planid,listModel.addtime,listModel.addman,listModel.totalmoney,listModel.storename,listModel.mobile,nil];
                [designCell reloadMethodListCellWithArray:dataArray];
                if (listModel.planid.length > 0) {
                    designCell.planID = listModel.planid;
                    [designCell enableCaseButton:YES];
                }else{
                    [designCell enableCaseButton:NO];
                }
            }
        }else{
            //加载数据
            if(_vcViewModel.dataMethodListArray.count > 0){
                ZDHDesignViewMethodListDesignplanListModel *listModel = _vcViewModel.dataMethodListArray[indexPath.section];
                NSArray *dataArray = [NSArray arrayWithObjects:listModel.planid,listModel.addtime,listModel.addman,listModel.totalmoney,listModel.storename,listModel.mobile,nil];
                [designCell reloadMethodListCellWithArray:dataArray];
                if (listModel.planid.length > 0) {
                    designCell.planID = listModel.planid;
                    [designCell enableCaseButton:YES];
                }else{
                    [designCell enableCaseButton:NO];
                }
            }
        }
    }
    designCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return designCell;
}
//UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}
#pragma mark - Other methods
//上拉加载
//设计单加载
- (void)getDesignListFooterDataWithPage:(NSInteger)page{
    _ListPage++;
    __block ZDHDesignView *selfView = self;
    __block ZDHDesignViewViewModel *selfDesignModel = _vcViewModel;
    [_vcViewModel getListWithMemberID:[ZDHSellMan shareInstance].sellManID  page:_ListPage success:^(NSMutableArray *resultArray) {
        //获取成功
        [selfView.tableView reloadData];
        //检测是否已经完全读取数据
        if (_ListfootCount != selfDesignModel.dataListArray.count) {
            _ListfootCount = selfDesignModel.dataListArray.count;
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
//设计方案加载数据
- (void)getDesignMethodFooterDataWithPage:(NSInteger)page{
    _methodPage++;
    __block ZDHDesignView *selfView = self;
    __block ZDHDesignViewViewModel *selfDesignModel = _vcViewModel;
    [_vcViewModel getMethodListWithMemberID:[ZDHSellMan shareInstance].sellManID page:_methodPage success:^(NSMutableArray *resultArray) {
        //获取成功
        [selfView.tableView reloadData];
        //检测是否已经完全读取数据
        if (_methodfootCount != selfDesignModel.dataMethodListArray.count) {
            _methodfootCount = selfDesignModel.dataMethodListArray.count;
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
#pragma mark tap Method
- (void)searchClick {
    
    //收起键盘
    [_topTextField resignFirstResponder];
    __block ZDHDesignView *selfView = self;
    __block ZDHDesignViewViewModel *selfDesignModel = _vcViewModel;
    if(_allButton.selected==YES){
        for (int i= 0;i<15;i++){//最大页码是15
            _ListPage++;
            [_vcViewModel getListWithMemberID:[ZDHSellMan shareInstance].sellManID  page:_ListPage success:^(NSMutableArray *resultArray) {
                //获取成功
                [selfView searchResultData];
                //检测是否已经完全读取数据
                if (_ListfootCount != selfDesignModel.dataListArray.count) {
                    _ListfootCount = selfDesignModel.dataListArray.count;
                }else{
                    [selfView.tableView.footer endRefreshingWithNoMoreData];
                }
            } fail:^(NSError *error) {
                //获取失败
                [selfView searchResultData];
                [selfView.tableView.footer endRefreshingWithNoMoreData];
            }];
        }
    }else{
        for (int i = 0; i<15; i++) {
            _methodPage++;
            [_vcViewModel getMethodListWithMemberID:[ZDHSellMan shareInstance].sellManID page:_methodPage success:^(NSMutableArray *resultArray) {
                //获取成功
                [selfView searchResultData];
                //检测是否已经完全读取数据
                if (_methodfootCount != selfDesignModel.dataMethodListArray.count) {
                    _methodfootCount = selfDesignModel.dataMethodListArray.count;
                }else{
                    [selfView.tableView.footer endRefreshingWithNoMoreData];
                }
            } fail:^(NSError *error) {
                //获取失败
                [selfView searchResultData];
                [selfView.tableView.footer endRefreshingWithNoMoreData];
            }];
        }
    }
}
//点击搜索后刷新界面
- (void)searchResultData {
    
    if ( _topTextField) {
        NSString *searchKey = _topTextField.text;
        if (searchKey.length > 0) {
            _isSearch = YES;
        }else{
            _isSearch = NO;
        }
        [_searchArray removeAllObjects];
        if (_allButton.selected) {
            //请输入设计单号/客户联系电话
            for (ZDHDesignViewListDesignListModel *listModel in _vcViewModel.dataListArray) {
                NSRange orderRange = [listModel.orderid rangeOfString:searchKey];
                NSRange numRange = [listModel.mobile rangeOfString:searchKey];
                if (numRange.location != NSNotFound) {
                    [_searchArray addObject:listModel];
                }
                if (orderRange.location != NSNotFound) {
                    [_searchArray addObject:listModel];
                }
            }
        }else{
            //请输入设计方案编号/联系电话
            for (ZDHDesignViewMethodListDesignplanListModel *listModel in _vcViewModel.dataMethodListArray) {
                NSRange orderRange = [listModel.planid rangeOfString:searchKey];
                NSRange numRange = [listModel.mobile rangeOfString:searchKey];
                if (numRange.location != NSNotFound) {
                    [_searchArray addObject:listModel];
                }
                if (orderRange.location != NSNotFound) {
                    [_searchArray addObject:listModel];
                }
            }
            
        }
        [_tableView reloadData];
    }
}

@end
