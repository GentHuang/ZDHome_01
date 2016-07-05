//
//  ZDHProductTypeDescCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/17.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//View
#import "ZDHProductTypeCell.h"
#import "ZDHProductDetailCommenCell.h"
//ViewModel
//#import "ZDHProductTypeCellViewModel.h"
//Lib
#import "Masonry.h"
//CellStatu
#import "ZDHProductDetailCommenCellStatus.h"
//Macro
#define kFontSize 20
@interface ZDHProductTypeCell()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (assign, nonatomic) int imageCount;
@property (assign, nonatomic) int selectedIndex;
@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) NSArray *pidArray;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *scrollContentView;
@property (strong, nonatomic) UIImageView *lineImageView;
@property (strong, nonatomic) UIImage *lineImage;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *cellStatusArray;
//@property (strong, nonatomic) ZDHProductTypeCellViewModel *viewModel;
@end
@implementation ZDHProductTypeCell
#pragma mark - Init methods
- (void)initData{
    _cellStatusArray = [NSMutableArray array];
    _imageCount = 0;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        [self setSubViewsLayout];
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
    //ScrollView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_scrollView];
    //ScrollContentView
    _scrollContentView = [[UIView alloc] init];
    [_scrollView addSubview:_scrollContentView];
    //下划线
    _lineImage = [UIImage imageNamed:@"product_img_line"];
    _lineImageView = [[UIImageView alloc] initWithImage:_lineImage];
    [self.contentView addSubview:_lineImageView];
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
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //CollectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ZDHProductDetailCommenCell class] forCellWithReuseIdentifier:@"CommenCell"];
    [self.contentView addSubview:_collectionView];
    //ViewModel
//    _viewModel = [[ZDHProductTypeCellViewModel alloc] init];
}
- (void)setSubViewsLayout{
    //ScrollView
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.left.equalTo(17);
        make.right.equalTo(0);
        make.height.equalTo(110);
    }];
    //ScrollContentView
    [_scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    //下划线
    [_lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(8);
        make.size.equalTo(_lineImage.size);
        make.bottom.equalTo(0);
    }];
    //CollectionView
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_bottom).with.offset(@15);
        make.left.equalTo(_lineImageView.mas_left);
        make.right.equalTo(_lineImageView.mas_right);
        make.bottom.equalTo(-4);
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
        [CommenCell reloadImageView:_imageArray[indexPath.item]];
    }
    return CommenCell;
}
//UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = (int)indexPath.item;
    //更新Cell的状态
    ZDHProductDetailCommenCellStatus *selectedCellStatus;
    for (int i = 0; i < _imageCount; i ++) {
        if (i == indexPath.item) {
            selectedCellStatus = _cellStatusArray[i];
            ZDHProductDetailCommenCell *selectedCell = (ZDHProductDetailCommenCell *)[collectionView cellForItemAtIndexPath:indexPath];
            if (!selectedCellStatus.isSelected) {
                [selectedCell setIsSelected:YES];
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHProductTypeDescCell" object:self userInfo:@{@"selectedIndex":_pidArray[_selectedIndex]}];
            }
            selectedCellStatus.isSelected = selectedCell.selected;
        }else{
            ZDHProductDetailCommenCellStatus *allCellStatus = _cellStatusArray[i];
            allCellStatus.isSelected = NO;
            NSIndexPath *otherPath = [NSIndexPath indexPathForItem:i inSection:indexPath.section];
            ZDHProductDetailCommenCell *otherCell = (ZDHProductDetailCommenCell *)[collectionView cellForItemAtIndexPath:otherPath];
            [otherCell setIsSelected:NO];
        }
    }
    //选中取消效果
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}
#pragma mark - Other methods
//刷新图片
- (void)reloadCellImageView:(NSArray *)array pidArray:(NSArray *)pidArray selectedPid:(NSString *)pid{
    //清空旧数据
    if (_cellStatusArray.count > 0) {
        [_cellStatusArray removeAllObjects];
    }
    _imageArray = array;
    _pidArray = pidArray;
    _imageCount = (int)_imageArray.count;
    for (int i = 0; i < _imageCount; i ++) {
        ZDHProductDetailCommenCellStatus *cellStatus = [[ZDHProductDetailCommenCellStatus alloc] init];
        if ([pidArray[i] isEqualToString:pid]) {
            cellStatus.isSelected = YES;
        }else{
            cellStatus.isSelected = NO;
        }
        [_cellStatusArray addObject:cellStatus];
    }
    [_collectionView reloadData];
}
//刷新文字
- (void)reloadCellContent:(NSArray *)contentArray{
    //清除旧数据
    [self deleteSubViews:_scrollContentView];
    NSString *infoString = [contentArray firstObject];
    NSArray *showInfoArray = [infoString componentsSeparatedByString:@"\n"];
    //创建描述Label
    UIView *lastView;
    for (int i = 0; i < showInfoArray.count; i ++) {
        UILabel *allLabel = [[UILabel alloc] init];
        allLabel.font = FONTSIZES(kFontSize);
        NSMutableArray *stringArray = [NSMutableArray array];
        if (i == 7) {
            
            NSArray *firstSeparateArray = [showInfoArray[i] componentsSeparatedByString:@"$$$"];
            NSArray *secondArray = [NSArray array];
            for (NSInteger i = 0; i < firstSeparateArray.count; i ++) {
                
                secondArray = [firstSeparateArray[i] componentsSeparatedByString:@"[|]"];
                
                NSString *combinationString = [NSString stringWithFormat:@"%@(%@)",[secondArray firstObject],secondArray.count>2?secondArray[secondArray.count - 2]:@""];
                [stringArray addObject:combinationString];
            }
            NSString *combinationString = [stringArray componentsJoinedByString:@" + "];
            if (firstSeparateArray.count > 1) {
            
                allLabel.text = combinationString;
            }
            else{
                
                allLabel.text = [secondArray firstObject];
            }
        
        }else{
            
            allLabel.text = showInfoArray[i];
        }
        allLabel.numberOfLines = 0;
        [_scrollContentView addSubview:allLabel];
        if (i == 0){
            
            [allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.left.equalTo(0);
                make.right.equalTo(_scrollContentView.mas_right).offset(0);
            }];
        }else{
            [allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).with.offset(@5);
                make.left.equalTo(0);
                make.right.equalTo(_scrollContentView.mas_right).offset(0);
            }];
        }
        lastView = allLabel;
    }
    if (lastView) {
        
        [_scrollContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastView.mas_bottom);
        }];
    }
}
//删除子View
- (void)deleteSubViews:(UIView *)view{
    for (UIView *subView in [view subviews]) {
        [subView removeFromSuperview];
    }
}
@end
