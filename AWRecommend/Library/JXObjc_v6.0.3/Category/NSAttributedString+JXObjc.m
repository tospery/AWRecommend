//
//  NSAttributedString+JXObjc.m
//  JXSamples
//
//  Created by 杨建祥 on 16/4/23.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "NSAttributedString+JXObjc.h"

@implementation NSAttributedString (JXObjc)
// YJX_LIB 修改range参数为数组
//- (NSAttributedString *)jx_attributeWithColor:(UIColor *)color
//                                         font:(UIFont *)font
//                                        range:(NSRange)range {
//    NSMutableAttributedString *mtAttrString = [[NSMutableAttributedString alloc] initWithAttributedString:self];
//    [mtAttrString addAttribute:NSForegroundColorAttributeName
//                         value:(id)color
//                         range:range];
//    [mtAttrString addAttribute:NSFontAttributeName
//                         value:(id)font
//                         range:range];
//    return mtAttrString;
//}

+ (instancetype)jx_attributedStringWithString:(NSString *)string color:(UIColor *)color font:(UIFont *)font {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (color) {
        [attributes setObject:color forKey:NSForegroundColorAttributeName];
    }
    if (font) {
        [attributes setObject:font forKey:NSFontAttributeName];
    }
    return [[NSAttributedString alloc] initWithString:string attributes:attributes];
}

@end
