//
//  JXNetworkManager.h
//  MeijiaStore
//
//  Created by 杨建祥 on 16/1/12.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXNetworkManager : NSObject
+ (BOOL)isEnableInternet;
+ (BOOL)IsEnableWIFI;
+ (BOOL)IsEnableWWAN;
@end
