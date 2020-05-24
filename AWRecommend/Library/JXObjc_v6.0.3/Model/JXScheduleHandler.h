//
//  JXScheduleHandler.h
//  JXSamples
//
//  Created by 杨建祥 on 16/5/15.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXScheduleHandler : NSObject
@property (nonatomic, copy) JXVoidBlock_id didTriggerBlock;

- (void)didTriggerAction:(id)sender;
@end
