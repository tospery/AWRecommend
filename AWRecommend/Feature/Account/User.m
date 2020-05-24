//
//  User.m
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/27.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "User.h"

@implementation User
//- (void)setupProperties:(id)another {
//    NSArray *properties = [[self class] jx_getProperties];
//    for (NSString *key in properties) {
//        [self setValue:[another valueForKey:key] forKey:key];
//    }
//}

- (void)resetProperties {
    [super resetProperties];
    
    self.mobile = nil;
    self.nickName = nil;
    self.dateOfBirth = nil;
    self.avatar = nil;
    self.sex = -1;
    self.sig = nil;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"jxID": @"wiseAccountInfoDto.id",
             @"mobile": @"wiseAccountInfoDto.mobile",
             @"nickName": @"wiseAccountInfoDto.nickName",
             @"dateOfBirth": @"wiseAccountInfoDto.dateOfBirth",
             @"avatar": @"wiseAccountInfoDto.avatar",
             @"sex": @"wiseAccountInfoDto.sex"};
}

- (NSString *)displayName {
    NSString *name = self.nickName;
    if (0 == name.length) {
        name = self.mobile;
    }
    if (0 == name.length) {
        name = self.jxID;
    }
    if (0 == name.length) {
        name = @"未知";
    }
    return name;
}

//- (void)logout {
//    [super logout];
//    [self resetProperties];
//}

@end
