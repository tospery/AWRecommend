//
//  JXScheduleHandler.m
//  JXSamples
//
//  Created by 杨建祥 on 16/5/15.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXScheduleHandler.h"

@implementation JXScheduleHandler
- (void)didTriggerAction:(id)sender {
    if (self.didTriggerBlock) {
        self.didTriggerBlock(sender);
    }
}

- (void)dealloc {
    JXLogInfo(@"JXTarget dealloc");
}

@end
