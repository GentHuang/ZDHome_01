//
//  ZDHListView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//View
#import "ZDHDownLoadView.h"
#import "ZDHListView.h"
#import "ZDHListUpCell.h"
#import "ZDHListSpreadView.h"
//ViewModel
#import "ZDHListViewViewModel.h"
#import "ZDHLIstViewSceneViewModel.h"
#import "ZDHLIstViewClothesViewModel.h"
#import "ZDHLIstViewCellViewModel.h"
//Cell状态
#import "ZDHLIstViewCellStatus.h"
//Lib
#import "Masonry.h"
#import "MBProgressHUD.h"
//Macros
#define kListUpButtonTag 26000
#define kListDownButtonTag 27000
#define kListDownSpreadButtonTag 28000
//add
#define KListUpButtonSpreadTag 25000
@interface ZDHListView()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ZDHListViewViewModel *listViewModel;
@property (strong, nonatomic) ZDHLIstViewSceneViewModel *sceneViewModel;
@property (strong, nonatomic) ZDHLIstViewClothesViewModel *clothesViewModel;
@property (strong, nonatomic) ZDHLIstViewCellViewModel *cellViewModel;
@property (strong, nonatomic) NSString *firstSectionName;
@property (strong, nonatomic) NSString *secondSectionName;
@property (strong, nonatomic) ZDHListSpreadView *spreadView;

@property (strong, nonatomic) NSString *iSUnpackZIP;
//临时数据u
@property (strong, nonatomic) NSArray *clothesNameArray0;
@property (strong, nonatomic) NSArray *clothesNameArray1;
@property (strong, nonatomic) NSArray *clothesNameArray2;
@end

@implementation ZDHListView
#pragma mark - Init methods
- (void)initData{
    //ListViewModel
    _listViewModel = [[ZDHListViewViewModel alloc] init];
    //SceneViewModel
    _sceneViewModel = [[ZDHLIstViewSceneViewModel alloc] init];
    //ClothesViewModel
    _clothesViewModel = [[ZDHLIstViewClothesViewModel alloc] init];
    //CellViewModel
    _cellViewModel = [[ZDHLIstViewCellViewModel alloc] init];
    
    //临时
    //    _clothesNameArray0 = @[@"base",@"SOHO",@"艾维斯（280绒布版）",@"宠爱",@"丛林",@"翠提春晓",@"儿童版",@"范娜贝斯A",@"非主体布板",@"海岸",@"豪森",@"华沙盛典",@"皇家爱丁堡"];
    //    _clothesNameArray1 = @[@"base",@"SOHO",@"艾维斯（280绒布版）",@"宠爱",@"丛林",@"翠提春晓",@"儿童版",@"范娜贝斯A",@"非主体布板"];
    //    _clothesNameArray2 = @[@"base",@"SOHO",@"艾维斯（280绒布版）",@"宠爱",@"丛林",@"翠提春晓",@"儿童版",@"范娜贝斯A",@"非主体布板",@"海岸",@"豪森",@"华沙盛典",@"皇家爱丁堡",@"海岸",@"豪森",@"华沙盛典",@"皇家爱丁堡"];
}
- (instancetype)init{
    if (self = [super init]) {
        [self initData];
        [self createUI];
        [self setSubViewLayout];
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
//    __block ZDHListView *selfView = self;
    __weak __typeof(self) weakSelf = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed)];
    [self addGestureRecognizer:tap];
    self.backgroundColor = WHITE;
    //TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = WHITE;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    //下拉刷新
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf startNetworkDownload];
    }];
    [_tableView.header beginRefreshing];
    
    //回调是否解压
//    __block ZDHListView *selfVC = self;
    _cellViewModel.FinisUpZIP = ^(NSString*finishString){
        
        [weakSelf  isUnpackZIP:finishString];
    };
}
- (void)setSubViewLayout{
    //TableView
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.and.top.equalTo(0);
    }];
}
#pragma mark - Event response
//点击收起SpreadView
- (void)tapPressed{
    if (_spreadView) {
        [_spreadView removeFromSuperview];
        _spreadView = nil;
        [_tableView reloadData];
    }
}
//点击下载或暂停
- (void)buttonPressed:(UIButton *)button{
    
    UIView *contentView = [button superview];
    ZDHListUpCell *upCell = (ZDHListUpCell *)[contentView superview];
    int selectedIndex;
    if (button.tag < kListDownButtonTag) {
        
        //主题空间离线包
        [upCell setCellMode:kStopDownloadMode];
        selectedIndex = (int)(button.tag - kListUpButtonTag);
        ZDHLIstViewCellStatus *cellStatus = _cellViewModel.sceneCellStatusArray[selectedIndex];
        if (cellStatus.isStart) {
            //放进队列下载
            [cellStatus setIsStop];
            cellStatus.isDownloading = YES;
            [_cellViewModel getIntoDownloadQueue:_sceneViewModel.downloadArray[selectedIndex] titleText:_sceneViewModel.titleArray[selectedIndex]];
        }else if(cellStatus.isStop){
            //暂停下载
            [cellStatus setisContinue];
            cellStatus.isDownloading = NO;
            [_cellViewModel pauseDownload:_sceneViewModel.downloadArray[selectedIndex]];
        }else if(cellStatus.isContinue){
            //继续下载
            [cellStatus setIsStop];
            cellStatus.isDownloading = YES;
            [_cellViewModel getIntoDownloadQueue:_sceneViewModel.downloadArray[selectedIndex] titleText:_sceneViewModel.titleArray[selectedIndex]];
        }
        //设置Button状态
        [upCell setCellMode:[_cellViewModel getButtonStatus:_cellViewModel.sceneCellStatusArray[selectedIndex]]];
        [_tableView reloadData];
    }else if (button.tag >= kListDownSpreadButtonTag) {
        //布版离线包的点开按钮
        selectedIndex = (int)(button.tag - kListDownSpreadButtonTag);
        for (int i = 0; i < [_tableView numberOfRowsInSection:1]; i ++) {
            if (i == selectedIndex) {
                button.selected = !button.selected;
            }else{
                UIButton *allButton = (UIButton *)[self viewWithTag:i+kListDownSpreadButtonTag];
                allButton.selected = NO;
            }
        }
        [self displaySpreadViewWithIndex:selectedIndex];
    }else if(button.tag >= kListDownButtonTag && button.tag < kListDownSpreadButtonTag){
        //布版离线包的下载按钮
        selectedIndex = (int)(button.tag - kListDownButtonTag);
        ZDHLIstViewCellStatus *cellStatus = _cellViewModel.clothesCellStatusArray[selectedIndex];
        if (cellStatus.isStart) {
            //放进队列下载
            [cellStatus setIsStop];
            cellStatus.isDownloading = YES;
            [_cellViewModel getIntoDownloadQueue:_clothesViewModel.downloadArray[selectedIndex] titleText:_clothesViewModel.titleArray[selectedIndex]];
        }else if(cellStatus.isStop){
            //暂停下载
            [cellStatus setisContinue];
            cellStatus.isDownloading = NO;
            [_cellViewModel pauseDownload:_clothesViewModel.downloadArray[selectedIndex]];
        }else if(cellStatus.isContinue){
            //继续下载
            [cellStatus setIsStop];
            cellStatus.isDownloading = YES;
            [_cellViewModel getIntoDownloadQueue:_clothesViewModel.downloadArray[selectedIndex] titleText:_clothesViewModel.titleArray[selectedIndex]];
        }
        //设置Button状态
        [upCell setCellMode:[_cellViewModel getButtonStatus:_cellViewModel.clothesCellStatusArray[selectedIndex]]];
    }
}
//回调进度条
- (void)reloadCellProgress:(CGFloat)progress urlString:(NSString *)urlString{
    
    ZDHLIstViewCellStatus *cellStatus;
    ZDHListUpCell *upCell;
    int selectedIndex;
    for (NSString *url in _sceneViewModel.downloadArray) {
        if ([url isEqualToString:urlString]) {
            selectedIndex = (int)[_sceneViewModel.downloadArray indexOfObject:url];
            upCell = (ZDHListUpCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
            cellStatus = _cellViewModel.sceneCellStatusArray[selectedIndex];
            cellStatus.progress = progress;
        }
    }
    for (NSString *url in _clothesViewModel.downloadArray) {
        if ([url isEqualToString:urlString]) {
            selectedIndex = (int)[_clothesViewModel.downloadArray indexOfObject:url];
            upCell = (ZDHListUpCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:1]];
            cellStatus = _cellViewModel.clothesCellStatusArray[selectedIndex];
            cellStatus.progress = progress;
        }
    }
    [upCell reloadProgressView:progress isDownload:cellStatus.isDownloading];
}
//接收通知
- (void)notificationRecieve{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notitficationResponse:) name:@"ZDHLIstViewCellViewModel" object:nil];
}
//下载出错通知反馈
- (void)notitficationResponse:(NSNotification *)notification{
    //    NSLog(@"%@",[notification.userInfo valueForKey:@"title"]);
    NSString *title = [notification.userInfo valueForKey:@"title"];
    ZDHListUpCell *cell;
    ZDHLIstViewCellStatus *cellStatus;
    for (int i = 0; i < _sceneViewModel.titleArray.count; i ++) {
        if ([title isEqualToString:_sceneViewModel.titleArray[i]]) {
            cell = (ZDHListUpCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cellStatus = _cellViewModel.sceneCellStatusArray[i];
            break;
        }
    }
    for (int i = 0; i < _clothesViewModel.titleArray.count; i ++) {
        if ([title isEqualToString:_clothesViewModel.titleArray[i]]) {
            cell = (ZDHListUpCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
            cellStatus = _cellViewModel.clothesCellStatusArray[i];
            break;
        }
    }
    [cellStatus setIsStart];
    [cell setCellMode:[_cellViewModel getButtonStatus:cellStatus]];
}
#pragma mark - Network request
//请求下载列表信息
- (void)startNetworkDownload{
    __block ZDHListView *selfView = self;
    __block BOOL isSceneReload = NO;
    __block BOOL isClothesReload = NO;
    //获取空间下载列表
    [_listViewModel getSceneDownloadListWithUrlSuccess:^(NSMutableArray *resultArray) {
        //获取成功
        //转换数据
        [_sceneViewModel transfromDataWith:_listViewModel.sceneArray];
        //获取主题空间离线包大小
        [_sceneViewModel getRealSize:_sceneViewModel.downloadArray success:^(NSMutableArray *resultArray, NSMutableArray *secondResultArray) {
            // 初始化Cell状态
            [_cellViewModel storedDataWithSceneArray:_listViewModel.sceneArray realSizeArray:resultArray];
            _firstSectionName = @"主题空间离线包";
            isSceneReload = YES;
            if (isClothesReload && isSceneReload) {
                [selfView.tableView reloadData];
                [selfView.tableView.header endRefreshing];
            }
        }];
    } fail:^(NSError *error) {
        //获取失败
        isSceneReload = YES;
        if (isClothesReload && isSceneReload) {
            [selfView.tableView reloadData];
            [selfView.tableView.header endRefreshing];
        }
    }];
    //获取布板下载列表
    [_listViewModel getClothesDownloadListSuccess:^(NSMutableArray *resultArray) {
        //获取成功
        //转换数据
        [_clothesViewModel transfromDataWith:_listViewModel.clothesArray];
        //        获取主题空间离线包大小
        [_clothesViewModel getRealSize:_clothesViewModel.downloadArray success:^(NSMutableArray *resultArray, NSMutableArray *secondResultArray) {
            // 初始化Cell状态
            [_cellViewModel storedDataWithClothesArray:_listViewModel.clothesArray realSizeArray:resultArray];
            _secondSectionName = @"布板离线包";
            isClothesReload = YES;
            if (isClothesReload && isSceneReload) {
                [selfView.tableView reloadData];
                [selfView.tableView.header endRefreshing];
            }
        }];
        [selfView.tableView reloadData];
        [selfView.tableView.header endRefreshing];
    } fail:^(NSError *error) {
        //获取失败
        isClothesReload = YES;
        if (isClothesReload && isSceneReload) {
            [selfView.tableView reloadData];
            [selfView.tableView.header endRefreshing];
        }
    }];
    //刷新一次值 判断是否在解压
    //    [self isUnpackZIP];
}
#pragma mark - Protocol methods
//UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            if (_cellViewModel.sceneCellStatusArray.count>0) {
                return _cellViewModel.sceneCellStatusArray.count;
            }else{
                return 0;
            }
            break;
        case 1:
            if (_cellViewModel.clothesCellStatusArray.count>0) {
                return _cellViewModel.clothesCellStatusArray.count;
            }else{
                return 0;
            }
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self) weakSelf = self;
    ZDHListUpCell *upCell = nil;
    
    if (upCell == nil) {
        upCell = [[ZDHListUpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UpCell"];
    }
    upCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //设置点击事件
    upCell.buttonBlock = ^(UIButton *button){
        
        [weakSelf buttonPressed:button];
    };
    upCell.spreadButtonBlock = ^(UIButton *button){
        
        [weakSelf buttonPressed:button];
    };
    //点击展开空间压缩包按钮
    upCell.spreadButtonBlock = ^(UIButton *button ){
        [weakSelf UpSpreadbuttonPress:button];
    };
    switch (indexPath.section) {
        case 0:{
            //主题空间离线包
            //            [upCell setCellType:kUpCellType];
            //添加展开按钮
            [upCell setCellType:kDownCellType];
            upCell.spreadButton.tag =indexPath.row+ KListUpButtonSpreadTag;
            
            if (_cellViewModel.sceneCellStatusArray.count>0) {
                
                [upCell reloadCellTitle:_sceneViewModel.titleArray[indexPath.row] size:_sceneViewModel.sizeArray[indexPath.row]];
                upCell.rightButton.tag = indexPath.row+kListUpButtonTag;
            }
            
            if (_cellViewModel.sceneCellStatusArray.count>0) {
                //设置Button状态
                [upCell setCellMode:[_cellViewModel getButtonStatus:_cellViewModel.sceneCellStatusArray[indexPath.row]]];
                //设置进度条状态
                [upCell reloadProgressView:[_cellViewModel getProgress:_cellViewModel.sceneCellStatusArray[indexPath.row]] isDownload:[_cellViewModel getIsDownloading:_cellViewModel.sceneCellStatusArray[indexPath.row]]];
                //进度条回调
//                __block ZDHListView *selfView = self;
                _cellViewModel.processBlock = ^(CGFloat progress,NSString *urlString){
                    
                    [weakSelf reloadCellProgress:progress urlString:urlString];
                };
            }
        }
            break;
        case 1:{
            //布板
            [upCell setCellType:kDownCellType];
            [upCell setCellMode:kStartDownloadMode];
            [upCell reloadCellTitle:_clothesViewModel.titleArray[indexPath.row] size:_clothesViewModel.sizeArray[indexPath.row]];
            upCell.spreadButton.tag = indexPath.row + kListDownSpreadButtonTag;
            
            if (_cellViewModel.clothesCellStatusArray.count>0) {
                
                [upCell reloadCellTitle:_clothesViewModel.titleArray[indexPath.row] size:_clothesViewModel.sizeArray[indexPath.row]];
                upCell.rightButton.tag = indexPath.row+kListDownButtonTag;
            }
            if (_cellViewModel.clothesCellStatusArray.count>0) {
                //设置Button状态
                [upCell setCellMode:[_cellViewModel getButtonStatus:_cellViewModel.clothesCellStatusArray[indexPath.row]]];
                //设置进度条状态
                [upCell reloadProgressView:[_cellViewModel getProgress:_cellViewModel.clothesCellStatusArray[indexPath.row]] isDownload:[_cellViewModel getIsDownloading:_cellViewModel.clothesCellStatusArray[indexPath.row]]];
                //进度条回调
//                __block ZDHListView *selfView = self;
                _cellViewModel.processBlock = ^(CGFloat progress,NSString *urlString){
                    [weakSelf reloadCellProgress:progress urlString:urlString];
                };
            }
        }
            break;
        default:
            break;
    }
    return upCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}
//UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 22;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 75;
    }else{
        return 50;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc] init];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:25];
    nameLabel.backgroundColor = LIGHTGRAY;
    [backView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
        make.left.equalTo(20);
        make.right.equalTo(-20);
        make.height.equalTo(50);
    }];
    switch (section) {
        case 0:
            nameLabel.text = _firstSectionName;
            break;
        case 1:
            nameLabel.text = _secondSectionName;
            break;
        default:
            break;
    }
    return backView;
}
#pragma mark - Other methods
//停止全部任务
- (void)cancelAllDownload{
    [_cellViewModel cancelAllDownload];
}
//点击空间展开按钮
- (void)UpSpreadbuttonPress:(UIButton*)button {
    int selectedIndex;
    //点击展开空间按钮
    if (button.tag>=KListUpButtonSpreadTag &&button.tag<kListUpButtonTag) {
        //布版离线包的点开按钮
        selectedIndex = (int)(button.tag - KListUpButtonSpreadTag);
        for (int i = 0; i < [_tableView numberOfRowsInSection:0]; i ++) {
            if (i == selectedIndex) {
                button.selected = !button.selected;
            }else{
                UIButton *allButton = (UIButton *)[self viewWithTag:i+KListUpButtonSpreadTag];
                allButton.selected = NO;
            }
        }
        [self displayUpSpreadViewWithIndex:selectedIndex];
    }else if (button.tag >= kListDownSpreadButtonTag) {
        //布版离线包的点开按钮
        selectedIndex = (int)(button.tag - kListDownSpreadButtonTag);
        for (int i = 0; i < [_tableView numberOfRowsInSection:1]; i ++) {
            if (i == selectedIndex) {
                button.selected = !button.selected;
            }else{
                UIButton *allButton = (UIButton *)[self viewWithTag:i+kListDownSpreadButtonTag];
                allButton.selected = NO;
            }
        }
        [self displaySpreadViewWithIndex:selectedIndex];
    }
}
//显示空间Spread
- (void)displayUpSpreadViewWithIndex:(int)seleldIndex {
    
    if(_listViewModel.allpacksArray.count>0){
        
        NSString *string = _listViewModel.allpacksArray[seleldIndex];
        NSArray *dataArry = [string componentsSeparatedByString:@","];
        //获取当前SpreadButton
        UIButton *button = (UIButton *)[self viewWithTag:seleldIndex+KListUpButtonSpreadTag];
        if (dataArry.count >1) {
            if (button.selected) {
                if (_spreadView == nil) {
                    //SpreadView
                    _spreadView = [[ZDHListSpreadView alloc] init];
                    _spreadView.alpha = 0;
                    [self addSubview:_spreadView];
                    [_spreadView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(20);
                        make.height.equalTo(100);
                        make.bottom.equalTo(button.mas_top);
                    }];
                    [_spreadView reloadSpreadViewWithArray:dataArry];
                    [UIView animateWithDuration:0.5 animations:^{
                        _spreadView.alpha = 1;
                    }];
                }else{
                    [_spreadView removeFromSuperview];
                    _spreadView = nil;
                    //SpreadView
                    _spreadView = [[ZDHListSpreadView alloc] init];
                    _spreadView.alpha = 0;
                    [self addSubview:_spreadView];
                    [_spreadView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(20);
                        make.height.equalTo(100);
                        make.bottom.equalTo(button.mas_top);
                    }];
                    [_spreadView reloadSpreadViewWithArray:dataArry];
                    [UIView animateWithDuration:0.5 animations:^{
                        _spreadView.alpha = 1;
                    }];
                }
            }else{
                [_spreadView removeFromSuperview];
                _spreadView = nil;
            }
        }
        
    }
}

//显示布板SpreadView
- (void)displaySpreadViewWithIndex:(int)selectedIndex{
    
    if (_listViewModel.clothAllpacksArray.count>0) {
        
        NSString *string = _listViewModel.clothAllpacksArray[selectedIndex];
        NSArray *dataArry = [string componentsSeparatedByString:@","];
        //获取当前SpreadButton
        UIButton *button = (UIButton *)[self viewWithTag:selectedIndex+kListDownSpreadButtonTag];
        if (dataArry.count>1) {
            if (button.selected) {
                if (_spreadView == nil) {
                    //SpreadView
                    _spreadView = [[ZDHListSpreadView alloc] init];
                    _spreadView.alpha = 0;
                    [self addSubview:_spreadView];
                    [_spreadView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(20);
                        make.height.equalTo(100);
                        make.bottom.equalTo(button.mas_top);
                    }];
                    [_spreadView reloadSpreadViewWithArray:dataArry];
                    [UIView animateWithDuration:0.5 animations:^{
                        _spreadView.alpha = 1;
                    }];
                }else{
                    [_spreadView removeFromSuperview];
                    _spreadView = nil;
                    //SpreadView
                    _spreadView = [[ZDHListSpreadView alloc] init];
                    _spreadView.alpha = 0;
                    [self addSubview:_spreadView];
                    [_spreadView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(20);
                        make.height.equalTo(100);
                        make.bottom.equalTo(button.mas_top);
                    }];
                    [_spreadView reloadSpreadViewWithArray:dataArry];
                    [UIView animateWithDuration:0.5 animations:^{
                        _spreadView.alpha = 1;
                    }];
                }
            }else{
                [_spreadView removeFromSuperview];
                _spreadView = nil;
            }
        }
    }
}
//滑动的时候隐藏视图
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_spreadView) {
        [_spreadView removeFromSuperview];
        _spreadView = nil;
    }
}

- (void)isUnpackZIP:(NSString*)string {
    
    self.iSUnpackZIP = string;
    
}

//----------------------------------------------------
#pragma makr --- 重写隐藏方法;
- (void)setHidden:(BOOL)hidden {
    
    [super setHidden:hidden];
    if(hidden==NO)
        [_tableView.header beginRefreshing];
    
}
//----------------------------------------------------
//监听是否有更新信息
- (void)createnotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadUpdatemessage:) name:@"更新下载" object:nil];
}
- (void)downloadUpdatemessage:(NSNotification*)noti {
    if ([noti.name isEqualToString:@"更新下载"]) {
        
        //        ZDHListUpCell *cell =
        //        NSArray *array = noti.userInfo[@"更新"];
        //        if (array >0) {
        //            for (NSString *string in array) {
        //                if ([@"yes" isEqualToString:string]) {
        //                    _promptImage.hidden = NO;
        //                    return;
        //                }
        //            }
        //            _promptImage.hidden = YES;
        //        }
    }
}

@end