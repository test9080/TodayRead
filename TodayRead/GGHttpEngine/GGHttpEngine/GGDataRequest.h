//
//  GGDataRequest.h
//  GGHttpEngineDemo
//
//  Created by cn on 15/2/27.
//  Copyright (c) 2015年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGTask.h"

typedef enum
{
	HttpMethodGet,
	HttpMethodPost
}HttpMethod;

@interface GGDataRequest : NSObject

@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, copy) NSString *requestApi;
@property (nonatomic, strong) NSMutableDictionary *requestParams;
@property (nonatomic, strong) NSMutableDictionary *dataParams;
@property (nonatomic, strong) NSMutableDictionary *imageParams;
@property (nonatomic, strong) NSMutableDictionary *headerParams;
@property (nonatomic, strong) GGTask *task;
@property (nonatomic, assign) HttpMethod httpMethod;
@property (nonatomic, assign) BOOL isBackGround;   //是否为后台请求

+ (GGDataRequest *) dataRequest;

- (BOOL)sameWith:(GGDataRequest *)dataRequest;

@end
