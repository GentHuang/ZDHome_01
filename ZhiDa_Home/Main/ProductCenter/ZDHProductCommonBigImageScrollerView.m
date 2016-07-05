//
//  ZDHProductCommonBigImageScrollerView.m
//  
//
//  Created by apple on 16/3/21.
//
//

#import "ZDHProductCommonBigImageScrollerView.h"
#import "ZDHProductCommonBigImageView.h"
#import "Masonry.h"

#define KSCrollWitdh 1024
#define KSCrollHeight 659
@interface ZDHProductCommonBigImageScrollerView()<UIScrollViewDelegate>

@property (assign, nonatomic) int scrollerIndex;
@property (strong, nonatomic) UILabel *labelImageCount;
@property (strong, nonatomic) UIScrollView *scrollerView;
//@property (strong, nonatomic) ZDHProductCommonBigImageView *bigImageView;
@property (strong, nonatomic) UIView *scrollContentView;
@property (strong, nonatomic) NSMutableArray *scrollerImageArray;

@end

@implementation ZDHProductCommonBigImageScrollerView

- (void) initData{
    // 当前界面的图片的索引
    _scrollerIndex = 0;
    
}

- (instancetype) init{
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initData];
        [self createUI];
        [self createAutolayout];
    }
    return self;
}

// 添加UI
- (void) createUI{
    
    _scrollerView = [[UIScrollView alloc]init];
    _scrollerView.pagingEnabled = YES;
    _scrollerView.showsHorizontalScrollIndicator = NO;
    _scrollerView.showsVerticalScrollIndicator = NO;
    _scrollerView.delegate = self;
    _scrollerView.backgroundColor = WHITE;
    [self addSubview:_scrollerView];
    //ContentView
    _scrollContentView = [[UIView alloc] init];
    [_scrollerView addSubview:_scrollContentView];
    
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

// 添加约束
- (void) createAutolayout{
    
    [_labelImageCount mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.width.height.mas_equalTo(40);
        make.top.equalTo(self.mas_top).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    
    [_scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.equalTo(self);
    }];
    //ContentView
    [_scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollerView);
        make.height.equalTo(_scrollerView);
    }];
}

// 添加图片的滚动
- (void) loadBigImageWithImageArray:(NSArray *) imageArray{
    // 删除
    for (UIView *subView in _scrollContentView.subviews) {
        if ([subView isKindOfClass:[ZDHProductCommonBigImageView class]]) {
            
            [subView removeFromSuperview];
        }
    }
    [_scrollerView setContentOffset:CGPointMake(0 * KSCrollWitdh, 0) animated:YES];
    ZDHProductCommonBigImageView *lastBigImage = nil;
    _scrollerImageArray = [[NSMutableArray alloc]initWithArray:imageArray];
     [self reflashImagePageWithPage:1 sumPage:_scrollerImageArray.count];
    for (NSInteger i = 0 ; i < imageArray.count; i++) {
        
        ZDHProductCommonBigImageView *bigImage = [[ZDHProductCommonBigImageView alloc]init];
        [bigImage reloadImageView:imageArray[i]];
        [_scrollContentView addSubview:bigImage];
        [bigImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(_scrollerView.mas_centerY);
            make.left.equalTo(@(i*(KSCrollWitdh)));
            make.size.equalTo(bigImage.image.size);
        }];
        lastBigImage = bigImage;
    }
    
    [_scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastBigImage.mas_right);
    }];
}
// 计算目前的数据
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int index = _scrollerView.contentOffset.x / KSCrollWitdh;
    [self reflashImagePageWithPage:index + 1 sumPage:_scrollerImageArray.count];
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
      int index = _scrollerView.contentOffset.x / KSCrollWitdh;
    _scrollerIndex = index;
    NSDictionary *dic = @{@"scrollerIndex":[NSString stringWithFormat:@"%d",index + 1]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHProductCommonBigImageScrollerView" object:self userInfo:dic];
}

// 刷新图片的数量以及目前的张数
- (void) reflashImagePageWithPage:(NSInteger)index sumPage:(NSInteger)sum{
    
    _labelImageCount.text = [NSString stringWithFormat:@"%ld/%ld",(long)index,(long)sum];
}
// 根据collectionView改变scrollView当前显示的视图
- (void) loadContentViewWithIndex:(NSInteger)index{
//    NSLog(@"scrollerView --- >%d",index);
    [self reflashImagePageWithPage:1 + index sumPage:_scrollerImageArray.count];
     [_scrollerView setContentOffset:CGPointMake(index * KSCrollWitdh, 0) animated:YES];
}

@end
