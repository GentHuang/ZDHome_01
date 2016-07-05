//
//  ZDHGroupViewController.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

//Controller
#import "ZDHGroupViewController.h"
#import "ZDHOrderViewController.h"
//Libs
#import "Masonry.h"
//ViewModel
#import "ZDHGroupViewControllerViewModel.h"
//Macro
#define kImageTag 40000
#define kNameTag 41000
#define kJobTag 42000
#define kIntroTag 43000
@interface ZDHGroupViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *downImageView;
@property (strong, nonatomic) UIImageView *bannerImageView;
@property (strong, nonatomic) UILabel *groupNameLabel;
@property (strong, nonatomic) ZDHGroupViewControllerViewModel *vcViewModel;
@property (strong, nonatomic) UIImageView *mainDesignerImageView;
@property (strong, nonatomic) UIView *mainDesignerBackView;
@property (strong, nonatomic) UILabel *mainDesignerNameLabel;
@property (strong, nonatomic) UILabel *mainDesignerJobLabel;
@property (strong, nonatomic) UILabel *mainDesignerIntroLabel;
@property (strong, nonatomic) UIImageView *bottomImageView;
@end
@implementation ZDHGroupViewController
#pragma mark - Init methods
- (void)initData{
    //vcViewModel
    _vcViewModel = [[ZDHGroupViewControllerViewModel alloc] init];
}
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setNavigationBar];
    [self createUI];
    [self setSubViewLayout];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    
//    NSLog(@"----->对象释放");
}
#pragma mark - Getters and setters
- (void)setNavigationBar{
    [self.currNavigationController setNavigationBarMode:kNavigationBarDetailMode];
    [self.currNavigationController setDetailTitleLabelWithString:@"设计团队"];
}
- (void)createUI{
//    __block ZDHGroupViewController *selfVC = self;
    __weak __typeof(self) weakSelf = self;
    //scrollView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = WHITE;
    [self.view addSubview:_scrollView];
    //下拉刷新
    _scrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf getHeaderData];
    }];
    [_scrollView.header beginRefreshing];
    //contentView
    _contentView = [[UIView alloc] init];
    [_scrollView addSubview:_contentView];
    //顶部图片
    _bannerImageView = [[UIImageView alloc] initWithImage:nil];
    _bannerImageView.backgroundColor = CLEAR;
    [_contentView addSubview:_bannerImageView];
    //下部分背景
    _downImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"design_bg"]];
    [_contentView addSubview:_downImageView];
    //设计师团队
    _groupNameLabel = [[UILabel alloc] init];
    _groupNameLabel.text = @"设计师团队";
    _groupNameLabel.font = [UIFont boldSystemFontOfSize:45/2];
    [_downImageView addSubview:_groupNameLabel];
    //首席设计师图片
    _mainDesignerImageView = [[UIImageView alloc] init];
    _mainDesignerImageView.backgroundColor = CLEAR;
    [_downImageView addSubview:_mainDesignerImageView];
    //首席设计师背景(姓名，职业，简介)
    _mainDesignerBackView = [[UIView alloc] init];
    _mainDesignerBackView.backgroundColor = CLEAR;
    [_downImageView addSubview:_mainDesignerBackView];
    //首席设计师名字
    _mainDesignerNameLabel = [[UILabel alloc] init];
    _mainDesignerNameLabel.text = @"";
    _mainDesignerNameLabel.font = [UIFont boldSystemFontOfSize:45/2];
    [_mainDesignerBackView addSubview:_mainDesignerNameLabel];
    //首席设计师职位
    _mainDesignerJobLabel = [[UILabel alloc] init];
    _mainDesignerJobLabel.text = @"";
    _mainDesignerJobLabel.font = [UIFont boldSystemFontOfSize:28/2];
    [_mainDesignerBackView addSubview:_mainDesignerJobLabel];
    //首席设计师介绍
    _mainDesignerIntroLabel = [[UILabel alloc] init];
    _mainDesignerIntroLabel.text = @"";
    _mainDesignerIntroLabel.font = [UIFont systemFontOfSize:28/2];
    _mainDesignerIntroLabel.textColor = [UIColor darkGrayColor];
    _mainDesignerIntroLabel.numberOfLines = 0;
    [_mainDesignerBackView addSubview:_mainDesignerIntroLabel];
    
    //设计师团队信息
    for (int i = 0; i < 4; i ++) {
        //头像
        UIImageView *allImageView = [[UIImageView alloc] init];
        allImageView.contentMode = UIViewContentModeScaleAspectFit;
        allImageView.tag = i + kImageTag;
        allImageView.backgroundColor = CLEAR;
        [_downImageView addSubview:allImageView];
        [allImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_mainDesignerBackView.mas_bottom).with.offset((i/2)*(536/2)+162/2);
            make.left.mas_equalTo(_mainDesignerImageView.mas_left).with.offset((i%2)*(1017/2));
            make.width.mas_equalTo(310/2);
            make.height.mas_equalTo(299/2);
        }];
        //设计师背景(姓名，职业，简介)
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = CLEAR;
        [_downImageView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(allImageView.mas_top).with.offset(-15/2);
            make.bottom.mas_equalTo(allImageView.mas_bottom).with.offset(15/2);
            make.left.mas_equalTo(allImageView.mas_right).with.offset(112/2);
            make.width.mas_equalTo(543/2);
        }];
        //设计师名字
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = @"";
        nameLabel.tag = i + kNameTag;
        nameLabel.font = [UIFont boldSystemFontOfSize:45/2];
        [backView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        //首席设计师职位
        UILabel *jobLabel = [[UILabel alloc] init];
        jobLabel.text = @"";
        jobLabel.tag = i + kJobTag;
        jobLabel.font = [UIFont boldSystemFontOfSize:28/2];
        [backView addSubview:jobLabel];
        [jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        //首席设计师介绍
        UILabel *introLabel = [[UILabel alloc] init];
        introLabel.text = @"";
        introLabel.tag = i + kIntroTag;
        introLabel.font = [UIFont systemFontOfSize:28/2];
        introLabel.textColor = [UIColor darkGrayColor];
        introLabel.numberOfLines = 0;
        [backView addSubview:introLabel];
        [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(jobLabel.mas_bottom).with.offset(73/2);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }
    //马上预约
    _bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_img_order"]];
    _bottomImageView.userInteractionEnabled = YES;
    _bottomImageView.backgroundColor = CLEAR;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
    [_bottomImageView addGestureRecognizer:tap];
    [_contentView addSubview:_bottomImageView];
}
- (void)setSubViewLayout{
    __weak __typeof(self) weakSelf = self;
    //scrollView
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAV_HEIGHT);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    //下半部分背景
    [_downImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bannerImageView.mas_bottom);
    }];
    //马上预约
    [_bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.downImageView.mas_bottom).with.offset(70);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
    //contentView
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.scrollView);
        make.width.mas_equalTo(weakSelf.scrollView.mas_width);
        make.bottom.mas_equalTo(weakSelf.bottomImageView.mas_bottom);
    }];
    //顶部图片
    [_bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(234);
    }];
    //设计师团队
    [_groupNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(37/2);
        make.left.mas_equalTo(36/2);
    }];
    //首席设计师图片
    [_mainDesignerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(132/2);
        make.left.mas_equalTo(51/2);
        make.width.mas_equalTo(608/2);
        make.height.mas_equalTo(380/2);
    }];
    //首席设计师背景(姓名，职业，简介)
    [_mainDesignerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mainDesignerImageView.mas_top).with.offset(-15/2);
        make.bottom.mas_equalTo(weakSelf.mainDesignerImageView.mas_bottom).with.offset(15/2);
        make.left.mas_equalTo(weakSelf.mainDesignerImageView.mas_right).with.offset(112/2);
        make.right.mas_equalTo(0);
    }];
    //首席设计师名字
    [_mainDesignerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    //首席设计师职位
    [_mainDesignerJobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_mainDesignerNameLabel.mas_bottom);
        make.left.mas_equalTo(0);
    }];
    //首席设计师介绍
    [_mainDesignerIntroLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mainDesignerJobLabel.mas_bottom).with.offset(73/2);
        make.left.mas_equalTo(0);
    }];
}
#pragma mark - Init methods
#pragma mark - Life circle
#pragma mark - Getters and setters
#pragma mark - Event response
//点击图片跳转
- (void)imagePressed:(UITapGestureRecognizer *)tap{
    ZDHOrderViewController *orderVC = [[ZDHOrderViewController alloc] init];
    orderVC.currNavigationController = self.currNavigationController;
    orderVC.appDelegate = self.appDelegate;
    [self.currNavigationController pushViewController:orderVC animated:YES];
}
#pragma mark - Network request
//下拉获取数据
- (void)getHeaderData{
    __block ZDHGroupViewControllerViewModel *selfViewModel = _vcViewModel;
//    __block ZDHGroupViewController *selfVC = self;
    __weak __typeof(self) weakSelf = self;
    __block BOOL isBanner = NO;
    __block BOOL isMain = NO;
    __block BOOL isGroup = NO;
    //banner获取
    [_vcViewModel getBannerSuccess:^(NSMutableArray *resultArray) {
       //获取成功
        //刷新banner
        [weakSelf.bannerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:TESTIMGEURL,selfViewModel.dataBannerString]]];
        isBanner = YES;
        if (isBanner && isMain && isGroup) {
            [weakSelf.scrollView.header endRefreshing];
        }
    } fail:^(NSError *error) {
        //获取失败
        [weakSelf.scrollView.header endRefreshing];
    }];
    //首席设计师信息
    [_vcViewModel getMainDesignerSuccess:^(NSMutableArray *resultArray) {
        //获取成功
        //刷新首席设计师
        [weakSelf loadMainDesignerImage:selfViewModel.dataMainImageString name:selfViewModel.dataMainNameString job:selfViewModel.dataMainJobString intro:selfViewModel.dataMainIntroString];
        isMain = YES;
        if (isBanner && isMain && isGroup) {
            [weakSelf.scrollView.header endRefreshing];
        }
    } fail:^(NSError *error) {
        //获取失败
        [weakSelf.scrollView.header endRefreshing];
    }];
    //设计师团队
    [_vcViewModel getDesignerGroupSuccess:^(NSMutableArray *resultArray) {
        //获取成功
        //刷新设计师团队
        [weakSelf loadDesignerImageArray:selfViewModel.dataGroupImageArray name:selfViewModel.dataGroupNameArray job:selfViewModel.dataGroupJobArray intro:selfViewModel.dataGroupIntroArray];
        isGroup = YES;
        if (isBanner && isMain && isGroup) {
            
            [weakSelf.scrollView.header endRefreshing];
        }
    } fail:^(NSError *error) {
        //获取失败
        [weakSelf.scrollView.header endRefreshing];
    }];
}
#pragma mark - Protocol methods
#pragma mark - Other methods
//首席设计师信息
- (void)loadMainDesignerImage:(NSString *)imageString name:(NSString *)nameString job:(NSString *)jobString intro:(NSString *)introString{
    [_mainDesignerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:TESTIMGEURL,imageString]]];
    _mainDesignerNameLabel.text = nameString;
    _mainDesignerJobLabel.text = jobString;
    NSMutableAttributedString *introMutableString = [[NSMutableAttributedString alloc] initWithData:[introString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    _mainDesignerIntroLabel.text = introMutableString.string;
}
//设计师团队
- (void)loadDesignerImageArray:(NSArray *)imageArray name:(NSArray *)nameArray job:(NSArray *)jobArray intro:(NSArray *)introArray{
    
    for (int i = 0; i < imageArray.count; i ++) {
        UIImageView *allImageView = (UIImageView *)[self.view viewWithTag:i+kImageTag];
        [allImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:TESTIMGEURL,imageArray[i]]]];
        UILabel *nameLabel = (UILabel *)[self.view viewWithTag:i+kNameTag];
        nameLabel.text = nameArray[i];
        UILabel *jobLabel = (UILabel *)[self.view viewWithTag:i+kJobTag];
        jobLabel.text = jobArray[i];
        UILabel *introLabel = (UILabel *)[self.view viewWithTag:i+kIntroTag];
        NSMutableAttributedString *introMutableString = [[NSMutableAttributedString alloc] initWithData:[introArray[i] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        introLabel.text = introMutableString.string;
    }
}
@end
