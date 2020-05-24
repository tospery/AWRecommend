//
//  JXPersistenceManager.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/1.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXPersistenceManager.h"

@implementation JXPersistenceManager
- (BOOL)storageBasic:(id)basic key:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:basic forKey:key];
    return [ud synchronize];
}

- (id)fetchBasic:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:key];
}

- (BOOL)storageArchive:(id)archive path:(NSString *)path {
    NSString *filePath = [NSString jx_filepathWithFilename:path];
    if (![self createFolder:filePath]) {
        JXLogError(@"创建文件路径失败");
        return NO;
    }
    
    return [NSKeyedArchiver archiveRootObject:archive toFile:filePath];
}

- (id)fetchArchive:(NSString *)path {
    NSString *filePath = [NSString jx_filepathWithFilename:path];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

- (BOOL)createFolder:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSString *name = url.lastPathComponent;
    NSString *folder = [path stringByReplacingOccurrencesOfString:name withString:@""];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:folder]) {
        return [fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}

+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

@end



