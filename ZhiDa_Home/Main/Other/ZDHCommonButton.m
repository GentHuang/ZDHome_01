//
//  ZDHCommonButton.m
//  ZhiDa_Home
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHCommonButton.h"
//Libs
#import "Masonry.h"
//Macros
#define kFontSize 23
#define kSelectedViewHeight 4
@interface ZDHCommonButton()
@property (strong, nonatomic) UIImageView *selectedView;
@property (assign, nonatomic) BOOL isSelected;
@end
@implementation ZDHCommonButton
#pragma mark - Init methods
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
#pragma mark - Life circle
#pragma mark - Getters and setters
- (void)createUI{
    _isSelected = NO;
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.titleLabel.font = FONTSIZESBOLD(kFontSize);
}
- (void)setButtonWithTitleName:(NSString *)titleName{
    
    [self setTitle:titleName forState:UIControlStateNormal];
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    //底部阴影
    NSDictionary *dic = @{NSFontAttributeName:self.titleLabel.font};
    CGRect bounds = [titleName boundingRectWithSize:CGSizeMake(SCREEN_MAX_WIDTH, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    CGFloat selectedViewWidth = bounds.size.width;
    _selectedView = [[UIImageView alloc] init];
    _selectedView.image = [UIImage imageNamed:@"com_btn_line"];
    [self addSubview:_selectedView];
    [_selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(selectedViewWidth);
        make.bottom.equalTo(self).with.offset(@(-kSelectedViewHeight+2));
        make.height.equalTo(@kSelectedViewHeight);
    }];
}
- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (_isSelected == NO) {
        _selectedView.hidden = YES;
    }else{
        _selectedView.hidden = NO;
    }
}
#pragma mark - Event response
#pragma mark - Network request
#pragma mark - Protocol methods
#pragma mark - Other methods
@end
