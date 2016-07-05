//
//  ZDHNavigationHomePullView.m
//  
//
//  Created by apple on 16/3/23.
//
//

#import "ZDHNavigationHomePullView.h"
#import "Masonry.h"

#define  kHomeViewButtonTag 60000

@interface ZDHNavigationHomePullView()

@property (strong, nonatomic) NSArray *imageNorArray;
@property (strong, nonatomic) NSArray *imageSelectedArray;

@end

@implementation ZDHNavigationHomePullView

- (void) initData{
    
    _imageNorArray = @[[UIImage imageNamed:@"nav_right_home_normal"],[UIImage imageNamed:@"nav_right_zd_normal"],[UIImage imageNamed:@"nav_right_user_normal"],[UIImage imageNamed:@"nav_right_setting_normal"]];
    _imageSelectedArray = @[[UIImage imageNamed:@"nav_right_home_selected"],[UIImage imageNamed:@"nav_right_zd_selected"],[UIImage imageNamed:@"nav_right_user_selected"],[UIImage imageNamed:@"nav_right_setting_selected"]];
}

- (instancetype) init{
    
    if (self = [super init]) {
        self.backgroundColor = PINKISHRED;
        [self initData];
        [self loadHomeViewButton];
    }
    return self;
}
// 下拉按钮
- (void) loadHomeViewButton{
    UIButton *lastButton = nil;
    for(NSInteger i = 0;i < 4; i++){
        
        UIButton *button = [[UIButton alloc]init];
        [button setBackgroundImage:_imageNorArray[i] forState:UIControlStateNormal];
        [button setBackgroundImage:_imageSelectedArray[i] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(returnHomePageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = kHomeViewButtonTag + i;
        button.hidden = YES;
        [self addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.right.equalTo(self).offset(0);
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).offset(i * 44);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(80);
        }];
        lastButton = button;
    }
}

#define  mark - event
- (void) returnHomePageButtonClick:(UIButton *)button{
    _isPullViewFlag = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHNavigationHomePullView" object:self userInfo:@{@"selectedButton":button,@"naviStyle":@"2"}];
}

@end










