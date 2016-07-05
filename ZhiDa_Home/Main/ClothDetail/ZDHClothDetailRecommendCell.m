//
//  ZDHClothDetailRecommendCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHClothDetailRecommendCell.h"
#import "ZDHClothDetailCommenCell.h"
//ViewModel
//#import "ZDHClothDetailRecommendCellViewModel.h"
//CellStatu
#import "ZDHProductDetailCommenCellStatus.h"
//Lib
#import "Masonry.h"
@interface ZDHClothDetailRecommendCell()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (assign, nonatomic) int imageCount;
@property (assign, nonatomic) int selectedIndex;
@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) NSArray *idArray;
@property (strong, nonatomic) NSMutableArray *cellStatusArray;
@property (strong, nonatomic) UIImageView *rightImageView;
@property (strong, nonatomic) UICollectionView *collectionView;
//@property (strong, nonatomic) ZDHClothDetailRecommendCellViewModel *viewModel;
@end
@implementation ZDHClothDetailRecommendCell
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
    _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_img_recommend2"]];
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
    [_collectionView registerClass:[ZDHClothDetailCommenCell class] forCellWithReuseIdentifier:@"CommenCell"];
    [self.contentView addSubview:_collectionView];
    //ViewModel
    //    _viewModel = [[ZDHClothDetailRecommendCellViewModel alloc] init];
}
- (void)setSubViewLayout{
    //右边图片
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(8);
        make.left.equalTo(10);
        make.width.equalTo(28);
        make.height.equalTo(110);
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
    ZDHClothDetailCommenCell *CommenCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommenCell" forIndexPath:indexPath];
    if (_imageCount > 0) {
        //加载状态w
        ZDHProductDetailCommenCellStatus *cellStatus = _cellStatusArray[indexPath.item];
        [CommenCell setIsSelected:cellStatus.isSelected];
        //加载数据
        [CommenCell reloadImageView:_imageArray[indexPath.item]];
    }
    return CommenCell;
}
//UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = (int)indexPath.item;
    _pressedBlock(_idArray[_selectedIndex]);
    //更新Cell的状态
    ZDHProductDetailCommenCellStatus *selectedCellStatus;
    for (int i = 0; i < _imageCount; i ++) {
        if (i == indexPath.item) {
            selectedCellStatus = _cellStatusArray[i];
            ZDHClothDetailCommenCell *selectedCell = (ZDHClothDetailCommenCell *)[collectionView cellForItemAtIndexPath:indexPath];
            if (selectedCellStatus.isSelected) {
                [selectedCell setIsSelected:NO];
            }else{
                [selectedCell setIsSelected:YES];
            }
            selectedCellStatus.isSelected = !selectedCellStatus.isSelected;
        }else{
            ZDHProductDetailCommenCellStatus *allCellStatus = _cellStatusArray[i];
            allCellStatus.isSelected = NO;
            NSIndexPath *otherPath = [NSIndexPath indexPathForItem:i inSection:indexPath.section];
            ZDHClothDetailCommenCell *otherCell = (ZDHClothDetailCommenCell *)[collectionView cellForItemAtIndexPath:otherPath];
            [otherCell setIsSelected:NO];
        }
    }
    self.selectedIndex = (int)indexPath.item;
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHClothDetailRecommendCell" object:self userInfo:@{@"selectedIndex":_idArray[_selectedIndex]}];
    //选中取消效果
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}
#pragma mark - Other methods
//刷新图片
- (void)reloadCellImageView:(NSArray *)array idArray:(NSArray *)idArray selectedID:(NSString *)ID{
    _imageArray = array;
    _idArray = idArray;
    _imageCount = (int)_imageArray.count;
    [_cellStatusArray removeAllObjects];
    for (int i = 0; i < _imageCount; i ++) {
        ZDHProductDetailCommenCellStatus *cellStatus = [[ZDHProductDetailCommenCellStatus alloc] init];
        if ([_idArray[i] isEqualToString:ID]) {
            cellStatus.isSelected = YES;
        }else{
            cellStatus.isSelected = NO;
        }
        [_cellStatusArray addObject:cellStatus];
    }
    [_collectionView reloadData];
}
@end
