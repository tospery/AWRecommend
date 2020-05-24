////
////  JXDataCache.m
////  MyCoding
////
////  Created by 杨建祥 on 16/5/2.
////  Copyright © 2016年 杨建祥. All rights reserved.
////
//
//#import "JXDataCache.h"
//
//@interface JXDataCache ()
//@property (nonatomic, strong) NSMutableDictionary *memory;
//
//@end
//
//@implementation JXDataCache
//#pragma mark - Override methods
//- (instancetype)init {
//    if (self = [super init]) {
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        _baseURLString = [ud stringForKey:kJXUdBaseURLString];
//        _account = [ud stringForKey:kJXUdAccount];
//        _password = [ud stringForKey:kJXUdPassword];
//    }
//    return self;
//}
//
//- (NSMutableDictionary *)memory {
//    if (!_memory) {
//        _memory = [[NSMutableDictionary alloc] init];
//    }
//    return _memory;
//}
//
//#pragma mark - Public methods
//- (void)save {
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    [ud setObject:_baseURLString forKey:kJXUdBaseURLString];
//    [ud setObject:_account forKey:kJXUdAccount];
//    [ud setObject:_password forKey:kJXUdPassword];
//    [ud synchronize];
//}
//
//// User的成员方法
////- (void)cleanUserData {
////
////}
//
////- (id)objectForKey:(NSString *)key {
////    return [self.cacheDict objectForKey:key];
////}
////
////- (void)setObject:(id)object forKey:(NSString *)key toCached:(BOOL)toCached {
////    if (!object || !key) {
////        return;
////    }
////    
////    [self.cacheDict setObject:object forKey:key];
////    if (toCached) {
////        [self.cacheArr addObject:key];
////    }
////}
////
////- (void)removeObjectForKey:(NSString *)key {
////    [self.cacheDict removeObjectForKey:key];
////}
//
//#pragma mark - Class methods
//+ (instancetype)sharedInstance {
//    static id instance;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[[self class] alloc] init];
//    });
//    return instance;
//}
//@end
