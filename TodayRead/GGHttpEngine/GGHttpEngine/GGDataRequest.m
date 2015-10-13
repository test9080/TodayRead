//
//  GGDataRequest.m
//  GGHttpEngineDemo
//
//  Created by cn on 15/2/27.
//  Copyright (c) 2015年 cn. All rights reserved.
//

#import "GGDataRequest.h"
#import "GGDataManager.h"

@implementation GGDataRequest
@synthesize requestUrl;
@synthesize requestApi;
@synthesize requestParams;
@synthesize dataParams;
@synthesize imageParams;
@synthesize task;
@synthesize httpMethod;
@synthesize headerParams;
@synthesize isBackGround = _isBackGround;

#pragma mark - Create helper

+ (GGDataRequest *) dataRequest
{
    return [[GGDataRequest alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
        requestParams = [[NSMutableDictionary alloc] init];
        dataParams = [[NSMutableDictionary alloc] init];
        imageParams = [[NSMutableDictionary alloc] init];
        headerParams = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (NSString *) requestUrl
{
    return requestUrl;
}

#pragma mark - Compare function

- (BOOL)sameWith:(GGDataRequest *)dataRequest
{
    if(dataRequest == self)
    {
        return YES;
    }
    
    if(!dataRequest || ![dataRequest isKindOfClass:[self class]])
    {
        return NO;
    }
    
    GGBaseData* data = [[GGDataManager sharedInstance] getGGDataForCategory:task.dataCategory];
    
    return [data isRequest:self eaquleTo:dataRequest];
}

#pragma mark - help fun

- (NSString *)description
{
    return [NSString stringWithFormat:@"\nrequestUrl:%@\nrequestParams:%@\nimageParams:%@\nheaderParams:%@\n"
            ,self.requestUrl
            ,self.requestParams
            ,self.imageParams
            ,self.headerParams];
}

@end
