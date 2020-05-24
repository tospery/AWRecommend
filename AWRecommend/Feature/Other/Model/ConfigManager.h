//
//  ConfigManager.h
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CMInstance                  ([ConfigManager sharedInstance])

@interface ConfigManager : NSObject
@property (nonatomic, copy) NSString *baseURLString;
@property (nonatomic, copy) NSString *pathURLString;

+ (instancetype)sharedInstance;
@end
