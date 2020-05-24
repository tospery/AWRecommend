//
//  UIFont+JXObjc.m
//  JXSamples
//
//  Created by 杨建祥 on 16/4/23.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "UIFont+JXObjc.h"

//static NSString *fontName;
//static CGFloat fontScale;

@implementation UIFont (JXObjc)
+ (void)load {
//    if (0 == JXInstance.systemFontName.length) {
//        JXInstance.systemFontName = [UIFont systemFontOfSize:12].fontName;
//    }
//    JXExchangeMethod(@selector(systemFontOfSize:), @selector(jx_ex_systemFontOfSize:));
//    //JXExchangeMethod(@selector(fontWithName:size:), @selector(jx_ex_fontWithName:size:));
}

//+ (UIFont *)jx_ex_systemFontOfSize:(CGFloat)fontSize {
//    return [UIFont fontWithName:JXInstance.systemFontName size:(fontSize * JXInstance.fontScaleFactor)];
//}

//+ (UIFont *)jx_ex_fontWithName:(NSString *)fontName size:(CGFloat)fontSize {
//    
//}

+ (UIFont *)jx_systemFontOfSize:(CGFloat)fontSize {
    return [UIFont systemFontOfSize:(fontSize * JXInstance.fontFactor)];
}

+ (UIFont *)jx_boldSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont boldSystemFontOfSize:(fontSize * JXInstance.fontFactor)];
}

+ (UIFont *)jx_deviceRegularFontOfSize:(CGFloat)fontSize {
    UIFont *result;
    JXDeviceInch inch = [JXDevice sharedInstance].inch;
    switch (inch) {
        case JXDeviceInch35:
            result = [UIFont systemFontOfSize:fontSize];
            break;
        case JXDeviceInch40:
            result = [UIFont systemFontOfSize:fontSize];
            break;
        case JXDeviceInch47:
            result = [UIFont systemFontOfSize:(fontSize + 1)];
            break;
        case JXDeviceInch55:
            result = [UIFont systemFontOfSize:(fontSize + 2)];
            break;
        default:
            result = [UIFont systemFontOfSize:fontSize];
            break;
    }
    return result;
}

+ (UIFont *)jx_deviceBoldFontOfSize:(CGFloat)fontSize {
    UIFont *result;
    JXDeviceInch inch = [JXDevice sharedInstance].inch;
    switch (inch) {
        case JXDeviceInch35:
            result = [UIFont boldSystemFontOfSize:fontSize];
            break;
        case JXDeviceInch40:
            result = [UIFont boldSystemFontOfSize:fontSize];
            break;
        case JXDeviceInch47:
            result = [UIFont boldSystemFontOfSize:(fontSize + 1)];
            break;
        case JXDeviceInch55:
            result = [UIFont boldSystemFontOfSize:(fontSize + 2)];
            break;
        default:
            result = [UIFont boldSystemFontOfSize:fontSize];
            break;
    }
    return result;
}

+ (UIFont *)jx_deviceCustomFontWithName:(NSString *)name size:(CGFloat)size {
    UIFont *result;
    JXDeviceInch inch = [JXDevice sharedInstance].inch;
    switch (inch) {
        case JXDeviceInch35:
            result = [UIFont fontWithName:name size:size];
            break;
        case JXDeviceInch40:
            result = [UIFont fontWithName:name size:size];
            break;
        case JXDeviceInch47:
            result = [UIFont fontWithName:name size:(size + 1)];
            break;
        case JXDeviceInch55:
            result = [UIFont fontWithName:name size:(size + 2)];
            break;
        default:
            result = [UIFont fontWithName:name size:size];
            break;
    }
    return result;
}

@end















