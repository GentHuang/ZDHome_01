//
//  ZDDesignMethodsCollectionView.m
//  ZhiDa_Home
//
//  Created by apple on 16/3/24.
//  Copyright (c) 2016年 软碟技术. All rights reserved.
//

#import "ZDDesignMethodsCollectionView.h"
#import "ZDDesignMethodCollectionCell.h"
#import <Masonry.h>
@interface ZDDesignMethodsCollectionView()
<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) UILabel *labelImageCount;
@end

@implementation ZDDesignMethodsCollectionView

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
    //布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //修改item大小
    layout.itemSize = CGSizeMake(SCREEN_MAX_WIDTH, 510);
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
    [_collectionView registerClass:[ZDDesignMethodCollectionCell class] forCellWithReuseIdentifier:@"cell"];
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
    ZDDesignMethodCollectionCell *cell = (ZDDesignMethodCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadImageViewWithImage:_imageArray[indexPath.row]];
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = _collectionView.contentOffset.x / SCREEN_MAX_WIDTH;
    _labelImageCount.text = [NSString stringWithFormat:@"%d/%zd",index+1,_imageArray.count];
}
#pragma mark - Other methods
//添加大图
- (void)loadBigImageWithImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    _labelImageCount.text = [NSString stringWithFormat:@"1/%zd",_imageArray.count];
    [_collectionView reloadData];
    //重第一张开始
    [_collectionView setContentOffset:CGPointMake(0, 0)];
    if (_imageArray.count<2) {
        _labelImageCount.hidden = YES;
    }else {
        _labelImageCount.hidden = NO;
    }
    
}
@end
