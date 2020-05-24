//
//  NetManager.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/9.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NMInstance                  ([NetManager sharedInstance])

@interface NetManager : NSObject
@property (nonatomic, copy) NSString *baseURLString;
@property (nonatomic, copy) NSString *pathURLString;

+ (instancetype)sharedInstance;
@end
