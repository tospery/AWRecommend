//
//  JXApp.h
//  MyCoding
//
//  Created by 杨建祥 on 16/4/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSInteger, JXAppEnv){
//    JXAppEnvNone,
//    JXAppEnvDev,
//    JXAppEnvTest,
//    JXAppEnvProduct
//};

@interface JXApp : NSObject
//@property (nonatomic, assign, readonly) JXAppEnv env;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *version;

+ (NSString *)name;
+ (NSString *)identifier;
+ (NSString *)version;

+ (instancetype)sharedInstance;
@end
