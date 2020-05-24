//
//  JXMemoryCache.h
//  JXSamples
//
//  Created by 杨建祥 on 16/4/29.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXMemoryCache : NSObject
@property (nonatomic, copy) NSString *baseURLString;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;

- (void)save;

- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;

+ (instancetype)sharedInstance;
@end
