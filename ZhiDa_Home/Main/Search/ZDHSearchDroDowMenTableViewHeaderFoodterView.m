//
//  ZDHSearchDroDowMenTableViewHeaderFoodterView.m
//  下拉菜单Demo
//
//  Created by apple on 16/3/10.
//  Copyright (c) 2016年 TTC. All rights reserved.
//

#import "ZDHSearchDroDowMenTableViewHeaderFoodterView.h"
#import "Masonry.h"

@interface ZDHSearchDroDowMenTableViewHeaderFoodterView()

@property (strong, nonatomic) UILabel *labelTitle;
@property (strong, nonatomic) UIImageView *imageOpenClose;
@property (assign, nonatomic) BOOL isOpen;
@property (strong, nonatomic) UIImageView *segamentLine;

@end
@implementation ZDHSearchDroDowMenTableViewHeaderFoodterView

- (void) initData{
    
    _isOpen = NO;
}

- (instancetype) initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor colorWithRed:99/256.0 green:99/256.0 blue:99/256.0 alpha:1];
        [self initData];
        [self createUI];
        [self createAutolayout];
    }
    return self;
}
// 创建UI
- (void) createUI{
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerViewTap)]];
    _labelTitle = [[UILabel alloc]init];
    _labelTitle.textColor = [UIColor whiteColor];
    _labelTitle.font = [UIFont systemFontOfSize:20];
    _labelTitle.text = @"家具";
    _labelTitle.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_labelTitle];
    
    _imageOpenClose = [[UIImageView alloc]init];
    _imageOpenClose.image = [UIImage imageNamed:@"search_close"];
    [self.contentView addSubview:_imageOpenClose];
    
    _segamentLine = [[UIImageView alloc]init];
    _segamentLine.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_segamentLine];
}
// 给UI添加约束
- (void) createAutolayout{
    
    [_labelTitle mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(20);
        make.height.mas_equalTo(40);
    }];
    
    [_imageOpenClose mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(_imageOpenClose.image.size.height);
    }];
    
    [_segamentLine mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

// 组头
+ (instancetype) headerViewWithTableView:(UITableView *)tableView{
    
    static NSString *headerIdentify = @"MenuTableViewHeaderView";
    ZDHSearchDroDowMenTableViewHeaderFoodterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentify];
    if (headerView == nil) {
        
        headerView = [[ZDHSearchDroDowMenTableViewHeaderFoodterView alloc]initWithReuseIdentifier:headerIdentify];
    }
    return headerView;
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
#define mark - responder Event
- (void)headerViewTap{
    NSDictionary *dic;
    if (_isOpen) {
        _isOpen = NO;
        _imageOpenClose.image = [UIImage imageNamed:@"search_close"];
        dic = @{@"sectionIndex":[NSNumber numberWithInt:_sectionIndex],@"id":@"0"};
    }
    else{
        
        _isOpen = YES;
        _imageOpenClose.image = [UIImage imageNamed:@"search_open"];
        dic = @{@"sectionIndex":[NSNumber numberWithInt:_sectionIndex],@"id":@"1"};

    }
    // 发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ZDHSearchDroDowMenTableViewHeaderFoodterView" object:self userInfo:dic];
}

// 保证转状态
- (void) showSectionOpenflag:(NSString *) flag{
    
    if ([flag isEqualToString:@"0"]) {
        _isOpen = NO;
        _imageOpenClose.image = [UIImage imageNamed:@"search_close"];
    }
    else if([flag isEqualToString:@"1"]){
        
        _isOpen = YES;
        _imageOpenClose.image = [UIImage imageNamed:@"search_open"];
    }
}

// 添加组头文字
- (void) loadTitleText:(NSString *)title{
    
    _labelTitle.text = title;
}

@end




























