//
//  IMManager.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/5.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMManager : NSObject <TIMMessageListener, TIMConnListener>
+ (instancetype)sharedInstance;

@end
