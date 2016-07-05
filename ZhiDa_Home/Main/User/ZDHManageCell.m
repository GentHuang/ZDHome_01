//
//  ZDHManageCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHManageCell.h"
//Libs
#import "Masonry.h"
@interface ZDHManageCell()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *sizeLabel;
@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UILabel *progressLabel;
@end
@implementation ZDHManageCell
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
    _titleLabel.text = @"";
    _titleLabel.font = FONTSIZES(22);
    [self.contentView addSubview:_titleLabel];
    //SizeLabel
    _sizeLabel = [[UILabel alloc] init];
    _sizeLabel.text = @"";
    _sizeLabel.textColor = [UIColor colorWithRed:143/256.0 green:143/256.0 blue:143/256.0 alpha:1];
    _sizeLabel.font = FONTSIZES(18);
    [self.contentView addSubview:_sizeLabel];
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
//    _progressLabel.hidden = YES;
    _progressView.tintColor = [UIColor colorWithRed:37/256.0 green:137/256.0 blue:201/256.0 alpha:1];
    _progressLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_progressLabel];
    
    //删除
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_deleteButton setTitleColor:[UIColor colorWithRed:175/256.0 green:175/256.0 blue:175/256.0 alpha:1] forState:UIControlStateDisabled];
    _deleteButton.layer.borderColor = [[UIColor colorWithRed:175/256.0 green:175/256.0 blue:175/256.0 alpha:1] CGColor];
    _deleteButton.layer.borderWidth = 0.5;
//    _deleteButton.layer.masksToBounds = YES;
    _deleteButton.layer.cornerRadius = 4;
    [self.contentView addSubview:_deleteButton];
    //更新
    _updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_updateButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _updateButton.enabled = NO;
    [_updateButton setTitle:@"更新" forState:UIControlStateNormal];
    [_updateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_updateButton setTitleColor:[UIColor colorWithRed:175/256.0 green:175/256.0 blue:175/256.0 alpha:1] forState:UIControlStateDisabled];
    _updateButton.layer.borderColor = [[UIColor colorWithRed:175/256.0 green:175/256.0 blue:175/256.0 alpha:1] CGColor];
    _updateButton.layer.borderWidth = 0.5;
    _updateButton.layer.masksToBounds = YES;
    _updateButton.layer.cornerRadius = 4;
    [self.contentView addSubview:_updateButton];
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
    //删除
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(134/2);
        make.height.equalTo(64/2);
        make.right.equalTo(_lineView.mas_right);
        make.bottom.equalTo(-12);
    }];
    //更新
    [_updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(134/2);
        make.height.equalTo(64/2);
        make.right.equalTo(_deleteButton.mas_left).with.offset(-20);
        make.bottom.equalTo(_deleteButton.mas_bottom);
    }];
//-------------添加的进度条--------------
    //进度条
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(64/2);
        make.right.equalTo(_updateButton.mas_left).with.offset(-70/2);
        make.width.equalTo(680/2);
        make.height.equalTo(3);
    }];
    //进度数字
    [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_progressView.mas_bottom).with.offset(6);
        make.centerX.equalTo(_progressView.mas_centerX);
        make.width.equalTo(100);
        make.height.equalTo(15);
        
    }];
}
#pragma mark - Event response
//点击按钮
- (void)buttonPressed:(UIButton *)button{
        self.buttonBlock(button);
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//刷新
- (void)reloadCellTitle:(NSString *)title size:(NSString *)size{
    _titleLabel.text = title;
    _sizeLabel.text = size;
}
//是否可以更新
- (void)canUpdata:(NSString*)canUpdata{
//    NSLog(@"canUpdata == %@",canUpdata);
    if ([@"yes" isEqualToString:canUpdata]) {
        _updateButton.enabled = YES;
    }
    else if([@"no" isEqualToString:canUpdata]){
        _updateButton.enabled = NO;
    }
}
//刷新进度条
- (void)reloadProgressView:(CGFloat)progress isDownload:(BOOL)isDownloading{
    if (progress == 0) {
        if (isDownloading) {
            _progressLabel.hidden = NO;
            _progressView.hidden = NO;
            _progressLabel.text = @"等待下载";
            _progressView.progress = 0;//预防显示错误
        }else{
            _progressLabel.hidden = YES;
            _progressView.hidden = YES;
        }
    }else if(progress == 1||progress>0.99){
        _progressLabel.hidden = YES;
        _progressView.hidden = YES;
        [self setCellMode:kFinishDownloadMode];
    }else if(progress > 0&&progress<0.99){
        _progressLabel.hidden = NO;
        _progressView.hidden = NO;
        _progressView.progress = progress;
        _progressLabel.text = [NSString stringWithFormat:@"%.02f%%",progress*100];
    }
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

- (void)setStartDownloadMode{
    _updateButton.enabled = YES;
    [_updateButton setTitle:@"更新" forState:UIControlStateNormal];
    
}
- (void)setStopDownloadMode{
    _updateButton.enabled = YES;
    [_updateButton setTitle:@"暂停" forState:UIControlStateNormal];
}
- (void)setFinishDownloadMode{
    _updateButton.enabled = NO;
    [_updateButton setTitle:@"更新" forState:UIControlStateNormal];
}
- (void)setContinueDownloadMode{
    _updateButton.enabled = YES;
    [_updateButton setTitle:@"继续" forState:UIControlStateNormal];
}
@end

