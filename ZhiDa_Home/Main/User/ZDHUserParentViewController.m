//
//  ZDHUserParentViewController.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Controllers
#import "ZDHUserParentViewController.h"
//Views
#import "ZDHParentHeaderCell.h"
#import "ZDHParentOtherCell.h"
#import "ZDHParentFooterCell.h"
//Libs
#import "Masonry.h"

//获取账号
#import "ZDHLogView.h"
//Macros
#define kLeftTableViewWidth 180
#define kHeaderCellHeight 108
#define kOtherCellHeight 60
@interface ZDHUserParentViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSArray *nameArray;
@property (assign, nonatomic) int selectedIndex;
@property (strong, nonatomic) UIImageView *shadowImageView;
@property (strong, nonatomic) UIImage *shadowImage;

@property (strong, nonatomic) ZDHLogView *userName;
@end
@implementation ZDHUserParentViewController
#pragma mark - Init methods
- (void)initData{
    _nameArray = @[@"电子布板",@"我的工单",@"内部资讯",@"离线下载"];
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
    self.view.backgroundColor = WHITE;
    //LeftView
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _leftTableView.backgroundColor = LIGHTGRAY;
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.scrollEnabled = NO;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_leftTableView registerClass:[ZDHParentOtherCell class] forCellReuseIdentifier:@"OtherCell"];
    [_leftTableView registerClass:[ZDHParentFooterCell class] forCellReuseIdentifier:@"FooterCell"];
    [_leftTableView registerClass:[ZDHParentHeaderCell class] forCellReuseIdentifier:@"HeaderCell"];
    [_leftTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.view addSubview:_leftTableView];
    //阴影
    _shadowImageView = [[UIImageView alloc] init];
    _shadowImage = [UIImage imageNamed:@"vip_left_shadow"];
    _shadowImageView.image = _shadowImage;
    [self.view addSubview:_shadowImageView];
    _userName = [[ZDHLogView alloc]init];
    
    [super createSuperUI];
}
- (void)setSubViewLayout{
    [super setSuperSubViewLayout];
    //LeftView
    [_leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NAV_HEIGHT+STA_HEIGHT));
        make.bottom.equalTo(0);
        make.left.equalTo(0);
        make.width.equalTo(@kLeftTableViewWidth);
    }];
    //阴影
    [_shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_shadowImage.size.width);
        make.bottom.equalTo(0);
        make.top.equalTo(@(STA_HEIGHT+NAV_HEIGHT));
        make.left.equalTo(_leftTableView.mas_right);
    }];
}
- (void)setNavigationBar{
    [self.currNavigationController setNavigationBarMode:kNavigationBarDIYMode];
    [self.currNavigationController setDetailTitleLabelWithString:@"会员中心"];
}

#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
//UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        ZDHParentHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
        headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        //显示用户名
        headerCell.nameLabel.text = [ZDHSellMan shareInstance].realName;
        //测试使用
        if (headerCell.nameLabel.text==nil) {
            headerCell.nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"用户名"];
             NSLog(@"用户名%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"用户名"]);
        }
        cell = headerCell;
    }else if(indexPath.row < 5){
        ZDHParentOtherCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"OtherCell"];
        [otherCell reloadCellWithName:_nameArray[indexPath.row-1]];
        if (indexPath.row==4) {
            //创建一个红色提示按钮
            [otherCell creatUpdateImageView];
        }
        cell = otherCell;
    }else{
        ZDHParentFooterCell *footerCell = [tableView dequeueReusableCellWithIdentifier:@"FooterCell"];
        footerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = footerCell;
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor];
    return cell;
}
//UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return kHeaderCellHeight;
    }else if(indexPath.row < 5){
        return kOtherCellHeight;
    }else{
        return 337;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = (int)indexPath.row;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHUserParentViewController" object:self userInfo:@{@"selectedIndex":[NSNumber numberWithInt:self.selectedIndex]}];
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 5) {
        return nil;
    }else{
        return indexPath;
    }
}
#pragma mark - Other methods
//刷新数据
- (void)reloadData{
    [_leftTableView reloadData];
}
@end
