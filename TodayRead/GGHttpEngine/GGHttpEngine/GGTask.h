//
//  GGTask.h
//  GGHttpEngineDemo
//
//  Created by cn on 15/2/27.
//  Copyright (c) 2015年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGEngine.h"

@interface GGTask : NSObject

@property (nonatomic, strong) NSString *dataCategory;
@property (nonatomic, assign) int dataRequestType;
@property (nonatomic, assign) long long dataID;
@property (nonatomic, strong) NSMutableDictionary  *argDict;
@property (nonatomic, strong) NSMutableSet *senders;

//添加到引擎
- (void)addToEngine;

- (NSDictionary *)serialize;
- (BOOL)unserialize:(NSDictionary *)dictionary;

+ (GGTask *)task;

+ (GGTask *)createWithSender:(id)sender
             forDataCategory:(NSString *)dataCategory;

+ (GGTask *)createWithSender:(id)sender
             forDataCategory:(NSString *)dataCategory
              forRequestType:(int)requestType
                   forDataID:(long long)dataID;

//[[GGDataManager sharedInstance] getGGDataForCategory:task.dataCategory]
- (GGBaseData*)taskData;
- (GGJson *)taskDataJson;

@end
