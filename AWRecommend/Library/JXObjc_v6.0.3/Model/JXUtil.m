//
//  JXUtil.m
//  JXSamples
//
//  Created by 杨建祥 on 16/4/23.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXUtil.h"

@implementation JXUtil

@end


BOOL JXDataIsEmpty(id obj) {
    if (!obj) {
        return YES;
    }
    
    if ([obj isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([obj isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)obj;
        return array.count == 0 ? YES : NO;
    }
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = (NSDictionary *)obj;
        return dictionary.count == 0 ? YES : NO;
    }
    
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *string = (NSString *)obj;
        return string.length == 0 ? YES : NO;
    }
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)obj;
        return [number isEqualToNumber:@(0)];
    }
    
    return NO;
}

UIBarButtonItem * JXCreateBackItem(id target, SEL action, UIColor *color) {
    return [UIBarButtonItem jx_barItemWithType:buttonBackType
                                         color:color
                                        target:target
                                        action:action];
}


UIBarButtonItem * JXCreateCloseItem(id target, SEL action, UIColor *color) {
    return [UIBarButtonItem jx_barItemWithType:buttonCloseType
                                         color:color
                                        target:target
                                        action:action];
}


void MethodSwizzle(Class c, SEL orig, SEL now) {
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, now);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, now, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

// 备份
CGFloat DistanceBetweenPoints(CGPoint point1, CGPoint point2) {
    CGFloat distance2 = ABS((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));
    return sqrtf(distance2);
}

CGFloat DegreeBetweenPoints(CGPoint start, CGPoint end) {
    CGFloat tan = atan(ABS((end.y - start.y) / (end.x - start.x))) * 180 / M_PI;
    if (end.x > start.x && end.y > start.y) {
        return -tan;
    }else if (end.x > start.x && end.y < start.y) {
        return tan;
    }else if (end.x < start.x && end.y > start.y) {
        return tan - 180;
    }else {
        return 180 - tan;
    }
}

JXPayResult JXGetAlipayPayResult(NSDictionary *response) {
    NSString *status = [response objectForKey:@"resultStatus"];
    if ([status isEqualToString:@"9000"]) {
        return JXPayResultSuccess;
    }else if ([status isEqualToString:@"6001"] || [status isEqualToString:@"4000"]) {
        return JXPayResultCanceled;
    }else {
        return JXPayResultFailure;
    }
}

NSArray * JXAllPropertyFromClass(NSObject* className) {
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([className class], &propertyCount);
    
    NSMutableArray * propertyNames = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    
    return [NSArray arrayWithArray:propertyNames];
}


NSString * JXBuildFilepathInDocument(NSString *pathComponent) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths[0] stringByAppendingPathComponent:pathComponent];
}


//if (MCInstance.isSmallDevice) {
//    UIImage *image = [btn imageForState:UIControlStateNormal];
//    CGSize size = image.size;
//    image = [image scaleToSize:CGSizeMake(size.width * 0.85, size.height * 0.85) usingMode:NYXResizeModeAspectFill];
//    [btn setImage:image forState:UIControlStateNormal];
//}

UIImage * JXAdaptImage(UIImage *image) {
    if ([JXDevice sharedInstance].isSmall) {
        CGSize size = image.size;
        return [image scaleToSize:CGSizeMake(size.width * 0.85, size.height * 0.85) usingMode:NYXResizeModeAspectFill];
    }
    return image;
}

void JXAdaptButton(UIButton *button, UIFont *font) {
    UIImage *image = [button imageForState:UIControlStateNormal];
    if (image) {
        [button setImage:JXAdaptImage(image) forState:UIControlStateNormal];
    }
    image = [button imageForState:UIControlStateSelected];
    if (image) {
        [button setImage:JXAdaptImage(image) forState:UIControlStateSelected];
    }
    image = [button imageForState:UIControlStateHighlighted];
    if (image) {
        [button setImage:JXAdaptImage(image) forState:UIControlStateHighlighted];
    }
    image = [button imageForState:UIControlStateDisabled];
    if (image) {
        [button setImage:JXAdaptImage(image) forState:UIControlStateDisabled];
    }
    if (font) {
        button.titleLabel.font = font;
    }
}

void JXAdaptImageView(UIImageView *imageView) {
    UIImage *image = imageView.image;
    if (image) {
        imageView.image = JXAdaptImage(image);
    }
}


NSString * JXFileTypeString(JXFileType type) {
    NSString *ret = nil;
    switch (type) {
        case JXFileTypeImagePNG:
            ret = @"image/png";
            break;
        case JXFileTypeImageJPEG:
            ret = @"image/jpeg";
            break;
        default:
            break;
    }
    return ret;
}


UIViewController * JXCurrentViewController(void) {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = JXTopViewController(rootVC);
    while (currentVC.presentedViewController) {
        currentVC = JXTopViewController(currentVC.presentedViewController);
    }
    return currentVC;
}

UIViewController * JXTopViewController(UIViewController *vc) {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return JXTopViewController([(UINavigationController *)vc topViewController]);
    }
    
    if ([vc isKindOfClass:[UITabBarController class]]) {
        return JXTopViewController([(UITabBarController *)vc selectedViewController]);
    }
    
    return vc;
}

NSString * JXScanLibString(JXScanLib lib) {
    NSArray *strs = @[@"Native", @"ZXing", @"ZBar"];
    if (lib < 1 || lib > strs.count) {
        return nil;
    }
    return strs[lib - 1];
}

CGFloat JXAdaptValue(CGFloat d40, CGFloat d47, CGFloat d55) {
    CGFloat ret = d40;
    
    JXDeviceInch inch = [JXDevice sharedInstance].inch;
    if (JXDeviceInch47 == inch) {
        ret = d47;
    }else if (JXDeviceInch55 == inch) {
        ret = d55;
    }
    
    return ret;
}

CGFloat JXAdaptScreenWidth(void) {
    static CGFloat width = 0.0f;
    if (0 == width) {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    return width;
}

CGFloat JXAdaptScreenHeight(void) {
    static CGFloat height = 0.0f;
    if (0 == height) {
        height = [UIScreen mainScreen].bounds.size.height;
    }
    return height;
}

void JXExitApplication(void) {
    [JXAppDelegate applicationWillTerminate:[UIApplication sharedApplication]];
    
    UIWindow *window = JXAppWindow;
    [UIView animateWithDuration:0.6f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(JXScreenWidth / 2.0, JXScreenHeight / 2.0, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}



//NSString * JXErrorCodeString(JXErrorCode code) {
//    return nil;
//}









