//
//  NSMutableArray+JXObjc.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "NSMutableArray+JXObjc.h"

@implementation NSMutableArray (JXObjc)
- (BOOL)jx_addObjectNewly:(id)anObject {
    if (!anObject) {
        return NO;
    }
    
    BOOL has = NO;
    for (id obj in self) {
        if ([obj isEqual:anObject]) {
            has = YES;
            break;
        }
    }
    if (has) {
        return NO;
    }
    
    [self addObject:anObject];
    return YES;
}

- (void)exAddObject:(id)anObject {
    if (!anObject) {
        return;
    }
    
    [self addObject:anObject];
}

- (void)exInsertObjects:(NSArray *)objects atIndex:(NSUInteger)index unduplicated:(BOOL)unduplicated {
    if (!unduplicated) {
        NSRange range = NSMakeRange(index, objects.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self insertObjects:objects atIndexes:indexSet];
        return;
    }
    
    for (id obj in objects) {
        if (![self containsObject:obj]/* && ![self exContainsValue:obj]*/) {
            [self insertObject:obj atIndex:index++];
        }
    }
}

@end
