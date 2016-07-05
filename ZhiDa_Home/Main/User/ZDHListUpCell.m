//
//  ZDHListUpCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHListUpCell.h"
//Libs
#import "Masonry.h"
@interface ZDHListUpCell()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *sizeLabel;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UILabel *progressLabel;

//提示更新图标
//@property (strong, nonatomic) UILabel *prompt;
@end
@implementation ZDHListUpCell
#pragma mark - Init methods
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        [self setSubViewLayout];
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
    //TitleLabel
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"罗兰德";
    _titleLabel.font = FONTSIZES(22);
    [self.contentView addSubview:_titleLabel];
    //SizeLabel
    _sizeLabel = [[UILabel alloc] init];
    _sizeLabel.text = @"120.29MB";
    _sizeLabel.textColor = [UIColor colorWithRed:143/256.0 green:143/256.0 blue:143/256.0 alpha:1];
    _sizeLabel.font = FONTSIZES(18);
    [self.contentView addSubview:_sizeLabel];
    //RightImageView
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"vip_btn_download"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_rightButton];
    //LineView
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = LIGHTGRAY;
    [self.contentView addSubview:_lineView];
    //进度条
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.hidden = YES;
    _progressView.progress = 0;
    [self.contentView addSubview:_progressView];
    //进度文字
    _progressLabel = [[UILabel alloc] init];
    _progressLabel.text = @"等待下载";
    _progressLabel.hidden = YES;
    _progressView.tintColor = [UIColor colorWithRed:37/256.0 green:137/256.0 blue:201/256.0 alpha:1];
    _progressLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_progressLabel];
    //展开按钮
    _spreadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _spreadButton.backgroundColor = WHITE;
    [_spreadButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_spreadButton setImage:[UIImage imageNamed:@"vip_download_icon_nor"] forState:UIControlStateNormal];
    [_spreadButton setImage:[UIImage imageNamed:@"vip_download_icon_select"] forState:UIControlStateSelected];
    [_spreadButton setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 20, 45)];
    [self.contentView addSubview:_spreadButton];
    
    //提示更新图标
    _promptLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_promptLabel];
    _promptLabel.text = @"new";
    _promptLabel.font = [UIFont systemFontOfSize:16];
    _promptLabel.textAlignment = NSTextAlignmentCenter;
    _promptLabel.textColor = [UIColor whiteColor];
    _promptLabel.backgroundColor = [UIColor redColor];
    
    _promptLabel.layer.cornerRadius = 13;
    _promptLabel.layer.masksToBounds = YES;
    _promptLabel.layer.shadowColor = [UIColor blueColor].CGColor;
    _promptLabel.layer.shadowRadius = 2.0;
    _promptLabel.layer.borderColor = [UIColor grayColor].CGColor;
    _promptLabel.layer.borderWidth = 2.0f;
    
    _promptLabel.hidden = YES;
}
- (void)setSubViewLayout{
    //LineView
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.right.equalTo(-20);
        make.bottom.equalTo(-1);
        make.height.equalTo(1);
    }];
    //TitleLabel
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_lineView.mas_top).with.offset(-30);
        make.left.equalTo(_lineView.mas_left);
        make.width.equalTo(500);
        make.height.equalTo(22);
    }];
    //sizeLabel
    [_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom);
        make.left.equalTo(_titleLabel.mas_left);
        make.width.equalTo(500);
        make.height.equalTo(18);
    }];
    //rightButton
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(17);
        make.height.equalTo(20);
        make.right.equalTo(_lineView.mas_right);
        make.centerY.equalTo(self.contentView);
    }];
    //进度条
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_lineView.mas_right).with.offset(-176/2);
        make.top.equalTo(64/2);
        make.width.equalTo(796/2);//996/2
        make.height.equalTo(3);
    }];
    //进度文字
    [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_progressView.mas_centerX);
        make.top.equalTo(_progressView.mas_bottom).with.offset(6);
        make.width.equalTo(100);
        make.height.equalTo(15);
    }];
    //展开按钮
    [_spreadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(_lineView.mas_left).with.offset(500/2);//250/2
        make.width.equalTo(70);
        make.height.equalTo(self.contentView.mas_height).with.offset(-10);
    }];
    //提示更新图标
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(50);
        make.height.equalTo(20);
        make.left.equalTo(_lineView.mas_left).with.offset(220);
        make.top.equalTo(_titleLabel.mas_top).with.offset(5);
    }];
}
#pragma mark - Event response
//点击下载获取暂停
- (void)buttonPressed:(UIButton *)button{
    
    if (button == _spreadButton) {
        self.spreadButtonBlock(button);
    }else{
        self.buttonBlock(button);
    }
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新
- (void)reloadCellTitle:(NSString *)title size:(NSString *)size{
    _titleLabel.text = title;
    _sizeLabel.text = size;
}
//设置Cell样式
- (void)setCellMode:(CellMode)mode{
    switch (mode) {
        case 0:
            [self setStartDownloadMode];
            break;
        case 1:
            [self setStopDownloadMode];
            break;
        case 2:
            [self setFinishDownloadMode];
            break;
        case 3:
            [self setContinueDownloadMode];
            break;
        default:
            break;
    }
}
//开始下载
- (void)setStartDownloadMode{
    _rightButton.enabled = YES;
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"vip_btn_download"] forState:UIControlStateNormal];
    [_rightButton setTitle:@"" forState:UIControlStateNormal];
    _rightButton.layer.borderWidth = 0;
    [_rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(17);
        make.height.equalTo(20);
    }];
}
//暂停下载
- (void)setStopDownloadMode{
    _rightButton.enabled = YES;
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"nil"] forState:UIControlStateNormal];
    [_rightButton setTitle:@"暂停" forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _rightButton.layer.borderColor = [[UIColor colorWithRed:166/256.0 green:166/256.0 blue:166/256.0 alpha:1] CGColor];
    _rightButton.layer.borderWidth = 1;
    _rightButton.layer.masksToBounds = YES;
    _rightButton.layer.cornerRadius = 4;
    [_rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(134/2);
        make.height.equalTo(64/2);
    }];
}
//已经下载
- (void)setFinishDownloadMode{
    _rightButton.enabled = NO;
    _rightButton.layer.borderWidth = 0;
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"nil"] forState:UIControlStateNormal];
    [_rightButton setTitle:@"已下载" forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor colorWithRed:166/256.0 green:166/256.0 blue:166/256.0 alpha:1] forState:UIControlStateNormal];
    [_rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(134/2);
        make.height.equalTo(64/2);
    }];
}
//继续下载
- (void)setContinueDownloadMode{
    _rightButton.enabled = YES;
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"nil"] forState:UIControlStateNormal];
    [_rightButton setTitle:@"继续" forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _rightButton.layer.borderColor = [[UIColor colorWithRed:166/256.0 green:166/256.0 blue:166/256.0 alpha:1] CGColor];
    _rightButton.layer.borderWidth = 1;
    _rightButton.layer.masksToBounds = YES;
    _rightButton.layer.cornerRadius = 4;
    [_rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(134/2);
        make.height.equalTo(64/2);
    }];
}
//刷新进度条
- (void)reloadProgressView:(CGFloat)progress isDownload:(BOOL)isDownloading{
    if (progress == 0) {
        if (isDownloading) {
            _progressLabel.hidden = NO;
            _progressView.hidden = NO;
            _progressLabel.text = @"等待下载";
        }else{
            _progressLabel.hidden = YES;
            _progressView.hidden = YES;
        }
    }else if(progress == 1){
        _progressLabel.hidden = YES;
        _progressView.hidden = YES;
        [self setCellMode:kFinishDownloadMode];
    }else if(progress > 0){
        _progressLabel.hidden = NO;
        _progressView.hidden = NO;
        _progressView.progress = progress;
        _progressLabel.text = [NSString stringWithFormat:@"%.02f%%",progress*100];
    }
}
//选择Cell的类型
- (void)setCellType:(CellType)type{
    switch (type) {
        case 0:
            [self setUpCellType];
            break;
        case 1:
            [self setDownCellType];
            break;
        default:
            break;
    }
}
//上部的Cell
- (void)setUpCellType{
    _spreadButton.hidden = YES;
}
//下部的Cell
- (void)setDownCellType{
    _spreadButton.hidden = NO;
}

//是否显示提示更新图标

@end
