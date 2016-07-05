//
//  ZDHClothDetailTypeCell.m
//  ZhiDa_Home
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHClothDetailTypeCell.h"
#import "ZDHClothDetailCommenCell.h"
//ViewModel
//#import "ZDHClothDetailTypeViewModel.h"
//Lib
#import "Masonry.h"
//CellStatu
#import "ZDHProductDetailCommenCellStatus.h"

// 用途icon模型
#import "ZDHClothIconGettyPelistbyClothIdModel.h"
//Macro
#define kFontSize 20
#define kLabelContentTag 32000
#define kIconButtonTag 31000
@interface ZDHClothDetailTypeCell()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (assign, nonatomic) int imageCount;
@property (assign, nonatomic) int selectedIndex;
@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) NSArray *idArray;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *scrollContentView;
@property (strong, nonatomic) UIImageView *lineImageView;
@property (strong, nonatomic) UIImage *lineImage;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *cellStatusArray;
@property (strong, nonatomic) UILabel *distributLable;
@property (strong, nonatomic) NSMutableArray *modelArray;
@property (assign, nonatomic) NSInteger tagCount;
//@property (strong, nonatomic) ZDHClothDetailTypeViewModel *viewModel;
//暂时
@property (strong, nonatomic) NSArray *nameArray;
@end
@implementation ZDHClothDetailTypeCell
#pragma mark - Init methods
- (void)initData{
    _cellStatusArray = [NSMutableArray array];
    _imageCount = 0;
    //暂时
    _nameArray = @[@"成      分:",@"幅      宽:",@"方      向:",@"洗涤方式:",@"库      存:",@"状      态:",@"用      途:"];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initData];
        [self createUI];
        [self setSubViewsLayout];
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
    [_collectionView registerClass:[ZDHClothDetailCommenCell class] forCellWithReuseIdentifier:@"CommenCell"];
    [self.contentView addSubview:_collectionView];
    
    
    _distributLable  = [[UILabel alloc] init];
    _distributLable.textAlignment = NSTextAlignmentRight;
    _distributLable.backgroundColor = WHITE;
    _distributLable.font = FONTSIZES(kFontSize);
    [self.contentView addSubview:_distributLable];
    
    [_distributLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.left.equalTo(17);
        make.height.equalTo(@kFontSize);
    }];
    
    //暂时
    //创建描述Label
    UIView *lastView;
    for (int i = 0; i < _nameArray.count; i ++) {
        UILabel *allLabel = [[UILabel alloc] init];
        allLabel.textAlignment = NSTextAlignmentRight;
        allLabel.backgroundColor = WHITE;
        allLabel.font = FONTSIZES(kFontSize);
        allLabel.text = _nameArray[i];
        [self.contentView addSubview:allLabel];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.backgroundColor = WHITE;
        contentLabel.tag = i + kLabelContentTag;
        contentLabel.font = FONTSIZES(kFontSize);
        if (i == 6) {
            contentLabel.backgroundColor = PINK;
            contentLabel.layer.masksToBounds = YES;
            contentLabel.layer.cornerRadius = 5;
            contentLabel.textColor = WHITE;
        }
        [self.contentView addSubview:contentLabel];
        
        if (i == 0){
            [allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_distributLable.mas_bottom).with.offset(@5);
                make.left.equalTo(17);
                make.height.equalTo(@kFontSize);
            }];
        }else{
            [allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).with.offset(@5);
                make.left.equalTo(17);
                make.height.equalTo(@kFontSize);
            }];
        }
        lastView = allLabel;
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.mas_top);
            make.left.equalTo(lastView.mas_right);
            make.height.equalTo(lastView.mas_height);
        }];
    }
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
        make.height.equalTo(160/2);
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
    ZDHClothDetailCommenCell *CommenCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommenCell" forIndexPath:indexPath];
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
            ZDHClothDetailCommenCell *selectedCell = (ZDHClothDetailCommenCell *)[collectionView cellForItemAtIndexPath:indexPath];
            if (!selectedCellStatus.isSelected) {
                [selectedCell setIsSelected:YES];
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHClothDetailTypeCell" object:self userInfo:@{@"selectedIndex":_idArray[_selectedIndex]}];
            }
            selectedCellStatus.isSelected = selectedCell.selected;
        }else{
            ZDHProductDetailCommenCellStatus *allCellStatus = _cellStatusArray[i];
            allCellStatus.isSelected = NO;
            NSIndexPath *otherPath = [NSIndexPath indexPathForItem:i inSection:indexPath.section];
            ZDHClothDetailCommenCell *otherCell = (ZDHClothDetailCommenCell *)[collectionView cellForItemAtIndexPath:otherPath];
            [otherCell setIsSelected:NO];
        }
    }
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
        if ([idArray[i] isEqualToString:ID]) {
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
    //创建描述Label
    UIView *lastView;
    for (int i = 0; i < contentArray.count; i ++) {
        UILabel *allLabel = [[UILabel alloc] init];
        allLabel.font = FONTSIZES(kFontSize);
        allLabel.text = contentArray[i];
        [_scrollContentView addSubview:allLabel];
        if (i == 0){
            [allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.left.equalTo(0);
                make.height.equalTo(@kFontSize);
            }];
        }else{
            [allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).with.offset(@5);
                make.left.equalTo(0);
                make.height.equalTo(@kFontSize);
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
//刷新Label
- (void)reloadDescLabelWithArray:(NSArray *)array{
    for (int i = 0; i < array.count; i ++) {
        UILabel *allLabel = (UILabel *)[self viewWithTag:(i+kLabelContentTag)];
        allLabel.text = array[i];
    }
}
// 刷新布的用途
- (void)reflashClothUseWithArray:(NSMutableArray *)modelArray{
    if (_tagCount > 0) {
        
        for (int i = 0; i < _tagCount; i ++) {
            UIButton *btn = (UIButton *)[self viewWithTag:i +  kIconButtonTag];
            [btn removeFromSuperview];
        }
    }
    _modelArray = modelArray;
    UILabel *beforeLable = (UILabel *)[self viewWithTag:(_nameArray.count - 2) + kLabelContentTag];
    UILabel *allLabel = (UILabel *)[self viewWithTag:(_nameArray.count - 1) + kLabelContentTag];
    UIButton *lastIconButton = nil;
    for (NSInteger i = 0; i < modelArray.count; i ++) {
        ZDHClothIconGettyPelistbyClothIdModel *model = modelArray[i];
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:DESIGNIMGURL,model.icon]] placeholderImage:nil];
        UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconButton setBackgroundImage:imageView.image forState:UIControlStateNormal];
        [iconButton addTarget:self action:@selector(iconClassifyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        iconButton.tag = kIconButtonTag + i;
        [self.contentView addSubview:iconButton];
        [iconButton mas_makeConstraints:^(MASConstraintMaker *make){
        
            make.left.equalTo(lastIconButton?lastIconButton.mas_right:allLabel.mas_right).offset(15);
            make.height.width.equalTo(25);
            make.top.equalTo(beforeLable.mas_bottom).offset(5);
        }];
        lastIconButton = iconButton;
    }
    if (lastIconButton) {
        
     [_scrollContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(lastIconButton.mas_bottom);
     }];
    }
    
    _tagCount = modelArray.count;
}
// 用于返回按钮的model
- (void) iconClassifyButtonClick:(UIButton *)btn{
    
    self.useIconButton(btn);
}

- (void) reloadDistributeWithLableTitle:(NSString *)labelTitle{
    
    _distributLable.text = [NSString stringWithFormat:@"所属布板:%@",labelTitle];
}
@end
