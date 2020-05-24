//
//  UIFont+AWRecommend.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/4/17.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "UIFont+AWRecommend.h"

@implementation UIFont (AWRecommend)
//+ (UIFont *)aw_systemFontOfSize:(CGFloat)fontSize {
//    return [UIFont fontWithName:@"NotoSansHans-Black" size:(fontSize * JXInstance.fontScaleFactor)];
//}
//
//+ (UIFont *)aw_boldSystemFontOfSize:(CGFloat)fontSize {
//    return [UIFont fontWithName:@"NotoSansHans-DemiLight" size:(fontSize * JXInstance.fontScaleFactor)];
//}

@end


/*************************************************************************
 UILabel
 ************************************************************************/
@interface UILabel (AWRecommend)

@end

@implementation UILabel (AWRecommend)
+ (void)load{
    JXExchangeMethod(@selector(initWithFrame:), @selector(jx_ex_initWithFrame:));
    JXExchangeMethod(@selector(initWithCoder:), @selector(jx_ex_initWithCoder:));
}

- (instancetype)jx_ex_initWithCoder:(NSCoder *)decoder {
    [self jx_ex_initWithCoder:decoder];
    [self jx_ex_custom];
    return self;
}

- (instancetype)jx_ex_initWithFrame:(CGRect)frame {
    [self jx_ex_initWithFrame:frame];
    [self jx_ex_custom];
    return self;
}

- (void)jx_ex_custom {
    if (!self) {
        return;
    }
    
    UIFont *font = self.font;
    UIFontDescriptor *descriptor = font.fontDescriptor;
    UIFontDescriptorSymbolicTraits symbolicTraits = descriptor.symbolicTraits;
    BOOL isBold = (symbolicTraits & UIFontDescriptorTraitBold) != 0;
    NSString *name = isBold ? @"NotoSansHans-Black" : @"NotoSansHans-DemiLight";
    
    self.font = [UIFont fontWithName:name size:(font.pointSize * JXInstance.fontFactor)];
}

@end



/*************************************************************************
 UITextField
 ************************************************************************/
@interface UITextField (AWRecommend)

@end

@implementation UITextField (AWRecommend)
+ (void)load{
    JXExchangeMethod(@selector(initWithFrame:), @selector(jx_ex_initWithFrame:));
    JXExchangeMethod(@selector(initWithCoder:), @selector(jx_ex_initWithCoder:));
}

- (instancetype)jx_ex_initWithCoder:(NSCoder *)decoder {
    [self jx_ex_initWithCoder:decoder];
    [self jx_ex_custom];
    return self;
}

- (instancetype)jx_ex_initWithFrame:(CGRect)frame {
    [self jx_ex_initWithFrame:frame];
    [self jx_ex_custom];
    return self;
}

- (void)jx_ex_custom {
    if (!self) {
        return;
    }
    
    UIFont *font = self.font;
    UIFontDescriptor *descriptor = font.fontDescriptor;
    UIFontDescriptorSymbolicTraits symbolicTraits = descriptor.symbolicTraits;
    BOOL isBold = (symbolicTraits & UIFontDescriptorTraitBold) != 0;
    NSString *name = isBold ? @"NotoSansHans-Black" : @"NotoSansHans-DemiLight";
    
    self.font = [UIFont fontWithName:name size:(font.pointSize * JXInstance.fontFactor)];
}

@end




/*************************************************************************
 UITextView
 ************************************************************************/
@interface UITextView (AWRecommend)

@end

@implementation UITextView (AWRecommend)
+ (void)load{
    JXExchangeMethod(@selector(initWithFrame:), @selector(jx_ex_initWithFrame:));
    JXExchangeMethod(@selector(initWithCoder:), @selector(jx_ex_initWithCoder:));
}

- (instancetype)jx_ex_initWithCoder:(NSCoder *)decoder {
    [self jx_ex_initWithCoder:decoder];
    [self jx_ex_custom];
    return self;
}

- (instancetype)jx_ex_initWithFrame:(CGRect)frame {
    [self jx_ex_initWithFrame:frame];
    [self jx_ex_custom];
    return self;
}

- (void)jx_ex_custom {
    if (!self) {
        return;
    }
    
    UIFont *font = self.font;
    UIFontDescriptor *descriptor = font.fontDescriptor;
    UIFontDescriptorSymbolicTraits symbolicTraits = descriptor.symbolicTraits;
    BOOL isBold = (symbolicTraits & UIFontDescriptorTraitBold) != 0;
    NSString *name = isBold ? @"NotoSansHans-Black" : @"NotoSansHans-DemiLight";
    
    self.font = [UIFont fontWithName:name size:(font.pointSize * JXInstance.fontFactor)];
}

@end


/*************************************************************************
 UIButton
 ************************************************************************/
@interface UIButton (AWRecommend)

@end

@implementation UIButton (AWRecommend)
+ (void)load{
    JXExchangeMethod(@selector(initWithFrame:), @selector(jx_ex_initWithFrame:));
    JXExchangeMethod(@selector(initWithCoder:), @selector(jx_ex_initWithCoder:));
}

- (instancetype)jx_ex_initWithCoder:(NSCoder *)decoder {
    [self jx_ex_initWithCoder:decoder];
    [self jx_ex_custom];
    return self;
}

- (instancetype)jx_ex_initWithFrame:(CGRect)frame {
    [self jx_ex_initWithFrame:frame];
    [self jx_ex_custom];
    return self;
}

- (void)jx_ex_custom {
    if (!self) {
        return;
    }
    
    UIFont *font = self.titleLabel.font;
    UIFontDescriptor *descriptor = font.fontDescriptor;
    UIFontDescriptorSymbolicTraits symbolicTraits = descriptor.symbolicTraits;
    BOOL isBold = (symbolicTraits & UIFontDescriptorTraitBold) != 0;
    NSString *name = isBold ? @"NotoSansHans-Black" : @"NotoSansHans-DemiLight";
    
    self.titleLabel.font = [UIFont fontWithName:name size:(font.pointSize * JXInstance.fontFactor)];
}

@end


