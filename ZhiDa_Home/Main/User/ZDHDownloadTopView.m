//
//  ZDHDownloadTopView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHDownloadTopView.h"
//Libs
#import "Masonry.h"

@interface ZDHDownloadTopView()
@property (assign, nonatomic) int selectedIndex;
@property (strong, nonatomic) UIButton *listButton;
@property (strong, nonatomic) UIButton *manageButton;
@property (strong, nonatomic) UIView *lineView;
//红色提示图标
@property (strong, nonatomic) UIImageView *promptImage;
@end

@implementation ZDHDownloadTopView
#pragma mark - Init methods
-(instancetype)init{
    if (self = [super init]) {
        [self createUI];
        [self setSubViewLayout];
        //添加通知
        [self createnotification];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    self.backgroundColor = WHITE;
    //分割线
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = LIGHTGRAY;
    [self addSubview:_lineView];
    //下载列表
    _listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_listButton setBackgroundImage:[UIImage imageNamed:@"vip_btn_list_nol" ] forState:UIControlStateNormal];
    [_listButton setBackgroundImage:[UIImage imageNamed:@"vip_btn_list_sel" ] forState:UIControlStateSelected];
    [_listButton addTarget:self action:@selector(topButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _listButton.selected = YES;
    [self addSubview:_listButton];
    //下载管理
    _manageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_manageButton setBackgroundImage:[UIImage imageNamed:@"vip_btn_man_nol"] forState:UIControlStateNormal];
    [_manageButton setBackgroundImage:[UIImage imageNamed:@"vip_btn_man_sel"] forState:UIControlStateSelected];
    [_manageButton addTarget:self action:@selector(topButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_manageButton];
    
    //提示更新小圆点
    _promptImage = [[UIImageView alloc]init];
    _promptImage.backgroundColor = [UIColor redColor];
    [_manageButton addSubview:_promptImage];
    //圆角半径
    _promptImage.layer.cornerRadius = 7;
    _promptImage.hidden = YES;
}
- (void)setSubViewLayout{
    //分割线
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(0);
        make.bottom.equalTo(-1);
        make.height.equalTo(1);
    }];
    //下载列表
    [_listButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(115);
        make.height.equalTo(35);
        make.left.equalTo(576/2);
    }];
    //下载管理
    [_manageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_listButton);
        make.top.equalTo(_listButton.mas_top);
        make.right.equalTo(-576/2);
    }];
    
    //提示小标点
    [_promptImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(14);
        make.width.height.equalTo(14);
        make.top.equalTo(_manageButton.mas_top);
        make.right.equalTo(_manageButton.mas_right);
    }];
}
#pragma mark - Event response
//点击按钮
- (void)topButtonPressed:(UIButton *)button{
    _listButton.selected = NO;
    _manageButton.selected = NO;
    button.selected = YES;
    if (button == _listButton) {
        self.selectedIndex = 0;
    }else if(button == _manageButton){
        self.selectedIndex = 1;
    }else{
        self.selectedIndex = 2;
    }
}
- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
//监听是否有更新信息
- (void)createnotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadUpdatemessage:) name:@"更新下载" object:nil];
}
- (void)downloadUpdatemessage:(NSNotification*)noti {
    if ([noti.name isEqualToString:@"更新下载"]) {
        
        NSArray *array = noti.userInfo[@"更新"];
        if (array >0) {
            for (NSString *string in array) {
                if ([@"yes" isEqualToString:string]) {
                    _promptImage.hidden = NO;
                    return;
                }
            }
            _promptImage.hidden = YES;
        }
    }
}
//解压过程中不能切换管理界面
- (void)iSUnpackZIPNotSwitch {
    _manageButton.enabled = NO;
}
- (void)iSFinishZIP {
    _manageButton.enabled = YES;
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
@end
