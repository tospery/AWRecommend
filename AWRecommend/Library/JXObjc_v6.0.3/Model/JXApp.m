//
//  JXApp.m
//  MyCoding
//
//  Created by 杨建祥 on 16/4/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXApp.h"

@interface JXApp ()
// @property (nonatomic, assign, readwrite) JXAppEnv env;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *identifier;
@property (nonatomic, copy, readwrite) NSString *version;

@end

@implementation JXApp
- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

//- (JXAppEnv)env {
//    if (!_env) {
//        NSString *buildString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//        NSArray *buildArray = [buildString componentsSeparatedByString:@"."];
//        _env = (3 == buildArray.count);
//    }
//    return _env;
//}

//- (JXAppEnv)env {
//    if (!_env) {
//        NSString *idstr = self.identifier;
//        if ([idstr hasSuffix:@".dev"]) {
//            _env = JXAppEnvDev;
//        }else if ([idstr hasSuffix:@".hoc"]) {
//            _env = JXAppEnvHoc;
//        }else if ([idstr hasSuffix:@".ent"]) {
//            _env = JXAppEnvEnt;
//        }else {
//            _env = JXAppEnvApp;
//        }
//    }
//    return _env;
//}

- (NSString *)name {
    if (!_name) {
        _name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    }
    return _name;
}

- (NSString *)identifier {
    if (!_identifier) {
        _identifier = [[NSBundle mainBundle] bundleIdentifier];
    }
    return _identifier;
}

- (NSString *)version {
    if (!_version) {
        _version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    return _version;
}

+ (NSString *)name {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (NSString *)identifier {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)version {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

//NSString *aa = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//NSArray *bb = [aa componentsSeparatedByString:@"."];

+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
@end
