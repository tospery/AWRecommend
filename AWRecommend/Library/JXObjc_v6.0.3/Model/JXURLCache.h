//
//  JXURLCache.h
//  GDLBLotteryLiaoning
//
//  Created by 杨建祥 on 17/1/7.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXURLCache : NSURLCache
@property(nonatomic, assign) NSInteger cacheTime;
@property(nonatomic, retain) NSString *diskPath;
@property(nonatomic, retain) NSMutableDictionary *responseDictionary;

- (id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path cacheTime:(NSInteger)cacheTime;


@end
