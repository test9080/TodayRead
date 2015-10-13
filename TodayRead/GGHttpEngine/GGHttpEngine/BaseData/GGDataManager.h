//
//  GGDataManager.h
//  GGHttpEngineDemo
//
//  Created by cn on 15/2/27.
//  Copyright (c) 2015年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGBaseData.h"

@interface GGDataManager : NSObject
{
    NSMutableDictionary *_dataModules;
}

+ (GGDataManager *)sharedInstance;

- (GGBaseData *)getGGDataForCategory:(NSString *)dataCategory;

- (NSArray *)allDataCategories;

- (void)removeDataCategory:(NSString *)dataCategory;

- (void)didReceiveMemoryWarning;

@end
