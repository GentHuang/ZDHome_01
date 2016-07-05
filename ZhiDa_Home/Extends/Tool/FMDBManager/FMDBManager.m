//
//  FMDBManager.m
#import "FMDBManager.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"
#import <objc/runtime.h>
// 通过实体获取类名
#define KCLASS_NAME(model) [NSString stringWithUTF8String:object_getClassName(model)]
// 通过实体获取属性数组数目
#define KMODEL_PROPERTYS_COUNT [[self getAllProperties:model] count]
// 通过实体获取属性数组
#define KMODEL_PROPERTYS [self getAllProperties:model]
@interface FMDBManager()
@property (strong, nonatomic) FMDatabaseQueue *dbQueue;
@end
@implementation FMDBManager
//初始化方法
-(id) init{
    if(self = [super init]){
        //创建数据库队列
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:[self databaseFilePath]];
    }
    return self;
}
// 单例
+ (FMDBManager *)sharedInstace{
    static FMDBManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FMDBManager alloc] init];
    });
    return manager;
}
// 获取沙盒路径
- (NSString *)databaseFilePath{
    //    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentPath = [filePath objectAtIndex:0];
    //    NSLog(@"%@",filePath);
    NSString *dbFilePath = [DocumentsDirectory stringByAppendingPathComponent:@"projectDB.sqlite"];
    NSLog(@"%@",dbFilePath);
    return dbFilePath;
}
// 创建表
- (void)creatTable:(id)model{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //打开数据库
        // 判断数据是否已经打开
        if (![db open]) {
            [db open];
        }
        //为数据库设置缓存，提高查询效率
        [db setShouldCacheStatements:YES];
        //判断数据库中是否已经存在这个表，如果不存在则创建该表
        if (![db tableExists:KCLASS_NAME(model)]) {
            //   create table weibomodel (id integer primary key,userID text,userClass text,screenName text,name text,province text,city text,location text...)
            //（1）获取类名作为数据库表名
            //（2）获取类的属性作为数据表字段
            
            // 1.创建表语句头部拼接
            NSString *creatTableStrHeader = [NSString stringWithFormat:@"create table %@(id INTEGER PRIMARY KEY",KCLASS_NAME(model)];
            
            // 2.创建表语句中部拼接
            NSString *creatTableStrMiddle =[NSString string];
            for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
                creatTableStrMiddle = [creatTableStrMiddle stringByAppendingFormat:@",%@ TEXT",[KMODEL_PROPERTYS objectAtIndex:i]];
            }
            // 3.创建表语句尾部拼接
            NSString *creatTableStrTail =[NSString stringWithFormat:@")"];
            // 4.整句创建表语句拼接
            NSString *creatTableStr = [NSString string];
            creatTableStr = [creatTableStr stringByAppendingFormat:@"%@%@%@",creatTableStrHeader,creatTableStrMiddle,creatTableStrTail];
            [db executeUpdate:creatTableStr];
            
            NSLog(@"创建完成");
        }
        //    关闭数据库
        //        [db close];
    }];
}
// 数据库增加或更新
-(void)insertAndUpdateModelToDatabase:(id)model{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        // 判断数据库能否打开
        // 判断数据是否已经打开
        if (![db open]) {
            [db open];
        }
        // 设置数据库缓存
        [db setShouldCacheStatements:YES];
        // 判断是否存在对应的userModel表
        if(![db tableExists:KCLASS_NAME(model)]){
            [self creatTable:model];
        }
        //以上操作与创建表是做的判断逻辑相同
        //现在表中查询有没有相同的元素，如果有，做修改操作
        // 拼接查询语句头部
        NSString *selectStr = [NSString stringWithFormat:@"select * from %@ where",KCLASS_NAME(model)];
        // 拼接查询语句尾部
        NSString *selectStrTail = [NSString stringWithFormat:@"%@ = ?",[KMODEL_PROPERTYS objectAtIndex:0]];
        for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i ++) {
            NSString *keyString = [KMODEL_PROPERTYS objectAtIndex:i];
            NSString *valueString = [model valueForKey:[KMODEL_PROPERTYS objectAtIndex:i]];
            //若是数组,字段为空，则不纳入筛选范围
            if ([valueString isKindOfClass:[NSArray class]] || valueString == nil) {
                continue;
            }
            if (i == KMODEL_PROPERTYS_COUNT - 1) {
                selectStrTail = [NSString stringWithFormat:@" %@='%@'",keyString,valueString];
            }else{
                selectStrTail = [NSString stringWithFormat:@" %@='%@' and",keyString,valueString];
            }
            selectStr = [selectStr stringByAppendingString:selectStrTail];
        }
        // 整个查询语句拼接
        FMResultSet * resultSet = [db executeQuery:selectStr];
        if([resultSet next])
        {
            // 拼接更新语句的头部
            NSString *updateStrHeader = [NSString stringWithFormat:@"update %@ set ",KCLASS_NAME(model)];
            // 拼接更新语句的中部
            NSString *updateStrMiddle = [NSString string];
            for (int i = 0; i< KMODEL_PROPERTYS_COUNT; i++) {
                updateStrMiddle = [updateStrMiddle stringByAppendingFormat:@"%@ = ?",[KMODEL_PROPERTYS objectAtIndex:i]];
                if (i != KMODEL_PROPERTYS_COUNT -1) {
                    updateStrMiddle = [updateStrMiddle stringByAppendingFormat:@","];
                }
            }
            // 拼接更新语句的尾部
            NSString *updateStrTail = [NSString stringWithFormat:@" where %@ = '%@'",[KMODEL_PROPERTYS objectAtIndex:0],[model valueForKey:[KMODEL_PROPERTYS objectAtIndex:0]]];
            // 整句拼接更新语句
            NSString *updateStr = [NSString string];
            updateStr = [updateStr stringByAppendingFormat:@"%@%@%@",updateStrHeader,updateStrMiddle,updateStrTail];
            NSMutableArray *propertyArray = [NSMutableArray array];
            
            for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
                NSString *midStr = [model valueForKey:[KMODEL_PROPERTYS objectAtIndex:i]];
                // 判断属性值是否为空
                if (midStr == nil) {
                    midStr = @"none";
                }
                [propertyArray addObject:midStr];
            }
            [db executeUpdate:updateStr withArgumentsInArray:propertyArray];
        }
        //向数据库中插入一条数据
        else{
            // 拼接插入语句的头部
            NSString *insertStrHeader = [NSString stringWithFormat:@"INSERT INTO %@ (",KCLASS_NAME(model)];
            // 拼接插入语句的中部1
            NSString *insertStrMiddleOne = [NSString string];
            for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
                insertStrMiddleOne = [insertStrMiddleOne stringByAppendingFormat:@"%@",[KMODEL_PROPERTYS objectAtIndex:i]];
                if (i != KMODEL_PROPERTYS_COUNT -1) {
                    insertStrMiddleOne = [insertStrMiddleOne stringByAppendingFormat:@","];
                }
            }
            // 拼接插入语句的中部2
            NSString *insertStrMiddleTwo = [NSString stringWithFormat:@") VALUES ("];
            // 拼接插入语句的中部3
            NSString *insertStrMiddleThree = [NSString string];
            for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
                insertStrMiddleThree = [insertStrMiddleThree stringByAppendingFormat:@"?"];
                if (i != KMODEL_PROPERTYS_COUNT-1) {
                    insertStrMiddleThree = [insertStrMiddleThree stringByAppendingFormat:@","];
                }
            }
            // 拼接插入语句的尾部
            NSString *insertStrTail = [NSString stringWithFormat:@")"];
            // 整句插入语句拼接
            NSString *insertStr = [NSString string];
            insertStr = [insertStr stringByAppendingFormat:@"%@%@%@%@%@",insertStrHeader,insertStrMiddleOne,insertStrMiddleTwo,insertStrMiddleThree,insertStrTail];
            NSMutableArray *modelPropertyArray = [NSMutableArray array];
            for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
                NSString *str = [model valueForKey:[KMODEL_PROPERTYS objectAtIndex:i]];
                if (str == nil) {
                    str = @"none";
                }
                [modelPropertyArray addObject: str];
            }
            [db executeUpdate:insertStr withArgumentsInArray:modelPropertyArray];
        }
        // 关闭数据库
        //        [db close];
        [resultSet close];
    }];
}
// 按关键字删除对应实体
- (void)deleteModelInDatabase:(id)model withDic:(NSDictionary *)infoDic{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        // 判断数据是否已经打开
        if (![db open]) {
            [db open];
        }
        // 设置数据库缓存，优点：高效
        [db setShouldCacheStatements:YES];
        // 判断是否有该表
        if(![db tableExists:KCLASS_NAME(model)]){
            return;
        }
        // 删除操作
        // 拼接删除语句
        // delete from tableName where userId = ?
        
        //拼接查询语句
        NSMutableString *deletStr = [NSMutableString stringWithFormat:@"delete from %@ where",KCLASS_NAME(model)];
        for (int i = 0; i < infoDic.allKeys.count; i ++) {
            NSString *keyString = infoDic.allKeys[i];
            NSString *valueString = [infoDic valueForKey:keyString];
            if (i == infoDic.allKeys.count - 1) {
                [deletStr appendString:[NSString stringWithFormat:@" %@='%@'",keyString,valueString]];
            }else{
                [deletStr appendString:[NSString stringWithFormat:@" %@='%@' and",keyString,valueString]];
            }
        }
        [db executeUpdate:deletStr];
        // 关闭数据库
//        [db close];
    }];
}
// 数据库删除所有实体
- (void)deleteModelAllInDatabase:(id)model{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        // 判断数据是否已经打开
        if (![db open]) {
            [db open];
        }
        // 设置数据库缓存，优点：高效
        [db setShouldCacheStatements:YES];
        // 判断是否有该表
        if(![db tableExists:KCLASS_NAME(model)]){
            return;
        }
        // 删除操作
        // 拼接删除语句
        // delete from tableName where userId = ?
        NSString *deletStr = [NSString stringWithFormat:@"delete from %@",KCLASS_NAME(model)];
        [db executeUpdate:deletStr];
        // 关闭数据库
        //        [db close];
    }];
}
// 数据库按关键字查询实体
- (void)selectModelArrayInDatabase:(id)model withDic:(NSDictionary *)infoDic success:(SuccessBlock)successBlock fail:(FailBlock)failBlock{
    //数据数组
    __block NSMutableArray *userModelArray = [NSMutableArray array];
    //查询开始
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback){
        //打开数据库
        // 判断数据是否已经打开
        if (![db open]) {
            [db open];
        }
        // 设置数据库缓存，优点：高效
        [db setShouldCacheStatements:YES];
        // 判断是否有该表
        if(![db tableExists:KCLASS_NAME(model)]){
            failBlock(nil);
            return;
        }
        //定义一个可变数组，用来存放查询的结果，返回给调用者
        //定义一个结果集，存放查询的数据
        //拼接查询语句
        NSMutableString *selectStr = [NSMutableString stringWithFormat:@"select * from %@ where",KCLASS_NAME(model)];
        for (int i = 0; i < infoDic.allKeys.count; i ++) {
            NSString *keyString = infoDic.allKeys[i];
            NSString *valueString = [infoDic valueForKey:keyString];
            if (i == infoDic.allKeys.count - 1) {
                [selectStr appendString:[NSString stringWithFormat:@" %@='%@'",keyString,valueString]];
            }else{
                [selectStr appendString:[NSString stringWithFormat:@" %@='%@' and",keyString,valueString]];
            }
        }
        FMResultSet *resultSet = [db executeQuery:selectStr];
        //判断结果集中是否有数据，如果有则取出数据
        while ([resultSet next]) {
            // 用id类型变量的类去创建对象
            id modelResult = [[[model class]alloc] init];
            for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
                //如果是数组，则不放进Model里面
                NSString *valueString = [KMODEL_PROPERTYS objectAtIndex:i];
                if ([valueString isEqualToString:@"spaceitem"]) {
                    continue;
                }
                [modelResult setValue:[resultSet stringForColumn:[KMODEL_PROPERTYS objectAtIndex:i]] forKey:[KMODEL_PROPERTYS objectAtIndex:i]];
            }
            //将查询到的数据放入数组中。
            [userModelArray addObject:modelResult];
        }
        if (userModelArray.count > 0) {
            successBlock(userModelArray);
        }else{
            failBlock(nil);
        }
        // 关闭数据库
        // [db close];
        [resultSet close];
    }];
}
// 数据库查询所有实体
- (void)selectModelArrayInDatabase:(id)model success:(SuccessBlock)successBlock fail:(FailBlock)failBlock{
    //定义一个可变数组，用来存放查询的结果，返回给调用者
    __block NSMutableArray *userModelArray = [NSMutableArray array];
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback){
        //打开数据库
        // 判断数据是否已经打开
        if (![db open]) {
            [db open];
        }
        // 设置数据库缓存，优点：高效
        [db setShouldCacheStatements:YES];
        // 判断是否有该表
        if(![db tableExists:KCLASS_NAME(model)]){
            failBlock(nil);
            return;
        }
        //定义一个结果集，存放查询的数据
        //拼接查询语句
        NSString *selectStr = [NSString stringWithFormat:@"select * from %@",KCLASS_NAME(model)];
        FMResultSet *resultSet = [db executeQuery:selectStr];
        //判断结果集中是否有数据，如果有则取出数据
        while ([resultSet next]) {
            // 用id类型变量的类去创建对象
            id modelResult = [[[model class]alloc] init];
            for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
                [modelResult setValue:[resultSet stringForColumn:[KMODEL_PROPERTYS objectAtIndex:i]] forKey:[KMODEL_PROPERTYS objectAtIndex:i]];
            }
            //将查询到的数据放入数组中。
            [userModelArray addObject:modelResult];
        }
        if (userModelArray.count > 0) {
            successBlock(userModelArray);
        }else{
            failBlock(nil);
        }
        // 关闭数据库
        // [db close];
        [resultSet close];
    }];
}
//获取所有属性
- (NSArray *)getAllProperties:(id)model{
    u_int count;
    
    objc_property_t *properties  = class_copyPropertyList([model class], &count);
    
    NSMutableArray *propertiesArray = [NSMutableArray array];
    
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    
    free(properties);
    return propertiesArray;
}
#pragma mark   myMethod
//根据model更新数据库
- (void)insertAndUpdateModelToDatabaseWithName:(id)model{
    
    //1.判断是否存在
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback){
        //打开数据库
        // 判断数据是否已经打开
        // 设置数据库缓存
        if (![db open]) {
            NSLog(@"数据库打开失败");
            return;
        }
        [db setShouldCacheStatements:YES];
        // 判断是否存在对应的userModel表
        //以上操作与创建表是做的判断逻辑相同
        //现在表中查询有没有相同的元素，如果有，做修改操作
        // 拼接查询语句头部
        NSString *selectStr = [NSString stringWithFormat:@"select * from %@ where",KCLASS_NAME(model)];
        // 拼接查询语句尾部
        NSString *selectStrTail = [NSString stringWithFormat:@"%@ = ?",[KMODEL_PROPERTYS objectAtIndex:0]];
        for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i ++) {
            NSString *keyString = [KMODEL_PROPERTYS objectAtIndex:i];
            NSString *valueString = [model valueForKey:[KMODEL_PROPERTYS objectAtIndex:i]];
            //若是数组,字段为空，则不纳入筛选范围
            if ([valueString isKindOfClass:[NSArray class]] || valueString == nil) {
                continue;
            }
            if (i == KMODEL_PROPERTYS_COUNT - 1) {
                selectStrTail = [NSString stringWithFormat:@" %@='%@'",keyString,valueString];
            }else{
                selectStrTail = [NSString stringWithFormat:@" %@='%@' and",keyString,valueString];
            }
            selectStr = [selectStr stringByAppendingString:selectStrTail];
        }
        // 整个查询语句拼接
        FMResultSet * resultSet = [db executeQuery:selectStr];
        if([resultSet next])
        {  
            // 拼接更新语句的头部
            NSString *updateStrHeader = [NSString stringWithFormat:@"update %@ set ",KCLASS_NAME(model)];
            // 拼接更新语句的中部
            NSString *updateStrMiddle = [NSString string];
            for (int i = 0; i< KMODEL_PROPERTYS_COUNT; i++) {
                updateStrMiddle = [updateStrMiddle stringByAppendingFormat:@"%@ = ?",[KMODEL_PROPERTYS objectAtIndex:i]];
                if (i != KMODEL_PROPERTYS_COUNT -1) {
                    updateStrMiddle = [updateStrMiddle stringByAppendingFormat:@","];
                }
            }
            // 拼接更新语句的尾部
            NSString *updateStrTail = [NSString stringWithFormat:@" where %@ = '%@'",[KMODEL_PROPERTYS objectAtIndex:0],[model valueForKey:[KMODEL_PROPERTYS objectAtIndex:0]]];
            // 整句拼接更新语句
            NSString *updateStr = [NSString string];
            updateStr = [updateStr stringByAppendingFormat:@"%@%@%@",updateStrHeader,updateStrMiddle,updateStrTail];
            NSMutableArray *propertyArray = [NSMutableArray array];
            
            for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
                NSString *midStr = [model valueForKey:[KMODEL_PROPERTYS objectAtIndex:i]];
                // 判断属性值是否为空
                if (midStr == nil) {
                    midStr = @"none";
                }
                [propertyArray addObject:midStr];
            }
            [db executeUpdate:updateStr withArgumentsInArray:propertyArray];
        }
    
    }];
}

//更新数据库
//更新
-(void)update:(NSString *)tableName WithSetValue:(NSDictionary *)dic withWhere:(NSDictionary *)whereDic{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback){
    
        if (![db open]) {
            NSLog(@"数据库打开失败");
            return;
        }
        if (tableName.length == 0)return ;
        if (dic.count == 0) return ;
        
        NSMutableString *sql = [[NSMutableString alloc]init];
        [sql appendFormat:@"UPDATE %@ SET", tableName];
        for (NSString *key in dic) {
            [sql appendFormat:@" %@=:%@,", key, key];

        }
        if ([@"," isEqualToString:[sql substringWithRange:NSMakeRange(sql.length-1, 1)]]) {
            [sql setString:[sql substringToIndex:sql.length-1]];
        }
        //如果有条件
        if (whereDic.count > 0) {
            [sql appendFormat:@" WHERE"];
            for (NSString *key in whereDic) {
                [sql appendFormat:@" %@=:%@ AND", key, key];

            }
            if ([@"AND" isEqualToString:[sql substringWithRange:NSMakeRange(sql.length-3, 3)]]) {
                [sql setString:[sql substringToIndex:sql.length-3]];
            }
        }
        //整合两个dic的值
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic addEntriesFromDictionary:dic];
        [paramDic addEntriesFromDictionary:whereDic];
        
        NSLog(@"%@", sql);//show sql
        
        [db executeUpdate:sql withParameterDictionary:paramDic];
        
//        [db close];
    }];
    
}


@end
