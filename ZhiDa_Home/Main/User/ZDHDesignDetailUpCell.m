//
//  ZDHDesignDetailUpCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//View
#import "ZDHDesignDetailUpCell.h"
//Libs
#import "Masonry.h"
//Macros
#define kLabelHeight 30
#define kLeftLabelWidth 130
#define kRightLabelWidth 130
#define kLabelFont 20
#define kLabelTag 24000
@interface ZDHDesignDetailUpCell()
@property (strong, nonatomic) NSArray *nameArray;
@property (strong, nonatomic) NSArray *leftContentArray;
@property (strong, nonatomic) NSArray *rightNameArray;
@property (strong, nonatomic) NSArray *rightContentArray;
@property (strong, nonatomic) UIView *scrollViewContentView;
@end

@implementation ZDHDesignDetailUpCell
#pragma mark - Init methods
- (void)initData{
    _nameArray = @[@"设计单号:",@"门店:",@"客户:",@"客户联系电话:",@"省/市:",@"楼盘:",@"户型:",@"类型:",@"风格:",@"家庭状况:",@"客户预算:",@"期望完成时间:",@"提交日期:",@"",@"详细地址:",@"详细说明:",@"偏好产品:",@"附件:"];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initData];
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
    self.backgroundColor = WHITE;
    //创建列表
    UIView *lastLeftView;
    UIView *lastRightView;
    for (int i = 0; i < _nameArray.count; i ++) {
        //标题
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.text = _nameArray[i];
        leftLabel.textAlignment = NSTextAlignmentRight;
        leftLabel.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1];
        leftLabel.font = FONTSIZES(kLabelFont);
        [self.contentView addSubview:leftLabel];
        //偏好产品
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1];
        if(i==0){
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(10);
                make.height.equalTo(@kLabelHeight);
                make.width.equalTo(@kLeftLabelWidth);
                make.top.equalTo(@(i*(kLabelHeight+9)));
            }];
            lastLeftView = leftLabel;
        }else if (i == 14) {
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastLeftView.mas_bottom).with.offset(9);
                make.left.equalTo(10);
                make.height.equalTo(75);
                make.width.equalTo(@kLeftLabelWidth);
            }];
            lastLeftView = leftLabel;
        }else if (i == 15){
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastLeftView.mas_bottom).with.offset(9);
                make.left.equalTo(10);
                make.height.equalTo(160);
                make.width.equalTo(@kLeftLabelWidth);
            }];
            lastLeftView = leftLabel;
            
        }else if (i == 16){
            [leftLabel removeFromSuperview];
            [self.contentView addSubview:backView];
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastLeftView.mas_bottom).with.offset(9);
                make.left.equalTo(10);
                make.height.equalTo(425/2);
                make.width.equalTo(@kLeftLabelWidth);
            }];
            [backView addSubview:leftLabel];
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(45/2);
                make.left.equalTo(77/2);
                make.height.equalTo(20);
                make.right.equalTo(0);
            }];
            lastLeftView = backView;
        }else if (i == 17){
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastLeftView.mas_bottom).with.offset(9);
                make.left.equalTo(10);
                make.height.equalTo(154/2);
                make.width.equalTo(@kLeftLabelWidth);
            }];
            lastLeftView = leftLabel;
        }else if(i%2==0){
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(10);
                make.height.equalTo(@kLabelHeight);
                make.width.equalTo(@kLeftLabelWidth);
                make.top.equalTo(lastLeftView.mas_bottom).with.offset(9);
            }];
            lastLeftView = leftLabel;
        }else{
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(394);
                make.height.equalTo(@kLabelHeight);
                make.width.equalTo(@kRightLabelWidth);
                make.top.equalTo(lastLeftView.mas_top);
            }];
            lastRightView = leftLabel;
        }
        //内容标签
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.tag = i+kLabelTag;
        contentLabel.text = _nameArray[i];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1];
        contentLabel.font = [UIFont systemFontOfSize:17.5];
        contentLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:contentLabel];
        if(i >= 14) {
            //偏好产品
            if (i == 16) {
                //偏好产品
                UIScrollView *scrollView = [[UIScrollView alloc] init];
                scrollView.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1];
                [contentLabel removeFromSuperview];
                scrollView.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1];
                [self.contentView addSubview:scrollView];
                [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastLeftView.mas_right);
                    make.height.equalTo(lastLeftView.mas_height);
                    make.right.equalTo(-20);
                    make.top.equalTo(lastLeftView.mas_top);
                }];
                //contenView
                _scrollViewContentView = [[UIView alloc] init];
                [scrollView addSubview:_scrollViewContentView];
                [_scrollViewContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(scrollView);
                    make.width.equalTo(scrollView.mas_width);
                }];
            }else{
                //其他栏目
                [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastLeftView.mas_right);
                    make.height.equalTo(lastLeftView.mas_height);
                    make.right.equalTo(-20);
                    make.top.equalTo(lastLeftView.mas_top);
                }];
            }
        }else if(i%2 == 0){
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastLeftView.mas_right);
                make.height.equalTo(lastLeftView.mas_height);
                make.right.equalTo(-469);
                make.top.equalTo(lastLeftView.mas_top);
            }];
        }else{
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastRightView.mas_right);
                make.height.equalTo(lastRightView.mas_height);
                make.right.equalTo(-20);
                make.top.equalTo(lastRightView.mas_top);
            }];
        }
    }
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//加载基本信息
- (void)reloadCellWithArray:(NSArray *)dataArray{
    if (dataArray.count > 1) {
        for (int i = 0; i < dataArray.count; i ++) {
            UILabel *allLabel = (UILabel *)[self viewWithTag:(i+kLabelTag)];
            allLabel.text = dataArray[i];
        }
    }
}
// 加载偏好产品
- (void)loadAboutProductWithImageArray:(NSArray *)imageArray titleArray:(NSArray *)titleArray{
    //清除旧数据
    for (UIView *subView in _scrollViewContentView.subviews) {
        [subView removeFromSuperview];
    }
    //加载数据
    UIView *lastView;
    for (int i = 0 ; i < imageArray.count; i ++) {
        //背景
        UIView *allBackView = [[UIView alloc] init];
        allBackView.layer.borderWidth = 0.5;
        allBackView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [_scrollViewContentView addSubview:allBackView];
        [allBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(200/2);
            make.width.equalTo(210/2);
            make.top.equalTo((i/6)*(200/2+8)+13);
            make.left.equalTo((i%6)*(210/2+8));
        }];
        lastView = allBackView;
        //编号标签
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = titleArray[i];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:12];
        nameLabel.textColor = [UIColor darkGrayColor];
        [allBackView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(allBackView.mas_centerX);
            make.left.right.equalTo(allBackView);
            make.bottom.equalTo(allBackView.mas_bottom).with.offset(-2);
        }];
        //图片
        UIImageView *allImageView = [[UIImageView alloc] init];
//      [allImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:DESIGNIMGURL,imageArray[i]]]];
        //添加加载提示框
        
        allImageView.backgroundColor = WHITE;
        [allBackView addSubview:allImageView];
        [allImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(90);
            make.height.equalTo(80);
            make.top.equalTo(2);
            make.centerX.equalTo(allBackView.mas_centerX);
        }];
        
        __block SDPieProgressView *pv;
        __block UIImageView *selfView = allImageView;
        [allImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:DESIGNIMGURL,imageArray[i]]] andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //下载图片开始
            //加载进度条
            if (!pv) {
                pv = [[SDPieProgressView alloc] init];
                [selfView addSubview:pv];
                [pv mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(allImageView);
                    make.width.height.mas_equalTo(50);
                }];
            }
            pv.progress = (float)receivedSize/(float)expectedSize;
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //下载完成
            for (UIView *subView in selfView.subviews) {
                if ([subView isKindOfClass:[SDPieProgressView class]]) {
                    [subView removeFromSuperview];
                }
            }
        }];
    }
    [_scrollViewContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom).with.offset(10);
    }];
}
@end
