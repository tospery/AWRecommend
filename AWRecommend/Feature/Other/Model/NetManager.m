//
//  NetManager.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/9.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "NetManager.h"

@implementation NetManager
- (instancetype)init {
    if (self = [super init]) {
        _pathURLString = @"appvworks.ihealth.portal";
        
#ifdef JXEnableEnvDev
        _baseURLString = @"http://183.220.1.29:10001";
        //_baseURLString = @"http://192.168.10.235:8080";
        //_baseURLString = @"https://ivhome-test.appvworks.com";
#elif defined(JXEnableEnvHoc)
        //_baseURLString = @"http://ivhome-test.appvworks.com";
        //_baseURLString = @"http://192.168.0.203:8080";
        _baseURLString = @"http://d13617e6.ngrok.io";
#elif defined(JXEnableEnvApp)
        _baseURLString = @"https://api.appvworks.com";
        _pathURLString = nil;
#else
#endif
        
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
