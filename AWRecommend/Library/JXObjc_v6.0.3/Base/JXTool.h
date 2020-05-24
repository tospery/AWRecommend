//
//  JXTool.h
//  JXSamples
//
//  Created by 杨建祥 on 16/4/23.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#ifndef JXTool_h
#define JXTool_h

/*******************************************************************************************
 颜色
 ******************************************************************************************/
#define JXColorRGB(r, g, b)                     \
[UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define JXColorRGBA(r, g, b, a)                 \
[UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]
#define JXColorHex(rgbValue)                    \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define JXColorHexA(rgbValue, a)                \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]


/*******************************************************************************************
 日志
 ******************************************************************************************/
#ifdef JXEnableLibCocoaLumberjack
#define JXLogVerbose(fmt, ...)          DDLogVerbose((fmt), ##__VA_ARGS__)
#define JXLogDebug(fmt, ...)            DDLogDebug((fmt), ##__VA_ARGS__)
#define JXLogInfo(fmt, ...)             DDLogInfo((fmt), ##__VA_ARGS__)
#define JXLogWarn(fmt, ...)             DDLogWarn((fmt), ##__VA_ARGS__)
#define JXLogError(fmt, ...)            DDLogError((fmt), ##__VA_ARGS__)
#else

// #if defined(JXEnableEnvDev) || defined(JXEnableEnvHoc)
#if defined(DEBUG)
#define JXLogVerbose(fmt, ...)          NSLog((fmt), ##__VA_ARGS__)
#define JXLogDebug(fmt, ...)            NSLog((fmt), ##__VA_ARGS__)
#else
#define JXLogVerbose(fmt, ...)
#define JXLogDebug(fmt, ...)
#endif

#define JXLogInfo(fmt, ...)             NSLog((fmt), ##__VA_ARGS__)
#define JXLogWarn(fmt, ...)             NSLog((fmt), ##__VA_ARGS__)
#define JXLogError(fmt, ...)            NSLog((fmt), ##__VA_ARGS__)


#endif


/********************************************************************************************************
 提示框
 ********************************************************************************************************/
// Alert
#define JXAlert(title, msg)                                 \
[[[UIAlertView alloc] initWithTitle:(title) message:(msg) delegate:self cancelButtonTitle:kStringOK otherButtonTitles: nil] show]
#define JXAlertParams(title, msg, cancelBtn, otherBtns)     \
[[[UIAlertView alloc] initWithTitle:(title) message:(msg) delegate:self cancelButtonTitle:(cancelBtn) otherButtonTitles:otherBtns, nil] show]
// HUD
#define JXHUDProcessing(msg)                                                    \
[SVProgressHUD jx_configWithInteraction:NO];[SVProgressHUD showWithStatus:(msg)]
#define JXHUDHide()                                                             \
[SVProgressHUD dismiss]
#define JXHUDSuccess(msg, interaction)                                          \
[SVProgressHUD jx_configWithInteraction:interaction];[SVProgressHUD showSuccessWithStatus:(msg)]
#define JXHUDError(msg, interaction)                                            \
[SVProgressHUD jx_configWithInteraction:interaction];[SVProgressHUD showErrorWithStatus:(msg)]
#define JXHUDInfo(msg, interaction)                                             \
[SVProgressHUD jx_configWithInteraction:interaction];[SVProgressHUD showInfoWithStatus:(msg)]

//#define JXHUDProcessing(msg)                                                    \
//[JXHUDManager configHUDWithInteraction:(NO)];[JXHUDManager showWithStatus:(msg)]
//#define [JXDialog hideHUD]                                                             \
//[JXHUDManager dismiss]
//#define JXHUDSuccess(msg, interaction)                                          \
//[JXHUDManager configHUDWithInteraction:(interaction)];[JXHUDManager showSuccessWithStatus:(msg)]
//#define JXHUDError(msg, interaction)                                            \
//[JXHUDManager configHUDWithInteraction:(interaction)];[JXHUDManager showErrorWithStatus:(msg)]
//#define JXHUDInfo(msg, interaction)                                             \
//[JXHUDManager configHUDWithInteraction:(interaction)];[JXHUDManager showInfoWithStatus:(msg)]


// Status
//#define JXStatus(msg)                                                       \
//[JDStatusBarNotification showWithStatus:(msg) dismissAfter:kTimeTips styleName:JDStatusBarStyleDefault]
//#define JXStatusSuccess(msg)                                                \
//[JDStatusBarNotification showWithStatus:(msg) dismissAfter:kTimeTips styleName:JDStatusBarStyleSuccess]
//#define JXStatusFailure(msg)                                                \
//[JDStatusBarNotification showWithStatus:(msg) dismissAfter:kTimeTips styleName:JDStatusBarStyleError]


/********************************************************************************************************
 屏幕尺寸
 ********************************************************************************************************/
#define JXAdaptScreen(x)                            ((x) * JXInstance.screenFactor)
#define JXAdaptFontSize(x)                          ((x) * JXInstance.fontFactor)


#define JXScreenSize                                ([UIScreen mainScreen].bounds.size)
#define JXScreenWidth                               ([UIScreen mainScreen].bounds.size.width)
#define JXScreenHeight                              ([UIScreen mainScreen].bounds.size.height)
//#define JXScreenScale(x)                            (round((x) / 320.0f * JXScreenWidth))  // 使用640x1136的nib
//#define JXScreenScale(x)                            ((x) / 320.0f * JXScreenWidth)  // 使用640x1136的nib
#define JXScreenScale(x)                            ((x) * JXInstance.screenFactor)
#define JXFontSize(x)                               ((x) * JXInstance.fontFactor)

// JXInstance.screenFactor

#define JXScreenFactor                              (JXScreenWidth/375.0f)          // 使用750x1334的设计图

#define JXFrameWidth                                ([UIScreen mainScreen ].applicationFrame.size.width)
#define JXFrameHeight                               ([UIScreen mainScreen ].applicationFrame.size.height)

/*******************************************************************************************
 本地化
 ******************************************************************************************/
#ifdef JXEnableFuncLocalize
#define JXT(local, display)                         local
#else
#define JXT(local, display)                         display
#endif


/********************************************************************************************************
 设备与系统
 ********************************************************************************************************/
#define JXDeviceIsPad                       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define JXDeviceIsPhone                     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//#define JXiOSVersionGreaterThanOrEqual(x)   ([[[UIDevice currentDevice] systemVersion] floatValue] >= (x))
#define JXiOSVersionGreaterThanOrEqual(x)   ([[UIDevice currentDevice].systemVersion compare:(x) options:NSNumericSearch] >= NSOrderedSame)
#define JXRandomNumber(x, y)                ((NSInteger)((x) + (arc4random() % ((y) - (x) + 1))))
#define JXDeviceIsPortrait                  (UIDeviceOrientationPortrait == [UIDevice currentDevice].orientation)

/*******************************************************************************************
 便捷
 ******************************************************************************************/
#define JXURLWithStr(x)                     ([NSURL jx_URLWithString:(x)])
#define JXStrWithInt(x)                     ([NSString stringWithFormat:@"%llu", ((unsigned long long)x)])
#define JXStrWithFlt(x)                     ([NSString stringWithFormat:@"%.2f", (x)])
#define JXStrWithFmt(fmt, ...)              ([NSString stringWithFormat:(fmt), ##__VA_ARGS__])

#define JXStrWithDft(str, dft)              ((str).length == 0 ? (dft) : (str))
#define JXIntWithDft(i, dft)                (i == 0 ? (dft) : (i))
#define JXArrFirst(arr, dft)                ((arr).count == 0 ? (dft) : (arr)[0])
#define JXArrValue(arr, dft)                ((arr).count != 0 ? (arr) : (dft))
#define JXArrEmpty(arr, dft)                (((NSArray *)arr).count != 0 ? (arr) : (dft))
#define JXArrIndex(arr, index, dft)         ((arr).count <= 0 ? (dft) : (arr)[(index)])
#define JXArrTable(arr)                     ((((NSArray *)arr).count == 0) ? nil : @[(arr)])

#define JXObjWithDft(obj, dft)              ((obj) != nil ? (obj) : (dft))

#define JXArrWithDft(arr, dft)              ((arr) != nil ? (arr) : (dft))


#define JXArrDataSource(arr)                ((((NSArray *)arr).count == 0) ? nil : @[(arr)])

#define JXContextMR                         ([NSManagedObjectContext MR_defaultContext])
#define JXContextAD                         ([(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext])

// YJX_TODO
#define JXFont(x)                           ([UIFont jx_systemFontOfSize:(x)])
#define JXFontBold(x)                       ([UIFont jx_boldSystemFontOfSize:(x)])

//#define JXFont(x)                           ([UIFont systemFontOfSize:(x)])


#define JXImageWithName(x)                  ([UIImage imageNamed:(x)])
#define JXImageWithColor(x)                 ([UIImage jx_imageWithColor:(x)])

/*******************************************************************************************
 其他
 ******************************************************************************************/
#define JXAppDelegate                       ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define JXAppWindow                         ([[UIApplication sharedApplication].delegate window])
#define JXDegreeToRadian(x)                 (M_PI * (x) / 180.0)
#define JXTerminate(msg)                    NSAssert(NO, @"%@%@", kStringErrorWithGuillemet, msg)
#define JXCheck(arg, ret)                               \
if (JXDataIsEmpty(arg)) {                          \
JXLogError(kStringArgumentError);                       \
return ret;                                             \
}
#define JXCheckWithoutRet(arg)                          \
if (JXDataIsEmpty(arg)) {                          \
JXLogError(kStringArgumentError);                       \
return;                                                 \
}

#define JXNil2Val(obj, val)                  (((obj) == nil) ? val : (obj))

#define JXArgErrSingal                  ([RACSignal error:[NSError jx_errorWithCode:JXErrorCodeArgumentError]])

#define JXExchangeMethod(oldSel, newSel)  ([[self class] jx_exchangeMethod:(oldSel) withNewMethod:(newSel)])


// #define JXAPIDeprecated         NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "JXObjc -> 该接口已过期！！！")
#define JXAPIDeprecated601      NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "JXObjc_v6.0.1 -> 该接口已过期！！！")

#endif /* JXTool_h */







