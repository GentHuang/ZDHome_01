//
//  ZDHSearchDropdownMenuCellCell.m
//  ZhiDa_Home
//
//  Created by apple on 16/3/15.
//  Copyright (c) 2016年 软碟技术. All rights reserved.
//

#import "ZDHSearchDropdownMenuCellCell.h"
#import "Masonry.h"

@interface ZDHSearchDropdownMenuCellCell()
@property (strong, nonatomic) UILabel *labelCell;
@end

@implementation ZDHSearchDropdownMenuCellCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = CELLSELECTEDCOLOR;
        [self createUI];
        [self createAutolayout];
    }
    return self;
}

- (void) createUI{
    
    _labelCell = [[UILabel alloc]init];
    _labelCell.textColor = [UIColor redColor];
    _labelCell.font = [UIFont systemFontOfSize:16];
    _labelCell.text = @"家具";
    _labelCell.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_labelCell];
}

- (void) createAutolayout{
    
    [_labelCell mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.height.mas_equalTo(40);
    }];
}


// 创建cell
+ (instancetype)cellCellWithTableView:(UITableView *)tableView{
    
    static NSString *cellIdentify = @"ZDHSearchDropdownMenuCellCell";
    ZDHSearchDropdownMenuCellCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[ZDHSearchDropdownMenuCellCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

// 刷新cell
- (void) loadCellCellTitle:(NSString *)titleString{
    
    _labelCell.text = titleString;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
