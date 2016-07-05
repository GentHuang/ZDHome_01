//
//  ZDHNavHomePageView.m
//  
//
//  Created by apple on 16/3/26.
//
//

#import "ZDHNavHomePageView.h"
#import "Masonry.h"
//临时
#import "ZDHUser.h"
//Macros
#define kRightButtonTag 60000
#define kButtonWidth 64
@interface ZDHNavHomePageView()

@property (strong, nonatomic) UIView *rightView;
@property (strong, nonatomic) NSArray *buttonNorName;
@property (strong, nonatomic) NSArray *buttonSelName;
//临时
@property (strong, nonatomic) ZDHUser *user;
// 防止通知冲突
@property  (assign,nonatomic) BOOL isNotiFirst;

@end

@implementation ZDHNavHomePageView
#pragma mark - Init methods
- (void)initData{
    _buttonNorName = @[[UIImage imageNamed:@"nav_classify_pull"],[UIImage imageNamed:@"btn_product_nor"],[UIImage imageNamed:@"btn_user_nor"],[UIImage imageNamed:@"btn_config_nor"]];
    _buttonSelName = @[[UIImage imageNamed:@"btn_home_sel"],[UIImage imageNamed:@"btn_product_sel"],[UIImage imageNamed:@"btn_user_sel"],[UIImage imageNamed:@"btn_config_sel"]];
}
-(instancetype)init{
    if (self = [super init]) {
        
        [self initData];
        [self createTabBar];
        [self setSubViewsLayout];
        //临时
        _user = [ZDHUser getCurrUser];
    }
    return self;
}

#pragma mark - Getters and setters
- (void)createTabBar{
    //创建TabBar
    _rightView = [[UIView alloc] init];
    _rightView.backgroundColor = [UIColor clearColor];
    _rightView.userInteractionEnabled = YES;
    [self addSubview:_rightView];
}
- (void)setSubViewsLayout{
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.width.equalTo(@(kButtonWidth*4));
        make.height.equalTo(@NAV_HEIGHT);
    }];
    //创建TabBar
    for (int i = 0; i < 4; i ++) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setBackgroundImage:_buttonNorName[i] forState:UIControlStateNormal];
        //        [rightButton setBackgroundImage:_buttonSelName[i] forState:UIControlStateSelected];
        [rightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setTag:(i+kRightButtonTag)];
        if (i == 0) {
            rightButton.selected = YES;
        }
        
        [_rightView addSubview:rightButton];
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@(i*kButtonWidth));
            make.width.equalTo(@kButtonWidth);
            make.bottom.equalTo(@0);
        }];
    }
}

#pragma mark - Event response
//点击按钮
- (void)rightButtonPressed:(UIButton *)button{

    for (int i = 0; i < 4; i ++) {
        UIButton *tmpButton = (UIButton *)[self viewWithTag:(i+kRightButtonTag)];
        tmpButton.selected = NO;
    }
    UIButton *tmpButton = (UIButton *)[self viewWithTag:(2+kRightButtonTag)];
    tmpButton.selected = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHNavigationHomePullView" object:self userInfo:@{@"selectedButton":button,@"naviStyle":@"1"}];
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//隐藏TabBar
- (void)hideTabBar{
    
    _rightView.hidden = YES;
}
//显示TabBar
- (void)showTabBar{
    _rightView.hidden = NO;
}
//用户退出
- (void)logoutAction{
    
    for (int i = 0; i < 4; i ++) {
        UIButton *tmpButton = (UIButton *)[self viewWithTag:(i+kRightButtonTag)];
        tmpButton.selected = NO;
    }
    UIButton *tmpButton = (UIButton *)[self viewWithTag:(0+kRightButtonTag)];
    tmpButton.selected = YES;
}



@end
