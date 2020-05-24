//
//  JXObject.m
//  MyCoding
//
//  Created by 杨建祥 on 16/4/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXObject.h"

@implementation JXObject
- (NSString *)description {
    return [self mj_JSONString];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"jxID": @"id",
             @"jxDescription": @"description"};
}

- (instancetype)initWithUid:(NSString *)uid {
    if (self = [self init]) {
        _jxID = uid;
    }
    return self;
}

- (BOOL)isGreaterThan:(id)object {
    return YES;
}

- (BOOL)isLowerThan:(id)object {
    return NO;
}

@end
