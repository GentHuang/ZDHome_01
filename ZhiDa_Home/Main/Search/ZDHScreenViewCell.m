//
//  ZDHScreenViewCell.m
//  TableView二级联动Demo
//
//  Created by apple on 16/3/11.
//  Copyright (c) 2016年 TTC. All rights reserved.
//

#import "ZDHScreenViewCell.h"
#import "Masonry.h"

@interface ZDHScreenViewCell()

@property(strong, nonatomic) UILabel *labelLeftTitle;
@property(strong, nonatomic) UILabel *labelRight;

@end

@implementation ZDHScreenViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor grayColor];
        [self createUI];
        [self createAutolayout];
    }
    return self;
}

+ (instancetype) cellScreenViewCellWithTableView:(UITableView *)tableView{
    
    static NSString *identify = @"ScreenViewCell";
    ZDHScreenViewCell *screenCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (screenCell == nil) {
        screenCell = [[ZDHScreenViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    return screenCell;
}

- (void)awakeFromNib {
}
// 创建UI
- (void) createUI{
    // 左边title
    _labelLeftTitle = [[UILabel alloc]init];
    _labelLeftTitle.textColor = [UIColor whiteColor];
    _labelLeftTitle.textAlignment = NSTextAlignmentLeft;
    _labelLeftTitle.font = [UIFont systemFontOfSize:25];
//    _labelLeftTitle.font = [UIFont boldSystemFontOfSize:18];
    [self.contentView addSubview:_labelLeftTitle];
    
    // 右边title
    _labelRight = [[UILabel alloc]init];
    _labelRight.textColor = [UIColor whiteColor];
    _labelRight.textAlignment = NSTextAlignmentRight;
    _labelRight.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_labelRight];
}

// 添加约束
- (void) createAutolayout{
    
    __weak __typeof(self.contentView) weaks = self.contentView;
    
    [_labelRight mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(weaks.mas_right).offset(-15);
        make.bottom.mas_equalTo(weaks.mas_bottom).offset(-10);
        
    }];
    
    [_labelLeftTitle mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.centerY.equalTo(weaks.mas_centerY);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(weaks.mas_left).offset(20);
    }];
}



// 添加lable的标题
- (void) titleLableWithString:(NSString *)titleString{
    
    _labelLeftTitle.text = titleString;
}
// 刷新商品分类
- (void) loadGoodsTitle:(NSString *)goodsString{
    
    _labelRight.text = goodsString;
}

// 改变字体颜色
- (void) changeCellTitleColorWithFlag:(BOOL) flag{
    
    if (flag) {
        _labelLeftTitle.textColor = [UIColor redColor];
        _labelRight.textColor = [UIColor redColor];
    }
    else{
        
        _labelLeftTitle.textColor = [UIColor whiteColor];
        _labelRight.textColor = [UIColor whiteColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
