//
//  ZDHProductCenterSearchScreenView.m
//  TableView二级联动Demo
//
//  Created by apple on 16/3/11.
//  Copyright (c) 2016年 TTC. All rights reserved.
//

#import "ZDHProductCenterSearchScreenView.h"
#import "ZDHScreenViewCell.h"
#import "ZDHScreenSecondCell.h"

// model
#import "ZDHSearchViewControllerListNewsSearchModel.h"
#import "ZDHSearchViewControllerListNewsSearchSearchTModel.h"
#import "Masonry.h"

@interface ZDHProductCenterSearchScreenView()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic, strong) UITableView *firstTable;
@property(nonatomic, strong) UITableView *secondTable;
//第一个tableView选择的Index
@property (nonatomic,assign) int *firstIndex;
@property (nonatomic,assign) int *secondIndex;
// 打开标志
@property (nonatomic,strong) UIImageView *imageOpen;
// 筛选的id
// 品牌
@property (copy, nonatomic) NSString *brandIdString;
// 空间
@property (copy, nonatomic) NSString *spaceIdString;
// 风格
@property (copy, nonatomic) NSString *styleIdString;

// 标记数组
@property (strong, nonatomic) NSMutableArray *selectedFlagArray;
@property (assign, nonatomic) BOOL isFirstTime;
@property (strong, nonatomic) UIImageView *topView;
@property (strong, nonatomic) UIView *backGroundView;

@end

@implementation ZDHProductCenterSearchScreenView

- (void) initData{
    
    _titleArray = [[NSMutableArray alloc]initWithArray:@[@"品牌",@"空间",@"风格"]];
    _goodsDataListArray = [NSMutableArray array];
    _selectedFlagArray = [[NSMutableArray alloc] initWithArray:@[@"",@"",@""]];
    _brandIdString = @"";
    _spaceIdString = @"";
    _styleIdString = @"";
    _isFirstTime = YES;
}

- (instancetype) init{
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self initData];
        [self createUI];
        [self createAutolayout];
    }
    return self;
}

- (void) createUI{
    
    _imageOpen = [[UIImageView alloc]init];
    _imageOpen.image = [UIImage imageNamed:@"search_openFlag"];
    [self addSubview:_imageOpen];
    
    _backGroundView = [[UIView alloc]init];
    _backGroundView.layer.cornerRadius = 5.0;
    _backGroundView.layer.masksToBounds = YES;
    [self addSubview:_backGroundView];
    
    _topView = [[UIImageView alloc]init];
    _topView.backgroundColor = [UIColor colorWithRed:99/256.0 green:99/256.0 blue:99/256.0 alpha:1];
    [_backGroundView addSubview:_topView];
    
    // 第一级tableView
    _firstIndex = 0;
    _firstTable = [[UITableView alloc]init];
    _firstTable.delegate = self;
    _firstTable.dataSource = self;
    _firstTable.backgroundColor = [UIColor grayColor];
    _firstTable.translatesAutoresizingMaskIntoConstraints = NO;
    _firstTable.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [_backGroundView addSubview:_firstTable];
    
    // 第二级tableview
    _secondTable = [[UITableView alloc]init];
    _secondTable.delegate=self;
    _secondTable.dataSource=self;
    _secondTable.translatesAutoresizingMaskIntoConstraints = NO;
    _secondTable.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [_backGroundView addSubview:_secondTable];
}

- (void) createAutolayout{
    
    [_imageOpen mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.height.mas_equalTo(7);
        make.width.mas_equalTo(15);
        make.top.equalTo(self.mas_top).offset(0);
        make.right.equalTo(self.mas_right).offset(-80);
    }];
    
    [_backGroundView mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(_imageOpen.mas_bottom).offset(0);
    }];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.height.mas_equalTo(40);
        make.left.right.equalTo(self);
        make.top.equalTo(_backGroundView.mas_top).offset(0);
    }];
    
    [_firstTable mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.mas_equalTo(_topView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_centerX).offset(0);
        make.height.mas_equalTo(self);
    }];
    
    [_secondTable mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.mas_equalTo(_firstTable.mas_top).offset(0);
        make.left.mas_equalTo(_firstTable.mas_right).offset(0);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(self);
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _firstTable) {
        
        return 54;
    }else{
        
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_firstTable) {
        
        return _titleArray.count;
    }
    else if (tableView == _secondTable)
    {
        if (_goodsDataListArray.count > 0) {
            
            NSMutableArray *dataArray = _goodsDataListArray[(NSInteger)_firstIndex];
            return dataArray.count + 1;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == _firstTable) {
        
         ZDHScreenViewCell *screenCell = [ZDHScreenViewCell cellScreenViewCellWithTableView:tableView];
         [screenCell titleLableWithString:_titleArray[indexPath.row ]];

        if ([[_selectedFlagArray objectAtIndex:indexPath.row] isEqualToString:@""]) {
            
            [screenCell loadGoodsTitle:@"全部"];
        }
        else{
            
            [screenCell loadGoodsTitle:_selectedFlagArray[indexPath.row]];
        }
        
            if ((int)_firstIndex == indexPath.row) {
                    
                screenCell.backgroundColor = [UIColor whiteColor];
                [screenCell changeCellTitleColorWithFlag:YES];
            }else{
                    
                screenCell.backgroundColor = [UIColor grayColor];
                [screenCell changeCellTitleColorWithFlag:NO];
            }
    
        return screenCell;
    }
    else{
        
        ZDHScreenSecondCell *screenCell = [ZDHScreenSecondCell cellWithTableView:tableView];
        
        if (indexPath.row == 0) {
            
            [screenCell loadTitilzWithString:@"全部"];
            if (_firstIndex == 0) {
                
                [screenCell titleColorSelected:YES];
            }
            for (NSInteger i = 0; i < _selectedFlagArray.count; i ++) {
                
                 NSString *selecteString = _selectedFlagArray[(int)_firstIndex];
                if ([selecteString isEqualToString:@""]) {
                     [screenCell titleColorSelected:YES];
                }else{
                    [screenCell titleColorSelected:NO];
                }
            }
        }
        else{
            
            NSMutableArray *dataArray = _goodsDataListArray[(NSInteger)_firstIndex];
            ZDHSearchViewControllerListNewsSearchSearchTModel *tModel = dataArray[indexPath.row - 1];
            [screenCell loadTitilzWithString:tModel.title];
            NSString *selecteString = _selectedFlagArray[(int)_firstIndex];
            if ([selecteString isEqualToString:tModel.title]) {
                
                [screenCell titleColorSelected:YES];
            }else{
                
                [screenCell titleColorSelected:NO];
            }
        }
        return screenCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _firstTable) {
        
        _firstIndex = (int *)indexPath.row;
        [_secondTable reloadData];
        [_firstTable reloadData];
    }
    else if (tableView == _secondTable)
    {
        _secondIndex = (int *)indexPath.row;
         NSMutableArray *dataArray = _goodsDataListArray[(NSInteger)_firstIndex];
        if (_secondIndex > 0) {
           ZDHSearchViewControllerListNewsSearchSearchTModel *tModel = dataArray[ indexPath.row -1];
            // 添加标记
            [_selectedFlagArray replaceObjectAtIndex:(NSInteger)_firstIndex withObject:tModel.title];
        }else{
            [_selectedFlagArray replaceObjectAtIndex:(NSInteger)_firstIndex withObject:@""];
        }
        [self changeTypeIDString];
        [_secondTable reloadData];
        [_firstTable reloadData];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}

// 触发加载数据
- (void) changeTypeIDString{
    
    NSMutableArray *dataArray = _goodsDataListArray[(NSInteger)_firstIndex];
    if (_firstIndex == 0) {
        if (_secondIndex == 0) {
         // 获取全部的数据
            _brandIdString = @"";
            _spaceIdString = @"";
            _styleIdString = @"";
        }else{
          // 获取某一个关键字的搜索结果
            ZDHSearchViewControllerListNewsSearchSearchTModel *tModel = dataArray[(NSInteger)_secondIndex - 1];
            _brandIdString = tModel.tytypeid;
        }
    }
    else if((int)_firstIndex == 1){
        if (_secondIndex == 0) {
            // 获取全部的数据
            _brandIdString = @"";
            _spaceIdString = @"";
            _styleIdString = @"";
        }else{

           ZDHSearchViewControllerListNewsSearchSearchTModel *tModel = dataArray[(NSInteger)_secondIndex - 1];
          _spaceIdString = tModel.tytypeid;
        }
    }
    else{
        if (_secondIndex == 0) {
            // 获取全部的数据
            _brandIdString = @"";
            _spaceIdString = @"";
            _styleIdString = @"";
        }else{

           ZDHSearchViewControllerListNewsSearchSearchTModel *tModel = dataArray[(int)_secondIndex - 1];
           _styleIdString = tModel.tytypeid;
        }
    }
    
    NSDictionary *idDic = @{@"brandIdString":_brandIdString,@"spaceIdString":_spaceIdString,@"styleIdString":_styleIdString};
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchScreenView" object:self userInfo:idDic];
}

// 清空已选的title
- (void) cleanAllTheSelectedTitle{
    
    for (NSInteger i = 0; i < _selectedFlagArray.count; i ++) {
        
        [_selectedFlagArray replaceObjectAtIndex:i withObject:@""];
    }
    [_firstTable reloadData];
    [_secondTable reloadData];
}

// 打开和收起筛选
-(void) openOrCloseScreenBarWithFlag:(BOOL)flag withListData:(NSMutableArray *)array withSelected:(NSMutableArray *)selectedArray{
    
    for (NSInteger i = 0 ; i < _titleArray.count; i ++) {
        
        if (i == 0) {
            ZDHSearchViewControllerListNewsSearchModel *searchModel = array[i];
            [_goodsDataListArray addObject:searchModel.search_t];
            for (NSInteger j = 0; j < searchModel.search_t.count; j ++) {
                ZDHSearchViewControllerListNewsSearchSearchTModel *tModel = searchModel.search_t[j];
                NSString *selectedId = selectedArray[0];
                if ([selectedId isEqualToString:tModel.tytypeid]) {
                    [_selectedFlagArray replaceObjectAtIndex:0 withObject:tModel.title];
                }
            }
        }
        else if(i == 1){
            ZDHSearchViewControllerListNewsSearchModel *searchModel = array[i + 1];
            [_goodsDataListArray addObject:searchModel.search_t];
            for (NSInteger j = 0; j < searchModel.search_t.count; j ++) {
                ZDHSearchViewControllerListNewsSearchSearchTModel *tModel = searchModel.search_t[j];
                NSString *selectedId = selectedArray[1];
                if ([selectedId isEqualToString:tModel.tytypeid]) {
                    [_selectedFlagArray replaceObjectAtIndex:1 withObject:tModel.title];
                }
            }
        }
        else if( i == 2){
            
            ZDHSearchViewControllerListNewsSearchModel *searchModel = array[i + 1];
            [_goodsDataListArray addObject:searchModel.search_t];
            
            for (NSInteger j = 0; j < searchModel.search_t.count; j ++) {
                
                ZDHSearchViewControllerListNewsSearchSearchTModel *tModel = searchModel.search_t[j];
                NSString *selectedId = selectedArray[2];
                if ([selectedId isEqualToString:tModel.tytypeid]) {
                    [_selectedFlagArray replaceObjectAtIndex:2 withObject:tModel.title];
                }
            }
        }
    }
    [_firstTable reloadData];
    [_secondTable reloadData];
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
}
/**
 *  打开和收起筛选view
 *
 *  @param flag yes:打开，no：收起
 */
- (void) openSearchClassifyWithFlag:(BOOL)flag{
    
    // 展开列表视图
    if (flag) {
        
        [UIView animateWithDuration:0.3 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make){
                make.height.mas_equalTo(500);
            }];
            [self layoutIfNeeded];
        }];
        [UIView commitAnimations];
    }else{
        // 收起
        [UIView animateWithDuration:0.3 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make){
                make.height.mas_equalTo(0);
            }];
            [self layoutIfNeeded];
        }];
        [UIView commitAnimations];
    }
}
// 加载数据
- (void) loadClassifyViewWithDataArray:(NSMutableArray *)array selectedArray:(NSMutableArray *)selectedArray{
    
    for (NSInteger i = 0 ; i < _titleArray.count; i ++) {
        
        if (i == 0) {
            ZDHSearchViewControllerListNewsSearchModel *searchModel = array[i];
            [_goodsDataListArray addObject:searchModel.search_t];
            for (NSInteger j = 0; j < searchModel.search_t.count; j ++) {
                ZDHSearchViewControllerListNewsSearchSearchTModel *tModel = searchModel.search_t[j];
                NSString *selectedId = selectedArray[0];
                if ([selectedId isEqualToString:tModel.tytypeid]) {
                    
                    [_selectedFlagArray replaceObjectAtIndex:0 withObject:tModel.title];
                }
            }
        }
        else if(i == 1){
            ZDHSearchViewControllerListNewsSearchModel *searchModel = array[i + 1];
            [_goodsDataListArray addObject:searchModel.search_t];
            for (NSInteger j = 0; j < searchModel.search_t.count; j ++) {
                ZDHSearchViewControllerListNewsSearchSearchTModel *tModel = searchModel.search_t[j];
                NSString *selectedId = selectedArray[1];
                if ([selectedId isEqualToString:tModel.tytypeid]) {
                    [_selectedFlagArray replaceObjectAtIndex:1 withObject:tModel.title];
                }
            }
        }
        else if( i == 2){
            
            ZDHSearchViewControllerListNewsSearchModel *searchModel = array[i + 1];
            [_goodsDataListArray addObject:searchModel.search_t];
            
            for (NSInteger j = 0; j < searchModel.search_t.count; j ++) {
                
                ZDHSearchViewControllerListNewsSearchSearchTModel *tModel = searchModel.search_t[j];
                NSString *selectedId = selectedArray[2];
                if ([selectedId isEqualToString:tModel.tytypeid]) {
                    [_selectedFlagArray replaceObjectAtIndex:2 withObject:tModel.title];
                }
            }
        }
    }
    [_firstTable reloadData];
    [_secondTable reloadData];
}

@end
