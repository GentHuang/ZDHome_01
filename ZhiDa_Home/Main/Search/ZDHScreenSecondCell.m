//
//  ZDHScreenSecondCell.m
//  下拉菜单Demo
//
//  Created by apple on 16/3/14.
//  Copyright (c) 2016年 TTC. All rights reserved.
//

#import "ZDHScreenSecondCell.h"
#import "Masonry.h"

@interface ZDHScreenSecondCell()

@property (strong, nonatomic) UILabel *labelLeftTitle;
@property (strong, nonatomic) UIImageView *imageSelected;

@end

@implementation ZDHScreenSecondCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
        [self createAutolayout];
    }
    return self;
}

- (void)awakeFromNib {
}
// 创建UI
- (void) createUI{
    // 左边title
    _labelLeftTitle = [[UILabel alloc]init];
    _labelLeftTitle.textColor = [UIColor blackColor];
    _labelLeftTitle.textAlignment = NSTextAlignmentLeft;
    _labelLeftTitle.font = [UIFont systemFontOfSize:20];
    _labelLeftTitle.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:_labelLeftTitle];
    
    _imageSelected = [[UIImageView alloc]init];
    _imageSelected.hidden = YES;
    _imageSelected.image = [UIImage imageNamed:@"seach_tableView_selected"];
    [self.contentView addSubview:_imageSelected];
    
}

// 添加约束
- (void) createAutolayout{
    
    __weak __typeof(self) weaks = self;

    [_labelLeftTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(weaks.mas_centerY);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(weaks.mas_left).offset(20);
    }];
    
    [_imageSelected mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(weaks.mas_centerY);
        make.height.width.mas_equalTo(_imageSelected.image.size);
        make.right.mas_equalTo(weaks.mas_right).offset(-15);
    }];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *cellIdentify = @"ZDHScreenSecondCell";
    ZDHScreenSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[ZDHScreenSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    return cell;
}

// 添加标题
- (void) loadTitilzWithString:(NSString *)titleString{
    _labelLeftTitle.text = titleString;
}

// 改变字体与选择
- (void) titleColorSelected:(BOOL)flag{
    
    if (flag) {
        _labelLeftTitle.textColor = [UIColor redColor];
        _imageSelected.hidden = NO;
    }
    else{
        _labelLeftTitle.textColor = [UIColor blackColor];
        _imageSelected.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
