//
//  ZDHSearchDropdownMenuView.m
//  下拉菜单Demo
//
//  Created by apple on 16/3/10.
//  Copyright (c) 2016年 TTC. All rights reserved.
//

#import "ZDHSearchDropdownMenuView.h"
#import "Masonry.h"
#import "ZDHSearchDroDowMenTableViewHeaderFoodterView.h"
#import "ZDHSearchDropdownMenuTableViewCell.h"
// model
#import "ZDHSearchViewControllerNewListProtypelistModel.h"
#import "ZDHSearchViewControllerNewListProtypelistChindtypeModel.h"

#define WHITE [UIColor whiteColor]
#define kTableViewLeftHeight 300
#define kViewLeftHeight 300


@interface ZDHSearchDropdownMenuView ()<UITableViewDataSource,UITableViewDelegate>


@property (assign, nonatomic) BOOL isDraged;
// 用于标志的数组
@property (strong, nonatomic) NSMutableArray *mutableArrayFlag;
// 保存cell数量总和的高度
@property (assign, nonatomic) float heightSum;

@property (strong, nonatomic) UIImageView *imageViewOpenMenu;

@property (strong, nonatomic) NSMutableArray *cellArray;
@property (strong, nonatomic) NSIndexPath *dexPath;

@property (assign, nonatomic) int cellCount;
// section的标志数组
@property (strong, nonatomic) NSMutableArray *sectionIDArray;
// 获取默认的已选项
@property (copy, nonatomic) NSString *receivedSelectedId;
//  类目
@property (strong, nonatomic) UIImageView *categoryView;

// goodsName
@property (copy, nonatomic) NSString *goodsName;


@end

@implementation ZDHSearchDropdownMenuView

- (void) initData{
    _sectionIDArray = [NSMutableArray array];
    _receivedSelectedId = @"";
    _goodsName = @"";
    _typeIdString = 0;
    _heightSum = 0;
    _mutableArrayFlag = [NSMutableArray array];
    _cellArray = [NSMutableArray array];
    _dexPath = nil;
}

- (instancetype) init{
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.cellCount = 0;
        [self initData];
        [self createUI];
        [self createUIAutolayout];
        [self receiveNotification];
    }
    return self;
}

// 创建UI
- (void) createUI{
    
    _tableViewMenu = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableViewMenu.backgroundColor = [UIColor whiteColor];
    _tableViewMenu.backgroundColor = CELLSELECTEDCOLOR;//[UIColor colorWithRed:99/256.0 green:99/256.0 blue:99/256.0 alpha:1];;
    _tableViewMenu.sectionHeaderHeight = 44;
    _tableViewMenu.dataSource = self;
    _tableViewMenu.delegate = self;
    _tableViewMenu.showsVerticalScrollIndicator = NO;
    _tableViewMenu.translatesAutoresizingMaskIntoConstraints = NO;
    _tableViewMenu.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewMenu.bounces = NO;
    _tableViewMenu.layer.cornerRadius = 5.0;
    [self addSubview:_tableViewMenu];
    
    _imageViewOpenMenu = [[UIImageView alloc]init];
    _imageViewOpenMenu.image = [UIImage imageNamed:@"search_openFlag"];
    [self addSubview:_imageViewOpenMenu];
    
}
// 添加控件约束
- (void) createUIAutolayout{

    [_imageViewOpenMenu mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.mas_equalTo(7);
        make.width.mas_equalTo(15);
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(20);
    }];
    [_tableViewMenu mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self);
        make.top.mas_equalTo(_imageViewOpenMenu.mas_bottom).offset(0);
    }];
}

#define mark  UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.sectionArray.count > 0) {
        
        return self.sectionArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_cellCount > 0) {
        if (_dexPath.row == indexPath.row && _dexPath.section == indexPath.section) {
            return _cellCount * 44;
        }
        else{
            return 44;
        }
    }
    return 44;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_mutableArrayFlag.count > 0){
        if ([_mutableArrayFlag[section] isEqualToString:@"0"]) {
            return 0;
        }
    }
    else{
        return 0;
    }
    if (_cellArray.count > 0) {
        
        NSMutableArray *cellTitleArrary = [[NSMutableArray alloc]initWithArray:_cellArray[section]];
        if (cellTitleArrary.count > 0) {
             return cellTitleArrary.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZDHSearchDropdownMenuTableViewCell *zdCell = [ZDHSearchDropdownMenuTableViewCell cellWithTableView:tableView];
    zdCell.backgroundColor = GRAY;
    if (_dexPath) {
    
        if (indexPath.section == _dexPath.section && indexPath.row == _dexPath.row) {
            
            [zdCell showSelectedImage:YES];
            zdCell.backgroundColor = CELLSELECTEDCOLOR;
        }
        else{
            [zdCell showSelectedImage:NO];
            zdCell.backgroundColor = GRAY;
        }
    }
    
    if (_cellArray.count > 0) {
        NSMutableArray *cellTitleArrary = [[NSMutableArray alloc]initWithArray:_cellArray[indexPath.section]];
        if (cellTitleArrary.count > 0) {
            ZDHSearchViewControllerNewListProtypelistChindtypeModel *chindModel  = cellTitleArrary[indexPath.row];
            [zdCell loadCellTitleString:chindModel.typename_conflict];
            NSMutableArray *array = [NSMutableArray arrayWithArray:chindModel.chindtype];
            [zdCell goodsClassifyButtonWithArray:array];
        }
    }
    return zdCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    ZDHSearchDroDowMenTableViewHeaderFoodterView *headerView = [ZDHSearchDroDowMenTableViewHeaderFoodterView headerViewWithTableView:tableView];
    headerView.sectionIndex = (int)section;
    [headerView showSectionOpenflag:_sectionIDArray[section]];
    [headerView loadTitleText:_sectionArray[section]];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *cellTitleArrary = [[NSMutableArray alloc]initWithArray:_cellArray[indexPath.section]];
    
    if (cellTitleArrary.count > 0) {
        
        ZDHSearchViewControllerNewListProtypelistChindtypeModel *chindModel  = cellTitleArrary[indexPath.row];
        self.typeIdString = chindModel.typeid_conflict;
        self.goodsName = chindModel.typename_conflict;
    }
    _dexPath = indexPath;
     ZDHSearchViewControllerNewListProtypelistChindtypeModel *chindModel  = cellTitleArrary[indexPath.row];
    _cellCount = (int)(chindModel.chindtype.count + 1);
    NSDictionary *dic = @{@"typeid":self.typeIdString,@"typename":self.goodsName};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHSearchDropdownMenuView" object:self userInfo:dic];
    [self.tableViewMenu reloadData];
}


// 打开和收起菜单栏
-(void) showMenuBarWithFlag:(BOOL)flag withArray:(NSMutableArray *)array withID:(NSString *)sendID{
        _receivedSelectedId = sendID;
    // 隐藏视图
    if (flag) {
        [UIView animateWithDuration:0.3 animations:^{
            
            [self mas_updateConstraints:^(MASConstraintMaker *make){
                make.height.mas_equalTo(0);
            }];
            [self layoutIfNeeded];
        }];
        [UIView commitAnimations];
    // 展开列表视图
    }else{

        [UIView animateWithDuration:0.3 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make){
                make.height.mas_equalTo(500);
            }];
            [self layoutIfNeeded];
        }];
        [UIView commitAnimations];
    }
    [self reloadTableView:array];
}
// 更新tableView以及标识数组
- (void) reloadTableView:(NSMutableArray *)array{

    self.sectionArray = [NSMutableArray array];
    _mutableArrayFlag = [NSMutableArray array];
    _sectionIDArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        
        ZDHSearchViewControllerNewListProtypelistModel *listModel = array[i];
        [self.sectionArray addObject:listModel.typename_conflict];
        [_sectionIDArray addObject:@"0"];
        NSMutableArray *chindtypeArray = [NSMutableArray array];
        for (NSInteger j = 0; j < listModel.chindtype.count; j ++) {
            
            ZDHSearchViewControllerNewListProtypelistChindtypeModel *chindModel = listModel.chindtype[j];
            [chindtypeArray addObject:chindModel];
            if([chindModel.typeid_conflict isEqualToString:_receivedSelectedId]){
                
                _dexPath = [NSIndexPath indexPathForRow:j inSection:i];
            }
        }
        [_cellArray addObject:chindtypeArray];
        [_mutableArrayFlag addObject:@"0"];
    }
    if (array.count > 0) {
        
        if(![_receivedSelectedId isEqualToString:@""]|| !_receivedSelectedId){
            
           NSMutableArray *cellTitleArrary = [[NSMutableArray alloc]initWithArray:_cellArray[_dexPath.section]];
           ZDHSearchViewControllerNewListProtypelistChindtypeModel *chindModel  = cellTitleArrary[_dexPath.row];
           _cellCount = (int)(chindModel.chindtype.count + 1);
             [_tableViewMenu reloadData];
           [self loadSectionCellOpenSelected];
        }
        else{
            
            _cellCount = 0;
            _dexPath = nil;
             [_tableViewMenu reloadData];
        }
    }
}

// 接收来自组头视图的通知
- (void) receiveNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceiveAction:) name:@"ZDHSearchDroDowMenTableViewHeaderFoodterView" object:nil];
}
// 通知反馈
- (void) notificationReceiveAction:(NSNotification *)notifi{
    
    if (_sectionArray.count == 0) {
        
        if (_cellArray.count >0) {
           for (NSInteger i = 0; i < _cellArray.count; i ++) {
              [_sectionIDArray addObject:@"0"];
           }
        }
        _sectionIDArray= [[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0"]];
    }
    if([notifi.name isEqualToString:@"ZDHSearchDroDowMenTableViewHeaderFoodterView"]){
        
        // 获取到组头的标识
        int index = [[notifi.userInfo valueForKey:@"sectionIndex"] intValue];
        NSString *flag = [notifi.userInfo valueForKey:@"id"];
        [_sectionIDArray replaceObjectAtIndex:index withObject:flag];
        [_tableViewMenu beginUpdates];
        NSMutableArray *mutableArray = [NSMutableArray array];
        NSMutableArray *cellTitleArrary = nil;
        if (_cellArray.count > 0) {
            
            cellTitleArrary = [[NSMutableArray alloc]initWithArray:_cellArray[index]];
        }
        for (NSInteger i = 0; i < cellTitleArrary.count; i ++) {
            // 需要展开的Cell
            NSIndexPath *inderPathToInset = [NSIndexPath indexPathForRow:i inSection:index];
            [mutableArray addObject:inderPathToInset];
        }
        // 展开动画
        if (_mutableArrayFlag.count > 0) {
      
          if ([_mutableArrayFlag[index] isEqualToString:@"0"]) {
              [_mutableArrayFlag replaceObjectAtIndex:index withObject:@"1"];
              [_tableViewMenu insertRowsAtIndexPaths:mutableArray withRowAnimation:UITableViewRowAnimationTop];
           }
           else{
            // 收起cell动画
            [_mutableArrayFlag replaceObjectAtIndex:index withObject:@"0"];
            [_tableViewMenu deleteRowsAtIndexPaths:mutableArray withRowAnimation:UITableViewRowAnimationTop];
           }
        }
        [_tableViewMenu endUpdates];
    }
}
// 打开默认cell
- (void) loadSectionCellOpenSelected{
    
    if (_sectionArray.count == 0) {
        
        if (_cellArray.count >0) {
            for (NSInteger i = 0; i < _cellArray.count; i ++) {
                [_sectionIDArray addObject:@"0"];
            }
        }
        _sectionIDArray= [[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0"]];
    }
    if (![_receivedSelectedId isEqualToString:@""]) {
        
       [_sectionIDArray replaceObjectAtIndex:_dexPath.section withObject:@"1"];
       [_tableViewMenu beginUpdates];
        NSMutableArray *mutableArray = [NSMutableArray array];
        NSMutableArray *cellTitleArrary = nil;
       if (_cellArray.count > 0) {
           
           cellTitleArrary = [[NSMutableArray alloc]initWithArray:_cellArray[_dexPath.section]];
        }
       for (NSInteger i = 0; i < cellTitleArrary.count; i ++) {
        // 需要展开的Cell
          NSIndexPath *inderPathToInset = [NSIndexPath indexPathForRow:i inSection:_dexPath.section];
          [mutableArray addObject:inderPathToInset];
        }
       // 展开动画
       if (_mutableArrayFlag.count > 0) {
        
          if ([_mutableArrayFlag[_dexPath.section] isEqualToString:@"0"]) {
              [_mutableArrayFlag replaceObjectAtIndex:_dexPath.section withObject:@"1"];
              [_tableViewMenu insertRowsAtIndexPaths:mutableArray withRowAnimation:UITableViewRowAnimationTop];
           }
        else{
            // 收起cell动画
            [_mutableArrayFlag replaceObjectAtIndex:_dexPath.section withObject:@"0"];
            [_tableViewMenu deleteRowsAtIndexPaths:mutableArray withRowAnimation:UITableViewRowAnimationTop];
        }
    }
    [_tableViewMenu endUpdates];
    }
}

@end

























