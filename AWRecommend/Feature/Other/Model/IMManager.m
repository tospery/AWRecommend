//
//  IMManager.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/5.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "IMManager.h"

@implementation IMManager
#pragma mark - TIMMessageListener
- (void)onNewMessage:(NSArray *) msgs {
    
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
