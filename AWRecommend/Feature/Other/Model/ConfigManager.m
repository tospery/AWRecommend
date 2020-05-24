//
//  ConfigManager.m
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "ConfigManager.h"

@implementation ConfigManager
- (instancetype)init {
    if (self = [super init]) {
#ifdef JXEnableEnvDev
        //_baseURLString = @"http://192.168.10.235:8080";
        _baseURLString = @"https://ivhome-test.appvworks.com";
#elif defined(JXEnableEnvHoc)
        _baseURLString = @"https://ivhome-test.appvworks.com";
#elif defined(JXEnableEnvApp)
#else
#endif
        _pathURLString = @"appvworks.ihealth.portal";
    }
    return self;
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
