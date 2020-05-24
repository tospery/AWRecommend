//
//  JXNetwork.h
//  MeijiaStore
//
//  Created by 杨建祥 on 16/1/12.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

//#ifdef JXEnableLibReachability
#import <Foundation/Foundation.h>

@interface JXNetwork : NSObject
@property (nonatomic, strong, readonly) NSString *ip;

//- (void)setupChangeBlock:(void (^)(NetworkStatus status))changeBlock;
//- (BOOL)isEnabled;
//
//+ (NetworkStatus)currentNetworkStatus;

+ (instancetype)sharedInstance;
@end
//#endif
