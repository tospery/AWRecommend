//
//  NSTimer+JXObjc.h
//  JXSamples
//
//  Created by 杨建祥 on 16/5/14.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (JXObjc)
- (void)jx_pause;


- (void)jx_resume;

- (void)jx_resumeWithInterval:(NSTimeInterval)interval;
@end
