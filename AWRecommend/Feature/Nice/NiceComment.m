//
//  NiceComment.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/21.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "NiceComment.h"

@implementation NiceComment
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    NSDictionary *dict = [super mj_replacedKeyFromPropertyName];
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithDictionary:dict];
    [ret setObject:@"dto" forKey:@"user"];
    return ret;
}

@end


@implementation NiceCommentUser
- (NSString *)displayName {
    NSString *name = self.nickName;
    if (0 == name.length) {
        name = self.mobile;
        if (name.length == 11) {
            name = JXStrWithFmt(@"%@****%@", [name substringToIndex:3], [name substringFromIndex:7]);
        }
    }
    if (0 == name.length) {
        name = self.jxID;
    }
    if (0 == name.length) {
        name = @"未知";
    }
    return name;
}
@end
