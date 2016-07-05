//
//  ZDHProductCenterBrandBigImageView.m
//  ZhiDa_Home
//
//  Created by apple on 16/3/25.
//  Copyright (c) 2016年 软碟技术. All rights reserved.
//

#import "ZDHProductCenterBrandBigImageView.h"
#import "ZDHProductCenterBrandBigImageCollectionCell.h"
#import <Masonry.h>
@interface ZDHProductCenterBrandBigImageView()
<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//滚动的位置
@property (assign, nonatomic) int scrollerIndex;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) UILabel *labelImageCount;
@property (assign, nonatomic) BOOL isDraged;
@end

@implementation ZDHProductCenterBrandBigImageView

#pragma mark - Init methods
- (instancetype)init{
    if (self = [super init]) {
        [self createUI];
        [self setSubViewLayout];
        self.isDraged = NO;
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    self.scrollerIndex = 0;
    //布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //修改item大小
    layout.itemSize = CGSizeMake(SCREEN_MAX_WIDTH, 501);
    //左右两个item的最小间距
    layout.minimumInteritemSpacing = 0;
    //上下两个item的最小间距
    layout.minimumLineSpacing = 0;
    //滚动的方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //CollectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.layer.borderWidth = 1;
    _collectionView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[ZDHProductCenterBrandBigImageCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:_collectionView];
    
    _labelImageCount = [[UILabel alloc]init];
    _labelImageCount.backgroundColor = [UIColor grayColor];
    _labelImageCount.alpha = 0.5;
    _labelImageCount.layer.cornerRadius = 20.0f;
    _labelImageCount.font = [UIFont systemFontOfSize:15];
    _labelImageCount.textColor = [UIColor whiteColor];
    _labelImageCount.textAlignment = NSTextAlignmentCenter;
    _labelImageCount.layer.masksToBounds = YES;
    [self addSubview:_labelImageCount];
}
- (void)setSubViewLayout{
    [_labelImageCount mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.height.mas_equalTo(40);
        make.top.equalTo(self.mas_top).offset(30);
        make.right.equalTo(self.mas_right).offset(-30);
    }];
    //collectionView
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.height.mas_equalTo(self);
    }];
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
    ZDHProductCenterBrandBigImageCollectionCell *cell = (ZDHProductCenterBrandBigImageCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadImageViewWithImage:_imageArray[indexPath.row]];
    return cell;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isDraged = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int index = _collectionView.contentOffset.x / SCREEN_MAX_WIDTH;
    _labelImageCount.text = [NSString stringWithFormat:@"%d/%zd",index+1,_imageArray.count];
//    if (self.isDraged) {
//        self.isDraged = NO;
    self.scrollerIndex  = index;
//    }
}


#pragma mark - Other methods
//添加大图
- (void)loadBigImageWithImageArray:(NSArray *) imageArray{
    _imageArray = [NSArray arrayWithArray:imageArray];
    _labelImageCount.text = [NSString stringWithFormat:@"1/%zd",_imageArray.count];
    [_collectionView reloadData];
    //重第一张开始
    [_collectionView setContentOffset:CGPointMake(0, 0)];
    //只有一张图片不显示
    if (_imageArray.count < 2) {
        _labelImageCount.hidden = YES;
    }else {
         _labelImageCount.hidden = NO;
    }
}
//滚动到指定的位置
- (void)scrollWithIndex:(NSString*)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[index integerValue] inSection:0];
    //移动到水平中间
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
@end
