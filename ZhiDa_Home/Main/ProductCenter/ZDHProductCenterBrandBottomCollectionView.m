//
//  TTCFirstPageBannerView.m
//  TTC_Broadband
//
//  Created by apple on 16/1/12.
//  Copyright (c) 2016年 TTC. All rights reserved.
//

#import "ZDHProductCenterBrandBottomCollectionView.h"
#import "ZDHProductCenterBrandBottomCollectionViewCell.h"
#import "Masonry.h"
#import "ZDHProductCenterBrandBottomImageView.h"

#define kBackWidth 188
#define kBackHeight 129
#define kCellImageTag   2000
@interface ZDHProductCenterBrandBottomCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
@property (assign, nonatomic) int currCount;
@property (assign, nonatomic) CGFloat lastX;
@property (assign, nonatomic) CGFloat pageX;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) UIPageControl *pageVC;
@property (assign, nonatomic) int selectedIndex;
@property (assign, nonatomic) int index;
@property (strong, nonatomic) NSMutableArray *isSelectFlagArray;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic) BOOL isScrollerBigImage;
@end

@implementation ZDHProductCenterBrandBottomCollectionView
#pragma mark - Init methods
- (instancetype)init{
    if (self = [super init]) {
        self.isScrollerBigImage = NO;
        self.index = 0;
        [self createUI];
        [self setSubViewLayout];
        [self notification];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    //布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //修改item大小
    layout.itemSize = CGSizeMake(kBackWidth,kBackHeight);
    //左右两个item的最小间距
    layout.minimumInteritemSpacing = 0;
    //上下两个item的最小间距
    layout.minimumLineSpacing = 15;
    //滚动的方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //CollectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.layer.borderWidth = 1;
    _collectionView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[ZDHProductCenterBrandBottomCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:_collectionView];
}
- (void)setSubViewLayout{
    //collectionView
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self);
        make.height.mas_equalTo(self);
    }];
}

- (void) notification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceive:)
                                                 name:@"ZDHProductCommonBigImageScrollerView"
                                               object:nil];
}

- (void) notificationReceive:(NSNotification *)noti{
    
    if ([noti.name isEqualToString:@"ZDHProductCommonBigImageScrollerView"]) {
        // 根据某个item来改变相应的
        if ([[noti.userInfo valueForKey:@"scrollerIndex"] integerValue] < _imageArray.count) {

            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[noti.userInfo valueForKey:@"scrollerIndex"] integerValue] inSection:0];
            [self itemStatusSelectedChangecollectionView:_collectionView indexPath:indexPath];
        }
    }
}
//获取数据
- (void)reloadRightScrollViewWithArray:(NSArray *)array index:(int)selectedIndex{
    
    _imageArray = [NSArray arrayWithArray:array];
    _isSelectFlagArray = [NSMutableArray array];
    for (NSInteger i = 0; i < _imageArray.count; i ++) {
        if (i == 0) {
            
            [_isSelectFlagArray addObject:@"1"];
        }else{
            
            [_isSelectFlagArray addObject:@"0"];
        }
    }
    [_collectionView reloadData];
}
#pragma mark - Event response
#pragma mark - Data request
#pragma mark - Protocol methods
//UICollectionViewDataSource Method
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (_imageArray.count > 0) {
        return _imageArray.count;
    }else{
        return 0;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZDHProductCenterBrandBottomCollectionViewCell *cell = (ZDHProductCenterBrandBottomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    // 设置cell的标志位
    [cell loadImageViewWithImage:_imageArray[indexPath.item] withIndexTag:_isSelectFlagArray[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.isScrollerBigImage = YES;
    [self itemStatusSelectedChangecollectionView:collectionView indexPath:indexPath];
    self.selectedIndex = (int)indexPath.item;
}

// 改变已选的item的背景图片
- (void) itemStatusSelectedChangecollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
   
    //移动到水平中间
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    for (NSInteger i = 0; i < _imageArray.count; i ++) {
        
        if ([_isSelectFlagArray[i] isEqualToString:@"1"]) {
            
            [_isSelectFlagArray replaceObjectAtIndex:i withObject:@"0"];
            break;
        }
    }
    // 改变已选
    [_isSelectFlagArray replaceObjectAtIndex:indexPath.item withObject:@"1"];
    [_collectionView reloadData];
//    self.isScrollerBigImage = YES;
}
//滚动到指定的位置
- (void)scrollWithIndex:(NSString*)index {
   
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[index integerValue] inSection:0];
    // 过滤大图滚动对底部背景图的影响
    if (_isScrollerBigImage && self.selectedIndex == indexPath.item) {
        _isScrollerBigImage = NO;
        [self bigImageScrollerViewWithCollectionView:_collectionView indexpath:indexPath];
    }
    else if (_isScrollerBigImage == NO) {
        
        [self bigImageScrollerViewWithCollectionView:_collectionView indexpath:indexPath];
    }
}
// 大图被拖动后调用的方法
- (void) bigImageScrollerViewWithCollectionView:(UICollectionView *)collectionView indexpath:(NSIndexPath *)indexPath{
    
    //移动到水平中间
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    for (NSInteger i = 0; i < _imageArray.count; i ++) {
        
        if ([_isSelectFlagArray[i] isEqualToString:@"1"]) {
            
            [_isSelectFlagArray replaceObjectAtIndex:i withObject:@"0"];
            break;
        }
    }
    [_isSelectFlagArray replaceObjectAtIndex:indexPath.item withObject:@"1"];
    [_collectionView reloadData];
}

@end
