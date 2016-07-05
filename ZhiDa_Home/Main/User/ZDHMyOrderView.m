//
//  ZDHMyOrderView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHMyOrderView.h"
#import "ZDHMyOrderTopView.h"
#import "ZDHOrderView.h"
#import "ZDHDesignView.h"
#import "ZDHProductView.h"
#import "ZDHOrderDetailView.h"
#import "ZDHDesignDetailView.h"
#import "ZDHProductDetailView.h"
//Libs
#import "Masonry.h"
typedef enum{
    kOrderViewMode,
    kDesignViewMode,
    kProductViewMode,
    kOrderDetailViewMode,
    kDesignDetailViewMode,
    kProductDetailViewMode
}MyOrderViewMode;
@interface ZDHMyOrderView()
@property (strong, nonatomic) NSString *orderID;
@property (strong, nonatomic) ZDHMyOrderTopView *topView;
@property (strong, nonatomic) ZDHOrderView *orderView;
@property (strong, nonatomic) ZDHDesignView *designView;
@property (strong, nonatomic) ZDHProductView *productView;
@property (strong, nonatomic) ZDHOrderDetailView *orderDetailView;
@property (strong, nonatomic) ZDHDesignDetailView *designDetailView;
@property (strong, nonatomic) ZDHProductDetailView *productDetailView;
@property (strong, nonatomic) NSString *statusString;
@end

@implementation ZDHMyOrderView
#pragma mark - Init methods
-(instancetype)init{
    if (self = [super init]) {
        [self createUI];
        [self setSubViewLayout];
        [self addObserver];
        [self notificationRecieve];
    }
    return self;
}
-(void)dealloc{
    [_topView removeObserver:self forKeyPath:@"selectedIndex"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    self.backgroundColor = WHITE;
    //TopView
    _topView = [[ZDHMyOrderTopView alloc] init];
    [self addSubview:_topView];
    //初始化
    [self setMyOrderViewMode:kOrderViewMode];
}
- (void)setSubViewLayout{
    //TopView
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(0);
        make.height.equalTo(60);
    }];
}
#pragma mark - Event response
//添加观察者
- (void)addObserver{
    [_topView addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
}
//观察者反馈
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    int selectedIndex = [[change valueForKey:@"new"] intValue];
    [self setMyOrderViewMode:selectedIndex];
}
//接收通知
- (void)notificationRecieve{
    //预约单详情
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"ZDHOrderCellDetail" object:nil];
    //预约单反馈
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"ZDHOrderCellResponse" object:nil];
    //设计单详情
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"ZDHDesignCellDetail" object:nil];
    //商品订单详情
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResponse:) name:@"ZDHProductCellDetail" object:nil];
}
//通知反馈
- (void)notificationResponse:(NSNotification *)notification{
    if ([notification.name isEqualToString:@"ZDHOrderCellDetail"]) {
        //预约单详情
        _orderID = [notification.userInfo valueForKey:@"orderID"];
        [self setMyOrderViewMode:kOrderDetailViewMode];
    }else if([notification.name isEqualToString:@"ZDHOrderCellResponse"]){
//        NSLog(@"=====ZDHOrderCellResponse");
    }else if([notification.name isEqualToString:@"ZDHDesignCellDetail"]){
        //设计单详情
        _orderID = [notification.userInfo valueForKey:@"orderID"];
        _statusString = [notification.userInfo valueForKey:@"status"];
        [self setMyOrderViewMode:kDesignDetailViewMode];
    }else if([notification.name isEqualToString:@"ZDHProductCellDetail"]){
        //商品订单详情
        _orderID = [notification.userInfo valueForKey:@"orderID"];
        
        [self setMyOrderViewMode:kProductDetailViewMode];
    }
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//选择ViewMode
- (void)setMyOrderViewMode:(MyOrderViewMode)mode{
    switch (mode) {
        case 0:
            [self setOrderViewMode];
            break;
        case 1:
            [self setDesignViewMode];
            break;
        case 2:
            [self setProductViewMode];
            break;
        case 3:
            [self setOrderDetailViewMode];
            break;
        case 4:
            [self setDesignDetailViewMode];
            break;
        case 5:
            [self setProductDetailViewMode];
            break;
        default:
            break;
    }
}
//预约单列表
- (void)setOrderViewMode{
    [self deleteAllSubView];
    //预约单列表
    _orderView = [[ZDHOrderView alloc] init];
    [self addSubview:_orderView];
    [_orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(0);
        make.top.equalTo(_topView.mas_bottom);
    }];
}
//设计单列表
- (void)setDesignViewMode{
    [self deleteAllSubView];
    //DesignView
    _designView = [[ZDHDesignView alloc] init];
    [self addSubview:_designView];
    [_designView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(0);
        make.top.equalTo(_topView.mas_bottom);
    }];
}
//商品列表
- (void)setProductViewMode{
    [self deleteAllSubView];
    //ProductView
    _productView = [[ZDHProductView alloc] init];
    [self addSubview:_productView];
    [_productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(0);
        make.top.equalTo(_topView.mas_bottom);
    }];
}
//预约单详情
- (void)setOrderDetailViewMode{
    [self deleteAllSubView];
    //预约单详情
    _orderDetailView = [[ZDHOrderDetailView alloc] init];
    _orderDetailView.orderID = _orderID;
    [self addSubview:_orderDetailView];
    [_orderDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(0);
        make.top.equalTo(_topView.mas_bottom);
    }];
}
//设计单详情
- (void)setDesignDetailViewMode{
    
    [self deleteAllSubView];
    //设计单详情
    _designDetailView = [[ZDHDesignDetailView alloc] init];
    _designDetailView.orderID = _orderID;
    [self addSubview:_designDetailView];
    [_designDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(0);
        make.top.equalTo(_topView.mas_bottom);
    }];
}
//商品订单详情
- (void)setProductDetailViewMode{
    [self deleteAllSubView];
    //商品订单详情
    _productDetailView = [[ZDHProductDetailView alloc] init];
    _productDetailView.orderID = _orderID;
    [self addSubview:_productDetailView];
    [_productDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(0);
        make.top.equalTo(_topView.mas_bottom);
    }];
}
//清空子View
- (void)deleteAllSubView{
    for(UIView *view in [self subviews])
    {
        if (view != _topView) {
            [view removeFromSuperview];
        }
    }
}
@end
