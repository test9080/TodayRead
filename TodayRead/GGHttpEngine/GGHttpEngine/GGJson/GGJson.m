//
//  GGJson.m
//  GGHttpEngineDemo
//
//  Created by cn on 15/2/27.
//  Copyright (c) 2015年 cn. All rights reserved.
//

#import "GGJson.h"

@interface GGJson ()

@property (nonatomic, strong) id json;

@end

@implementation GGJson

@synthesize json;

+ (GGJson *)jsonWithArray
{
    return [self.class jsonWithObject:[NSMutableArray array]];
}

+ (GGJson *)jsonWithDictonary
{
    return [self.class jsonWithObject:[NSMutableDictionary dictionary]];
}

+ (GGJson *)jsonWithObject:(id)object
{
    GGJson * jsonObj = [[GGJson alloc] init];
    if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]])
    {
        jsonObj.json = object;
    }
    
    return jsonObj;
}

+ (GGJson *)jsonWithJsonString:(NSString *)jsonString
{
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id tempData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    
    return [self.class jsonWithObject:tempData];
}

- (GGJson *)getJsonForKey:(NSString *)key
{
    id retObj = nil;
    
    if (nil != key && [json isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dict = (NSDictionary*)json;
        retObj = [dict valueForKey:key];
    }
    
    if (retObj == nil)
    {
        retObj = [NSDictionary dictionary];
    }
    
    return [GGJson jsonWithObject:retObj];
}

- (GGJson *)getJsonForIndex:(int)index
{
    id retObj = nil;
    
    if ([json isKindOfClass:[NSArray class]])
    {
        NSArray* array = (NSArray*)json;
        
        if ([array count] > index)
        {
            retObj = [array objectAtIndex:index];
        }
    }
    
    if (retObj == nil)
    {
        retObj = [NSArray array];
    }
    
    return [GGJson jsonWithObject:retObj];
}

- (NSString *)getStringForKey:(NSString *)key
{
    id retObj = [NSString string];
    
    if (nil != key &&
        [json isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dict = (NSDictionary*)json;
        retObj = [dict valueForKey:key];
        
        if ([retObj isKindOfClass:[NSNumber class]])
        {
            retObj = [retObj stringValue];
        }
        
        if (![retObj isKindOfClass:[NSString class]])
        {
            retObj = [NSString string];
        }
    }
    
    return retObj;
}

- (id)getObjectForKey:(NSString *)key
{
    id retObj = nil;
    if (nil != key &&
        [json isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dict = (NSDictionary*)json;
        retObj = [dict valueForKey:key];
    }
    return retObj;
}

- (int)getIntForKey:(NSString *)key
{
    return [[self getStringForKey:key] intValue];
}

- (long long)getLongLongForKey:(NSString *)key
{
    return [[self getStringForKey:key] longLongValue];
}

- (double)getDoubleForKey:(NSString *)key
{
    return [[self getStringForKey:key] doubleValue];
}

- (BOOL)getBoolForKey:(NSString *)key
{
    return [[self getStringForKey:key] boolValue];
}

- (NSString *)getStringForIndex:(int)index
{
    id retObj = [NSString string];
    
    if ([json isKindOfClass:[NSArray class]])
    {
        NSArray* array = (NSArray*)json;
        
        if ([array count] > index)
        {
            retObj = [array objectAtIndex:index];
        }
        
        if ([retObj isKindOfClass:[NSNumber class]])
        {
            retObj = [retObj stringValue];
        }
        
        if (![retObj isKindOfClass:[NSString class]])
        {
            retObj = [NSString string];
        }
    }
    
    return retObj;
}

- (int)getIntForIndex:(int)index
{
    return [[self getStringForIndex:index] intValue];
}

- (long long)getLongLongForIndex:(int)index
{
    return [[self getStringForIndex:index] longLongValue];
}

- (BOOL)getBoolForIndex:(int)index
{
    return [[self getStringForIndex:index] boolValue];
}

- (BOOL)haveIntValueForKey:(NSString *)key
{
    if (nil != key &&
        [json isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dict = (NSDictionary*)json;
        id retObj = [dict valueForKey:key];
        
        if (!retObj) return NO;
        
        if ([retObj isKindOfClass:[NSNumber class]] || [retObj isKindOfClass:[NSString class]])
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)haveStringValueForKey:(NSString *)key
{
    if (nil != key &&
        [json isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dict = (NSDictionary*)json;
        id retObj = [dict valueForKey:key];
        
        if (!retObj) return NO;
        
        if ([retObj isKindOfClass:[NSString class]])
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)haveJsonValueForKey:(NSString *)key;
{
    if (nil != key &&
        [json isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dict = (NSDictionary*)json;
        id retObj = [dict valueForKey:key];
        
        if (!retObj) return NO;
        
        if ([retObj isKindOfClass:[NSDictionary class]]
            || [retObj isKindOfClass:[NSArray class]])
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)removeDataAtIndex:(NSInteger)index;
{
    if (![json isKindOfClass:[NSArray class]])
    {
        return NO;
    }
    
    if (index < [self count] && index >= 0)
    {
        [json removeObjectAtIndex:index];
        return YES;
    }
    
    return NO;
}

- (BOOL)insertData:(id)data atIndex:(NSInteger)index
{
    if (![json isKindOfClass:[NSArray class]])
    {
        return NO;
    }
    
    if (index >= [self count])
    {
        [json addObject:data];
    }
    else
    {
        [json insertObject:data atIndex:index];
    }
    
    return YES;
}

- (BOOL)insertData:(NSObject *)data forKey:(NSString *)key
{
    if (nil == key || nil == data)
    {
        return NO;
    }
    
    if (![json isKindOfClass:[NSDictionary class]])
    {
        return NO;
    }
    
    [json setValue:data forKey:key];
    
    return YES;
}

- (BOOL)setData:(NSObject *)data atIndex:(NSInteger)index
{
    if (![json isKindOfClass:[NSArray class]])
    {
        return NO;
    }
    
    if (index >= [self count])
    {
        [json addObject:data];
    }
    else
    {
        [json replaceObjectAtIndex:index withObject:data];
    }
    
    return YES;
}

- (BOOL)setData:(NSObject *)data forKey:(NSString *)key
{
    if (nil == data || nil == key)
    {
        return NO;
    }
    
    if (![json isKindOfClass:[NSDictionary class]] &&
        ![json isKindOfClass:[NSArray class]] &&
        ![json respondsToSelector:@selector(setValue:forKey:)]) // cn
    {
        return NO;
    }
    
    if (![json isKindOfClass:[NSMutableDictionary class]] &&
        [json isKindOfClass:[NSDictionary class]] &&
        ![[json allKeys] containsObject:key])
    {
        return NO;
    }
    
    [json setValue:data forKey:key];
    
    return YES;
}

- (BOOL)setIntValue:(int)value forKey:(NSString *)key
{
    if (nil == key)
    {
        return NO;
    }
    
    if (![json isKindOfClass:[NSDictionary class]])
    {
        return NO;
    }
    
    if (![json isKindOfClass:[NSMutableDictionary class]] &&
        [json isKindOfClass:[NSDictionary class]] &&
        ![[json allKeys] containsObject:key])
    {
        return NO;
    }
    
    [json setValue:[NSNumber numberWithInt:value] forKey:key];
    
    return YES;
}

- (unsigned int)count
{
    unsigned int ret = 0;
    SEL countSel = @selector(count);
    if ([json respondsToSelector:countSel])
    {
        ret = [json performSelector:countSel];
    }
    return ret;
}

- (NSString *)toString
{
    return [json description];
}

- (void)printJson
{
    NSLog(@"json is:\r\n %@", json);
}

- (id)copyWithZone:(NSZone *)zone
{
    GGJson *result = [[[self class] allocWithZone:zone] init];
    result.json = self.json;
    return result;
}

- (BOOL)isEqual:(id)anObject
{
    if ([anObject isKindOfClass:[GGJson class]])
    {
        return [self.json isEqual: [anObject json]];
    }
    return NO;
}

- (NSUInteger)hash
{
    return [self.json hash];
}

- (NSString *) description
{
    return [json description];
}

- (void)resetCoreDataFrom:(GGJson *)vdJson
{
    if ([self.json isKindOfClass:[NSMutableDictionary class]])
    {
        [self.json removeAllObjects];
        
        if ([vdJson.json isKindOfClass:[NSDictionary class]])
        {
            [self.json addEntriesFromDictionary:vdJson.json];
        }
    }
}

- (BOOL)addCoreDataForm:(GGJson *)_json keyArray:(NSArray *)keyArray
{
    if ([self.json isKindOfClass:[NSMutableDictionary class]])
    {
        id _dest = self.json;
        id _source = _json.json;
        if (![_source isKindOfClass:[NSDictionary class]])
        {
            return NO;
        }
        
        for (int i = 0; i < [keyArray count]; i++)
        {
            NSString *tempKey = [keyArray objectAtIndex:i];
            if ([[_dest allKeys] containsObject:tempKey])
            {
                _dest = [_dest objectForKey:tempKey];
            }
            else
            {
                return NO;
            }
            
            if ([[_source allKeys] containsObject:tempKey])
            {
                _source = [_source objectForKey:tempKey];
            }
            else
            {
                return NO;
            }
        }
        
        id tempId = _dest;
        if ([tempId isKindOfClass:[NSMutableArray class]])
        {
            if ([_source isKindOfClass:[NSArray class]])
            {
                [tempId addObjectsFromArray:_source];
                return YES;
            }
        }
    }
    return NO;
}

@end
