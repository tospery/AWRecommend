//
//  WXPayRequest.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/8/10.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXPayRequest : NSObject
@property (nonatomic, copy) NSString *partnerid;
@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *noncestr;
@property (nonatomic, copy) NSString *packages;
@property (nonatomic, copy) NSString *prepayid;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, assign) NSUInteger timestamp;

@end
