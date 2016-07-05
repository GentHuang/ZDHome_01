//
//  ZDHHomePageGroupCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/18.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//Views
#import "ZDHHomePageGroupCell.h"
//Libs
#import "Masonry.h"
//Macros
#define kGroupTag 9000
#define kImageViewTag 31000
#define kNameTitleTag 32000
#define kIntroTitleTag 33000
@implementation ZDHHomePageGroupCell
#pragma mark - Init methods
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
#pragma mark - Life circle
- (void)awakeFromNib {
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
#pragma mark - Getters and setters
- (void)createUI{
    UIImage *backImage = [UIImage imageNamed:@"home_img_design"];
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:backImage];
    backImageView.userInteractionEnabled = YES;
    backImageView.tag = kGroupTag;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed:)];
    [backImageView addGestureRecognizer:tap];
    [self.contentView addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    //设计师图片 名字 简介
    UIView *lastView;
    UIView *lastBackView;
    for (int i = 0; i < 3; i ++) {
        //图片
        UIImageView *allImageView = [[UIImageView alloc] initWithImage:nil];
        allImageView.tag = i + kImageViewTag;
        [backImageView addSubview:allImageView];
        //名字简介背景
        UIView *backView = [[UIView alloc] init];
        [backImageView addSubview:backView];
        if (i == 0) {
            //图片
            allImageView.backgroundColor = [UIColor colorWithRed:238/256.0 green:238/256.0 blue:238/256.0 alpha:1];
            [allImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.bottom.mas_equalTo(self.contentView.mas_centerY);
                make.right.mas_equalTo(-285.5/2);
                make.width.mas_equalTo(248/2);
            }];
            //名字简介背景
            backView.backgroundColor = [UIColor colorWithRed:238/256.0 green:238/256.0 blue:238/256.0 alpha:1];
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(allImageView.mas_bottom);
                make.right.mas_equalTo(-39/2);
                make.left.mas_equalTo(allImageView.mas_right);
                make.height.mas_equalTo(80/2);
            }];
            //名字
            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.text = @"";
            nameLabel.tag = i + kNameTitleTag;
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.font = [UIFont boldSystemFontOfSize:32/2];
            [backView addSubview:nameLabel];
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(20/2);
            }];
            //简介
            UILabel *introLabel = [[UILabel alloc] init];
            introLabel.text = @"";
            introLabel.tag = i + kIntroTitleTag;
            introLabel.textAlignment = NSTextAlignmentLeft;
            introLabel.textColor = [UIColor darkGrayColor];
            introLabel.font = [UIFont boldSystemFontOfSize:21/2];
            [backView addSubview:introLabel];
            [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(nameLabel.mas_bottom);
                make.left.mas_equalTo(20/2);
            }];
        }else if(i == 1){
            //图片
            allImageView.backgroundColor = [UIColor colorWithRed:229/256.0 green:229/256.0 blue:229/256.0 alpha:1];
            [allImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lastView.mas_bottom);
                make.bottom.mas_equalTo(0);
                make.left.mas_equalTo(lastView.mas_right);
                make.right.mas_equalTo(-39/2);
            }];
            //名字简介背景
            backView.backgroundColor = [UIColor colorWithRed:229/256.0 green:229/256.0 blue:229/256.0 alpha:1];
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(allImageView.mas_bottom);
                make.right.mas_equalTo(allImageView.mas_left);
                make.left.mas_equalTo(lastView.mas_left);
                make.height.mas_equalTo(80/2);
            }];
            lastBackView = backView;
            //名字
            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.text = @"";
            nameLabel.tag = i + kNameTitleTag;
            nameLabel.textAlignment = NSTextAlignmentRight;
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.font = [UIFont boldSystemFontOfSize:32/2];
            [backView addSubview:nameLabel];
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.right.mas_equalTo(-20/2);
            }];
            //简介
            UILabel *introLabel = [[UILabel alloc] init];
            introLabel.text = @"";
            introLabel.tag = i + kIntroTitleTag;
            introLabel.textAlignment = NSTextAlignmentRight;
            introLabel.textColor = [UIColor darkGrayColor];
            introLabel.font = [UIFont boldSystemFontOfSize:21/2];
            [backView addSubview:introLabel];
            [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(nameLabel.mas_bottom);
                make.right.mas_equalTo(-20/2);
            }];
        }else if(i == 2){
            //图片
            allImageView.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1];
            [allImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lastView.mas_top);
                make.bottom.mas_equalTo(0);
                make.left.mas_equalTo(self.contentView.mas_centerX).with.offset(1);
                make.right.mas_equalTo(-776/2);
            }];
            //名字简介背景
            backView.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1];
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(allImageView.mas_bottom);
                make.right.mas_equalTo(lastBackView.mas_left);
                make.left.mas_equalTo(allImageView.mas_right);
                make.height.mas_equalTo(80/2);
            }];
            //名字
            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.text = @"";
            nameLabel.tag = i + kNameTitleTag;
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.font = [UIFont boldSystemFontOfSize:32/2];
            [backView addSubview:nameLabel];
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(20/2);
            }];
            //简介
            UILabel *introLabel = [[UILabel alloc] init];
            introLabel.text = @"";
            introLabel.tag = i + kIntroTitleTag;
            introLabel.textAlignment = NSTextAlignmentLeft;
            introLabel.textColor = [UIColor darkGrayColor];
            introLabel.font = [UIFont boldSystemFontOfSize:21/2];
            [backView addSubview:introLabel];
            [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(nameLabel.mas_bottom);
                make.left.mas_equalTo(20/2);
            }];

        }
        lastView = allImageView;
    }
}
#pragma mark - Event response
//点击图片
- (void)tapPressed:(UITapGestureRecognizer *)tap{
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHHomePageGroupCell" object:self];
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//加载设计师图片
- (void)reloadImageWithImageArray:(NSArray *)imageArray{
    for (int i = 0; i < imageArray.count; i ++) {
        UIImageView *allImageView = (UIImageView *)[self.contentView viewWithTag:i+kImageViewTag];
        [allImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:TESTIMGEURL,imageArray[i]]]];
    }
}
//加载设计师名字和简介
- (void)reloadNameWithNameArray:(NSArray *)nameArray introArray:(NSArray *)introArray{
    for (int i = 0; i < nameArray.count; i ++) {
        UILabel *nameLabel = (UILabel *)[self.contentView viewWithTag:i+kNameTitleTag];
        nameLabel.text = nameArray[i];
        UILabel *introLabel = (UILabel *)[self.contentView viewWithTag:i+kIntroTitleTag];
        introLabel.text = introArray[i];
    }
}
@end
