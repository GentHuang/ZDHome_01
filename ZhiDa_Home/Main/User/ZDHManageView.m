//
//  ZDHManageView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//View
#import "ZDHManageView.h"
#import "ZDHManageCell.h"
//Lib
#import "Masonry.h"
//ViewModel
#import "ZDHManageViewViewModel.h"
//Model
#import "ZDHListViewSceneModel.h"
#import "ZDHListViewClothesModel.h"
#import "ZDHLIstViewCellViewModel.h"

#import "ZDHListViewViewModel.h"
#import "ZDHLIstViewSceneViewModel.h"
#import "ZDHLIstViewClothesViewModel.h"
#import "ZDHLIstViewCellViewModel.h"

//Cell状态
#import "ZDHLIstViewCellStatus.h"
@interface ZDHManageView()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (assign, nonatomic) int selectedIndex;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ZDHManageViewViewModel *cellViewModel;

@property (strong, nonatomic) NSMutableArray *isCanUpdataArr;
@property (strong, nonatomic) ZDHLIstViewCellViewModel *cellListViewModel;

@end

@implementation ZDHManageView
#pragma mark - Init methods
- (void)initData{
    //cellViewModel
    _cellViewModel = [[ZDHManageViewViewModel alloc] init];
//----------------------添加-------------------------
    _cellListViewModel = [[ZDHLIstViewCellViewModel alloc]init];
}
- (instancetype)init{
    if (self = [super init]) {
        [self initData];
        [self createUI];
        [self setSubViewLayout];
        //提示更新通知
        
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
//    __block ZDHManageView *selfView = self;
    self.backgroundColor = WHITE;
    //TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = WHITE;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[ZDHManageCell class] forCellReuseIdentifier:@"Cell"];
    [self addSubview:_tableView];
    //下拉刷新
    __weak __typeof(self) weakSelf = self;
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDataList];
    }];
    [self.tableView.header beginRefreshing];
    
    //回调是否解压
//    __block ZDHManageView *selfVC = self;
    _cellListViewModel.FinisUpZIP = ^(NSString*finishString){
        
//        [selfVC  isUnpackZIP:finishString];
    };
}
- (void)setSubViewLayout{
    //TableView
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.and.top.equalTo(0);
    }];
}
//更新提示通知
- (void)creatMessgeNotification {
    if(_cellViewModel.iSButtonCanClikArr.count>0){
    //发送提示更新通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"更新下载" object:self userInfo:@{@"更新":_cellViewModel.iSButtonCanClikArr}];
    }
}
#pragma mark - Event response
//点击按钮
- (void)buttonPressed:(UIButton *)button{
    UIView *contentView = (UIView *)[button superview];
    ZDHManageCell *cell = (ZDHManageCell *)[contentView superview];
    NSIndexPath *path = [_tableView indexPathForCell:cell];
    _selectedIndex = (int)path.row;
    //------------------创建Cell状态------------------------
    ZDHLIstViewCellStatus *cellStatus = _cellListViewModel.cellStatusArray[path.row];
    //取出下载模型
    ZDHListViewClothesModel *downloadModel= _cellViewModel.canUpdataModelArr[path.row];
    if (button == cell.deleteButton) {
        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否删除%@",downloadModel.name]
                                                        delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alView show];
    }
    //如果是可以更新的执行一下方法
    else if (button==cell.updateButton){
        //从最新网络连接取出下载的链接
        //放入下载队列
        //开始下载
        if(cellStatus.isStart){
            [cellStatus setIsStop];
            cellStatus.isDownloading = YES;
            [_cellListViewModel getIntoDownloadQueue:downloadModel.downurl titleText:downloadModel.name];
        }//取消下载
        else if(cellStatus.isStop){
            //暂停下载
            [cellStatus setisContinue];
            cellStatus.isDownloading = NO;
            [_cellListViewModel pauseDownload:downloadModel.downurl];
        }//继续下载
        else if(cellStatus.isContinue){
            [cellStatus setIsStop];
            cellStatus.isDownloading = YES;
            [_cellListViewModel getIntoDownloadQueue:downloadModel.downurl titleText:downloadModel.name];
        }
        //设置Button状态
        [cell setCellMode:[_cellListViewModel getButtonStatus:_cellListViewModel.cellStatusArray[path.row]]];
        [_tableView reloadData];
    }
}
#pragma mark - Network request
//获取服务器下载列表（用于检查是否有更新）
- (void)getDataList{
    
    __block ZDHManageViewViewModel *selfViewModel = _cellViewModel;
    __block ZDHManageView *selfView = self;
    [_cellViewModel getDowloadedFileList];
    //获取下载列表
    [_cellViewModel getSceneDownloadListWithUrlSuccess:^(NSMutableArray *resultArray) {
        NSLog(@"获取下载列表---->%@",kSceneDownloadListAPI);
        //获取成功
        [selfViewModel getClothesDownloadListSuccess:^(NSMutableArray *resultArray) {
            NSLog(@"获取布板下载列表---->%@",kClothesDownloadListAPI);
            //获取更新列表
            [selfViewModel getUpdataListSuccess:^(NSMutableArray *resultArray) {
                //判断cell是否可更新
                [_cellViewModel judgeCelliSCanUpdate];
                //获取cell的状态
                [_cellListViewModel storedDataWith:_cellViewModel.canUpdataModelArr withNetModel:_cellViewModel.dataModelFromNetArr];
                //发出通知
                [selfView creatMessgeNotification];
                //获取成功
                [selfView.tableView reloadData];
                [selfView.tableView.header endRefreshing];
            } fail:^(NSError *error) {
                //获取失败
                [selfView.tableView reloadData];
                [selfView.tableView.header endRefreshing];
            }];
        } fail:^(NSError *error) {
            //获取失败
            [selfView.tableView reloadData];
            [selfView.tableView.header endRefreshing];
        }];
    } fail:^(NSError *error) {
        //获取失败
        [selfView.tableView reloadData];
        [selfView.tableView.header endRefreshing];
    }];
}
#pragma mark - Protocol methods
//UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_cellViewModel.titleArray.count > 0) {
        return _cellViewModel.canUpdataModelArr.count;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDHManageCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Cell.buttonBlock = ^(UIButton *button){
        [self buttonPressed:button];
    };
    if (_cellViewModel.DownloadUrlArr.count > 0) {
        //加载数据
        ZDHListViewClothesModel *model = _cellViewModel.canUpdataModelArr[indexPath.row];
        [Cell reloadCellTitle:model.name size:[NSString stringWithFormat:@"%.02fMB",[model.size floatValue]/1024.0]];
        //设置Button状态
        if(_cellListViewModel.cellStatusArray.count>0)
        [Cell setCellMode:[_cellListViewModel getButtonStatus:_cellListViewModel.cellStatusArray[indexPath.row]]];
        //设置Cell的button是否可以已点击状态
        [Cell canUpdata:_cellViewModel.iSButtonCanClikArr[indexPath.row]];
        // 进度条状态
        [Cell reloadProgressView:[_cellListViewModel getProgress:_cellListViewModel.cellStatusArray[indexPath.row]] isDownload:[_cellListViewModel getIsDownloading:_cellListViewModel.cellStatusArray[indexPath.row]]];
        //进度条回调
        __block ZDHManageView *selfView = self;
        _cellListViewModel.processBlock = ^(CGFloat progress,NSString *urlString){
            [selfView reloadCellProgress:progress urlString:urlString];
        };
    }
    return Cell;
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
    return 75;
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
    nameLabel.text = @"已下载离线包";
    return backView;
}
//UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
     ZDHListViewClothesModel *model = _cellViewModel.canUpdataModelArr[_selectedIndex];
    switch (buttonIndex) {
        case 0:{
            //删除数据库的数据
            [_cellListViewModel removeObjectWithName:model.name];
            //删除对应的本地文件
//            [_cellViewModel deleteFile:model.name];
            [self deleteMangerFile:model.name withIndex:_selectedIndex];
            //删除对应模型
            [_cellViewModel.canUpdataModelArr removeObjectAtIndex:_selectedIndex];
            //删除对应cell的状态
            [_cellListViewModel.cellStatusArray removeObjectAtIndex:_selectedIndex];
            //移除Button状态
            if (_cellViewModel.iSButtonCanClikArr.count>0) {
                [_cellViewModel.iSButtonCanClikArr removeObjectAtIndex:_selectedIndex];
            }
            [self reloadData];
        }
            break;
        case 1:
            break;
        default:
            break;
    }
}
//----------------------------------------------------
#pragma makr --- 重写隐藏方法;
- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if(hidden==NO)
        [_tableView.header beginRefreshing];
}
#pragma mark ZJ Add method
//回调更新进度条
- (void)reloadCellProgress:(CGFloat)progress urlString:(NSString *)urlString{
    ZDHLIstViewCellStatus *cellStatus;
    ZDHManageCell *upCell;
    int selectedIndex;
    for (NSString *Url in _cellViewModel.DownloadUrlArr) {
        if([Url isEqualToString:urlString]){
            selectedIndex = (int)[_cellViewModel.DownloadUrlArr indexOfObject:Url];
            upCell = (ZDHManageCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
            cellStatus = _cellListViewModel.cellStatusArray[selectedIndex];
            cellStatus.progress = progress;
        }
    }
    [upCell reloadProgressView:progress isDownload:cellStatus.isDownloading];
}
- (void)reloadData{
    //发出通知
    [self creatMessgeNotification];
    [_tableView reloadData];
}
//停止全部任务
- (void)cancelAllDownload{
    [_cellListViewModel cancelAllDownload];
}

//弹出下载任务 删除文件
- (void)deleteMangerFile:(NSString *)title withIndex:(NSInteger)delecteIndex{
    //弹出所有的下载任务
    for (NSString *url in _cellViewModel.DownloadUrlArr) {
        [_cellListViewModel pauseDownload:url];
    }
    //删除 URL
    [_cellViewModel.DownloadUrlArr removeObjectAtIndex:delecteIndex];
    //删除存在的压缩包
    NSFileManager *manager = _cellViewModel.manager;
    NSString *path = [_cellListViewModel getDownloadPath:title];
    [manager removeItemAtPath:path error:nil];
    //删除对应的文件
    [_cellViewModel deleteFile:title];
}

#pragma mark cellStatus

@end
