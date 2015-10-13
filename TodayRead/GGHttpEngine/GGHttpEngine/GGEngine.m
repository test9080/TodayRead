//
//  GGEngine.m
//  GGHttpEngineDemo
//
//  Created by cn on 15/2/27.
//  Copyright (c) 2015年 cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGEngine.h"
#import "GGDataManager.h"
#import "GGTask.h"
#import "GGDataRequest.h"
#import "AFNetworking.h"

@interface GGEngine()

- (void)__convertValueTypeToString2:(NSMutableDictionary *)dictionary;

@end

@implementation GGEngine

@synthesize engineNetWorkThread = _engineNetWorkThread;
@synthesize engineDataThread = _engineDataThread;

+ (GGEngine *)sharedInstance
{
    static GGEngine *engine = nil;
    if (nil == engine)
    {
        engine = [[GGEngine alloc] init];
    }
    return engine;
}

#pragma mark - Thread for background work thread

- (void) emptyFunction
{
    
}

- (void) stopEngineNetWorkThread
{
    if (_engineNetWorkThread) {
        @synchronized(self){
            if (_engineNetWorkThread) {
                [_engineNetWorkThread cancel];
                [self performSelector:@selector(emptyFunction) onThread:_engineNetWorkThread withObject:nil waitUntilDone:NO];
                _engineNetWorkThread = nil;
            }
        }
    }
}

- (void) stopEngineDataThread
{
    if (_engineDataThread) {
        @synchronized(self){
            if (_engineDataThread) {
                [_engineDataThread cancel];
                [self performSelector:@selector(emptyFunction) onThread:_engineDataThread withObject:nil waitUntilDone:NO];
                _engineDataThread = nil;
            }
        }
    }
}

#pragma mark - Net work callback

- (void)realNotifyRequestSuccessForTask:(GGTask *)task
{
    NSMutableArray* observersForDataCategory = [dataObserverDict objectForKey:task.dataCategory];
    
    //make a observersForDataCategory copy, avoid crash if some observer remove itself from observersForDataCategory when processing
    observersForDataCategory = [NSMutableArray arrayWithArray:observersForDataCategory];
    
    for (id<GGDataObserver> dataObserver in observersForDataCategory)
    {
        if ([dataObserver respondsToSelector:@selector(requestSuccessForTask:)])
        {
            [dataObserver requestSuccessForTask:task];
        }
    }
}

- (void)notifyRequestSuccessForTask:(GGTask *)task
{
    [self performSelectorOnMainThread:@selector(realNotifyRequestSuccessForTask:) withObject:task waitUntilDone:NO];
}

- (void)realNotifyRequestFailed:(NSArray*) args
{
    GGTask * task = [args objectAtIndex:0];
    NSError* error = [args objectAtIndex:1];
    
    NSArray* observersForDataCategory = [dataObserverDict objectForKey:task.dataCategory];
    
    if(observersForDataCategory == nil)
    {
        return;
    }
    
    //make a observersForDataCategory copy, avoid crash if some observer remove itself from observersForDataCategory when processing
    observersForDataCategory = [NSArray arrayWithArray:observersForDataCategory];
    
    for (id<GGDataObserver> dataObserver in observersForDataCategory)
    {
        if ([dataObserver respondsToSelector:@selector(requestFailedForTask:withError:)])
        {
            [dataObserver requestFailedForTask:task withError:error];
        }
    }
}

- (void)notifyRequestFailedForTask:(GGTask *)task withError:(NSError*) error
{
    [self performSelectorOnMainThread:@selector(realNotifyRequestFailed:) withObject:[NSArray arrayWithObjects:task, error, nil] waitUntilDone:NO];
}

- (void)notifyRequestDataModify:(NSString *)dataCategory task:(GGTask *)task
{
    NSMutableArray* observersForDataCategory = [dataObserverDict objectForKey:dataCategory];
    
    if(observersForDataCategory == nil)
    {
        return;
    }
    
    //make a observersForDataCategory copy, avoid crash if some observer remove itself from observersForDataCategory when processing
    observersForDataCategory = [NSMutableArray arrayWithArray:observersForDataCategory];
    
    for (id<GGDataObserver> dataObserver in observersForDataCategory)
    {
        if ([dataObserver respondsToSelector:@selector(requestDataModifyForTask:)]) {
            
            [dataObserver requestDataModifyForTask:task];
        }
    }
}

- (void)realNotifyRequestDataModifyForTask:(GGTask *)task
{
    NSMutableArray* observersForDataCategory = [dataObserverDict objectForKey:task.dataCategory];
    
    if(observersForDataCategory == nil)
    {
        return;
    }
    
    //make a observersForDataCategory copy, avoid crash if some observer remove itself from observersForDataCategory when processing
    observersForDataCategory = [NSMutableArray arrayWithArray:observersForDataCategory];
    
    for (id<GGDataObserver> dataObserver in observersForDataCategory)
    {
        if ([dataObserver respondsToSelector:@selector(requestDataModifyForTask:)]) {
            
            [dataObserver requestDataModifyForTask:task];
        }
    }
}

- (void)notifyRequestDataModifyForTask:(GGTask *)task
{
    [self performSelectorOnMainThread:@selector(realNotifyRequestDataModifyForTask:) withObject:task waitUntilDone:NO];
}

- (void)realNotifyRequestAdded:(GGTask *)task
{
    NSMutableArray* observersForDataCategory = [dataObserverDict objectForKey:task.dataCategory];
    
    if(observersForDataCategory == nil)
    {
        return;
    }
    
    //make a observersForDataCategory copy, avoid crash if some observer remove itself from observersForDataCategory when processing
    observersForDataCategory = [NSMutableArray arrayWithArray:observersForDataCategory];
    
    for (id<GGDataObserver> dataObserver in observersForDataCategory)
    {
        if ([dataObserver respondsToSelector:@selector(taskAddedToEngine:)]) {
            
            [dataObserver taskAddedToEngine:task];
        }
    }
}

- (void)notifyRequestAdded:(GGTask *)task
{
    [self performSelectorOnMainThread:@selector(realNotifyRequestAdded:) withObject:task waitUntilDone:NO];
}

- (void)delegateSuccessForDataRequest:(GGDataRequest *) dataRequest
{
    [self.delegate requestSuccessForTask:dataRequest.task];
}

- (void)delegateFailedForDataRequestAndError:(NSDictionary*) info
{
    [self.delegate requestFailedForTask:(GGTask *)[[info valueForKey:@"dataRequest"] task] withError:[info valueForKey:@"error"]];
}

- (void)delegateTaskAddedToEngine:(GGTask *) task
{
    [self.delegate taskAddedToEngine:task];
}

- (void)threadForRequestFinished:(GGDataRequest *)dataRequest
                    dataProvider:(GGBaseData *)dataProvider
                  responseObject:(id)responseObject
{
    if (!dataProvider)
    {
        return;
    }
    
#if kURLRequestOutput
    NSLog(@"requestString:%@", [request responseString]);
#endif
    
    id jsonObject = responseObject;
    
    GGJson *ggJson = [GGJson jsonWithObject:jsonObject];
    
    BOOL processed = NO;
    
    processed = [dataProvider processASIHTTPRequest:dataRequest
                                       dataProvider:dataProvider
                                             ggJson:ggJson];
    if(processed)
    {
        [self notifyRequestSuccessForTask:dataRequest.task];
        
        if ([self.delegate respondsToSelector:@selector(requestSuccessForTask:)]) {
            [self performSelectorOnMainThread:@selector(delegateSuccessForDataRequest:) withObject:dataRequest waitUntilDone:NO];
        }
        
    }
    else
    {
        NSError* error = nil;
        if(!jsonObject)
        {
            // !!
            NSDictionary *errInfo = nil; //[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"parse json error, the string is:%@", [request responseString]] forKey:@"errorString"];
            error = [NSError errorWithDomain:@"HttpResultErrorDomain" code:0 userInfo:errInfo];
        }
        
        [self notifyRequestFailedForTask:dataRequest.task withError:error];
        
        if ([self.delegate respondsToSelector:@selector(requestFailedForTask:withError:)]) {
            [self performSelectorOnMainThread:@selector(delegateFailedForDataRequestAndError:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:dataRequest, @"dataRequest", error, @"error", nil] waitUntilDone:NO];
        }
    }
}

#pragma mark - View lifecycle

- (id)init
{
    self = [super init];
    
    if(self)
    {
        dataObserverDict = [[NSMutableDictionary alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleMemoryWarning:)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Observer function

- (void)unloadNoUsedData
{
    NSArray *dataCategories = [[GGDataManager sharedInstance] allDataCategories];
    
    for (NSString *dataCategory in dataCategories)
    {
        NSMutableArray* observersForDataCategory = [dataObserverDict objectForKey:dataCategory];
        
        if (observersForDataCategory && observersForDataCategory.count == 0)
        {
            GGBaseData* baseData = [[GGDataManager sharedInstance] getGGDataForCategory:dataCategory];
            if ([baseData isAutoCache])
            {
                [[GGDataManager sharedInstance] removeDataCategory:dataCategory];
            }
            
            if (nil != dataCategories)
            {
                [dataObserverDict removeObjectForKey:dataCategory];
            }
        }
    }
}

- (void)addDataObserver:(id<GGDataObserver>) theObserver forDataCategory:(NSString *) dataCategory;
{
    @synchronized(self){
        
        if ([dataCategory length] == 0 || theObserver == nil) {
            return;
        }
        
        NSMutableArray* observersForDataCategory = [dataObserverDict objectForKey:dataCategory];
        if(observersForDataCategory == nil)
        {
            observersForDataCategory = [NSMutableArray array];
            [dataObserverDict setObject:observersForDataCategory forKey:dataCategory];
        }
        
        BOOL shouldAdd = YES;
        for (id<GGDataObserver> observerInArray in observersForDataCategory) {
            if (observerInArray == theObserver) {
                shouldAdd = NO;
                break;
            }
        }
        
        if(shouldAdd)
        {
            [observersForDataCategory addObject:theObserver];
        }
    }
}

- (void)removeDataObserver:(id<GGDataObserver>) theObserver forDataCategory:(NSString *) dataCategory
{
    NSMutableArray* observersForDataCategory = [dataObserverDict objectForKey:dataCategory];
    if(observersForDataCategory == nil)
    {
        return;//no such category, so no such observer
    }
    [observersForDataCategory removeObject:theObserver];
    [self unloadNoUsedData];
}

- (void)removeDataObserver:(id<GGDataObserver>)theObserver
{
    @synchronized(self)
    {
        BOOL isMainThread = [NSThread isMainThread];
        NSArray *observersForDataCategory = [dataObserverDict allValues];
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:10];
        for (NSMutableArray *observers in observersForDataCategory) {
            for (id<GGDataObserver>observer in observers) {
                NSNumber* number = [NSNumber numberWithUnsignedInt:(NSUInteger)observer];
                int count = [[dic objectForKey:number] intValue];
                [dic setObject:[NSNumber numberWithInt:count+1] forKey:number];
            }
        }
        
        for (NSMutableArray *observers in observersForDataCategory)
        {
            NSMutableArray *delObservers = [[NSMutableArray alloc] initWithCapacity:1];
            
            for (id<GGDataObserver>observer in observers)
            {
                if ([observer isEqual:theObserver] || isMainThread)
                {
                    [delObservers addObject:observer];
                }
            }
        }
        
        [self unloadNoUsedData];
    }
}


#pragma mark - Task function

//TODO
- (void)__convertValueTypeToString2:(NSMutableDictionary *)dictionary
{
    NSArray* allKeys = dictionary.allKeys;
    for (NSString * key in allKeys) {
        id obj = [dictionary objectForKey:key];
        if (![obj isKindOfClass:[NSString class]]) {
            if ([obj respondsToSelector:@selector(stringValue)]) {
                obj = [obj stringValue];
                [dictionary setValue:obj forKey:key];
            }
            else
            {
                //can't convert, remove it to avoid crash!!!!!
                //                [dictionary removeObjectForKey:key];
            }
        }
    }
}


- (void)convertValueTypeToString:(NSMutableDictionary *)dictionary
{
    NSArray* allKeys = dictionary.allKeys;
    for (NSString * key in allKeys) {
        id obj = [dictionary objectForKey:key];
        if (![obj isKindOfClass:[NSString class]]) {
            if ([obj respondsToSelector:@selector(stringValue)]) {
                obj = [obj stringValue];
                [dictionary setValue:obj forKey:key];
            }
            else
            {
                [dictionary setValue:@"" forKey:key];
                //can't convert, remove it to avoid crash!!!!!
                //                [dictionary removeObjectForKey:key];
            }
        }
    }
}

- (void) _addRequest:(GGDataRequest *)dataRequest dataProvider:(GGBaseData*)dataProvider
{
    GGTask * task = dataRequest.task;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (HttpMethodGet == dataRequest.httpMethod)
    {
        [manager GET:dataRequest.requestUrl
          parameters:dataRequest.dataParams
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [self threadForRequestFinished:dataRequest dataProvider:dataProvider responseObject:responseObject];
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
             }];
    }
    else
    {
        
    }
    
    [self notifyRequestAdded:task];
    
    if ([self.delegate respondsToSelector:@selector(taskAddedToEngine:)]) {
        [self performSelectorOnMainThread:@selector(delegateTaskAddedToEngine:) withObject:task waitUntilDone:NO];
    }
}

- (BOOL)addTask:(GGTask *)task
{
    if (task == nil)
    {
        return NO;
    }
    
    GGBaseData* dataProvider = [[GGDataManager sharedInstance] getGGDataForCategory:task.dataCategory];
    GGDataRequest * newDataRequest = [dataProvider getDataRequestForTask:task];
    
    if(newDataRequest == nil || dataProvider == nil)
    {
        return NO;
    }
    
    [self _addRequest:newDataRequest dataProvider:dataProvider];

    return YES;
}

- (void)cancelAllTaskBySender:(id) sender
{

}

#pragma mark - Memory warning

- (void) handleMemoryWarning:(NSNotification *)notification
{
    [self didReceiveMemoryWarning];
}

- (void)didReceiveMemoryWarning
{
    [[GGDataManager sharedInstance] didReceiveMemoryWarning];
    [self unloadNoUsedData];
    [self performSelector:@selector(removeDataObserver:) withObject:nil afterDelay:0];
}

- (NSArray*) getAllRequest
{
    NSMutableArray* allRequestArray = [NSMutableArray arrayWithCapacity:0];
    return allRequestArray;
}

- (void)cancelAllNetWork
{

}

@end
