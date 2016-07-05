//
//  ZDHNewsViewControllerViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/11/11.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHNewsViewControllerViewModel.h"
//Model
#import "ZDHNewsViewControllerTitleModel.h"
#import "ZDHNewsViewControllerTitleTypeListModel.h"
#import "ZDHNewsViewControllerInfoModel.h"
#import "ZDHNewsViewControllerInfoListModel.h"
#import "ZDHNewsViewControllerDetailModel.h"
#import "ZDHNewsViewControllerDetailNewsModel.h"

@interface ZDHNewsViewControllerViewModel()
@property (assign, nonatomic) int allDetailCount;
@property (assign, nonatomic) int curDetailCount;
@end
@implementation ZDHNewsViewControllerViewModel
//初始化
- (instancetype)init{
    if (self = [super init]) {
        [self addObserver];
    }
    return self;
}
- (void)dealloc{
    [self removeObserver];
}
//获取内部资讯头部
- (void)getIntetNewsTitleSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataTitleArray = [NSMutableArray array];
    _dataTitleIDArray = [NSMutableArray array];
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:kNewsTitleAPI parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        
//        NSLog(@"返回的数据------>%@",responseObject);
        NSMutableArray *titleArray = [NSMutableArray array];
        NSMutableArray *idArray = [NSMutableArray array];
        NSArray *responseArray = responseObject;
        ZDHNewsViewControllerTitleModel *vcModel = [[ZDHNewsViewControllerTitleModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHNewsViewControllerTitleTypeListModel *listModel in vcModel.type_list) {
            //内部资讯头部信息
            if (![listModel.title isEqualToString:@"新闻"]) {
                [idArray addObject:listModel.typeid_conflict];
                [titleArray addObject:listModel.title];
            }else{
                //新闻资讯ID
                _newsID = listModel.typeid_conflict;
            }
        }
        if (titleArray.count > 0) {
            _dataTitleArray = titleArray;
            _dataTitleIDArray = idArray;
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//        NSLog(@"%@",error);
        fail(nil);
    }];
}
//根据Tid获取资讯简介
- (void)getNewsInfoWithTID:(NSString *)tid success:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataNewsInfoArray = [NSMutableArray array];
    _dataNewsNIDArray = [NSMutableArray array];
    //组建地址
    NSString *urlString = [NSString stringWithFormat:kInterNewsDetailAPI,tid];
    //下载数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
    
        NSMutableArray *infoArray = [NSMutableArray array];
        NSMutableArray *NIDArray = [NSMutableArray array];
        NSArray *responseArray = responseObject;
        ZDHNewsViewControllerInfoModel *infoModel = [[ZDHNewsViewControllerInfoModel alloc] init];
        [infoModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        for (ZDHNewsViewControllerInfoListModel *listModel in infoModel.news_list) {
            listModel.tid = tid;
            //获取资讯简介
            [infoArray addObject:listModel];
            //获取资讯ID
            [NIDArray addObject:listModel.id_conflict];
        }
        if (infoArray.count > 0) {
            _dataNewsInfoArray = infoArray;
            _dataNewsNIDArray = NIDArray;
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//        NSLog(@"%@",error);
        fail(nil);
    }];
}
//根据NID数组获取资讯详情
- (void)getNewsDetailWithNIDArray:(NSArray *)nidArray{
    //初始化
    _dataNewsDetailArray = [NSMutableArray array];
    _curDetailCount = 0;
    _allDetailCount = (int)nidArray.count;
    //网络请求
    _dataDetailArray = [NSMutableArray array];
    //开始下载
    for (int i = 0; i < nidArray.count; i ++) {
        //组建地址
        NSString *urlString = [NSString stringWithFormat:kInterNewsAPI,nidArray[i]];
//        NSLog(@"url------->%@",urlString);
        //下载数据
        [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
            NSArray *responseArray = responseObject;
            ZDHNewsViewControllerDetailModel *detailModel = [[ZDHNewsViewControllerDetailModel alloc] init];
            [detailModel setValuesForKeysWithDictionary:[responseArray firstObject]];
            for (ZDHNewsViewControllerDetailNewsModel *newsModel in detailModel.news_news) {
                newsModel.nid = nidArray[i];
                newsModel.newsIndex = i;
                //获取所有资讯详情
                [_dataDetailArray addObject:newsModel];
            }
            //下载完成
            self.curDetailCount ++;
        } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
//            NSLog(@"%@",error);
        }];
    }
}
#pragma mark - Other methods
//添加观察者
- (void)addObserver{
    //观察资讯详情是否完成下载
    [self addObserver:self forKeyPath:@"curDetailCount" options:NSKeyValueObservingOptionNew context:nil];
}
//删除观察者
- (void)removeObserver{
    [self removeObserver:self forKeyPath:@"curDetailCount"];
}
//观察反馈
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"curDetailCount"]) {
        //资讯详情
        if (_curDetailCount == _allDetailCount) {
            if (_dataDetailArray.count > 0) {
                _dataNewsDetailArray = _dataDetailArray;
            }
            self.detailSuccess(nil);
        }
    }
}
@end
