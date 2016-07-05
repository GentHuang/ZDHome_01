//
//  ZDHSearchDropdownMenuTableViewCell.m
//  下拉菜单Demo
//
//  Created by apple on 16/3/10.
//  Copyright (c) 2016年 TTC. All rights reserved.
//

#import "ZDHSearchDropdownMenuTableViewCell.h"
#import "Masonry.h"
#import "ZDHSearchViewControllerNewListProtypelistChindtypeChindtypeModel.h"
#import "ZDHSearchDropdownMenuCellCell.h"
#define kButtonTag 60000

@interface ZDHSearchDropdownMenuTableViewCell()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UILabel *labelTitle;
@property (strong, nonatomic) UIImageView *imageCellSelected;
@property (strong, nonatomic) UITableView *cellTable;
@property (strong, nonatomic) NSMutableArray *cellArray;
@property (strong, nonatomic) UIImageView *segamentLine;

@end

@implementation ZDHSearchDropdownMenuTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.contentView.backgroundColor = GRAY;
        _cellArray = [NSMutableArray array];
        [self createUI];
        [self createAutolayout];
    }
    return self;
}

- (void)createUI{
    
    _labelTitle = [[UILabel alloc]init];
    _labelTitle.textColor = [UIColor blackColor];
    _labelTitle.font = [UIFont systemFontOfSize:18];
    _labelTitle.text = @"家具";
    _labelTitle.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_labelTitle];
    
    _imageCellSelected = [[UIImageView alloc]init];
    _imageCellSelected.hidden = YES;
    _imageCellSelected.image = [UIImage imageNamed:@"seach_tableView_selected"];
    [self.contentView addSubview:_imageCellSelected];
    
    _cellTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _cellTable.rowHeight = 44;
    _cellTable.backgroundColor = GRAY;
    _cellTable.dataSource = self;
    _cellTable.delegate = self;
    _cellTable.scrollEnabled = NO;
    _cellTable.showsVerticalScrollIndicator = NO;
    _cellTable.translatesAutoresizingMaskIntoConstraints = NO;
    _cellTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_cellTable];
    
    _segamentLine = [[UIImageView alloc]init];
    _segamentLine.backgroundColor = SEGMENTLINECOLOR;
    [self.contentView addSubview:_segamentLine];
}

- (void) createAutolayout{
    
    [_labelTitle mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(self.contentView.mas_top).offset(2);
        make.left.mas_equalTo(self.contentView).offset(20);
        make.height.mas_equalTo(40);
    }];
    
    __weak __typeof(self) weaks = self;
    [_imageCellSelected  mas_makeConstraints:^(MASConstraintMaker *make){
        
         make.top.equalTo(self.contentView.mas_top).offset(13);
        make.height.width.mas_equalTo(_imageCellSelected.image.size);
        make.right.mas_equalTo(weaks.mas_right).offset(-20);
    }];
    
    [_cellTable  mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(_labelTitle.mas_bottom).offset(0);
        make.left.right.bottom.mas_equalTo(self.contentView);
    }];
    
    [_segamentLine mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.cellArray.count > 0) {
        
        return self.cellArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZDHSearchDropdownMenuCellCell *cellCell = [ZDHSearchDropdownMenuCellCell cellCellWithTableView:tableView];
    if (_cellArray.count > 0) {
        
        ZDHSearchViewControllerNewListProtypelistChindtypeChindtypeModel *chindtypeModel = _cellArray[indexPath.row];
        [cellCell loadCellCellTitle:chindtypeModel.typename_conflict];
    }
    
    return cellCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_cellArray.count > 0) {
        
        ZDHSearchViewControllerNewListProtypelistChindtypeChindtypeModel *chindtypeModel = _cellArray[indexPath.row];
        NSString *typeID = chindtypeModel.typeid_conflict;
        NSString *title = chindtypeModel.typename_conflict;
        NSDictionary *dic = @{@"typeid":typeID,@"title":title};
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHSearchDropdownMenuTableViewCell" object:self userInfo:dic];
    }
}

// 在刷新cell
- (void) goodsClassifyButtonWithArray:(NSMutableArray *)classifyArray{
    
    _cellArray = classifyArray;
    [_cellTable reloadData];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

// 创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *cellIdentify = @"MenuTableViewCell";
    ZDHSearchDropdownMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[ZDHSearchDropdownMenuTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void) loadCellTitleString:(NSString *)titleString{
    
    _labelTitle.text = titleString;
}

- (void) showSelectedImage:(BOOL) selectedTag{
    
    if (selectedTag) {
        
        _imageCellSelected.hidden = NO;
    }
    else{
        
        _imageCellSelected.hidden = YES;
    }
}

@end
