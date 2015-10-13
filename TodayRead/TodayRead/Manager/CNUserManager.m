//
//  CNUserManager.m
//  TodayRead
//
//  Created by cn on 15/10/13.
//  Copyright © 2015年 cn. All rights reserved.
//

#import "CNUserManager.h"

#define CN_Use_Count    @"CN_Use_Count"

@implementation CNUserManager

#pragma mark - public fun

+ (CNUserManager *)sharedInstance
{
    static CNUserManager *manager = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate,
                  ^{
                      manager = [[CNUserManager alloc] init];
                  });
    
    return manager;
}

- (void)addUseCount
{
    NSUInteger count = [self useCount];
    ++count;
    
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:CN_Use_Count];
}

- (NSUInteger)useCount
{
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:CN_Use_Count];
    return count;
}

@end
