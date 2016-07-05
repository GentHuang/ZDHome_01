//
//  ZDHDIYBottomRightView.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//
//View
#import "ZDHDIYBottomRightView.h"
#import "ZDHDIYBottomRightButton.h"
//Lib
#import "Masonry.h"
//Macro
#define kUpLeftButtonWidth 87
#define kUpBackViewWidth 210
#define kUpLabelFont 20
#define kDownLeftViewWidth 97//117


#define kUpButtonWidth 161//181
#define kUpButtonHeight 128//148
#define kDownButtonTag 13000
#define kUpImageButtonTag 11000
#define kDownImageButtonTag 72000

@interface ZDHDIYBottomRightView()
@property (assign, nonatomic) int upRightButtonCount;
@property (assign, nonatomic) int downRightButtonCount;
@property (assign, nonatomic) int upSelectedIndex;
@property (assign, nonatomic) int downSelectedIndex;
@property (assign, nonatomic) int typeSelectedIndex;
@property (assign, nonatomic) int downButtonCount;
@property (strong, nonatomic) UIScrollView *upScrollView;
@property (strong, nonatomic) UIView *upContentView;
@property (strong, nonatomic) UIScrollView *downLeftScrollView;
@property (strong, nonatomic) UIView *downLeftContentView;
@property (strong, nonatomic) UIScrollView *downRightScrollView;
@property (strong, nonatomic) UIView *downRightContentView;
//
@property (strong, nonatomic) NSMutableArray *dataSelectedArray;
@property (strong, nonatomic) NSMutableDictionary *dataSelectedDict;
//记录右边选择的位置
@property (assign, nonatomic) int rightSelectedIndex;


@end


@implementation ZDHDIYBottomRightView
#pragma mark - Init methods
-(NSMutableArray*)dataSelectedArray {
    if (!_dataSelectedArray) {
        _dataSelectedArray =[NSMutableArray array];
    }
    return _dataSelectedArray;
}
- (NSMutableDictionary*)dataSelectedDict {
    if (!_dataSelectedDict) {
        _dataSelectedDict =[NSMutableDictionary dictionary];
    }
    return _dataSelectedDict;
}
-(instancetype)init{
    if (self = [super init]) {
        [self createUI];
        [self setSubViewLayout];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    self.backgroundColor = WHITE;
    //ScrollView
    _upScrollView = [[UIScrollView alloc] init];
    _upScrollView.hidden = YES;
    _upScrollView.backgroundColor = WHITE;
    _upScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_upScrollView];
    //UpContentView
    _upContentView = [[UIView alloc] init];
    _upContentView.backgroundColor = WHITE;
    [_upScrollView addSubview:_upContentView];
    //替换模式控件
    //downLeftScrollView
    _downLeftScrollView = [[UIScrollView alloc] init];
    _downLeftScrollView.hidden = YES;
    _downLeftScrollView.backgroundColor = WHITE;
    _downLeftScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_downLeftScrollView];
    //downLeftContentView
    _downLeftContentView = [[UIView alloc] init];
    _downLeftContentView.backgroundColor = WHITE;
    [_downLeftScrollView addSubview:_downLeftContentView];
    //downRightScrollView
    _downRightScrollView = [[UIScrollView alloc] init];
    _downRightScrollView.hidden = YES;
    _downRightScrollView.backgroundColor = [UIColor whiteColor];
    _downRightScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_downRightScrollView];
    //downRightContentView
    _downRightContentView = [[UIView alloc] init];
    [_downRightScrollView addSubview:_downRightContentView];
}
- (void)setSubViewLayout{
    //ScrollView
    [_upScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    //UpContentView
    [_upContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_upScrollView);
        make.height.mas_equalTo(_upScrollView.mas_height);
    }];
    //替换模式控件
    //downLeftScrollView
    [_downLeftScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@kDownLeftViewWidth);
        make.top.left.bottom.mas_equalTo(0);
    }];
    //downLeftContentView
    [_downLeftContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_downLeftScrollView);
        make.width.mas_equalTo(_downLeftScrollView.mas_width);
    }];
    //downRightScrollView
    [_downRightScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(_downLeftScrollView.mas_right);
    }];
    //downRightContentView
    [_downRightContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_downRightScrollView);
        make.height.mas_equalTo(_downRightScrollView.mas_height);
    }];
}
#pragma mark - Event response
//点击右边按钮  - - - - > 右边按钮
- (void)rightButtonPressed:(UIButton *)button{
    
    ZDHDIYBottomRightButton *tmpButton = (ZDHDIYBottomRightButton *)button;
    if (tmpButton.tag < kDownImageButtonTag) {
        //选中按钮操作
        for (int i = 0; i < _upRightButtonCount; i ++) {
            ZDHDIYBottomRightButton *allButton = (ZDHDIYBottomRightButton *)[self viewWithTag:(i+kUpImageButtonTag)];
            [allButton unSelected];
        }
        [tmpButton selected];
        self.upSelectedIndex = (int)(tmpButton.tag - kUpImageButtonTag);
        //ScrollView移动
        CGFloat maxX = _upContentView.frame.size.width - _upScrollView.frame.size.width;
        if (maxX > 0) {
            CGFloat moveX = (_upSelectedIndex-1)*(kUpButtonWidth+55)+94/2;
            if (moveX <= 0) {
                moveX = 0;
            }
            if(moveX >= maxX){
                moveX = maxX;
            }
            [_upScrollView setContentOffset:CGPointMake(moveX, 0) animated:YES];
        }
    }else{
        //选中按钮操作
        for (int i = 0; i < _downRightButtonCount; i ++) {
            
            ZDHDIYBottomRightButton *allButton = (ZDHDIYBottomRightButton *)[self viewWithTag:(i+kDownImageButtonTag)];
            [allButton unSelected];
        }
        [tmpButton selected];
        self.downSelectedIndex = (int)(tmpButton.tag - kDownImageButtonTag);
        //ScrollView移动
        CGFloat maxX = _downRightContentView.frame.size.width - _downRightScrollView.frame.size.width;
        if (maxX > 0) {
            CGFloat moveX = (_downSelectedIndex-1)*(kUpButtonWidth+55)+94/2;
            if (moveX <= 0) {
                moveX = 0;
            }
            if(moveX >= maxX){
                moveX = maxX;
            }
            [_downRightScrollView setContentOffset:CGPointMake(moveX, 0) animated:YES];
        }
    }
 
}
//点击替换类型按钮 - - - - > 点击左边按钮
- (void)buttonPressed:(UIButton *)button{
    
    for (int i = 0; i < _downButtonCount; i ++) {
        UIButton *tmpButton = (UIButton *)[self viewWithTag:(i+kDownButtonTag)];
        tmpButton.selected = NO;
        tmpButton.backgroundColor = WHITE;
    }
    button.selected = YES;
    button.backgroundColor = [UIColor blackColor];
    self.typeSelectedIndex = (int)(button.tag - kDownButtonTag);
    
    //ScrollView移动
    CGFloat maxY = _downLeftContentView.frame.size.height - _downLeftScrollView.frame.size.height;
    if (maxY > 0) {
        CGFloat moveY = (_typeSelectedIndex-1)*40;
        if (moveY <= 0) {
            moveY = 0;
        }
        if(moveY >= maxY){
            moveY = maxY;
        }
        [_downLeftScrollView setContentOffset:CGPointMake(0, moveY) animated:YES];
    }
}
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
//选择上下视图的模式
- (void)setBottomRightViewMode:(RightViewMode)mode;{
    switch (mode) {
        case 0:
            [self useUpMode];
            break;
        case 1:
            [self useDownMode];
            break;
        default:
            break;
    }
}
//清单模式
- (void)useUpMode{
    //清单控件
    _upScrollView.hidden = YES;
    //替换控件
    _downLeftScrollView.hidden = NO;
    _downRightScrollView.hidden = NO;
}
//替换模式
- (void)useDownMode{
    //清单控件
    _upScrollView.hidden = NO;
    //替换控件
    _downLeftScrollView.hidden = YES;
    _downRightScrollView.hidden = YES;
}
//刷新清单图片和标题数据,场景清单的小图列表   - - - - >刷新大图
- (void)reloadUpScrollViewWithArray:(NSArray *)imageArray StringArray:(NSArray *)stringArray index:(int)index{
    
    //清除旧数据
    [self deleteAllSubView:_upContentView];
    //记录选择的图片存入字典
    [self.dataSelectedDict setValue:[NSString stringWithFormat:@"%d",index] forKey:[NSString stringWithFormat:@"%d",self.typeSelectedIndex]];
    
    _upRightButtonCount = (int)imageArray.count;
    if (_upRightButtonCount > 0) {
        UIView *lastView;
        for (int i = 0; i < imageArray.count; i ++) {
            //创建按钮
            ZDHDIYBottomRightButton *upButton = [[ZDHDIYBottomRightButton alloc] init];
            [upButton reloadImageView:imageArray[i]];
            [upButton reloadNumberTitle:stringArray[i]];
            [upButton setTag:(i+kUpImageButtonTag)];
            [upButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            if (i == index) {
                
                [upButton selected];
                [upButton setButtonMode:kBigButtonMode];
            }else{
                
                [upButton unSelected];
                [upButton setButtonMode:kSmallButtonMode];
            }
            [_upContentView addSubview:upButton];
            [upButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_upContentView.mas_centerY);
                make.left.mas_equalTo(i*(kUpButtonWidth+55)+94/2);
                make.width.mas_equalTo(140);
                make.height.mas_equalTo(kUpButtonHeight);
            }];
            lastView = upButton;
        }
        [_upContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(lastView.mas_right);
        }];
    }
}
//刷新替换类型数据
- (void)reloadDownLeftScrollViewWithArray:(NSArray *)array{
    //清除旧数据
    [self deleteAllSubView:_downLeftContentView];
    //初始化字典存储
    for (int i =0 ;i<array.count;i++ ) {
        [self.dataSelectedDict setValue:@"0" forKey:[NSString stringWithFormat:@"%d",i]];
    }
    
    UIButton *lastButton = nil;
    _downButtonCount = (int)array.count;
    if (_downButtonCount > 0) {
        for (int i = 0; i < array.count; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom] ;
            button.backgroundColor = WHITE;
            [button setTag:(i+kDownButtonTag)];//修改
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:WHITE forState:UIControlStateSelected];
            [button setTitle:array[i]  forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                button.backgroundColor = [UIColor blackColor];//改变成黑色
                button.selected = YES;
            }
            
            [_downLeftContentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(0);
                make.height.mas_equalTo(40);
                if (lastButton == nil) {
                    make.top.mas_equalTo(0);
                }else{
                    make.top.mas_equalTo(lastButton.mas_bottom).with.offset(0.5);
                }
            }];
            lastButton = button;
        }
        [_downLeftContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(lastButton.mas_bottom);
        }];
    }
}
//刷新替换产品图片和标题 - - -  - >刷新右边视图
- (void)reloadDownRightScrollViewWithImageArray:(NSArray *)imageArray titleArray:(NSArray *)titleArray{
    
    //清除旧数据
    [self deleteAllSubView:_downRightContentView];
    //取出之前选中的位置
    self.rightSelectedIndex = [[self.dataSelectedDict objectForKey:[NSString stringWithFormat:@"%d",self.typeSelectedIndex]] intValue];
    
    
    _downRightButtonCount = (int)imageArray.count;
    if (_downRightButtonCount > 0) {
        
        UIView *lastView;
        for (int i = 0; i < imageArray.count; i ++) {
            //创建按钮
            ZDHDIYBottomRightButton *downButton = [[ZDHDIYBottomRightButton alloc] init];
            [downButton setButtonMode:kMidButtonMode];
            [downButton reloadImageView:imageArray[i]];
            [downButton reloadNumberTitle:titleArray[i]];
            [downButton setTag:(i+kDownImageButtonTag)];
            [downButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_downRightContentView addSubview:downButton];
            if (i ==  self.rightSelectedIndex) {
                [downButton selected];
            }else{
                [downButton unSelected];
            }
            [downButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_downRightContentView.mas_centerY);
                make.left.mas_equalTo(i*(kUpButtonWidth+55)+94/2);
                make.width.mas_equalTo(kUpButtonWidth);
                make.height.mas_equalTo(kUpButtonHeight);
            }];
            lastView = downButton;
        }
        [_downRightContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(lastView.mas_right).with.offset(94/2);
        }];
    }
}
//清除所有子View
- (void)deleteAllSubView:(UIView *)superView{
    if (superView.subviews.count > 0) {
        for (UIView *subView in [superView subviews]) {
            [subView removeFromSuperview];
        }
    }
}

@end
