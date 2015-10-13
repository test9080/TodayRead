//
//  GGDataBase.m
//  GGHttpEngineDemo
//
//  Created by cn on 15/2/27.
//  Copyright (c) 2015年 cn. All rights reserved.
//

#import "GGBaseData.h"
#import "GGTask.h"
#import "GGDataRequest.h"
#import "GGDataRequest.h"
#import "devfs.h"
#import "GGDataManager.h"

@implementation GGBaseData
@synthesize dataCategory;
@synthesize dataDict;
@synthesize isInitialized = _isInitialized;

#pragma mark - Get ID from long long
- (NSString *)getIDFromLongLong:(long long)theID
{
    return [NSString stringWithFormat:@"%lld",theID];
}

#pragma mark - Get the data category
- (NSString *)getCategory
{
    return NSStringFromClass(self.class);
}

#pragma mark - Cache functions, the subclass can override them to control the cache files
- (BOOL)isAutoCache
{
    return NO;
}

- (NSString *)getCacheDir
{
    // !!
    NSString * userID = @"0"; //[KCConfigs sharedInstance].uid;
    return [NSString stringWithFormat:@"%s/%@/%@/", devFS_getDocumentDirectory(), userID, self.dataCategory];
}


- (void)threadOfSaveCacheForID:(NSNumber*)theID
{
    long long dataID = [theID longLongValue];
    // !!
    NSString * userID = @"0"; //[KCConfigs sharedInstance].uid;
    if ([userID length] != 0)
    {
        NSString * dir = [self getCacheDir];
        
        devFS_createFolder([dir cStringUsingEncoding:NSUTF8StringEncoding]);
        
        dir = [NSString stringWithFormat:@"%@%lld.dat",dir, dataID];
        
        id obj = [dataDict objectForKey:[self getIDFromLongLong:dataID]];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            @try
            {
                if ([obj conformsToProtocol:@protocol(NSCoding)])
                {
                    if (![NSKeyedArchiver archiveRootObject:obj toFile:dir])
                    {
                        NSLog(@"write cache failed!!!!%@", self);
                    }
                }
            }
            @catch (...)
            {
                NSLog(@"write cache failed!!!!%@", self);
            }
        });
    }
}

- (void)saveCacheForID:(long long)dataID
{
    //    [self performSelector:@selector(threadOfSaveCacheForID:) onThread:[GGEngine sharedInstance].engineDataThread withObject:[NSNumber numberWithLongLong:dataID] waitUntilDone:NO];
    
    [self threadOfSaveCacheForID:[NSNumber numberWithLongLong:dataID]];
}

- (void)threadOfClearCacheForID:(NSNumber*)theID
{
    long long dataID = [theID longLongValue];
    [dataStatusDict removeObjectForKey:[self getIDFromLongLong:dataID]];
    [dataDict removeObjectForKey:[self getIDFromLongLong:dataID]];
    
    // !!
    NSString * userID = @"0"; //[KCConfigs sharedInstance].uid;
    if ([userID length] != 0)
    {
        NSString * dir = [self getCacheDir];
        
        devFS_createFolder([dir cStringUsingEncoding:NSUTF8StringEncoding]);
        
        dir = [NSString stringWithFormat:@"%@%lld.dat",dir, dataID];
        
        devFS_removeFile([dir UTF8String]);
    }
}

- (void)clearCacheForID:(long long)dataID
{
    [self performSelector:@selector(threadOfClearCacheForID:) onThread:[GGEngine sharedInstance].engineDataThread withObject:[NSNumber numberWithLongLong:dataID] waitUntilDone:NO];
}

- (void)loadAllCache
{
    if (dataDict)
    {
        [dataDict removeAllObjects];
    }
    
    // !!
    NSString * userID = @"0"; //[KCConfigs sharedInstance].uid;
    
    if ([userID length] == 0)
    {
        NSString * dir = [NSString stringWithFormat:@"%s/lastLoginUser.dat", devFS_getDocumentDirectory()];
        userID = [NSString stringWithContentsOfFile:dir encoding:NSUTF8StringEncoding error:nil];
    }
    
    if ([userID length] != 0)
    {
        NSError* error;
        NSString * dir = [self getCacheDir];
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:&error];
        for (NSString * file in files)
        {
            if ([[file pathExtension] compare:@"dat"] == NSOrderedSame)
            {
                NSString * dataID = [file stringByDeletingPathExtension];
                Class class = [self getDataObjectClassForID:[dataID longLongValue]];
                id data = nil;
                
                if ([class conformsToProtocol:@protocol(NSCoding)])
                {
                    NSString * dir = [self getCacheDir];
                    
                    dir = [NSString stringWithFormat:@"%@%lld.dat",dir, [dataID longLongValue]];
                    
                    data = [NSKeyedUnarchiver unarchiveObjectWithFile:dir];
                }
                
                if (data)
                {
                    [dataDict setValue:data forKey:[self getIDFromLongLong:[dataID longLongValue]]];
                }
            }
        }
    }
    
    _isInitialized = YES;
    
    for (NSString * dataID in [dataDict allKeys]) {
        GGTask * task = [GGTask createWithSender:self forDataCategory:[self getCategory] forRequestType:GGDATA_REQUEST_REFRESH forDataID:[dataID longLongValue]];
        [[GGEngine sharedInstance] notifyRequestSuccessForTask:task];
    }
}

- (void)threadOfClearAllCache
{
    // !!
    NSString * userID = @"0"; //[KCConfigs sharedInstance].uid;
    
    if ([userID length] != 0)
    {
        NSString * dir = [self getCacheDir];
        devFS_removeFolder([dir UTF8String]);
    }
    
    if (dataDict)
    {
        [dataDict removeAllObjects];
    }
    
    if (dataStatusDict)
    {
        [dataStatusDict removeAllObjects];
    }
}

- (void)clearAllCache
{
    [self performSelector:@selector(threadOfClearAllCache) onThread:[GGEngine sharedInstance].engineDataThread withObject:nil waitUntilDone:NO];
}

- (void)clearAllCacheSynchronize
{
    [self threadOfClearAllCache];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _isInitialized = NO;
        dataCategory = [[self getCategory] copy];
        dataStatusDict = [[NSMutableDictionary alloc] init];
        dataDict =  [[NSMutableDictionary alloc] init];
        if([self isAutoCache])
        {
            [self loadAllCache];
        }
        else
        {
            _isInitialized = YES;
        }
    }
    return self;
}

#pragma mark - Generate the GGDateRequest, the subclass should override the function

- (GGDataRequest *)getDataRequestForTask:(GGTask *)task
{
    GGDataRequest * request = [GGDataRequest dataRequest];
    request.task = task;
    request.httpMethod = HttpMethodGet;
    
    return request;
}

#pragma mark - Derived class should override it to deal with the json data

- (BOOL)processJson:(GGJson *)ggJson forTask:(GGTask *)task
{
    return TRUE;
}

- (BOOL)refreshMergeDictionarySource:(NSDictionary *)source dest:(NSMutableDictionary *)destDic
{
    if ([destDic isKindOfClass:[NSMutableDictionary class]])
    {
        [destDic removeAllObjects];
        
        if ([source isKindOfClass:[NSDictionary class]])
        {
            [destDic addEntriesFromDictionary:source];
            return YES;
        }
    }
    return NO;
}

- (BOOL)getMoreMergeDictionarySource:(NSDictionary *)source dest:(NSMutableDictionary *)destDic key:(NSString *)key
{
    if ([destDic isKindOfClass:[NSMutableDictionary class]])
    {
        id tempId = [destDic objectForKey:key];
        if ([tempId isKindOfClass:[NSMutableArray class]])
        {
            if ([[source objectForKey:key] isKindOfClass:[NSArray class]])
            {
                NSMutableArray *array = tempId;
                [array addObjectsFromArray:[source objectForKey:key]];
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)getMoreMergeDictionarySourceByReverseOrder:(NSDictionary *)source dest:(NSMutableDictionary *)destDic key:(NSString *)key
{
    if ([destDic isKindOfClass:[NSMutableDictionary class]])
    {
        id tempId = [destDic objectForKey:key];
        if ([tempId isKindOfClass:[NSMutableArray class]])
        {
            if ([[source objectForKey:key] isKindOfClass:[NSMutableArray class]])
            {
                NSMutableArray *array = tempId;
                NSArray *sourceArray = [source objectForKey:key];
                
                for (int i = [sourceArray count] - 1; i >= 0; i--)
                {
                    id item = [sourceArray objectAtIndex:i];
                    [array insertObject:item atIndex:0];
                }
                
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)refreshMergeArraySource:(NSArray *)source dest:(NSMutableArray *)destDic
{
    if ([destDic isKindOfClass:[NSMutableArray class]])
    {
        [destDic removeAllObjects];
        
        if ([source isKindOfClass:[NSArray class]])
        {
            [destDic addObjectsFromArray:source];
            return YES;
        }
    }
    return NO;
}

- (BOOL)getMoreMergeArraySource:(NSArray *)source dest:(NSMutableArray *)destDic
{
    if ([destDic isKindOfClass:[NSMutableArray class]])
    {
        if ([source isKindOfClass:[NSArray class]])
        {
            [destDic addObjectsFromArray:source];
            return YES;
        }
    }
    return NO;
}

- (BOOL)refreshMergeDictionarySourceVDJson:(GGJson *)sourceVDJson destVDJson:(GGJson *)destVDJson
{
    if (nil == sourceVDJson ||
        [[sourceVDJson toString] length] == 0)
    {
        return NO;
    }
    
    [destVDJson resetCoreDataFrom:sourceVDJson];
    
    return YES;
}

- (BOOL)getMoreMergeDictionarySourceVDJson:(GGJson *)sourceVDJson destVDJson:(GGJson *)destVDJson key:(NSArray *)keyArray
{
    BOOL res =[destVDJson addCoreDataForm:sourceVDJson keyArray:keyArray];
    
    return res;
}

#pragma mark - Process the raw data back from the server
- (BOOL)processRawDataString:(NSString *)rawDataString forTask:(GGTask *)task
{
    NSData* jsonData = [rawDataString dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    
    if(!jsonObject)
    {
        return NO;
    }
    
    GGJson * ggJson = [GGJson jsonWithObject:jsonObject];
    
    return [self processRawDataGGJson:ggJson forTask:task];
}
- (BOOL)processRawDataGGJson:(GGJson *)rawDataJson forTask:(GGTask *)task
{
    GGJson * ggJson = rawDataJson;
    
    BOOL processed = [self processJson:ggJson forTask:task];
    
    return processed;
}

- (BOOL)processRawData:(NSData *)rawData forTask:(GGTask *)task
{
    return NO;
}

- (BOOL)processASIHTTPRequest:(GGDataRequest *)dataRequest
                 dataProvider:(GGBaseData *)dataProvider
                       ggJson:(GGJson *)ggJson
{
    BOOL processed = NO;
    GGTask * task = dataRequest.task;
    
    processed = [self processRawDataGGJson:ggJson forTask:task];
    
    if (processed)
    {
        if ([self isAutoCache] && (task.dataRequestType == GGDATA_REQUEST_REFRESH))
        {
            [self saveCacheForID:task.dataID];
        }
    }
    
    return  processed;
    
}

#pragma mark - Compare two GGDateRequest, the subclass should override the function and compare the special data

- (BOOL)isRequest:(GGDataRequest *)dataRequest eaquleTo:(GGDataRequest *)otherDataRequest
{
    BOOL same = YES;
    
    if(dataRequest.task.dataCategory != otherDataRequest.task.dataCategory || dataRequest.task.dataRequestType != otherDataRequest.task.dataRequestType)
    {
        same = NO;
    }
    
    if(same)
    {
        same = [dataRequest.task.argDict isEqualToDictionary:otherDataRequest.task.argDict];
    }
    
    return same;
}

- (void)removeDataAtIndex:(NSIndexPath *)indexPath DataId:(long long)dataID;
{
    
}

#pragma mark - The data's functions

- (Class)getDataObjectClassForID:(long long) dataID
{
    return [NSMutableDictionary class];
}

- (GGJson *)getGGJsonObjectForID:(long long)dataID
{
    id data = [dataDict objectForKey:[self getIDFromLongLong:dataID]];
    
    if (!data)
    {
        data = [[[self getDataObjectClassForID:dataID] alloc] init];
        [dataDict setObject:data forKey:[self getIDFromLongLong:dataID]];
    }
    
    return [GGJson jsonWithObject:data];
}

@end

@implementation GGBaseData (ObjectListQuery)

- (int) objectListCountForID:(long long)dataID;
{
    return [[self objectListDataForID:dataID] count];
}

//列表型数据的 json array
- (GGJson *)objectListDataForID:(long long)dataID;
{
    GGJson *data = [self getGGJsonObjectForID:dataID];
    return [data getJsonForKey:[self objectListKeyForID:dataID]];
}

//列表型数据 在服务器回来json中的key，该key对应的值是一个json array
- (NSString *)objectListKeyForID:(long long)dataID;
{
    NSAssert(NO, @"Subclass must override selector |objectListKeyForID:| to given a string key of list data which relative to your sepical service");
    return nil;
}

@end