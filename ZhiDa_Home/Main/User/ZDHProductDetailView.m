//
//  ZDHProductDetailView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHProductDetailView.h"
#import "ZDHProductDetailViewCell.h"
#import "ZDHProductDetailViewHeaderView.h"
//Libs
#import "Masonry.h"
//ViewModel
#import "ZDHProductViewDetailViewModel.h"
//Model
#import "ZDHProductViewDetailShopDetailModel.h"
#import "ZDHProductViewDetailShopDetailOtherlistModel.h"
#import "ZDHProductViewDetailShopDetailCurtainlistModel.h"
#import "ZDHProductViewDetailShopDetailFurniturelistModel.h"
#import "ZDHProductViewDetailShopDetailExpresslistModel.h"
#import "ZDHProductViewDetailShopDetailExpresslistErpexpressinfoModel.h"
//Macros
#define kTopLabelFont 18
#define kFirstCellHeight 400
#define kSecondCellHeight 200
@interface ZDHProductDetailView()<UITableViewDataSource,UITableViewDelegate>
{
    ZDHProductViewDetailShopDetailModel *detailModel ;
}
@property (strong, nonatomic) UILabel *topLabel;
@property (strong, nonatomic) UILabel *topContentLabel;
@property (strong, nonatomic) UIButton *caseButton;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) ZDHProductViewDetailViewModel *vcViewModel;

//临时
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImage *tmpImage;
@property (strong, nonatomic) UIImageView *tmpImageView;

@property (strong, nonatomic)  NSString *typeCell ;
@end
@implementation ZDHProductDetailView
#pragma mark - Init methods
- (void)initData{
    //vcViewModel
    _vcViewModel = [[ZDHProductViewDetailViewModel alloc] init];
   
}
-(instancetype)init{
    if (self = [super init]) {
        [self initData];
        [self createUI];
        [self setSubViewLayout];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    __block ZDHProductDetailView *selfView = self;
    self.backgroundColor = WHITE;
    //分割线
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = LIGHTGRAY;
    [self addSubview:_lineView];
    //TopLabel
    _topLabel = [[UILabel alloc] init];
    _topLabel.text = @"订单状态:";
    _topLabel.font = FONTSIZES(kTopLabelFont);
    [self addSubview:_topLabel];
    //TopContentLabel
    _topContentLabel = [[UILabel alloc] init];
    _topContentLabel.text = @"";
    _topContentLabel.font = FONTSIZES(kTopLabelFont);
    [self addSubview:_topContentLabel];
    //LogButton
    _caseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_caseButton addTarget:self action:@selector(topButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_caseButton setBackgroundImage:[UIImage imageNamed:@"vip_det_btn"] forState:UIControlStateNormal];
    [self addSubview:_caseButton];
    //TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = WHITE;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[ZDHProductDetailViewCell class] forCellReuseIdentifier:@"DetailCell"];
    [self addSubview:_tableView];
    //下拉刷新
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfView getData];
    }];
    [_tableView.header beginRefreshing];
}
- (void)setSubViewLayout{
    //TopLabel
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(25);
        make.left.equalTo(16);
        make.height.equalTo(@kTopLabelFont);
    }];
    //TopContentLabel
    [_topContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(25);
        make.left.equalTo(_topLabel.mas_right);
        make.height.equalTo(@kTopLabelFont);
    }];
    //LogButton
    [_caseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-19);
        make.top.equalTo(10);
        make.width.equalTo(150);
        make.height.equalTo(40);
    }];
    //分割线
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(_caseButton.mas_bottom).with.offset(10);
        make.height.equalTo(1);
    }];
    //TableView
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.mas_bottom);
        make.left.and.right.and.bottom.equalTo(0);
    }];
}
#pragma mark - Event response
//点击按钮
- (void)topButtonPressed:(UIButton *)button{
    NSString *name;
    if (button == _caseButton) {
        name = @"ZDHLogView";
    }
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:@{@"orderID":[NSString stringWithFormat:@"商品 %@",_orderID]}];
}
#pragma mark - Network request
//获取商品详情
- (void)getData{
    __block ZDHProductDetailView *selfView = self;
    __block ZDHProductViewDetailViewModel *selfViewModel = _vcViewModel;
    [_vcViewModel getProductDetailWithOrderID:_orderID success:^(NSMutableArray *resultArray) {
        //获取成功
        selfView.topContentLabel.text = selfViewModel.statusString;
        //获取窗帘最大行高
        if (selfViewModel.dataCurtainlistArray.count > 0) {
            [selfViewModel getMaxLineHeighWithDataArray:selfViewModel.dataCurtainlistArray];
        }
//------------tableview.datasource数据在这赋值----------------
         detailModel = [_vcViewModel.dataDetailArray firstObject];
        self.typeCell =detailModel.ordertype;
//----------------------------------------------------------
        [selfView.tableView reloadData];
        [selfView.tableView.header endRefreshing];
    } fail:^(NSError *error) {
        //获取失败
        [selfView.tableView reloadData];
        [selfView.tableView.header endRefreshing];
    }];
}
#pragma mark - Protocol methods
//UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            //基本信息
            return 1;
            break;
        case 1:{
            //物流信息
            if (_vcViewModel.dataExpresslistArray.count > 0) {
                return _vcViewModel.dataExpresslistArray.count;
            }else{
                return 0;
            }
        }
            break;
        case 2:{
            //窗帘信息
            if (_vcViewModel.dataCurtainlistArray.count > 0) {
//---------------------当数组内容为空的时候(特别是没有照片地址)，隐藏该cell------------------------------
                int count = 0;
                for (int i=0; i<_vcViewModel.dataCurtainlistArray.count; i++) {
                    ZDHProductViewDetailShopDetailCurtainlistModel *curModel = _vcViewModel.dataCurtainlistArray[i];
                    if ([curModel.proimg length]>0||[curModel.middlemodule length]>0||[curModel.outsidemodule length]>0||[curModel.screenmodule length]>0) {
                        count++;
                    }
                }
                return count;
            }else{
                return 0;
            }
        }
            break;
        case 3:{
            //家居信息
            if (_vcViewModel.dataFurniturelistArray.count > 0) {
//---------------------当数组内容为空的时候(特别是没有照片地址)，隐藏该cell------------------------------                
                int count = 0;
                for (int i=0; i<_vcViewModel.dataFurniturelistArray.count; i++) {
                    ZDHProductViewDetailShopDetailFurniturelistModel *listModel = _vcViewModel.dataFurniturelistArray[i];
                    if ([listModel.proimg length]>0||[listModel.promodule length]>0) {
                        count++;
                    }
                }
                return count;
            }else{
                return 0;
            }
        }
            break;
        case 4:{
            //其他信息
            if (_vcViewModel.dataOtherlistArray.count > 0) {
//---------------------当数组内容为空的时候(特别是没有照片地址)，隐藏该cell------------------------------
                int count = 0;
                for (int i=0; i<_vcViewModel.dataOtherlistArray.count; i++) {
                    ZDHProductViewDetailShopDetailOtherlistModel *listModel = _vcViewModel.dataOtherlistArray[i];
                    if ([listModel.proimg length]>0||[listModel.promodule length]>0) {
                        count++;
                    }
                }
                return count;
            }else{
                return 0;
            }
        }
            break;
        default:
            return 0;
            break;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_vcViewModel.dataDetailArray.count > 0) {
        return 5;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDHProductDetailViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
    detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:{
            //基本信息
            [detailCell selectCellType:kBaseCellType];
            if (_vcViewModel.dataDetailArray.count > 0) {
                //载入数据
//                ZDHProductViewDetailShopDetailModel *detailModel = [_vcViewModel.dataDetailArray firstObject];
                NSArray *dataArray = [NSArray arrayWithObjects:detailModel.orderid,detailModel.addman,detailModel.store,detailModel.shipmentdate,detailModel.adddate,detailModel.remarks,detailModel.feedback,[NSString stringWithFormat:@"%@",detailModel.checkman],detailModel.checktime,detailModel.recheckman,detailModel.rechecktime,nil];
                [detailCell loadBaseInfoWithDataArray:dataArray];
                //赋值cell类型
//--------------------------添加客户需求，"其他"类型的时候隐藏最后两个字段------------------------
                if ([_typeCell isEqualToString:@"其他"]) {
                    int count = (int)detailCell.lastBackView.subviews.count-1;
                    for (int i =count; i>count-4; i--) {
                        UILabel *label = (UILabel*)detailCell.lastBackView.subviews[i];
                        label.hidden = YES;
                    }
                }
//---------------------------------------------------------------------------------------
            }
        }
            break;
        case 1:{
            //订单物流
            [detailCell selectCellType:kLogisticsType];
            if ((_vcViewModel.dataExpresslistArray.count > 0)) {
                //载入数据
                ZDHProductViewDetailShopDetailExpresslistModel *listModel = _vcViewModel.dataExpresslistArray[indexPath.row];
                ZDHProductViewDetailShopDetailExpresslistErpexpressinfoModel *expressInfoModel = listModel.erpexpressinfo;
                listModel.erpnumber=listModel.erpnumber?listModel.erpnumber:@"";
//                NSArray *dataArray = [NSArray arrayWithObjects:listModel.erpnumber,expressInfoModel.expressname,listModel.expressnumber,expressInfoModel.senddate,expressInfoModel.num,expressInfoModel.money,expressInfoModel.linkmobile,nil];
//------------------------添加到数组的对象，有时候是空的，为了保证能够顺利读取后面的数据，当为空的时候用空对象占位-------------------
                NSArray *dataArray = [NSArray arrayWithObjects:listModel.erpnumber?listModel.erpnumber:@"",expressInfoModel.expressname?expressInfoModel.expressname:@"", listModel.expressnumber? listModel.expressnumber:@"",expressInfoModel.senddate?expressInfoModel.senddate:@"",expressInfoModel.num?expressInfoModel.num:@"",expressInfoModel.money?expressInfoModel.money:@"",expressInfoModel.linkmobile?expressInfoModel.linkmobile:@"",nil];
               
                [detailCell loadExpressInfoWithDataArray:dataArray];
            }
        }
            break;
        case 2:{
            //窗帘
            [detailCell selectCellType:kFirstCellType];
            if (_vcViewModel.dataCurtainlistArray.count > 0) {
                ZDHProductViewDetailShopDetailCurtainlistModel *curModel = _vcViewModel.dataCurtainlistArray[indexPath.row];
                //存储具体尺寸内容数据
                NSMutableArray *SizeDataArray = [NSMutableArray array];
                //切割othermore 字段内容
                if (curModel.othermore) {
                    NSArray *sectionArray = [curModel.othermore componentsSeparatedByString:@"###"];
                    //存储每组内容
                   
                    for (NSString *string in sectionArray) {
                        NSArray *subArray= [string componentsSeparatedByString:@"*_*"];
                        for (NSString *subString in subArray) {
                            [SizeDataArray addObject:subString];

                        }
                        [SizeDataArray addObject:@""];
                    }
                }
                
                NSArray *dataArray = [NSArray arrayWithObjects:curModel.headname,curModel.headmodule,curModel.headsize,curModel.headnum,@"",curModel.headlayout,curModel.outsidename,curModel.outsidemodule,curModel.outsidesize,curModel.outsidenum,@"",curModel.outsidelayout,curModel.middlename,curModel.middlemodule,curModel.middlesize,curModel.middlenum,@"",curModel.middlelayout,curModel.screenname,curModel.screenmodule,curModel.screensize,curModel.screennum,@"",curModel.screenlayout, nil];
                //添加多扩展内容
                NSMutableArray *AllCurArray = [NSMutableArray arrayWithArray:dataArray];
                [AllCurArray addObjectsFromArray:SizeDataArray];
                
                
                [detailCell loadCurtainDetailWithDataArray:AllCurArray index:(indexPath.row+1) image:curModel.proimg name:curModel.pronumber remark:curModel.remarks];
            }
        }
            break;
        case 3:{
            //家具信息
            [detailCell selectCellType:kFurnitureType];
            if (_vcViewModel.dataFurniturelistArray.count > 0) {
                //载入数据
                ZDHProductViewDetailShopDetailFurniturelistModel *listModel = _vcViewModel.dataFurniturelistArray[indexPath.row];
                NSArray *dataArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",(int)(indexPath.row+1)],listModel.proimg,listModel.promodule,listModel.prosize,listModel.pronorms,listModel.pronum,listModel.prounits,listModel.remarks,nil];
                [detailCell loadFurnitureInfoWithDataArray:dataArray];
            }
        }
            break;
        case 4:{
            //其他
            [detailCell selectCellType:kOtherCellType];
            if (_vcViewModel.dataOtherlistArray.count > 0) {
                //载入数据
                ZDHProductViewDetailShopDetailOtherlistModel *listModel = _vcViewModel.dataOtherlistArray[indexPath.row];
                NSArray *dataArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",(int)(indexPath.row+1)],listModel.proimg,listModel.promodule,listModel.prosize,listModel.pronum,listModel.prounits,listModel.remarks,nil];
                [detailCell loadOtherInfoWithDataArray:dataArray];
            }
        }
            break;
        default:
            [detailCell selectCellType:kOtherCellType];
            break;
    }
    return detailCell;
}
//UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 477/2;
            break;
        case 1:
            return 300/2;
            break;
        case 2:{
            //窗帘模式
            float height = [_vcViewModel.dataMaxHeightArray[indexPath.row] floatValue];
            return height+50;
        }
            break;
        default:
            return 220/2;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

//------------添加判断组头返回的高度值-------------------
    switch (section) {
        case 3:{
            if([_typeCell isEqualToString: @"窗帘"]||[_typeCell isEqualToString: @"其他"])
                    return 0;
        }
            break;
        case 4:{
            if([_typeCell isEqualToString: @"窗帘"]||[_typeCell isEqualToString: @"家具"])
                return 0;
        }
        default:
            break;
    }
//------------------------------
    return 105/2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ZDHProductDetailViewHeaderView *headerView = [[ZDHProductDetailViewHeaderView alloc] init];
    [headerView reloadTitleName:@"订单商品信息"];
    switch (section) {
        case 0:{
            [headerView reloadTitleName:@"订单基本信息"];
            [headerView useBigTitle];
        }
            break;
        case 1:{
            [headerView reloadTitleName:@"订单物流信息"];
            [headerView useBigTitle];
        }
            break;
        case 2:{
            [headerView reloadTitleName:@"订单商品信息"];
            [headerView useBigTitle];
        }
            break;
        case 3:{
//-------------添加判断如果是“窗帘和其他类”不显示在tableview中----------------------
            if([_typeCell isEqualToString: @"窗帘"]||[_typeCell isEqualToString: @"其他"])return nil;
//-------------------------------------
            [headerView reloadTitleName:@"家具类订单"];
            [headerView useSmallTitle];
        }
            break;
        case 4:{
//--------------添加判断如果是“窗帘和家具类”不显示在tableview中-----------------------
            if([_typeCell isEqualToString: @"窗帘"]||[_typeCell isEqualToString: @"家具"])return nil;
//-------------------------------------
            [headerView reloadTitleName:@"其他类订单"];
            [headerView useSmallTitle];
        }
            break;
        default:
            break;
    }
    return headerView;
}
#pragma mark - Other methods
@end