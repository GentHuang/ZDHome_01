//
//  ZDHNaviClassifyView.m
//
//
//  Created by apple on 16/3/28.
//
//

#import "ZDHNaviClassifyView.h"
#import "Masonry.h"

#define kCLLBUTTONTAG 10000
#define kCLLBUTIONWIDTH 111
#define kCLLBUTIONHEIGHT 49

@interface ZDHNaviClassifyView()

@property (strong, nonatomic) UIView *sectionView;
@property (strong, nonatomic) UIView *buttonView;
@property (strong, nonatomic) UIImageView *sectionImage;
@property (strong, nonatomic) UILabel *sectionLabel;
@property (strong, nonatomic) ZDHSearchViewControllerViewModel *viewModel;
@property (strong, nonatomic) NSArray *modelArray;
@property (copy, nonatomic)  NSString *typeID;
// 箭头图片
@property (strong, nonatomic) UIImageView *nextImageView;
//换成buttong
@property (strong, nonatomic) UIButton *nextButton;

@property (assign, nonatomic) int buttonCount;


@end

@implementation ZDHNaviClassifyView

- (instancetype)init{
    
    if(self = [super init]){
        [self createUI];
        [self createAutolayout];
    }
    return self;
}

- (void) createUI{
    _sectionView = [[UIView alloc]init];
    _sectionView.backgroundColor = GRAY;
    [self addSubview:_sectionView];
    // 创建箭头图标
//        _nextImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav_PullViewSectionNext"]];
//        [_sectionView addSubview:_nextImageView];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sectionView addSubview:_nextButton];
    
    [_nextButton setImage:[UIImage imageNamed:@"nav_PullViewSectionNext"] forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _nextButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    // 组头图标
    _sectionImage = [[UIImageView alloc]init];
    [_sectionView addSubview:_sectionImage];
    // 组头title
    _sectionLabel = [[UILabel alloc]init];
    _sectionLabel.textAlignment = NSTextAlignmentLeft;
    _sectionLabel.textColor = [UIColor blackColor];
    _sectionLabel.font = [UIFont boldSystemFontOfSize:25];
    [_sectionView addSubview:_sectionLabel];
}

- (void) createAutolayout{
    
    [_sectionView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.right.top.equalTo(self).offset(0);
        make.height.mas_equalTo(60);
    }];
    
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.equalTo(_sectionView.mas_left).offset(0);
        make.centerY.equalTo(_sectionView.mas_centerY);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(40);
    }];
    
    [_sectionImage mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.mas_equalTo(_sectionView.mas_left).offset(10);
        make.centerY.equalTo(_sectionView.mas_centerY);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(40);
    }];
    
    [_sectionLabel mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.equalTo(_sectionImage.mas_right).offset(10);
        make.centerY.equalTo(_sectionView.mas_centerY);
    }];
}

- (void) loadSelectedButtonWithArray:(NSMutableArray *)buttonArray sectionIndex:(NSInteger)indexPath withViewModel:(ZDHSearchViewControllerViewModel *)viewModel{
    
    [self deleteAllButton];
    _modelArray = [NSArray arrayWithArray:buttonArray];
    _viewModel = viewModel;
    int index = 0;
    int buttonCount = 0;
    int buttonRemainder = 0;
    _buttonCount = (int)buttonArray.count;
    // 获取行数
    if (buttonArray.count > 0) {
        
        buttonCount = (int)buttonArray.count / 3;
        // 获取多出的
        buttonRemainder = buttonArray.count % 3;
    }
    if (buttonRemainder > 0) {
        
        buttonCount = (buttonCount + 1);
    }
    UIButton *lastButton = nil;
    for (NSInteger i = 0; i < buttonCount; i ++) {
        
        for (NSInteger j = 0; j < 3; j ++) {
            UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            // 给button画边框
            cellBtn.layer.borderColor = KLINECOLOR.CGColor;
            cellBtn.layer.borderWidth = 0.5;
            // 防止数组越界
            if(buttonArray.count > index){
                
                ZDHSearchViewControllerNewListProtypelistChindtypeChindtypeModel *ChindtypeChindtypeModel = buttonArray[index];
                cellBtn.tag = kCLLBUTTONTAG + index;
                [cellBtn setTitle:ChindtypeChindtypeModel.typename_conflict forState:0];
                [cellBtn setTitleColor:[UIColor blackColor] forState:0];
                [cellBtn addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            [self addSubview:cellBtn];
            [cellBtn mas_makeConstraints:^(MASConstraintMaker *make){
                
                make.top.equalTo(self.sectionView.mas_bottom).offset(i * kCLLBUTIONHEIGHT);
                make.width.mas_equalTo(kCLLBUTIONWIDTH);
                make.height.mas_equalTo(kCLLBUTIONHEIGHT);
                make.left.equalTo(self.mas_left).offset(j * kCLLBUTIONWIDTH + 1);
            }];
            index ++;
            lastButton = cellBtn;
        }
        // 用于最后添加下划线
        UIView *viewBackground = [[UIView alloc]init];
        [self addSubview:viewBackground];
        viewBackground.backgroundColor = KLINECOLOR;
        [viewBackground mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.mas_equalTo(0.5);
            make.left.right.equalTo(self).offset(0);
            make.top.equalTo(lastButton.mas_bottom).offset(0);
        }];
    }
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(buttonCount * 50 + 60);
    }];
}
//删除所有按钮
- (void)deleteAllButton{
    if (_buttonCount > 0) {
        for (int i = 0; i < _buttonCount; i ++) {
            UIButton *allButton = (UIButton *)[self viewWithTag:(i+kCLLBUTTONTAG)];
            [allButton removeFromSuperview];
        }
    }
}
- (void)selectedButtonClick:(UIButton *)btn{
    if (btn==_nextButton) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHNaviClassifyTableviewCell" object:self userInfo:@{@"typeID":@"",@"titleName":_sectionLabel.text,@"sectionID":_typeID,@"dataProdutArray":_viewModel.dataProdutArray,@"dataListArray":_viewModel.dataListArray}];
        
    }else {
        ZDHSearchViewControllerNewListProtypelistChindtypeChindtypeModel *ChindtypeChindtypeModel = _modelArray[btn.tag - kCLLBUTTONTAG];
        NSString *type = ChindtypeChindtypeModel.typeid_conflict;
        NSString *titleName = ChindtypeChindtypeModel.typename_conflict;
//        NSLog(@"type == %@   titleName= %@",type,titleName);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDHNaviClassifyTableviewCell" object:self userInfo:@{@"typeID":type,@"titleName":titleName,@"sectionID":_typeID,@"dataProdutArray":_viewModel.dataProdutArray,@"dataListArray":_viewModel.dataListArray}];
    }
}

// 跟新组头以及标题
- (void) reflashSectionImageTitle:(ZDHSearchViewControllerNewListProtypelistChindtypeModel *)listChindtypeModel{
    
    _typeID = listChindtypeModel.typeid_conflict;
    _sectionLabel.text = listChindtypeModel.typename_conflict;
    [_sectionImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:DESIGNIMGURL,listChindtypeModel.img]] placeholderImage:nil];
}

@end
