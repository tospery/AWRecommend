//
//  NSMutableAttributedString+JXObjc.m
//  xiaokalv
//
//  Created by 杨建祥 on 16/6/27.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "NSMutableAttributedString+JXObjc.h"

@implementation NSMutableAttributedString (JXObjc)
// (NSString *)kCTForegroundColorAttributeName
// NSForegroundColorAttributeName
- (NSMutableAttributedString *)jx_addAttributeWithColor:(UIColor *)color font:(UIFont *)font range:(NSRange)range {
    [self addAttribute:NSForegroundColorAttributeName
                 value:(id)color
                 range:range];
    [self addAttribute:NSFontAttributeName
                 value:(id)font
                 range:range];
    return self;
}

- (NSMutableAttributedString *)jx_addLineSpacing:(CGFloat)spacing alignment:(NSTextAlignment)alignment {
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.alignment = alignment;
    [ps setLineSpacing:spacing];
    [self addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, self.length)];
    return self;
}

- (CGSize)jx_sizeWithWidth:(CGFloat)width {
    CGSize result = CGSizeZero;
    
    NSRange range = NSMakeRange(0, self.length);
    NSDictionary *attrs = [self attributesAtIndex:0 effectiveRange:&range];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:attrs];
//    if (![dict objectForKey:NSParagraphStyleAttributeName]) {
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.alignment = NSTextAlignmentCenter;
//        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//        [dict setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
//        
//        [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
//    }
    
    result = [self.string boundingRectWithSize:CGSizeMake(width, UINT16_MAX)
                                options:NSStringDrawingUsesLineFragmentOrigin
                             attributes:dict
                                context:nil].size;
    return CGSizeMake(ceilf(result.width), ceilf(result.height));
}


+ (instancetype)jx_attributedStringWithString:(NSString *)string color:(UIColor *)color font:(UIFont *)font {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (color) {
        [attributes setObject:color forKey:NSForegroundColorAttributeName];
    }
    if (font) {
        [attributes setObject:font forKey:NSFontAttributeName];
    }
    return [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
}
@end
