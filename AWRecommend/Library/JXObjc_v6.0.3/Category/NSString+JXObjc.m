//
//  NSString+JXObjc.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/1.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "NSString+JXObjc.h"
#import <CommonCrypto/CommonDigest.h>
#import <objc/message.h>
#import <objc/runtime.h>

@implementation NSString (JXObjc)
+ (NSString *)jx_filepathWithFilename:(NSString *)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    return [documents stringByAppendingPathComponent:filename];
}

- (NSString *)jx_md5Bit32 {
    const char *cStr = self.UTF8String;
    unsigned char digits[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digits);
    NSMutableString *result = [NSMutableString stringWithCapacity:2 * CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [result appendFormat:@"%02x", digits[i]];
    }
    return result;
}

- (NSString *)jx_md5Bit16 {
    NSString *md5Bit32 = [self jx_md5Bit32]; // 提取32位MD5散列的中间16位
    NSString *result = [[md5Bit32 substringToIndex:24] substringFromIndex:8]; // 即9～25位
    return result;
}

- (NSString *)jx_sha1 {
    // see http://www.makebetterthings.com/iphone/how-to-get-md5-and-sha1-in-objective-c-ios-sdk/
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

- (CGSize)jx_sizeWithAttributes:(NSDictionary *)attributes width:(CGFloat)width {
    CGSize result = CGSizeZero;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:attributes];
    if (![dict objectForKey:NSParagraphStyleAttributeName]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        [dict setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    }
    
    result = [self boundingRectWithSize:CGSizeMake(width, UINT16_MAX)
                                options:NSStringDrawingUsesLineFragmentOrigin
                             attributes:dict
                                context:nil].size;
    return CGSizeMake(ceilf(result.width), ceilf(result.height));
}

- (CGSize)jx_sizeWithFont:(UIFont *)font width:(CGFloat)width {
    CGSize result = CGSizeZero;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *textParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        textParagraphStyle.alignment = NSTextAlignmentCenter;
        textParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        result = [self boundingRectWithSize:CGSizeMake(width, UINT16_MAX)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName: font,
                                              NSParagraphStyleAttributeName: textParagraphStyle}
                                    context:nil].size;
        result = CGSizeMake(ceilf(result.width), ceilf(result.height));
    }
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font
                  constrainedToSize:CGSizeMake(width, UINT16_MAX)
                      lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
    }
    return result;
}

- (BOOL)jx_isEmpty {
    return 0 == self.length;
}

- (NSString *)jx_trimWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)jx_urlEncodeString {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%<>[\\]^`{|}\"]+"].invertedSet];
    // return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)jx_urlDecodeString {
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

// 备份
#pragma mark - Public methods
- (NSString *)exAddURLParams:(NSDictionary *)params {
    NSMutableString *result = [NSMutableString stringWithString:self];
    if (params.count != 0) {
        [result appendString:@"?"];
        for (NSString *key in params.allKeys) {
            id obj = params[key];
            if ([obj isKindOfClass:[NSString class]]) {
                [result appendString:[NSString stringWithFormat:@"%@=%@&", key, [obj exURLEncodeParamString]]];
            }else {
                [result appendString:[NSString stringWithFormat:@"%@=%@&", key, obj]];
            }
        }
        [result deleteCharactersInRange:NSMakeRange(result.length - 1, 1)];
    }
    return result;
}

- (NSString *)exURLEncodeLinkString {
    NSString *uStr = [self exURLEncodeParamString];
    NSMutableString *mStr = [NSMutableString stringWithString:uStr];
    [mStr replaceOccurrencesOfString:@"%3A" withString:@":" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mStr.length)];
    [mStr replaceOccurrencesOfString:@"%2F" withString:@"/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mStr.length)];
    return mStr;
}

- (NSString *)exURLEncodeParamString {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
}

- (NSString *)exURLEncodeParamStringWithEncoding:(NSStringEncoding)encoding {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", CFStringConvertNSStringEncodingToEncoding(encoding)));
}

- (NSString *)exMD5Bit32String {
    const char *cStr = self.UTF8String;
    unsigned char digits[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digits);
    NSMutableString *result = [NSMutableString stringWithCapacity:2 * CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [result appendFormat:@"%02x", digits[i]];
    }
    return result;
}

- (NSString *)exMD5Bit16String {
    NSString *md5Bit32 = [self exMD5Bit32String]; // 提取32位MD5散列的中间16位
    NSString *result = [[md5Bit32 substringToIndex:24] substringFromIndex:8]; // 即9～25位
    return result;
}

- (NSString *)exSHA1String {
    // see http://www.makebetterthings.com/iphone/how-to-get-md5-and-sha1-in-objective-c-ios-sdk/
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

- (void)exDrawInRect:(CGRect)rect font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment {
    if ([self respondsToSelector:@selector(drawWithRect:options:attributes:context:)]) {
        NSMutableParagraphStyle *textParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        textParagraphStyle.alignment = alignment;
        textParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self drawWithRect:rect
                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                attributes:@{NSFontAttributeName: font,
                             NSParagraphStyleAttributeName: textParagraphStyle,
                             NSForegroundColorAttributeName: color}
                   context:nil];
    }else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self drawInRect:rect
                withFont:font
           lineBreakMode:NSLineBreakByWordWrapping
               alignment:alignment];
#pragma clang diagnostic pop
    }
}

- (void)exDrawAtPoint:(CGPoint)point font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment {
    if (JXiOSVersionGreaterThanOrEqual(@"7.0")) {
        NSMutableParagraphStyle *textParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        textParagraphStyle.alignment = alignment;
        textParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self drawAtPoint:point
           withAttributes:@{NSFontAttributeName: font,
                            NSParagraphStyleAttributeName: textParagraphStyle,
                            NSForegroundColorAttributeName: color}];
    }else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [color setFill];
        [self drawAtPoint:point withFont:font];
#pragma clang diagnostic pop
    }
}

- (NSString *)exDeleteSpecialCharacterInFix:(NSString *)specialCharacter {
    NSMutableString *temp = [NSMutableString stringWithString:self];
    while (YES) {
        if ([temp hasPrefix:specialCharacter]) {
            [temp deleteCharactersInRange:NSMakeRange(0, 1)];
        }else {
            break;
        }
    }
    while (YES) {
        if ([temp hasSuffix:specialCharacter]) {
            [temp deleteCharactersInRange:NSMakeRange(temp.length - 1, 1)];
        }else {
            break;
        }
    }
    
    return temp;
}

- (NSString *)exReplaceUnicodeValue {
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
#pragma clang diagnostic pop
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

- (NSString *)exSubstringToIndex:(NSUInteger)to {
    if (self.length < to) {
        return self;
    }
    return [self substringToIndex:to];
}

- (NSUInteger)exLengthInByte {
    NSUInteger bytes = 0;
    NSUInteger unicodes = self.length;
    
    NSRange range;
    NSString *uString;
    const char *cString;
    for (NSUInteger i = 0; i < unicodes; ++i) {
        range = NSMakeRange(i, 1);
        uString = [self substringWithRange:range];
        cString = [uString UTF8String];
        if (cString == NULL || strlen(cString) == 1 ) {
            ++bytes;
        }else {
            bytes += 2;
        }
    }
    return bytes;
}

- (NSString *)exHexToDec {
    return JXStrWithInt(strtoul([self UTF8String], 0, 16));
}

- (BOOL)exCompareToIgnoreCase:(NSString *)other {
    if (NSOrderedSame == [self compare:other options:NSCaseInsensitiveSearch]) {
        return YES;
    }
    return NO;
}

- (NSString *)exSubstringWithByteCount:(NSUInteger)byteCount {
    NSUInteger bytes = [self exLengthInByte];
    if (byteCount >= bytes) {
        return self;
    }
    
    NSUInteger i = 0;
    NSUInteger unicodes = self.length;
    NSUInteger remaining = byteCount;
    
    NSRange range;
    NSString *uString;
    const char *cString;
    for (; i < unicodes && remaining > 0; ++i) {
        range = NSMakeRange(i, 1);
        uString = [self substringWithRange:range];
        cString = [uString UTF8String];
        if (cString == NULL || strlen(cString) == 1) {
            --remaining;
        }else {
            if (1 == remaining) {
                break;
            }
            remaining -= 2;
        }
    }
    
    return [self substringToIndex:i];
}

- (NSString *)exTrimWhitespaceAndNewline {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//- (NSString *)exTrimWhitespace {
//    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//}

- (NSString *)exStringWithReplaces:(NSDictionary *)replaces {
    NSString *result = self;
    for (NSString *key in replaces.keyEnumerator) {
        result = [result stringByReplacingOccurrencesOfString:[[NSString alloc] initWithFormat:@"%%%%%@%%%%", key]
                                                   withString:replaces[key]];
    }
    return result;
}

- (NSDate *)exDateWithFormat:(NSString *)format locale:(NSString *)locale {
    NSDate *date = [[NSDateFormatter exDateFormatterWithFormat:format locale:locale] dateFromString:self];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    return [date dateByAddingTimeInterval:interval];
}

- (NSDate *)exDateWithFormat:(NSString *)format {
    return [[NSDateFormatter exDateFormatterWithFormat:format] dateFromString:self];
}

- (CGFloat)exFloatValue {
    CGFloat first = [self floatValue];
    NSString *second = [NSString stringWithFormat:@"%.2f", first];
    return [second floatValue];
}

#pragma mark - Class methods
+ (NSString *)exJSStringResizeImagesForiOS:(CGFloat)width {
    return [NSString stringWithFormat:@"var script = document.createElement('script');"
            "script.type = 'text/javascript';"
            "script.text = \"function resizeImagesForiOS() { "
            "var myimg,oldwidth;"
            "var maxwidth=%.2f;"
            "for(i=0;i <document.images.length;i++){"
            "myimg = document.images[i];"
            "if(myimg.width > maxwidth){"
            "oldwidth = myimg.width;"
            "myimg.width = maxwidth;"
            "myimg.height = myimg.height * (maxwidth/oldwidth);"
            "}"
            "}"
            "}\";"
            "document.getElementsByTagName('head')[0].appendChild(script);", width];
}

- (NSString *)exMetaStringAdaptiveWidth:(CGFloat)width {
    return [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", width];
}

+ (NSString *)exDistanceWithLocation:(CLLocation *)fromLocation longitude:(CLLocation *)toLocation {
    CLLocationDistance dis = [fromLocation distanceFromLocation:toLocation];
    
    if (dis >= 1000) {
        return [NSString stringWithFormat:@"%0.0fkm",dis / 1000];
    }else {
        return [NSString stringWithFormat:@"%0.0fm", dis];
    }
}

+ (NSString *)exFilepathStringWithFilename:(NSString *)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    return [documents stringByAppendingPathComponent:filename];
}

@end
