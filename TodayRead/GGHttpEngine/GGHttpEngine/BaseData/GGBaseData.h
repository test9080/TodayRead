//
//  GGDataBase.h
//  GGHttpEngineDemo
//
//  Created by cn on 15/2/27.
//  Copyright (c) 2015年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGJson.h"

@class GGDataRequest;
@class GGTask;

static const int GGDATA_REQUEST_REFRESH             = 0;
static const int GGDATA_REQUEST_GETMORE             = GGDATA_REQUEST_REFRESH + 1;

@interface GGBaseData : NSObject
{
    NSMutableDictionary *dataStatusDict;
}

@property (nonatomic, readonly) NSString *dataCategory;
@property (nonatomic, readonly) NSMutableDictionary *dataDict;
@property (nonatomic, readonly) BOOL isInitialized;

- (BOOL)isAutoCache;

- (Class)getDataObjectClassForID:(long long) dataID;

- (NSString *) getCacheDir;

- (void)saveCacheForID:(long long)dataID;
- (void)clearCacheForID:(long long)dataID;
- (void)clearAllCache;
- (void)clearAllCacheSynchronize;

- (GGJson *)getGGJsonObjectForID:(long long)dataID;

- (NSString *)getIDFromLongLong:(long long)theID;

- (GGDataRequest *)getDataRequestForTask:(GGTask *)task;
- (BOOL)refreshMergeDictionarySource:(NSDictionary *)source dest:(NSMutableDictionary *)destDic;
- (BOOL)getMoreMergeDictionarySource:(NSDictionary *)source dest:(NSMutableDictionary *)destDic key:(NSString *)key;
- (BOOL)getMoreMergeDictionarySourceByReverseOrder:(NSDictionary *)source dest:(NSMutableDictionary *)destDic key:(NSString *)key;
- (BOOL)refreshMergeArraySource:(NSArray *)source dest:(NSMutableArray *)destDic;
- (BOOL)getMoreMergeArraySource:(NSArray *)source dest:(NSMutableArray *)destDic;

- (BOOL)refreshMergeDictionarySourceVDJson:(GGJson *)sourceVDJson destVDJson:(GGJson *)destVDJson;
- (BOOL)getMoreMergeDictionarySourceVDJson:(GGJson *)sourceVDJson destVDJson:(GGJson *)destVDJson key:(NSArray *)keyArray;

- (BOOL)processASIHTTPRequest:(GGDataRequest *)dataRequest
                 dataProvider:(GGBaseData *)dataProvider
                       ggJson:(GGJson *)ggJson;

- (BOOL)processRawData:(NSData *)rawData forTask:(GGTask *)task;
- (BOOL)processRawDataString:(NSString *)rawDataString forTask:(GGTask *)task;
- (BOOL)processRawDataGGJson:(GGJson *)rawDataJson forTask:(GGTask *)task;
- (BOOL)processJson:(GGJson *)ggJson forTask:(GGTask *)task;

- (BOOL)isRequest:(GGDataRequest *)dataRequest eaquleTo:(GGDataRequest *)otherDataRequest;

- (void)removeDataAtIndex:(NSIndexPath *)indexPath DataId:(long long)dataID;

@end

@interface GGBaseData(ObjectListQuery)
- (int)objectListCountForID:(long long)dataID;

//列表型数据的 json array
- (GGJson *)objectListDataForID:(long long)dataID;

//列表型数据 在服务器回来json中的key，该key对应的值是一个json array
- (NSString *)objectListKeyForID:(long long)dataID;
@end
