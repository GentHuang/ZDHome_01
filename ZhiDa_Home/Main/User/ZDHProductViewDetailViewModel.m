//
//  ZDHProductViewDetailViewModel.m
//  ZhiDa_Home
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import "ZDHProductViewDetailViewModel.h"
//Model
#import "ZDHProductViewDetailModel.h"
#import "ZDHProductViewDetailShopDetailModel.h"
#import "ZDHProductViewDetailShopDetailOtherlistModel.h"
#import "ZDHProductViewDetailShopDetailCurtainlistModel.h"
#import "ZDHProductViewDetailShopDetailFurniturelistModel.h"
#import "ZDHProductViewDetailShopDetailExpresslistModel.h"
#import "ZDHProductViewDetailShopDetailExpresslistErpexpressinfoModel.h"

@implementation ZDHProductViewDetailViewModel
//根据OrderID获取订单详情
- (void)getProductDetailWithOrderID:(NSString *)orderID success:(SuccessBlock)success fail:(FailBlock)fail{
    //初始化
    _dataDetailArray = [NSMutableArray array];
    _dataExpresslistArray = [NSMutableArray array];
    _dataOtherlistArray = [NSMutableArray array];
    _dataCurtainlistArray = [NSMutableArray array];
    _dataFurniturelistArray = [NSMutableArray array];
    //组建字符串
    NSString *urlString = [NSString stringWithFormat:kGetProductDetailAPI,orderID];
    //请求数据
    [[ZDHNetworkManager sharedManager] GET:urlString parameters:nil success:^void(AFHTTPRequestOperation * opertation, id responseObject) {
        NSArray *responseArray = responseObject;
        ZDHProductViewDetailModel *vcModel = [[ZDHProductViewDetailModel alloc] init];
        [vcModel setValuesForKeysWithDictionary:[responseArray firstObject]];
        ZDHProductViewDetailShopDetailModel *detailModel = vcModel.shop_detail;
        //获取详情信息
        _statusString = detailModel.status;
        [_dataDetailArray addObject:detailModel];
        for (ZDHProductViewDetailShopDetailExpresslistModel *expressListModel in detailModel.expresslist) {
            //获取快递信息
            [_dataExpresslistArray addObject:expressListModel];
        }
        for (ZDHProductViewDetailShopDetailOtherlistModel *otherListModel in detailModel.otherlist) {
            //获取其他信息
            [_dataOtherlistArray addObject:otherListModel];
        }
        for (ZDHProductViewDetailShopDetailFurniturelistModel *furModel in detailModel.furniturelist) {
            //获取家具信息
            [_dataFurniturelistArray addObject:furModel];
        }
        for (ZDHProductViewDetailShopDetailCurtainlistModel *curModel in detailModel.curtainlist) {
            //获取窗帘信息
            [_dataCurtainlistArray addObject:curModel];
        }
        if (_dataDetailArray.count > 0) {
            success(nil);
        }else{
            fail(nil);
        }
    } failure:^void(AFHTTPRequestOperation * opertation, NSError * error) {
        NSLog(@"%@",error);
        fail(nil);
    }];
}
//返回窗帘的行高
- (void)getMaxLineHeighWithDataArray:(NSArray *)dataArray{
    //指定长度数组
    NSArray *widthArray = @[@59,@114,@160,@90,@67,@94];
    //初始化
    _dataMaxHeightArray = [NSMutableArray array];
    float maxHeight = 40.0;
    for (ZDHProductViewDetailShopDetailCurtainlistModel *curModel in dataArray) {
        NSArray *curArray = [NSArray arrayWithObjects:curModel.headname,curModel.headmodule,curModel.headsize,curModel.headnum,@"",curModel.headlayout,curModel.outsidename,curModel.outsidemodule,curModel.outsidesize,curModel.outsidenum,@"",curModel.outsidelayout,curModel.middlename,curModel.middlemodule,curModel.middlesize,curModel.middlenum,@"",curModel.middlelayout,curModel.screenname,curModel.screenmodule,curModel.screensize,curModel.screennum,@"",curModel.screenlayout, nil];
        //存储具体尺寸内容数据
        NSMutableArray *SizeDataArray = [NSMutableArray array];
        //切割othermore 字段内容
        if (curModel.othermore) {
            NSArray *sectionArray = [curModel.othermore componentsSeparatedByString:@"###"];
            //存储每组内容
            
            for (NSString *string in sectionArray) {
                NSArray *subArray= [string componentsSeparatedByString:@"*_*"];
                for (NSString *subString in subArray) {
                    [SizeDataArray addObject:subString];
                    
                }
                [SizeDataArray addObject:@""];
            }
        }
        //添加多扩展内容
        NSMutableArray *AllCurArray = [NSMutableArray arrayWithArray:curArray];
        [AllCurArray addObjectsFromArray:SizeDataArray];
        
        float totalHeight = 0.0;
        for (int i = 0; i < AllCurArray.count; i ++) {
            
            if (i%6 == 0) {
                //每隔6个计算一次行高
                maxHeight = 40.0;
                for (int j = 0; j < 6; j ++) {
                    
                        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20]};
   
                    if((j+i)<AllCurArray.count) {
                        
                        CGRect bounds = [AllCurArray[j+i] boundingRectWithSize:CGSizeMake([widthArray[j] floatValue], 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
//                        NSLog(@"bounds == %@",NSStringFromCGRect(bounds));
                        if (bounds.size.height > maxHeight) {
                            maxHeight = bounds.size.height;
                        }
                   }
                }
                totalHeight += maxHeight;
            }
        }
        
        [_dataMaxHeightArray addObject:[NSNumber numberWithFloat:totalHeight]];
    }
}
@end
