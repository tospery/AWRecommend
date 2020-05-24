//
//  NSMutableDictionary+JXObjc.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "NSMutableDictionary+JXObjc.h"

@implementation NSMutableDictionary (JXObjc)
- (void)exRemoveObjectsWithValue:(id)value {
    [self removeObjectsForKeys:[self allKeysForObject:value]];
}

- (NSDictionary *)exRemoveObjectsWithKeys:(NSArray *)keys {
    if (keys.count == 0) {
        return nil;
    }
    
    NSMutableDictionary *results = [NSMutableDictionary dictionaryWithCapacity:keys.count];
    for (id key in keys) {
        id val = [self objectForKey:key];
        if (val) {
            [results setObject:val forKey:key];
        }
    }
    [self removeObjectsForKeys:keys];
    return results.count != 0 ? results : nil;
}

@end
