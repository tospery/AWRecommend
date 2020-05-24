//
//  NSMutableArray+JXObjc.h
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (JXObjc)
- (BOOL)jx_addObjectNewly:(id)anObject;

/**
 *  添加一个对象（如果对象为空，就不添加）
 *
 *  @param anObject 对象
 */
- (void)exAddObject:(id)anObject;

/**
 *  插入一个对象集合
 *
 *  @param objects      待插入的对象集
 *  @param index        索引
 *  @param unduplicated 是否排除同值对象
 */
- (void)exInsertObjects:(NSArray *)objects atIndex:(NSUInteger)index unduplicated:(BOOL)unduplicated;
@end
