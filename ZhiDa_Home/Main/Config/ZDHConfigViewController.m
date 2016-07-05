//
//  ZDHConfigViewController.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Controller
#import "ZDHConfigViewController.h"
#import "ZDHAboutViewController.h"
//View
#import "ZDHConfigUpCell.h"
#import "ZDHConfigDownCell.h"
#import "ZDHAboutPopUpView.h"
//ViewModel
#import "ZDHConfigUpCellViewModel.h"
//Lib
#import "Masonry.h"
@interface ZDHConfigViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *downArray;
@property (strong, nonatomic) ZDHConfigUpCellViewModel *upViewModel;
@property (strong, nonatomic) ZDHAboutPopUpView *popUpView;
@end

@implementation ZDHConfigViewController
#pragma mark - Init methods
- (void)initData{
    _downArray = @[@"给个好评",@"当前版本",@"关于志达"];
}
-(instancetype)init{
    if (self = [super init]) {
        [self initData];
    }
    return self;
}
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self setSubViewLayout];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBar];
    [self getCatheSize];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Getters and setters
- (void)createUI{
    self.view.backgroundColor = WHITE;
    //TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = WHITE;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[ZDHConfigUpCell class] forCellReuseIdentifier:@"UpCell"];
    [_tableView registerClass:[ZDHConfigDownCell class] forCellReuseIdentifier:@"DownCell"];
    [self.view addSubview:_tableView];

    [super createSuperUI];
}
- (void)setSubViewLayout{
    [super setSuperSubViewLayout];
    
    _popUpView = [[ZDHAboutPopUpView alloc]init];
    _popUpView.hidden = YES;
    _popUpView.layer.cornerRadius = 5.0;
    [self.view addSubview:_popUpView];
    [_popUpView mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.mas_equalTo(550);
        make.width.mas_equalTo(650);
        make.center.equalTo(self.view);
    }];
    //TableView
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NAV_HEIGHT));
        make.left.and.right.and.bottom.equalTo(0);
    }];
}
- (void)setNavigationBar{
    [self.currNavigationController setNavigationBarMode:kNavigationBarDIYMode];
    [self.currNavigationController setDetailTitleLabelWithString:@"设置"];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
//UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        default:
            return 0;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
        {
            ZDHConfigUpCell *upCell = [tableView dequeueReusableCellWithIdentifier:@"UpCell"];
            [upCell reloadSizeLabel:_upViewModel.sizeString];
            cell = upCell;
        }
            break;
        case 1:
        {
            ZDHConfigDownCell *downCell = [tableView dequeueReusableCellWithIdentifier:@"DownCell"];
            [downCell setTitle:_downArray[indexPath.row]];
            [downCell setCellMode:kImageMode];
            if (indexPath.row == 1) {
                [downCell setCellMode:kVersionMode];
                // 版本号
                NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                [downCell setVersionLabelWithString:[NSString stringWithFormat:@"V%@",version]];
            }
            cell = downCell;
        }
            break;
        default:
            return cell;
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}
//UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            if([_upViewModel.sizeString isEqualToString:@"0"]){
                UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"缓存大小为%@M,不需要清理",_upViewModel.sizeString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alView show];
            }else{
                UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"缓存大小为%@M,确定要清理缓存吗",_upViewModel.sizeString] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                [alView show];
            }
        }
            break;
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/zhi-da-jia-ju/id991665037?mt=8"];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                }
                    break;
                case 2:{
                    UIView *backGroundView = [[UIView alloc]init];
                    backGroundView.backgroundColor = [UIColor grayColor];
                    backGroundView.alpha = 0.7;
                    [self.view addSubview:backGroundView];
                    [backGroundView mas_makeConstraints:^(MASConstraintMaker *make){
                        
                        make.edges.equalTo(self.view);
                    }];
                    [self.view insertSubview:_popUpView aboveSubview:backGroundView];
                    _popUpView.hidden = NO;
                    [_popUpView popUpViewAboutZDHWithBackGroundView:backGroundView];
//                    ZDHAboutViewController *aboutVC = [[ZDHAboutViewController alloc] init];
//                    aboutVC.currNavigationController = self.currNavigationController;
//                    aboutVC.appDelegate = self.appDelegate;
//                    [self.currNavigationController pushViewController:aboutVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    
    
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
            nameLabel.text = @"应用设置";
            break;
        case 1:
            nameLabel.text = @"其他设置";
            break;
        default:
            break;
    }
    return backView;
}
//UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [_upViewModel clearCache];
        [self getCatheSize];
        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:nil message:@"清理成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alView show];
    }
}
#pragma mark - Other methods
//获取缓存大小
- (void)getCatheSize{
    //UpViewModel(用于获取缓存大小)
    _upViewModel = [[ZDHConfigUpCellViewModel alloc] init];
    [_tableView reloadData];
}
@end
