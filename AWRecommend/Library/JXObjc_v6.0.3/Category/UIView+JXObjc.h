//
//  UIView+JXObjc.h
//  JXSamples
//
//  Created by 杨建祥 on 16/4/23.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JXObjc)
@property (nonatomic, assign) CGFloat jx_x;
@property (nonatomic, assign) CGFloat jx_y;
@property (nonatomic, assign) CGFloat jx_width;
@property (nonatomic, assign) CGFloat jx_height;
@property (nonatomic, assign) CGSize jx_size;

- (UIView *)jx_viewWithIdentifier:(NSString *)identifier;

- (UIView *)jx_circleWithColor:(UIColor *)color border:(CGFloat)border;
- (UIView *)jx_borderWithColor:(UIColor *)color width:(CGFloat)width radius:(CGFloat)radius;
- (UIView *)jx_corner:(UIRectCorner)corner radius:(CGFloat)radius;

- (void)jx_addGradientLayerWithColors:(NSArray *)cgColorArray;
- (void)jx_addGradientLayerWithColors:(NSArray *)cgColorArray locations:(NSArray *)floatNumArray startPoint:(CGPoint )startPoint endPoint:(CGPoint)endPoint;
- (void)jx_addTapGestureWithTarget:(id)target action:(SEL)action;
- (void)jx_addLongTapGestureWithTarget:(id)target action:(SEL)action;


// backup
- (void)exCircleWithColor:(UIColor *)color border:(CGFloat)border;

/**
 *  不建议在Cell中使用border！！！
 *
 *  @param color  颜色
 *  @param width  宽度
 *  @param radius 角度
 *
 *  @return 结果
 */
// - (UIView *)exBorderWithColor:(UIColor *)color width:(CGFloat)width radius:(CGFloat)radius;

- (void)exRotateWithDuration:(CFTimeInterval)duration repeat:(BOOL)repeat;

- (void)exRotateWithAngle:(CGFloat)angle duration:(CFTimeInterval)duration;

- (void)exStopRotation;

- (void)addTapGestureForTarget:(id)target action:(SEL)action;

- (NSLayoutConstraint *)exMakeLeading:(CGFloat)leading relatedView:(UIView *)relatedView;
- (NSLayoutConstraint *)exMakeTop:(CGFloat)top relatedView:(UIView *)relatedView;
- (NSLayoutConstraint *)exMakeTrailing:(CGFloat)trailing relatedView:(UIView *)relatedView;
- (NSLayoutConstraint *)exMakeBottom:(CGFloat)bottom relatedView:(UIView *)relatedView;
- (NSArray *)exMakeConstraintsEdges;

- (NSLayoutConstraint *)exMakeCenterX:(CGFloat)centerX;
- (NSLayoutConstraint *)exMakeCenterY:(CGFloat)centerY;
- (NSArray *)exMakeConstraintsCenter;

- (NSLayoutConstraint *)exMakeWidth:(CGFloat)width;
- (NSLayoutConstraint *)exMakeHeight:(CGFloat)height;
- (NSArray *)exMakeConstraintsSize:(CGSize)size;

//- (NSLayoutConstraint *)exAddConstraintWithLeading:(CGFloat)leading
//                                       relatedView:(UIView *)relatedView
//                                          priority:(UILayoutPriority)priority;
//- (NSLayoutConstraint *)exAddConstraintWithTop:(CGFloat)top
//                                   relatedView:(UIView *)relatedView
//                                      priority:(UILayoutPriority)priority;
//- (NSLayoutConstraint *)exAddConstraintWithTrailing:(CGFloat)trailing
//                                        relatedView:(UIView *)relatedView
//                                           priority:(UILayoutPriority)priority;
//- (NSLayoutConstraint *)exAddConstraintWithBottom:(CGFloat)bottom
//                                      relatedView:(UIView *)relatedView
//                                         priority:(UILayoutPriority)priority;
//- (NSLayoutConstraint *)exAddConstraintWithWidth:(CGFloat)width
//                                        priority:(UILayoutPriority)priority;
//- (NSLayoutConstraint *)exAddConstraintWithHeight:(CGFloat)height
//                                         priority:(UILayoutPriority)priority;

@end
