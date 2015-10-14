//
//  ZhihuListData.m
//  GGHttpEngineDemo
//
//  Created by cn on 15/2/27.
//  Copyright (c) 2015年 cn. All rights reserved.
//

#import "ZhihuListData.h"
#import "GGDataRequest.h"
#import "GGTask.h"

@implementation ZhihuListData

- (BOOL)isAutoCache
{
    return YES;
}

#define BASE_URL @"http://news-at.zhihu.com/api/4/news/latest"

- (GGDataRequest *)getDataRequestForTask:(GGTask *)task
{
    GGDataRequest *request = [super getDataRequestForTask:task];
    request.task = task;
    request.httpMethod = HttpMethodGet;
    
    // 如果需要解析外界传入的附加参数，可调用task.argDict
    // 将附加参数拼入url
    
    request.requestUrl = BASE_URL;
    
//    NSString *category = @"";
//    if ([[task.argDict allKeys] containsObject:@"category"])
//    {
//        category = [task.argDict objectForKey:@"category"];
//        category = [self encodeToPercentEscapeString:category];
//    }
//    
//    if (GGDATA_REQUEST_REFRESH == task.dataRequestType) // 刷新
//    {
//        request.requestUrl = [NSString stringWithFormat:@"%@&page=%d&count=%d&category=%@", BASE_URL, 1, 20, category];
//    }
//    else // 查看更多
//    {
//        GGJson *tempJson = [self getGGJsonObjectForID:task.dataID];
//        int listCount = [[tempJson getJsonForKey:@"videos"] count];
//        
//        request.requestUrl = [NSString stringWithFormat:@"%@&page=%d&count=%d&category=%@", BASE_URL, (listCount / 20) + 1, 20, category];
//    }
    
    return request;
}

- (BOOL)processJson:(GGJson *)bsJson forTask:(GGTask *)task
{
    GGJson *destJson = [self getGGJsonObjectForID:task.dataID];
    BOOL res = [self refreshMergeDictionarySourceVDJson:bsJson destVDJson:destJson];
    
    return res;
    
//    BOOL res = NO;
    
//    if (GGDATA_REQUEST_REFRESH == task.dataRequestType)
//    {
//        res = [self refreshMergeDictionarySource:bsJson.json dest:destJson.json];
//    }
//    else
//    {
//        res = [self getMoreMergeDictionarySource:bsJson.json dest:destJson.json key:@"videos"];
//    }
    
    return res;
}

- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    // Encode all the reserved characters, per RFC 3986
    // ()
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)input,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8));
    return outputStr;
}


@end
