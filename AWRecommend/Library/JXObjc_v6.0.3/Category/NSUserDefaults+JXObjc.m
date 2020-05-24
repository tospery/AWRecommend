//
//  NSUserDefaults+JXObjc.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "NSUserDefaults+JXObjc.h"

@implementation NSUserDefaults (JXObjc)
/**
 *  清理用户设置
 */
- (void)exClean {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

@end
