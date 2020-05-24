//
//  ShortcutSymptom.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/19.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ShortcutSymptom.h"

@implementation ShortcutSymptom
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"disease": [ShortcutSymptomList class]};
}

@end


@implementation ShortcutSymptomList
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"disease": [ShortcutSymptomListDisease class]};
}


@end


@implementation ShortcutSymptomListDisease

@end
