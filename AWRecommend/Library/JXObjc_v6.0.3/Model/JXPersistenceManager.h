//
//  JXPersistenceManager.h
//  MyCoding
//
//  Created by 杨建祥 on 16/5/1.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PMInstance              ([JXPersistenceManager sharedInstance])

@interface JXPersistenceManager : NSObject
// 默认
- (BOOL)storageBasic:(id)basic key:(NSString *)key;
- (id)fetchBasic:(NSString *)key;

// 归档
- (BOOL)storageArchive:(id)archive path:(NSString *)path;
- (id)fetchArchive:(NSString *)path;

+ (instancetype)sharedInstance;
@end
