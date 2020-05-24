//
//  JXURLProtocol.h
//  GDLBLotteryLiaoning
//
//  Created by 杨建祥 on 17/1/7.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXURLProtocol : NSURLProtocol
+ (NSSet *)supportedSchemes;
+ (void)setSupportedSchemes:(NSSet *)supportedSchemes;

- (NSString *)cachePathForRequest:(NSURLRequest *)aRequest;
- (BOOL)useCache;

+ (void)setCachingEnabled:(BOOL)enabled;
@end
