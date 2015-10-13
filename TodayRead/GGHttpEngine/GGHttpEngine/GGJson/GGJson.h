//
//  GGJson.h
//  GGHttpEngineDemo
//
//  Created by cn on 15/2/27.
//  Copyright (c) 2015年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGJson : NSObject <NSCopying>

- (GGJson *)getJsonForKey:(NSString *)key;
- (GGJson *)getJsonForIndex:(int)index;

- (NSString *)getStringForKey:(NSString *)key;
- (int)getIntForKey:(NSString *)key;
- (long long)getLongLongForKey:(NSString *)key;
- (double)getDoubleForKey:(NSString *)key;
- (BOOL)getBoolForKey:(NSString *)key;
- (id)getObjectForKey:(NSString *)key;

- (NSString *)getStringForIndex:(int)index;
- (int)getIntForIndex:(int)index;
- (long long)getLongLongForIndex:(int)index;
- (BOOL)getBoolForIndex:(int)index;

- (BOOL)haveIntValueForKey:(NSString *)key;
- (BOOL)haveStringValueForKey:(NSString *)key;
- (BOOL)haveJsonValueForKey:(NSString *)key;

- (unsigned int)count;

- (void)printJson;

+ (GGJson *)jsonWithDictonary;
+ (GGJson *)jsonWithArray;
+ (GGJson *)jsonWithObject:(id)object;
+ (GGJson *)jsonWithJsonString:(NSString *)jsonString;

- (NSString *)toString;

// 修改数据相关 不建议使用这些函数，因为无法通知相关的observer数据已被修改
// 插入
- (BOOL)insertData:(id)data atIndex:(NSInteger)index;
- (BOOL)insertData:(NSObject *)data forKey:(NSString *)key;

// 修改值
- (BOOL)setData:(NSObject *)data atIndex:(NSInteger)index;
- (BOOL)setData:(NSObject *)data forKey:(NSString *)key;
- (BOOL)setIntValue:(int)value forKey:(NSString *)key;

//删除
- (BOOL)removeDataAtIndex:(NSInteger)index;

- (void)resetCoreDataFrom:(GGJson *)vdJson;
- (BOOL)addCoreDataForm:(GGJson *)_json keyArray:(NSArray *)keyArray;

@end
