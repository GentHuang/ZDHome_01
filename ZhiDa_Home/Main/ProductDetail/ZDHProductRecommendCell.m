//
//  ZDHProductRecommendDescCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//View
#import "ZDHProductRecommendCell.h"
#import "ZDHProductDetailCommenCell.h"
////ViewModel
//#import "ZDHProductRecommendCellViewModel.h"
//CellStatu
#import "ZDHProductDetailCommenCellStatus.h"
//Lib
#import "Masonry.h"
@interface ZDHProductRecommendCell()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (assign, nonatomic) int imageCount;
@property (assign, nonatomic) int selectedIndex;
@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) NSArray *pidArray;
@property (strong, nonatomic) NSMutableArray *cellStatusArray;
@property (strong, nonatomic) UIImageView *rightImageView;
@property (strong, nonatomic) UICollectionView *collectionView;
//@property (strong, nonatomic) ZDHProductRecommendCellViewModel *viewModel;
@end
@implementation ZDHProductRecommendCell
#pragma mark - Init methods
- (void)initData{
    _cellStatusArray = [NSMutableArray array];
    _imageCount = 0;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        [self setSubViewLayout];
        [self initData];
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
    //右边图片
    _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_img_recommend"]];
    [self.contentView addSubview:_rightImageView];
    //CollectionView
    //布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //修改item大小
    layout.itemSize = CGSizeMake(75, 75);
    //上下左右偏移
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //左右两个item的最小间距
    layout.minimumInteritemSpacing = 11;
    //上下两个item的最小间距
    layout.minimumLineSpacing = 11;
    //滚动的方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //CollectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ZDHProductDetailCommenCell class] forCellWithReuseIdentifier:@"CommenCell"];
    [self.contentView addSubview:_collectionView];
    //ViewModel
//    _viewModel = [[ZDHProductRecommendCellViewModel alloc] init];
}
- (void)setSubViewLayout{
    //右边图片
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(8);
        make.left.equalTo(10);
        make.width.equalTo(25);
        make.height.equalTo(105);
    }];
    //CollectionView
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightImageView.mas_top);
        make.left.equalTo(_rightImageView.mas_right).with.equalTo(20);
        make.width.equalTo(260);
        make.bottom.equalTo(-20);
    }];
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
//UICollectionViewDataSource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_imageCount > 0) {
        return _imageCount;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZDHProductDetailCommenCell *CommenCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommenCell" forIndexPath:indexPath];
    if (_imageCount > 0) {
        ZDHProductDetailCommenCellStatus *cellStatus = _cellStatusArray[indexPath.item];
        [CommenCell setIsSelected:cellStatus.isSelected];
        //下载图片
        [CommenCell reloadImageView:_imageArray[indexPath.item]];
    }
    return CommenCell;
}
//UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = (int)indexPath.item;
    _pressedBlock(_pidArray[_selectedIndex]);
}
#pragma mark - Other methods
//刷新图片
- (void)reloadCellImageView:(NSArray *)array pidArray:(NSArray *)pidArray selectedPid:(NSString *)pid{
    _imageArray = array;
    _pidArray = pidArray;
    _imageCount = (int)_imageArray.count;
    for (int i = 0; i < _imageCount; i ++) {
        ZDHProductDetailCommenCellStatus *cellStatus = [[ZDHProductDetailCommenCellStatus alloc] init];
        cellStatus.isSelected = NO;
        if ([pidArray[i] isEqualToString:pid]) {
            cellStatus.isSelected = YES;
        }
        [_cellStatusArray addObject:cellStatus];
    }
    [_collectionView reloadData];
}

@end
