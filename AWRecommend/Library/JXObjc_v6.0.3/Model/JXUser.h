//
//  JXUser.h
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXArchiveObject.h"
#import "JXPropertyProtocol.h"

@interface JXUser : JXArchiveObject <JXPropertyProtocol>
@property (nonatomic, assign) BOOL isLogined;
@property (nonatomic, copy) NSString *token;

//- (BOOL)checkLoginWithFinish:(JXLoginDidPassBlock)finish error:(NSError *)error;
- (void)checkLoginWithFinish:(JXVoidBlock_bool)finish error:(NSError *)error;

- (void)setupWithUser:(JXUser *)user;
- (void)loginWithUser:(JXUser *)user;
- (void)logout;

@end
