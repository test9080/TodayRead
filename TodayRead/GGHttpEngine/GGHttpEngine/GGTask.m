//
//  GGTask.m
//  GGHttpEngineDemo
//
//  Created by cn on 15/2/27.
//  Copyright (c) 2015年 cn. All rights reserved.
//

#import "GGTask.h"
#include <objc/runtime.h>
#import "GGDataManager.h"

#define DATA_REQUEST @"dataRequest"
#define DATA_CATEGORY @"dataCategory"
#define DATA_REQUEST_TYPE @"dataRequestType"
#define DATA_DATAID @"dataID"
#define DATA_ARG_DICT @"argDict"

@implementation GGTask

@synthesize dataCategory;
@synthesize dataRequestType;
@synthesize dataID;
@synthesize argDict;
@synthesize senders;

#pragma mark - Create helper

+ (GGTask *) task
{
    return [[GGTask alloc] init];
}

+ (GGTask *)createWithSender:(id)sender
             forDataCategory:(NSString *)dataCategory
{
    return [self.class createWithSender:sender
                        forDataCategory:dataCategory
                         forRequestType:0
                              forDataID:0];
}

+ (GGTask *)createWithSender:(id)sender
             forDataCategory:(NSString *)dataCategory
              forRequestType:(int)requestType
                   forDataID:(long long)dataID;
{
    GGTask *task = [[GGTask alloc] init];
    
    if (sender)
    {
        [task.senders addObject:sender];
    }
    
    task.dataCategory = dataCategory;
    task.dataRequestType = requestType;
    task.dataID = dataID;
    
    return task;
}

- (id)init
{
    self = [super init];
    if (self) {
        argDict = [[NSMutableDictionary alloc] init];
        senders = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)addToEngine
{
    [[GGEngine sharedInstance]addTask:self];
}

- (NSDictionary *)serialize
{
    @try
    {
        NSMutableDictionary * result = [NSMutableDictionary dictionaryWithCapacity:4];
        [result setValue:self.dataCategory forKey:DATA_CATEGORY];
        [result setValue:[NSString stringWithFormat:@"%d", self.dataRequestType]  forKey:DATA_REQUEST_TYPE];
        [result setValue:[NSString stringWithFormat:@"%lld", self.dataID]  forKey:DATA_DATAID];
        
        id data = [[NSClassFromString(self.dataCategory) alloc] init];
        if ([data respondsToSelector:@selector(serialize:)])
        {
            NSDictionary *dictionary = [data performSelector:@selector(serialize:) withObject:self];
            [result setValue:dictionary forKey:DATA_ARG_DICT];
        }
        return result;
    }
    @catch (...)
    {
    }
    return nil;
}

- (BOOL)unserialize:(NSDictionary *)dictionary
{
    @try
    {
        self.dataCategory = [dictionary valueForKey:DATA_CATEGORY];
        self.dataRequestType = [[dictionary valueForKey:DATA_REQUEST_TYPE] intValue];
        self.dataID = [[dictionary valueForKey:DATA_DATAID] longLongValue];
        
        id data = [[NSClassFromString(self.dataCategory) alloc] init];
        if ([data respondsToSelector:@selector(unserialize:)])
        {
            self.argDict = [data performSelector:@selector(unserialize:) withObject:[dictionary valueForKey:DATA_ARG_DICT]];
        }
        return YES;
    }
    @catch (...)
    {
    }
    return NO;
}

#pragma mark -

- (GGBaseData*)taskData;
{
    return [[GGDataManager sharedInstance] getGGDataForCategory:self.dataCategory];
}

- (GGJson *)taskDataJson;
{
    return [[self taskData] getGGJsonObjectForID:self.dataID];
}

#pragma mark - description

- (NSString *)description
{
    NSMutableString *desc = [NSMutableString stringWithCapacity:100];
    [desc appendFormat:@"<%s dataCategory:%@ dataRequestType:%d>\nargDict:%@", class_getName(self.class), dataCategory, dataRequestType, argDict];
    
    return desc;
}

@end
