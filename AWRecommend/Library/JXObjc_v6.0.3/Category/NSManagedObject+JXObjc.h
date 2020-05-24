//
//  NSManagedObject+JXObjc.h
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (JXObjc)
/**
 *  创建一个实体
 *
 *  @param name 实体名
 *
 *  @return 一个实体
 */
+ (id)exCreateEntity:(NSString *)name;

/**
 *  创建一个模型
 *
 *  @param name 实体名
 *
 *  @return 一个模型
 */
+ (id)exCreateModel:(NSString *)name;

@end
