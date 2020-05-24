//
//  UIImage+JXObjc.h
//  JXSamples
//
//  Created by 杨建祥 on 16/4/24.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JXObjc)
+ (void)jx_imageWithRemoteURL:(NSURL *)remoteURL localName:(NSString *)localName dftImage:(UIImage *)dftImage finish:(JXVoidBlock_id)finish;

//+ (void)jx_downloadWithLinks:(NSArray *)links finish:(JXVoidBlock_id)finish;

+ (UIImage *)jx_imageName:(NSString *)imageName frameworkName:(NSString *)frameworkName bundleName:(NSString *)bundleName;
+ (UIImage *)jx_imageName:(NSString *)imageName frameworkClass:(Class)frameworkClass bundleName:(NSString *)bundleName;

+ (UIImage *)jx_imageWithColor:(UIColor *)color;
+ (UIImage *)jx_imageWithResource:(NSString *)resource type:(NSString *)type;

- (UIImage*)jx_makeRadius:(CGFloat)radius;

/**
 *  获取指定质量的图片数据
 *
 *  @param compressionQuality 压缩质量（0~1）
 *  @param maxSize            最大数据量（kb）
 *
 *  @return 图片数据
 */
- (NSData *)jx_dataWithCompressionQuality:(CGFloat)compressionQuality maxSize:(NSUInteger)maxSize;

//- (UIImage *)imageWithColoredBorder:(NSUInteger)borderThickness borderColor:(UIColor *)color withShadow:(BOOL)withShadow;
//- (UIImage *)imageWithTransparentBorder:(NSUInteger)thickness;

// 备份
#pragma mark - Public methods

/**
 *  生成一个指定尺寸的图片
 *
 *  @param toWidth  宽度
 *  @param toHeight 高度
 *
 *  @return 图片
 */
- (UIImage *)jx_scaleWithWidth:(CGFloat)toWidth height:(CGFloat)toHeight;

/**
 *  获取图片的md5值
 *
 *  @return 结果
 */
- (NSString *)exMD5String;

/**
 *  绘制文本到图片上
 *
 *  @param text  文本
 *  @param font  字体
 *  @param color 颜色
 *  @param size  大小
 *
 *  @return 结果
 */
- (UIImage *)drawText:(NSString *)text font:(UIFont *)font color:(UIColor *)color size:(CGSize)size;

/**
 *  缩放图片
 *
 *  @param size 大小
 *
 *  @return 结果
 */
- (UIImage *)exScaleToSize:(CGSize)size;

/**
 *  弹性图片
 *
 *  @return 结果
 */
- (UIImage *)exStretchCenter;


+ (UIImage *)exImageWithBundleName:(NSString *)bundleName imageName:(NSString *)imageName;

@end
