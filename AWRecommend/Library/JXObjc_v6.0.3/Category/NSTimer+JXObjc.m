//
//  NSTimer+JXObjc.m
//  JXSamples
//
//  Created by 杨建祥 on 16/5/14.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "NSTimer+JXObjc.h"

@implementation NSTimer (JXObjc)
- (void)jx_pause {
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate distantFuture]];
}


- (void)jx_resume {
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate date]];
}

- (void)jx_resumeWithInterval:(NSTimeInterval)interval {
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}
@end
