//
//  CNUserManager.h
//  TodayRead
//
//  Created by cn on 15/10/13.
//  Copyright © 2015年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNUserManager : NSObject

// 单例
+ (CNUserManager *)sharedInstance;

//
- (void)addUseCount;
- (NSUInteger)useCount;

@end
