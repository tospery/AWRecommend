//
//  UIView+JXObjc.m
//  JXSamples
//
//  Created by 杨建祥 on 16/4/23.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "UIView+JXObjc.h"

#define UIViewJXObjcRotationAnimationKey            (@"UIViewJXObjcRotationAnimationKey")

@implementation UIView (JXObjc)
- (UIView *)jx_viewWithIdentifier:(NSString *)identifier {
    NSArray *subviews = self.subviews;
    UIView *ret = nil;
    for (UIView *view in subviews) {
        if ([identifier isEqualToString:view.jxIdentifier]) {
            ret = view;
            break;
        }
    }
    return ret;
}

// YJX_LIB 推荐使用圆角背景图
- (UIView *)jx_circleWithColor:(UIColor *)color border:(CGFloat)border {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width / 2.0;
    self.layer.borderWidth = border;
    self.layer.borderColor = color.CGColor;
    return self;
}

- (UIView *)jx_borderWithColor:(UIColor *)color width:(CGFloat)width radius:(CGFloat)radius{
    self.layer.masksToBounds = YES;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radius;
    return self;
}

- (UIView *)jx_corner:(UIRectCorner)corner radius:(CGFloat)radius {
    self.layer.masksToBounds = YES;
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)].CGPath;
    self.layer.mask = layer;
    return self;
}

- (void)jx_addGradientLayerWithColors:(NSArray *)cgColorArray{
    [self jx_addGradientLayerWithColors:cgColorArray locations:nil startPoint:CGPointMake(0.0, 0.5) endPoint:CGPointMake(1.0, 0.5)];
}

- (void)jx_addGradientLayerWithColors:(NSArray *)cgColorArray locations:(NSArray *)floatNumArray startPoint:(CGPoint )startPoint endPoint:(CGPoint)endPoint{
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.bounds;
    if (cgColorArray && [cgColorArray count] > 0) {
        layer.colors = cgColorArray;
    }else{
        return;
    }
    if (floatNumArray && [floatNumArray count] == [cgColorArray count]) {
        layer.locations = floatNumArray;
    }
    layer.startPoint = startPoint;
    layer.endPoint = endPoint;
    [self.layer addSublayer:layer];
}

- (void)jx_addTapGestureWithTarget:(id)target action:(SEL)action {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)jx_addLongTapGestureWithTarget:(id)target action:(SEL)action {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:longTap];
}

- (CGFloat)jx_x {
    return CGRectGetMinX(self.frame);
}

- (void)setJx_x:(CGFloat)x {
    self.frame = CGRectMake(x, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (CGFloat)jx_y {
    return CGRectGetMinY(self.frame);
}

- (void)setJx_y:(CGFloat)y {
    self.frame = CGRectMake(CGRectGetMinX(self.frame), y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (CGFloat)jx_width {
    return CGRectGetWidth(self.frame);
}

- (void)setJx_width:(CGFloat)width {
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), width, CGRectGetHeight(self.frame));
}

- (CGFloat)jx_height {
    return CGRectGetHeight(self.frame);
}

- (void)setJx_height:(CGFloat)height {
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), height);
}

- (CGSize)jx_size {
    return self.frame.size;
}

- (void)setJx_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

// backup

- (void)exCircleWithColor:(UIColor *)color border:(CGFloat)border {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width / 2.0;
    self.layer.borderWidth = border;
    self.layer.borderColor = color.CGColor;
}

//- (UIView *)exBorderWithColor:(UIColor *)color width:(CGFloat)width radius:(CGFloat)radius{
//    self.layer.masksToBounds = YES;
//    self.layer.borderColor = color.CGColor;
//    self.layer.borderWidth = width;
//    self.layer.cornerRadius = radius;
//    return self;
//}

- (void)exRotateWithDuration:(CFTimeInterval)duration repeat:(BOOL)repeat {
    //    POPBasicAnimation *anim = [self.layer pop_animationForKey:kJXAnimationPopRotation];
    //    if (!anim) {
    //        anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    //        // anim.toValue = @(M_PI * 2.0);
    //        // anim.fromValue = @(0);
    //        anim.duration = duration;
    //        anim.repeatForever = repeat;
    //        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    //        [self.layer pop_addAnimation:anim forKey:kJXAnimationPopRotation];
    //    }
    //    anim.toValue = @(M_PI * 2.0);
    
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = duration;
    //rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat ? HUGE_VALF : 1;
    rotationAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:rotationAnimation forKey:UIViewJXObjcRotationAnimationKey];
}

- (void)exRotateWithAngle:(CGFloat)angle duration:(CFTimeInterval)duration{
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);;
    [UIView animateWithDuration:duration animations:^{
        self.transform = transform;
    } completion:NULL];
}

- (void)exStopRotation {
    // [self.layer pop_removeAnimationForKey:kJXAnimationPopRotation];
    
    [self.layer removeAnimationForKey:UIViewJXObjcRotationAnimationKey];
}

- (void)addTapGestureForTarget:(id)target action:(SEL)action {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tapGestureRecognizer];
}

//- (void)addConstraintsForFillSuperview {
//    if (!self.superview) {
//        return;
//    }
//
//    UIView *thisView = self;
//    UIView *container = self.superview;
//
//    //    static NSMutableArray *selfConstraints;
//    //    if (selfConstraints) {
//    //        [container removeConstraints:selfConstraints];
//    //        [selfConstraints removeAllObjects];
//    //    }else {
//    //        selfConstraints = [NSMutableArray array];
//    //    }
//
//    NSMutableArray *constraints = [NSMutableArray array];
//    // Leading
//    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:thisView
//                                                                         attribute:NSLayoutAttributeLeading
//                                                                         relatedBy:NSLayoutRelationEqual
//                                                                            toItem:container
//                                                                         attribute:NSLayoutAttributeLeading
//                                                                        multiplier:1
//                                                                          constant:0];
//    [constraints addObject:leadingConstraint];
//    // Top
//    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:thisView
//                                                                     attribute:NSLayoutAttributeTop
//                                                                     relatedBy:NSLayoutRelationEqual
//                                                                        toItem:container
//                                                                     attribute:NSLayoutAttributeTop
//                                                                    multiplier:1
//                                                                      constant:0];
//    [constraints addObject:topConstraint];
//    // Trailing
//    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:thisView
//                                                                          attribute:NSLayoutAttributeTrailing
//                                                                          relatedBy:NSLayoutRelationEqual
//                                                                             toItem:container
//                                                                          attribute:NSLayoutAttributeTrailing
//                                                                         multiplier:1
//                                                                           constant:0];
//    [constraints addObject:trailingConstraint];
//    // Bottom
//    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:thisView
//                                                                        attribute:NSLayoutAttributeBottom
//                                                                        relatedBy:NSLayoutRelationEqual
//                                                                           toItem:container
//                                                                        attribute:NSLayoutAttributeBottom
//                                                                       multiplier:1
//                                                                         constant:0];
//    [constraints addObject:bottomConstraint];
//
//    [container addConstraints:constraints];
//}
//

- (NSArray *)exMakeConstraintsEdges {
    if (!self.superview) {
        return nil;
    }
    
    NSLayoutConstraint *leadingConstraint = [self exMakeLeading:0 relatedView:self.superview];
    NSLayoutConstraint *topConstraint = [self exMakeTop:0 relatedView:self.superview];
    NSLayoutConstraint *trailingConstraint = [self exMakeTrailing:0 relatedView:self.superview];
    NSLayoutConstraint *bottomConstraint = [self exMakeBottom:0 relatedView:self.superview];
    
    return @[leadingConstraint, topConstraint, trailingConstraint, bottomConstraint];
}

- (NSLayoutConstraint *)exMakeLeading:(CGFloat)leading relatedView:(UIView *)relatedView {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:relatedView
                                                                  attribute:NSLayoutAttributeLeading
                                                                 multiplier:1.0f
                                                                   constant:leading];
    [self.superview addConstraint:constraint];
    return constraint;
}

- (NSLayoutConstraint *)exMakeTop:(CGFloat)top relatedView:(UIView *)relatedView {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:relatedView
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0f
                                                                   constant:top];
    [self.superview addConstraint:constraint];
    return constraint;
}

- (NSLayoutConstraint *)exMakeTrailing:(CGFloat)trailing relatedView:(UIView *)relatedView {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeTrailing
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:relatedView
                                                                  attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0f
                                                                   constant:trailing];
    [self.superview addConstraint:constraint];
    return constraint;
}

- (NSLayoutConstraint *)exMakeBottom:(CGFloat)bottom relatedView:(UIView *)relatedView {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:relatedView
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0f
                                                                   constant:bottom];
    [self.superview addConstraint:constraint];
    return constraint;
}

- (NSArray *)exMakeConstraintsCenter {
    if (!self.superview) {
        return nil;
    }
    
    NSLayoutConstraint *xConstraint = [self exMakeCenterX:0];
    NSLayoutConstraint *yConstraint = [self exMakeCenterY:0];
    
    return @[xConstraint, yConstraint];
}

- (NSLayoutConstraint *)exMakeCenterX:(CGFloat)centerX {
    if (!self.superview) {
        return nil;
    }
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.superview
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0f
                                                                   constant:centerX];
    [self.superview addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)exMakeCenterY:(CGFloat)centerY {
    if (!self.superview) {
        return nil;
    }
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.superview
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1.0f
                                                                   constant:centerY];
    [self.superview addConstraint:constraint];
    
    return constraint;
}

- (NSArray *)exMakeConstraintsSize:(CGSize)size {
    NSLayoutConstraint *widthConstraint = [self exMakeWidth:size.width];
    NSLayoutConstraint *heightConstraint = [self exMakeHeight:size.height];
    
    return @[widthConstraint, heightConstraint];
}

- (NSLayoutConstraint *)exMakeWidth:(CGFloat)width {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:width];
    [self addConstraint:constraint];
    return constraint;
}

- (NSLayoutConstraint *)exMakeHeight:(CGFloat)height {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:height];
    [self addConstraint:constraint];
    return constraint;
}


//- (NSLayoutConstraint *)exAddConstraintWithLeading:(CGFloat)leading
//                                       relatedView:(UIView *)relatedView
//                                          priority:(UILayoutPriority)priority {
//    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
//                                                                  attribute:NSLayoutAttributeLeading
//                                                                  relatedBy:NSLayoutRelationEqual
//                                                                     toItem:relatedView
//                                                                  attribute:NSLayoutAttributeLeading
//                                                                 multiplier:1.0f
//                                                                   constant:leading];
//    constraint.priority = priority;
//    [relatedView addConstraint:constraint];
//    return constraint;
//}
//
//- (NSLayoutConstraint *)exAddConstraintWithTop:(CGFloat)top
//                                   relatedView:(UIView *)relatedView
//                                      priority:(UILayoutPriority)priority {
//    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
//                                                                  attribute:NSLayoutAttributeTop
//                                                                  relatedBy:NSLayoutRelationEqual
//                                                                     toItem:relatedView
//                                                                  attribute:NSLayoutAttributeTop
//                                                                 multiplier:1.0f
//                                                                   constant:top];
//    constraint.priority = priority;
//    [relatedView addConstraint:constraint];
//    return constraint;
//}
//
//- (NSLayoutConstraint *)exAddConstraintWithTrailing:(CGFloat)trailing
//                                        relatedView:(UIView *)relatedView
//                                           priority:(UILayoutPriority)priority {
//    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
//                                                                  attribute:NSLayoutAttributeTrailing
//                                                                  relatedBy:NSLayoutRelationEqual
//                                                                     toItem:relatedView
//                                                                  attribute:NSLayoutAttributeTrailing
//                                                                 multiplier:1.0f
//                                                                   constant:trailing];
//    constraint.priority = priority;
//    [relatedView addConstraint:constraint];
//    return constraint;
//}
//
//- (NSLayoutConstraint *)exAddConstraintWithBottom:(CGFloat)bottom
//                                      relatedView:(UIView *)relatedView
//                                         priority:(UILayoutPriority)priority {
//    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
//                                                                  attribute:NSLayoutAttributeBottom
//                                                                  relatedBy:NSLayoutRelationEqual
//                                                                     toItem:relatedView
//                                                                  attribute:NSLayoutAttributeBottom
//                                                                 multiplier:1.0f
//                                                                   constant:bottom];
//    constraint.priority = priority;
//    [relatedView addConstraint:constraint];
//    return constraint;
//}
//
//- (NSLayoutConstraint *)exAddConstraintWithCenterX:(CGFloat)centerX
//                                       relatedView:(UIView *)relatedView
//                                          priority:(UILayoutPriority)priority {
//    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
//                                                                  attribute:NSLayoutAttributeCenterX
//                                                                  relatedBy:NSLayoutRelationEqual
//                                                                     toItem:relatedView
//                                                                  attribute:NSLayoutAttributeCenterX
//                                                                 multiplier:1.0f
//                                                                   constant:centerX];
//    constraint.priority = priority;
//    [relatedView addConstraint:constraint];
//    return constraint;
//}
//
//- (NSLayoutConstraint *)exAddConstraintWithCenterY:(CGFloat)centerY
//                                       relatedView:(UIView *)relatedView
//                                          priority:(UILayoutPriority)priority {
//    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
//                                                                  attribute:NSLayoutAttributeCenterY
//                                                                  relatedBy:NSLayoutRelationEqual
//                                                                     toItem:relatedView
//                                                                  attribute:NSLayoutAttributeCenterY
//                                                                 multiplier:1.0f
//                                                                   constant:centerY];
//    constraint.priority = priority;
//    [relatedView addConstraint:constraint];
//    return constraint;
//}
//
//- (NSLayoutConstraint *)exAddConstraintWithWidth:(CGFloat)width
//                                        priority:(UILayoutPriority)priority {
//    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
//                                                                  attribute:NSLayoutAttributeWidth
//                                                                  relatedBy:NSLayoutRelationEqual
//                                                                     toItem:nil
//                                                                  attribute:NSLayoutAttributeNotAnAttribute
//                                                                 multiplier:1.0f
//                                                                   constant:width];
//    constraint.priority = priority;
//    [self addConstraint:constraint];
//    return constraint;
//}
//
//- (NSLayoutConstraint *)exAddConstraintWithHeight:(CGFloat)height
//                                         priority:(UILayoutPriority)priority {
//    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
//                                                                  attribute:NSLayoutAttributeHeight
//                                                                  relatedBy:NSLayoutRelationEqual
//                                                                     toItem:nil
//                                                                  attribute:NSLayoutAttributeNotAnAttribute
//                                                                 multiplier:1.0f
//                                                                   constant:height];
//    constraint.priority = priority;
//    [self addConstraint:constraint];
//    return constraint;
//}

@end
