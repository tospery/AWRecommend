//
//  HTTPResponseBase.h
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPResponseBase : JXObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) id data;

+ (void)setTag:(ApiTag)tag;

@end
