//
//  NSDictionary+JXObjc.h
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JXObjc)
/**
 *  移除字典中的空值（空字符串、NSNull对象和空值NSNumber）
 *
 *  @return 排除了空值的字典
 */
- (NSDictionary *)jx_ignoreEmptyObject;



// 备份
+ (instancetype)exInitWithExpressions:(NSString *)expressions;

@end
