//
//  ZDHTopClassifyView.m
//  ZhiDa_Home
//
//  Created by apple on 16/3/13.
//  Copyright (c) 2016年 软碟技术. All rights reserved.
//

#import "ZDHTopClassifyView.h"
#import "Masonry.h"

#define TOPBUTTONTAG 50000

@interface ZDHTopClassifyView()

// 左边商品分类按钮
@property (strong, nonatomic) UIButton *btnGoodsClassify;
// 综合按钮
@property (strong, nonatomic) UIButton *btnComprehensive;
// 新品按钮
@property (strong, nonatomic) UIButton *btnNewGoods;
// 人气按钮
@property (strong, nonatomic) UIButton *btnPopularity;
// 品牌筛选按钮
@property (strong, nonatomic) UIButton *btnClassify;

@property (strong, nonatomic) UIView *bagroundView;

@property (strong, nonatomic) UIImageView *buttonImage;

@end

@implementation ZDHTopClassifyView

- (instancetype) init{
    
    if (self = [super init]) {
        self.backgroundColor = GRAY;
        [self createUI];
        [self createAutolayout];
        [self notificationCenter];
    }
    return self;
}

// 创建UI
- (void) createUI{
    
    _bagroundView = [[UIView alloc]init];
    [self addSubview:_bagroundView];
    
    _btnGoodsClassify = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnGoodsClassify.tag = TOPBUTTONTAG;
    _btnGoodsClassify.selected = NO;
    [_btnGoodsClassify setTitle:@"全部分类" forState:0];
    [_btnGoodsClassify setTitleColor:[UIColor blackColor] forState:0];
    [_btnGoodsClassify addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bagroundView addSubview:_btnGoodsClassify];
    
    _btnComprehensive = [[UIButton alloc]init];
     _btnComprehensive.backgroundColor = WHITE;
    _btnComprehensive.tag = TOPBUTTONTAG + 1;
    _btnComprehensive.selected = YES;
    [_btnComprehensive setTitle:@"综合" forState:0];
    [_btnComprehensive setTitleColor:[UIColor blackColor] forState:0];
    [_btnComprehensive setBackgroundImage:[UIImage imageNamed:@"search_topButton_selected"] forState:0];
    [_btnComprehensive addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bagroundView addSubview:_btnComprehensive];
    
    _btnNewGoods = [[UIButton alloc]init];
     _btnNewGoods.backgroundColor = WHITE;
    _btnNewGoods.tag = TOPBUTTONTAG + 2;
    [_btnNewGoods setTitle:@"新品" forState:0];
    [_btnNewGoods setTitleColor:[UIColor blackColor] forState:0];
    [_btnNewGoods addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bagroundView addSubview:_btnNewGoods];
    
    _btnPopularity = [[UIButton alloc]init];
     _btnPopularity.backgroundColor = WHITE;
    _btnPopularity.tag = TOPBUTTONTAG + 3;
    [_btnPopularity setTitle:@"人气" forState:0];
    [_btnPopularity setTitleColor:[UIColor blackColor] forState:0];
    [_btnPopularity addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bagroundView addSubview:_btnPopularity];
    
    _btnClassify = [[UIButton alloc]init];
    [_btnClassify setTitle:@"筛选" forState:0];
    _btnClassify.tag = TOPBUTTONTAG + 4;
    _btnClassify.selected = NO;
    [_btnClassify setTitleColor:[UIColor blackColor] forState:0];
    [_btnClassify setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_btnClassify setImage:[UIImage imageNamed:@"search_classify"] forState:0];
    [_btnClassify setImageEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 50)];
    [_btnClassify addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bagroundView addSubview:_btnClassify];
    
    _buttonImage = [[UIImageView alloc]init];
    _buttonImage.image = [UIImage imageNamed:@"search_goodsClassify_Normal"];
    [_bagroundView addSubview:_buttonImage];
}

// 添加约束
- (void)createAutolayout{
    
    __weak __typeof(self) weaks = self;
    
    [_bagroundView mas_makeConstraints:^(MASConstraintMaker *make){
       
        make.edges.equalTo(weaks);
    }];
    
    [_btnGoodsClassify mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.left.mas_equalTo(_bagroundView).offset(30);
        make.top.equalTo(_bagroundView.mas_top).offset(10);
        make.bottom.equalTo(_bagroundView.mas_bottom).offset(-10);
    }];
    
    [_buttonImage mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.mas_equalTo(_btnGoodsClassify.mas_right).offset(0);
        make.height.width.equalTo(_buttonImage.image.size);
        make.centerY.equalTo(_btnGoodsClassify.mas_centerY);
    }];
    
    
    [_btnComprehensive mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.right.mas_equalTo(_btnNewGoods.mas_left).offset(-20);
        make.width.mas_equalTo(80);
        make.top.equalTo(_bagroundView.mas_top).offset(10);
        make.bottom.equalTo(_bagroundView.mas_bottom).offset(-10);
    }];
    
    [_btnNewGoods mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.right.mas_equalTo(_btnPopularity.mas_left).offset(-20);
        make.width.mas_equalTo(80);
        make.top.equalTo(weaks.mas_top).offset(10);
        make.bottom.equalTo(weaks.mas_bottom).offset(-10);
        
    }];
    [_btnPopularity mas_makeConstraints:^(MASConstraintMaker *make){
        
        
        make.right.mas_equalTo(_btnClassify.mas_left).offset(-60);
        make.width.mas_equalTo(80);
        make.top.equalTo(_bagroundView.mas_top).offset(10);
        make.bottom.equalTo(_bagroundView.mas_bottom).offset(-10);
    
    }];
    
    [_btnClassify mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.right.mas_equalTo(_bagroundView.mas_right).offset(-80);
        make.width.mas_equalTo(80);
        make.top.equalTo(_bagroundView.mas_top).offset(15);
        make.bottom.equalTo(_bagroundView.mas_bottom).offset(-10);
    }];
}

- (void) buttonPressed:(UIButton *)btn{
    
    for (NSInteger i = 1; i < 4; i ++) {
        
        UIButton *btn1 = (UIButton *)[self viewWithTag:TOPBUTTONTAG + i];
        [btn1 setBackgroundImage:[UIImage imageNamed:@""] forState:0];
    }
    if ( btn.tag >= TOPBUTTONTAG + 1 && btn.tag <= TOPBUTTONTAG + 3) {
        
        [btn setBackgroundImage:[UIImage imageNamed:@"search_topButton_selected"] forState:0];
    }else{
        
        [_btnComprehensive setBackgroundImage:[UIImage imageNamed:@"search_topButton_selected"] forState:0];
        _btnComprehensive.selected = YES;
    }
    
    self.pressButton(btn);
    if (btn.selected) {
        
        btn.selected = NO;
    }
    else{
        btn.selected = YES;
    }
    // 发送通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHTopClassifyView" object:btn];
}

// 接收来自左边视图的通知
- (void) notificationCenter{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"ZDHSearchDropdownMenuView" object:nil];
    
    // 监听左边下拉列表cellcell的通知ZDHSearchDropdownMenuTableViewCell
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"ZDHSearchDropdownMenuTableViewCell" object:nil];
}

- (void) notificationResponse:(NSNotification *)notification{
    
    if ([notification.name isEqualToString:@"ZDHSearchDropdownMenuView"]){
        //筛选搜索
        NSString *title = [notification.userInfo valueForKey:@"typename"];
        [self loadLeftButtonTitleWithString:title];
    }
    if ([notification.name isEqualToString:@"ZDHSearchDropdownMenuTableViewCell"]) {
        
        NSString *title = [notification.userInfo valueForKey:@"title"];
        [self loadLeftButtonTitleWithString:title];
    }
}

// 刷新button的标题
- (void) loadLeftButtonTitleWithString:(NSString *)title{
    if(![title isEqualToString:@""] && title){
        
        [_btnGoodsClassify setTitle:title forState:0];
    }else{
        [_btnGoodsClassify setTitle:@"全部分类" forState:0];
    }
}
// 恢复按钮的默认设置
- (void) recoverSettingButtonSelected{
    
    for (NSInteger i = 1; i < 4; i ++) {
        
        UIButton *btn1 = (UIButton *)[self viewWithTag:TOPBUTTONTAG + i];
        [btn1 setBackgroundImage:[UIImage imageNamed:@""] forState:0];
    }
    [_btnComprehensive setBackgroundImage:[UIImage imageNamed:@"search_topButton_selected"] forState:0];
    _btnComprehensive.selected = YES;
}

@end







