//
//  FMDBManager.h


#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface FMDBManager : NSObject
// 单例方法
+ (FMDBManager *)sharedInstace;

// 创建表
- (void)creatTable:(id)model;

// 数据库增加或更新
-(void)insertAndUpdateModelToDatabase:(id)model;

// 按关键字删除对应实体
- (void)deleteModelInDatabase:(id)model withDic:(NSDictionary *)infoDic;

// 数据库删除所有实体
- (void)deleteModelAllInDatabase:(id)model;

// 数据库查询所有实体
- (void)selectModelArrayInDatabase:(id)model success:(SuccessBlock)successBlock fail:(FailBlock)failBlock;

// 数据库按关键字查询实体
- (void)selectModelArrayInDatabase:(id)model withDic:(NSDictionary *)infoDic success:(SuccessBlock)successBlock fail:(FailBlock)failBlock;

//修改对应的数据
- (void)insertAndUpdateModelToDatabaseWithName:(id)model;

//更新修改数据库(new)
-(void)update:(NSString *)tableName WithSetValue:(NSDictionary *)dic withWhere:(NSDictionary *)whereDic;
@end
