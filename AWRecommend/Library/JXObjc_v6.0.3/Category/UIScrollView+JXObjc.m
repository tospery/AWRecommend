//
//  UIScrollView+JXObjc.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "UIScrollView+JXObjc.h"

@implementation UIScrollView (JXObjc)
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self.nextResponder touchesBegan:touches withEvent:event];
//    [super touchesBegan:touches withEvent:event];
//}
//
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self.nextResponder touchesMoved:touches withEvent:event];
//    [super touchesMoved:touches withEvent:event];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self.nextResponder touchesEnded:touches withEvent:event];
//    [super touchesEnded:touches withEvent:event];
//}

- (void)setRequestMode:(JXRequestMode)requestMode {
    objc_setAssociatedObject(self, @selector(requestMode), @(requestMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JXRequestMode)requestMode {
    return [objc_getAssociatedObject(self, @selector(requestMode)) integerValue];
}

- (void)setRequestError:(NSError *)requestError {
    objc_setAssociatedObject(self, @selector(requestError), requestError, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSError *)requestError {
    return objc_getAssociatedObject(self, @selector(requestError));
}

- (void)setCellName:(NSString *)cellName {
    objc_setAssociatedObject(self, @selector(cellName), cellName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)cellName {
    return objc_getAssociatedObject(self, @selector(cellName));
}

@end




