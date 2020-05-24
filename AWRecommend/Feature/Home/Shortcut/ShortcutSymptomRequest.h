//
//  ShortcutSymptomRequest.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/2.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShortcutSymptomRequest : NSObject
@property (nonatomic, assign) NSInteger current;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger suitObjectId;
@property (nonatomic, strong) NSArray *params;

@end


@interface ShortcutSymptomRequestParam : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *tag;

@end
