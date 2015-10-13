//
//  GGDataManager.m
//  GGHttpEngineDemo
//
//  Created by cn on 15/2/27.
//  Copyright (c) 2015年 cn. All rights reserved.
//

#import "GGDataManager.h"

@implementation GGDataManager

+ (GGDataManager *)sharedInstance
{
    static GGDataManager *manager = nil;
    if (nil == manager)
    {
        manager = [[GGDataManager alloc] init];
    }
    return manager;
}

- (id)init
{
    if ((self = [super init]))
    {
        _dataModules = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    
    return self;
}

#pragma mark - GGData classes's class factory

- (GGBaseData *)getGGDataForCategory:(NSString *)dataCategory
{
    if ([dataCategory length] == 0)
    {
        return nil;
    }
    
    NSAssert(dataCategory.length > 0, @"类名不能为空！");
    
    GGBaseData *data = [_dataModules objectForKey:dataCategory];
    
    if (!data)
    {    
        data = [[NSClassFromString(dataCategory) alloc] init];
        
        [_dataModules setValue:data forKey:dataCategory];
    }
    
    return data;
}

- (NSArray *)allDataCategories
{
    return _dataModules.allKeys;
}

- (void)removeDataCategory:(NSString *)dataCategory
{
    return;
//    NSAssert(dataCategory.length > 0, @"类名不能为空！");
//    
//    GGBaseData* baseData = [_dataModules objectForKey:dataCategory];
    
    //    if ([[baseData class] respondsToSelector:@selector(purgeSharedInstance)])
    //    {
    //        if (nil != dataCategory)
    //        {
    //            [_dataModules removeObjectForKey:dataCategory];
    //        }
    //        [[baseData class] purgeSharedInstance];
    //    }
    //    else
    {
        if (nil != dataCategory)
        {
            [_dataModules removeObjectForKey:dataCategory];
        }
    }
}

#pragma mark - Memory warning

- (void)didReceiveMemoryWarning
{
    //do nothing
}


@end
