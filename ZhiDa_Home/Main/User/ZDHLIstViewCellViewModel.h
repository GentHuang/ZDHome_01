//
//  ZDHLIstViewCellViewModel.h
//  ZhiDa_Home
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 软碟技术. All rights reserved.
//

#import <Foundation/Foundation.h>
//Cell状态
#import "ZDHLIstViewCellStatus.h"

@interface ZDHLIstViewCellViewModel : NSObject
//Cell状态
@property (strong, nonatomic) NSMutableArray *sceneCellStatusArray;
@property (strong, nonatomic) NSMutableArray *clothesCellStatusArray;
//
@property (copy, nonatomic) StringTransBlock FinisUpZIP;

//进度回调
@property (copy, nonatomic) DownloadBlock processBlock;
//放进下载队列
- (void)getIntoDownloadQueue:(NSString *)url titleText:(NSString *)titleText;
//暂停下载
- (void)pauseDownload:(NSString *)urlString;
//初始化SceneCell状态
- (void)storedDataWithSceneArray:(NSArray *)sceneArray realSizeArray:(NSArray *)array;
//初始化ClothesCell状态
- (void)storedDataWithClothesArray:(NSArray *)clothesArray realSizeArray:(NSArray *)array;
//返回Button状态
- (int)getButtonStatus:(ZDHLIstViewCellStatus *)cellStatus;
//返回下载进度
- (CGFloat)getProgress:(ZDHLIstViewCellStatus *)cellStatus;
//返回是否正在下载中
- (BOOL)getIsDownloading:(ZDHLIstViewCellStatus *)cellStatus;
//停止全部任务
- (void)cancelAllDownload;


/**--------添加------*/
@property (strong, nonatomic) NSMutableArray *cellStatusArray;

//添加管理界面 更新列表的cell状态初始化
- (void)storedDataWith:(NSArray *)DownloadModelArray withNetModel:(NSArray*)NetDownloadModelArray;
//删除数据库对应的实体
- (void)removeObjectWithName:(NSString*)title;
//下载的路径 (把下载路径公开)
- (NSString *)getDownloadPath:(NSString *)titleText;
@end
