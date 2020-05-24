//
//  JXUtil.h
//  JXSamples
//
//  Created by 杨建祥 on 16/4/23.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXUtil : NSObject

@end


BOOL JXDataIsEmpty(id obj);


UIBarButtonItem * JXCreateBackItem(id target, SEL action, UIColor *color);
UIBarButtonItem * JXCreateCloseItem(id target, SEL action, UIColor *color);

void MethodSwizzle(Class c, SEL orig, SEL now);

// 备份
JXPayResult JXGetAlipayPayResult(NSDictionary *response);
CGFloat DistanceBetweenPoints(CGPoint point1, CGPoint point2);
CGFloat DegreeBetweenPoints(CGPoint start, CGPoint end);
NSArray * JXAllPropertyFromClass(NSObject* className);
NSString * JXBuildFilepathInDocument(NSString *pathComponent);


void JXAdaptButton(UIButton *button, UIFont *font);
UIImage * JXAdaptImage(UIImage *image);


NSString * JXFileTypeString(JXFileType type);

UIViewController * JXCurrentViewController(void);
UIViewController * JXTopViewController(UIViewController *vc);


NSString * JXScanLibString(JXScanLib lib);
// NSString * JXErrorCodeString(JXErrorCode code);


CGFloat JXAdaptScreenWidth(void);
CGFloat JXAdaptScreenHeight(void);
CGFloat JXAdaptValue(CGFloat d40, CGFloat d47, CGFloat d55);


void JXExitApplication(void);





