//
//  NSString+JXObjc.h
//  MyCoding
//
//  Created by 杨建祥 on 16/5/1.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JXObjc)
- (NSString *)jx_md5Bit32;
- (NSString *)jx_md5Bit16;
- (NSString *)jx_sha1;

+ (NSString *)jx_filepathWithFilename:(NSString *)filename;
- (CGSize)jx_sizeWithFont:(UIFont *)font width:(CGFloat)width;
- (CGSize)jx_sizeWithAttributes:(NSDictionary *)attributes width:(CGFloat)width;

- (BOOL)jx_isEmpty;
- (NSString *)jx_trimWhitespace;

- (NSString *)jx_urlEncodeString;
- (NSString *)jx_urlDecodeString;

// 备份
#pragma mark - Public methods
/**
 *  为GET请求添加url参数
 *
 *  @param params url参数
 *
 *  @return 请求地址
 */
- (NSString *)exAddURLParams:(NSDictionary *)params;

/**
 *  对链接进行url编码
 *
 *  @return url编码值
 */
- (NSString *)exURLEncodeLinkString;

/**
 *  对参数进行url编码（可爱的妈妈 -> %E5%8F%AF%E7%88%B1%E7%9A%84%E5%A6%88%E5%A6%88）
 *
 *  @return url编码值
 */
- (NSString *)exURLEncodeParamString;

/**
 *  特定格式的URL编码
 *
 *  @param encoding 编码格式
 *
 *  @return url编码值
 */
- (NSString *)exURLEncodeParamStringWithEncoding:(NSStringEncoding)encoding;

/**
 *  32位MD5字符串
 *
 *  @return 32位MD5字符串
 */
- (NSString *)exMD5Bit32String;

/**
 *  16位MD5字符串
 *
 *  @return 16位MD5字符串
 */
- (NSString *)exMD5Bit16String;

- (NSString *)exSHA1String;

/**
 *  绘制字符串在一个rect中
 *
 *  @param rect      区域
 *  @param font      字体
 *  @param color     颜色
 *  @param alignment 对齐方式
 */
- (void)exDrawInRect:(CGRect)rect font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment;

/**
 *  绘制字符串到一个point
 *
 *  @param point     点
 *  @param font      字体
 *  @param color     颜色
 *  @param alignment 对齐方式
 */
- (void)exDrawAtPoint:(CGPoint)point font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment;


/**
 *  删除首位的特定字符串
 *
 *  @param specialCharacter 特定字符串
 *
 *  @return 结果
 */
- (NSString *)exDeleteSpecialCharacterInFix:(NSString *)specialCharacter;

/**
 *  替换Unicode编码值
 *
 *  @return 结果
 */
- (NSString *)exReplaceUnicodeValue;

/**
 *  安全版本的substringToIndex
 *
 *  @param to 索引
 *
 *  @return 结果
 */
- (NSString *)exSubstringToIndex:(NSUInteger)to;

/**
 *  字节长度
 *
 *  @return 字节长度
 */
- (NSUInteger)exLengthInByte;

/**
 *  十六进制字符串 -> 十进制字符串
 *
 *  @return 十进制字符串
 */
- (NSString *)exHexToDec;

/**
 *  忽略大小写的字符串比较
 *
 *  @param other 被比较的字符串
 *
 *  @return 是否相等
 */
- (BOOL)exCompareToIgnoreCase:(NSString *)other;

/**
 *  获取特定字节长度的子字符串
 *
 *  @param byteCount 字节长度
 *
 *  @return 特定字节长度的子字符串
 */
- (NSString *)exSubstringWithByteCount:(NSUInteger)byteCount;

/**
 *  移除空白字符和换行符
 *
 *  @return 结果
 */
- (NSString *)exTrimWhitespaceAndNewline;

///**
// *  移除空白字符
// *
// *  @return 结果
// */
//- (NSString *)exTrimWhitespace;

/**
 *  替换字典为字符串
 *
 *  @param replaces 替换字典
 *
 *  @return 结果
 */
- (NSString *)exStringWithReplaces:(NSDictionary *)replaces;

/**
 *  字符串 -> 日期（特定时区）
 *
 *  @param format 格式化符
 *  @param locale 时区
 *
 *  @return 日期
 */
- (NSDate *)exDateWithFormat:(NSString *)format locale:(NSString *)locale;

/**
 *  字符串 -> 日期（当前时区）
 *
 *  @param format 格式化符
 *
 *  @return 日期
 */
- (NSDate *)exDateWithFormat:(NSString *)format;

/**
 *  %.2f格式的浮点数
 *
 *  @return 结果
 */
- (CGFloat)exFloatValue;

#pragma mark - Class methods
/**
 *  JS脚本（重置网页中图片支持的最大宽度）
 *
 *  @param width 最大宽度
 *
 *  @return JS脚本字符串
 */
+ (NSString *)exJSStringResizeImagesForiOS:(CGFloat)width;

- (NSString *)exMetaStringAdaptiveWidth:(CGFloat)width;

/**
 *  两点之间的距离字符串
 *
 *  @param from 起点
 *  @param to   终点
 *
 *  @return 距离字符串
 */
+ (NSString *)exDistanceWithLocation:(CLLocation *)from longitude:(CLLocation *)to;

/**
 *  获取Document下指定文件名的文件路径
 *
 *  @param filename 文件名
 *
 *  @return 文件路径
 */
+ (NSString *)exFilepathStringWithFilename:(NSString *)filename;
@end
