//
//  IMListener.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/5.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMListener : NSObject <TIMMessageListener, TIMConnListener, TIMUserStatusListener>
+ (instancetype)sharedInstance;

@end
