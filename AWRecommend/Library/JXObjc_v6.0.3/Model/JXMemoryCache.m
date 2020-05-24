//
//  JXMemoryCache.m
//  JXSamples
//
//  Created by 杨建祥 on 16/4/29.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXMemoryCache.h"

@interface JXMemoryCache ()
@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation JXMemoryCache
#pragma mark - Override methods
- (instancetype)init {
    if (self = [super init]) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        _baseURLString = [ud stringForKey:kJXUdBaseURLString];
        _account = [ud stringForKey:kJXUdAccount];
        _password = [ud stringForKey:kJXUdPassword];
        
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Public methods
- (void)save {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:_baseURLString forKey:kJXUdBaseURLString];
    [ud setObject:_account forKey:kJXUdAccount];
    [ud setObject:_password forKey:kJXUdPassword];
    
//    for (NSString *key in self.dictionary.allKeys) {
//        if ([key hasPrefix:@"kPMKey"]) {
//            [ud setObject:self.dictionary[key] forKey:key];
//        }else {
//            [PMInstance storageArchive:self.dictionary[key] path:key];
//        }
//    }
    
    [ud synchronize];
}

- (id)objectForKey:(NSString *)key {
    return [self.dictionary objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key {
    [self.dictionary setObject:object forKey:key];
}

- (void)removeObjectForKey:(NSString *)key {
    [self.dictionary removeObjectForKey:key];
}

// User的成员方法
//- (void)cleanUserData {
//    
//}

#pragma mark - Class methods
+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
@end

