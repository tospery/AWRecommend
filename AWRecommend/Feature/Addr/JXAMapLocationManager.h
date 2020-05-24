//
//  JXAMapLocationManager.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/9/19.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXAMapLocationManager : NSObject <AMapLocationManagerDelegate>
- (RACSignal *)locateSignal;

@end
