//
//  UIImage+JXObjc.m
//  JXSamples
//
//  Created by 杨建祥 on 16/4/24.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "UIImage+JXObjc.h"
#import <CommonCrypto/CommonDigest.h>

//static CGImageRef CreateMask(CGSize size, NSUInteger thickness) {
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
//
//    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
//                                                       size.width,
//                                                       size.height,
//                                                       8,
//                                                       size.width * 32,
//                                                       colorSpace,
//                                                       kCGBitmapByteOrderDefault | kCGImageAlphaNone);
//    if (bitmapContext == NULL)
//    {
//        NSLog(@"create mask bitmap context failed");
//        return nil;
//    }
//
//    // fill the black color in whole size, anything in black area will be transparent.
//    CGContextSetFillColorWithColor(bitmapContext, [UIColor blackColor].CGColor);
//    CGContextFillRect(bitmapContext, CGRectMake(0, 0, size.width, size.height));
//
//    // fill the white color in whole size, anything in white area will keep.
//    CGContextSetFillColorWithColor(bitmapContext, [UIColor whiteColor].CGColor);
//    CGContextFillRect(bitmapContext, CGRectMake(thickness, thickness, size.width - thickness * 2, size.height - thickness * 2));
//
//    // acquire the mask
//    CGImageRef maskImageRef = CGBitmapContextCreateImage(bitmapContext);
//
//    // clean up
//    CGContextRelease(bitmapContext);
//    CGColorSpaceRelease(colorSpace);
//
//    return maskImageRef;
//}

@implementation UIImage (JXObjc)
//+ (void)jx_downloadWithLinks:(NSArray *)links finish:(JXVoidBlock_id)finish {
//    
//    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
//    NSMutableArray *images = [NSMutableArray arrayWithCapacity:links.count];
//    
//    for (NSString *link in links) {
//        [downloader downloadImageWithURL:JXURLWithStr(link) options:0 progress:NULL completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//            if (image && finished) {
//                [images addObject:image];
//            }
//            
//            if (images.count == links.count) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (finish) {
//                        finish(images);
//                    }
//                });
//            }
//        }];
//    }
//}

+ (void)jx_imageWithRemoteURL:(NSURL *)remoteURL localName:(NSString *)localName dftImage:(UIImage *)dftImage finish:(JXVoidBlock_id)finish {
    SDImageCache *cache = [SDImageCache sharedImageCache];
    __block UIImage *result = nil;
    
    if (0 != localName.length) {
        [cache imageFromDiskCacheForKey:localName];
        if (result) {
            if (finish) {
                finish(result);
            }
            return;
        }
    }
    
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    [downloader downloadImageWithURL:remoteURL options:0 progress:NULL completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        // YJX_LIB_v6.0.2
#ifdef JXEnableAppAWKSZhixuan
        if (image && finished) {
            result = image;
            [cache storeImage:image forKey:localName];
        }else {
            result = dftImage;
        }
        
        if (finish) {
            dispatch_async(dispatch_get_main_queue(), ^{
                finish(result);
            });
        }
#else
        if (image && finished) {
            result = image;
        }else {
            result = dftImage;
        }
        
        [cache storeImage:result forKey:localName completion:^{
            if (finish) {
                finish(result);
            }
        }];
#endif
    }];
}

//+ (void)jx_downloadWithLink:(NSString *)link finish:(JXVoidBlock_id)finish {
//    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
//    [downloader downloadImageWithURL:JXURLWithStr(link) options:0 progress:NULL completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//        if (image && finished) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (finish) {
//                    finish(image);
//                }
//            });
//        }
//    }];
//}

+ (UIImage *)jx_imageName:(NSString *)imageName frameworkName:(NSString *)frameworkName bundleName:(NSString *)bundleName {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *frameworkPath = [mainBundle pathForResource:frameworkName ofType:@"framework" inDirectory:@"Frameworks"];
    
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:frameworkPath];
    NSString *resourcePath = [frameworkBundle pathForResource:bundleName ofType:@"bundle"];
    
    NSBundle *resourceBundle = [NSBundle bundleWithPath:resourcePath];
    
    return [UIImage imageNamed:imageName inBundle:resourceBundle compatibleWithTraitCollection:nil];
}

+ (UIImage *)jx_imageName:(NSString *)imageName frameworkClass:(Class)frameworkClass bundleName:(NSString *)bundleName {
    NSBundle *frameworkBundle = [NSBundle bundleForClass:frameworkClass];
    NSBundle *resourcesBundle = [NSBundle bundleWithPath:[frameworkBundle pathForResource:bundleName ofType:@"bundle"]];
    return [UIImage imageNamed:imageName inBundle:resourcesBundle compatibleWithTraitCollection:nil];
}

+ (UIImage *)jx_imageWithColor:(UIColor *)color {
    CGSize imageSize = CGSizeMake(1, 1);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)jx_imageWithResource:(NSString *)resource type:(NSString *)type  {
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:resource ofType:type]];
}

- (UIImage*)jx_makeRadius:(CGFloat)radius {
    UIImage *image = self;
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    const CGRect RECT = CGRectMake(0, 0, image.size.width, image.size.height);
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:RECT cornerRadius:radius] addClip];
    // Draw your image
    [image drawInRect:RECT];
    
    // Get the image, here setting the UIImageView image
    //imageView.image
    UIImage* imageNew = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return imageNew;
}

- (NSData *)jx_dataWithCompressionQuality:(CGFloat)compressionQuality maxSize:(NSUInteger)maxSize {
    if (!self || !maxSize) {
        return nil;
    }
    
    CGSize  newSize      = CGSizeZero;
    CGFloat qualityRate  = compressionQuality;
    
    //获取原始图片的大小
    NSData     *originImageData = UIImageJPEGRepresentation(self, 1.0);
    NSUInteger originImageSize  = [originImageData length] / 1024;
    
    if (originImageSize <= maxSize) {
        newSize = self.size;
        
    }else {
        CGFloat rate = ((CGFloat)maxSize)/((CGFloat)originImageSize);
        
        newSize.width  = self.size.width*rate;
        newSize.height = self.size.height*rate;
    }
    
    if (!newSize.width || !newSize.height) {
        return nil;
    }
    
    UIImage *originImage = [self jx_scaleWithWidth:newSize.width height:newSize.height];
    NSData* pictureData = UIImageJPEGRepresentation(originImage,qualityRate);
    
    return pictureData;
}

//- (UIImage *)imageWithColoredBorder:(NSUInteger)borderThickness borderColor:(UIColor *)color withShadow:(BOOL)withShadow
//{
//    size_t shadowThickness = 0;
//    if (withShadow)
//    {
//        shadowThickness = 2;
//    }
//
//    size_t newWidth = self.size.width + 2 * borderThickness + 2 * shadowThickness;
//    size_t newHeight = self.size.height + 2 * borderThickness + 2 * shadowThickness;
//    CGRect imageRect = CGRectMake(borderThickness + shadowThickness, borderThickness + shadowThickness, self.size.width, self.size.height);
//
//    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(ctx);
//    CGContextSetShadow(ctx, CGSizeZero, 4.5f);
//    [color setFill];
//    CGContextFillRect(ctx, CGRectMake(shadowThickness, shadowThickness, newWidth - 2 * shadowThickness, newHeight - 2 * shadowThickness));
//    CGContextRestoreGState(ctx);
//    [self drawInRect:imageRect];
//    //CGContextDrawImage(ctx, imageRect, self.CGImage); //if use this method, image will be filp vertically
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    return img;
//}
//
//- (UIImage *)imageWithTransparentBorder:(NSUInteger)thickness
//{
//    size_t newWidth = self.size.width + 2 * thickness;
//    size_t newHeight = self.size.height + 2 * thickness;
//
//    size_t bitsPerComponent = 8;
//    size_t bitsPerPixel = 32;
//    size_t bytesPerRow = bitsPerPixel * newWidth;
//
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    if(colorSpace == NULL)
//    {
//        NSLog(@"create color space failed");
//        return nil;
//    }
//
//    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
//                                                       newWidth,
//                                                       newHeight,
//                                                       bitsPerComponent,
//                                                       bytesPerRow,
//                                                       colorSpace,
//                                                       kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast);
//    if (bitmapContext == NULL)
//    {
//        NSLog(@"create bitmap context failed");
//        return nil;
//    }
//
//    // acquire image with opaque border
//    CGRect imageRect = CGRectMake(thickness, thickness, self.size.width, self.size.height);
//    CGContextDrawImage(bitmapContext, imageRect, self.CGImage);
//    CGImageRef opaqueBorderImageRef = CGBitmapContextCreateImage(bitmapContext);
//
//    // acquire image with transparent border
//    CGImageRef maskImageRef = CreateMask(CGSizeMake(newWidth, newHeight), thickness);
//    CGImageRef transparentBorderImageRef = CGImageCreateWithMask(opaqueBorderImageRef, maskImageRef);
//    UIImage *transparentBorderImage = [UIImage imageWithCGImage:transparentBorderImageRef];
//
//    // clean up
//    CGColorSpaceRelease(colorSpace);
//    CGContextRelease(bitmapContext);
//    CGImageRelease(opaqueBorderImageRef);
//    CGImageRelease(maskImageRef);
//    CGImageRelease(transparentBorderImageRef);
//
//    return transparentBorderImage;
//}

// 备份
#pragma mark - Public methods


- (UIImage *)jx_scaleWithWidth:(CGFloat)toWidth height:(CGFloat)toHeight {
    CGFloat width=0;
    CGFloat height=0;
    CGFloat x=0;
    CGFloat y=0;
    
    if (self.size.width<toWidth){
        width = toWidth;
        height = self.size.height*(toWidth/self.size.width);
        y = (height - toHeight) / 2.0;
    }else if (self.size.height<toHeight){
        height = toHeight;
        width = self.size.width*(toHeight/self.size.height);
        x = (width - toWidth)/2.0;
    }else if (self.size.width>toWidth){
        width = toWidth;
        height = self.size.height*(toWidth/self.size.width);
        y = (height - toHeight)/2.0;
    }else if (self.size.height>toHeight){
        height = toHeight;
        width = self.size.width*(toHeight/self.size.height);
        x = (width - toWidth)/2.0;
    }else{
        height = toHeight;
        width = toWidth;
    }
    
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGSize subImageSize = CGSizeMake(toWidth, toHeight);
    CGRect subImageRect = CGRectMake(x, y, toWidth, toHeight);
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    UIGraphicsBeginImageContext(subImageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subImageRect, subImageRef);
    UIImage* subImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    return subImage;
}

- (NSString *)exMD5String {
    unsigned char result[16];
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(self)];
    CC_MD5((__bridge const void *)(imageData), (CC_LONG)[imageData length], result);
    NSString *imageHash = [NSString stringWithFormat:
                           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]];
    return imageHash;
}


- (UIImage *)drawText:(NSString *)text font:(UIFont *)font color:(UIColor *)color size:(CGSize)size {
    CGRect textRect;
    CGSize standardSize = [kStringNone jx_sizeWithFont:font width:size.width];
    CGSize textSize = [text jx_sizeWithFont:font width:size.width];
    if (textSize.height > standardSize.height) {
        textRect.origin.x = 0;
        textRect.origin.y = (size.height - textSize.height) / 2.0;
        textRect.size.width = size.width;
        textRect.size.height = textSize.height;
    }else {
        textRect.origin.x = (size.width - textSize.width) / 2.0;
        textRect.origin.y = size.height / 2.0 - textSize.height;
        textRect.size.width = textSize.width;
        textRect.size.height = textSize.height;
    }
    
    
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [color set];
    [text exDrawInRect:textRect
                  font:font
                 color:color
             alignment:NSTextAlignmentLeft];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)exScaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)exStretchCenter {
    return [self stretchableImageWithLeftCapWidth:self.size.width * 0.5
                                     topCapHeight:self.size.height * 0.6];
}

+ (UIImage *)exImageWithBundleName:(NSString *)bundleName imageName:(NSString *)imageName {
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"]];
    return [UIImage imageWithContentsOfFile:[bundle pathForResource:[NSString stringWithFormat:@"images/%@@2x", imageName] ofType:@"png"]];
}

@end
