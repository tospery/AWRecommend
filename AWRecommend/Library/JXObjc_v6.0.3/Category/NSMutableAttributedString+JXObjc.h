//
//  NSMutableAttributedString+JXObjc.h
//  xiaokalv
//
//  Created by 杨建祥 on 16/6/27.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (JXObjc)
- (NSMutableAttributedString *)jx_addAttributeWithColor:(UIColor *)color font:(UIFont *)font range:(NSRange)range;
- (NSMutableAttributedString *)jx_addLineSpacing:(CGFloat)spacing alignment:(NSTextAlignment)alignment;
- (CGSize)jx_sizeWithWidth:(CGFloat)width;

+ (instancetype)jx_attributedStringWithString:(NSString *)string color:(UIColor *)color font:(UIFont *)font;

@end
