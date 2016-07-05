//
//  ZDHListSpreadView.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/12.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHListSpreadView.h"
//Lib
#import "Masonry.h"
//Macro
#define kTitleFont 13
@interface ZDHListSpreadView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) UIImageView *downImageView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@end

@implementation ZDHListSpreadView
#pragma mark - Init methods
- (instancetype)init{
    if (self = [super init]) {
        [self createUI];
        [self setSubViewLayout];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    self.backgroundColor = CLEAR;
    //collectionView
    //布局
    _layout = [[UICollectionViewFlowLayout alloc] init];
    //修改item大小
    _layout.itemSize = CGSizeMake(270/2, kTitleFont);
    //上下左右偏移
    _layout.sectionInset = UIEdgeInsetsMake(69/2, 69/2, 69/2, 0);
    //左右两个item的最小间距
    _layout.minimumInteritemSpacing = 0;
    //上下两个item的最小间距
    _layout.minimumLineSpacing = kTitleFont;
    //滚动的方向
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //CollectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.layer.borderWidth = 0.5;
    _collectionView.layer.borderColor = [[UIColor colorWithRed:201/256.0 green:201/256.0 blue:201/256.0 alpha:1] CGColor];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.scrollEnabled = NO;
    [self addSubview:_collectionView];
    //三角形
    _downImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_down_btn_jiao"]];
    _downImageView.backgroundColor = WHITE;//WHITE
    [self addSubview:_downImageView];
}
- (void)setSubViewLayout{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(972/2);
    }];
    //三角形
    [_downImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(27/2);
        make.height.equalTo(25/2);
        make.bottom.equalTo(0);
        make.left.equalTo(255);//255/2
    }];
    //CollectionView
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.bottom.equalTo(-15/2);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
//UICollectionViewDataSource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_dataArray.count < 1) {
        return 10;
    }else{
        return _dataArray.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = WHITE;
    if (_dataArray.count > 0) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = _dataArray[indexPath.item];
        titleLabel.font = [UIFont systemFontOfSize:kTitleFont];
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return cell;
}
//UICollectionViewDelegate

#pragma mark - Other methods
//刷新SpreadView
- (void)reloadSpreadViewWithArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [_collectionView reloadData];
    int row;
    if (_dataArray.count%3==0) {
        row = (int)_dataArray.count/3;
    }else{
        row = (int)_dataArray.count/3+1;
    }
    CGFloat collectionViewHeight = row*2*kTitleFont+69+15/2-kTitleFont;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(collectionViewHeight);
    }];
    [self layoutIfNeeded];
}
@end
