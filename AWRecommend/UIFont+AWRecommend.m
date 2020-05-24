//
//  UIFont+AWRecommend.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/4/11.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "UIFont+AWRecommend.h"

@implementation UIFont (AWRecommend)
//+ (void)load {
//    Method m1 = class_getInstanceMethod(self, @selector(systemFontOfSize:));
//    Method m2 = class_getInstanceMethod(self, @selector(jx_systemFontOfSize:));
//    method_exchangeImplementations(m1, m2);
//}
//
//+ (UIFont *)jx_systemFontOfSize:(CGFloat)fontSize {
//    return [UIFont jx_deviceCustomFontWithName:@"NotoSansHans-DemiLight" size:fontSize];
//}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
+ (UIFont *)systemFontOfSize:(CGFloat)fontSize {
    return [UIFont jx_deviceCustomFontWithName:@"NotoSansHans-DemiLight" size:fontSize];
}

+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont jx_deviceCustomFontWithName:@"NotoSansHans-Black" size:fontSize];
}

#pragma clang diagnostic pop

@end
