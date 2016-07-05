//
//  ZDHDownLoadView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHDownLoadView.h"
#import "ZDHDownloadTopView.h"
#import "ZDHListView.h"
#import "ZDHManageView.h"
//Libs
#import "Masonry.h"
typedef enum{
    kListViewMode,
    kManageViewMode
}DownloadViewMode;
@interface ZDHDownLoadView()
@property (strong, nonatomic) ZDHDownloadTopView *topView;
@property (strong, nonatomic) ZDHListView *listView;
@property (strong, nonatomic) ZDHManageView *manageView;
@end

@implementation ZDHDownLoadView
#pragma mark - Init methods
-(instancetype)init{
    if (self = [super init]) {
        [self createUI];
        [self setSubViewLayout];
        [self addObserver];
    }
    return self;
}
-(void)dealloc{
    [_topView removeObserver:self forKeyPath:@"selectedIndex"];
    [_listView removeObserver:self forKeyPath:@"iSUnpackZIP"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    self.backgroundColor = WHITE;
    //TopView
    _topView = [[ZDHDownloadTopView alloc] init];
    [self addSubview:_topView];
    //listView
    _listView = [[ZDHListView alloc] init];
    [self addSubview:_listView];
    //ManageView
    _manageView = [[ZDHManageView alloc] init];
    [self addSubview:_manageView];
    //初始化
    [self setDownloadViewMode:kListViewMode];
}
- (void)setSubViewLayout{
    //TopView
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(0);
        make.height.equalTo(60);
    }];
    //lisytView
    [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(0);
        make.top.equalTo(_topView.mas_bottom);
    }];
    //ManageView
    [_manageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(0);
        make.top.equalTo(_topView.mas_bottom);
    }];

}
#pragma mark - Event response
//添加观察者
- (void)addObserver{
    [_topView addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
    //观察是否在解压
    [_listView addObserver:self forKeyPath:@"iSUnpackZIP" options:NSKeyValueObservingOptionNew context:nil];
}
//观察者反馈
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if(object==_topView){
    int selectedIndex = [[change valueForKey:@"new"] intValue];
    [self setDownloadViewMode:selectedIndex];
    
    }else if (object==_listView){
        NSString *isCanSwitch = [change valueForKey:@"new"];
        if ([isCanSwitch isEqualToString:@"yes"]) {
            NSLog(@"===解压 %@",isCanSwitch);
            [_topView iSFinishZIP];
        }else {
            NSLog(@"===解压 %@",isCanSwitch);
            [_topView iSUnpackZIPNotSwitch];
        }
        
    }
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//选择ViewMode
- (void)setDownloadViewMode:(DownloadViewMode)mode{
    switch (mode) {
        case 0:
            [self setListViewMode];
            break;
        case 1:
            [self setManageViewMode];
            break;
        default:
            break;
    }
}
//listView
- (void)setListViewMode{
    _listView.hidden = NO;
    _manageView.hidden = YES;
    
}
//ManageView
- (void)setManageViewMode{
    _listView.hidden = YES;
    _manageView.hidden = NO;
}
//停止全部任务
- (void)cancelAllDownload{
    [_listView cancelAllDownload];
    //停止更新
    [_manageView cancelAllDownload];

}
@end
