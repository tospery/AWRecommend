//
//  NSMutableDictionary+JXObjc.h
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (JXObjc)
- (void)exRemoveObjectsWithValue:(id)value;
- (NSDictionary *)exRemoveObjectsWithKeys:(NSArray *)keys;

@end
