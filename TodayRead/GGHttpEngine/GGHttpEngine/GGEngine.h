//
//  GGEngine.h
//  GGHttpEngineDemo
//
//  Created by cn on 15/2/27.
//  Copyright (c) 2015年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGBaseData.h"
#import "GGDataRequest.h"

@class GGTask;

@protocol GGDataObserver <NSObject>
@optional
- (void)requestSuccessForTask:(GGTask *)task;
- (void)requestFailedForTask:(GGTask *)task withError:(NSError*) error;
- (void)requestDataModifyForTask:(GGTask *)task;

- (void)taskAddedToEngine:(GGTask *)task;

@end

@protocol GGHttpEngineDelegate <NSObject>

@optional

- (void)requestSuccessForTask:(GGTask *)task;
- (void)requestFailedForTask:(GGTask *)task withError:(NSError*) error;
- (void)taskAddedToEngine:(GGTask *)task;

@end

@interface GGEngine : NSObject
{    
    //store the observer list for each data category
    NSMutableDictionary * dataObserverDict;
}

@property (nonatomic, readonly) NSThread* engineNetWorkThread;
@property (nonatomic, readonly) NSThread* engineDataThread;

@property (nonatomic, assign) id<GGHttpEngineDelegate> delegate;

+ (GGEngine *)sharedInstance;

- (void)addDataObserver:(id<GGDataObserver>) theObserver forDataCategory:(NSString *) dataCategory;
- (void)removeDataObserver:(id<GGDataObserver>) theObserver forDataCategory:(NSString *) dataCategory;
- (void)removeDataObserver:(id<GGDataObserver>)theObserver;

- (BOOL)addTask:(GGTask *)task;
- (void)cancelAllTaskBySender:(id) sender;

- (void)notifyRequestSuccessForTask:(GGTask *)task;
- (void)notifyRequestFailedForTask:(GGTask *)task withError:(NSError*) error;
- (void)notifyRequestDataModifyForTask:(GGTask *)task;
- (void)notifyRequestDataModify:(NSString *)dataCategory task:(GGTask *)task;

- (void)didReceiveMemoryWarning;

- (NSArray*) getAllRequest;

- (void)convertValueTypeToString:(NSMutableDictionary *)dictionary;

- (void)cancelAllNetWork;

@end
