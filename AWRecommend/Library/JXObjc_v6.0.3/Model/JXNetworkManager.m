//
//  JXNetworkManager.m
//  MeijiaStore
//
//  Created by 杨建祥 on 16/1/12.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import "JXNetworkManager.h"

@implementation JXNetworkManager
+ (BOOL)isEnableInternet {
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

+ (BOOL)IsEnableWIFI {
    return [AFNetworkReachabilityManager sharedManager].isReachableViaWiFi;
}

+ (BOOL)IsEnableWWAN {
    return [AFNetworkReachabilityManager sharedManager].isReachableViaWWAN;
}
@end
