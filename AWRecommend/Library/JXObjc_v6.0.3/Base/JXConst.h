//
//  JXConst.h
//  JXSamples
//
//  Created by 杨建祥 on 16/4/23.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#ifndef JXConst_h
#define JXConst_h


//JXHTTPRequestContentTypeNone,                                               // 没有content，用于Get请求方式
//JXHTTPRequestContentTypeFormURLEncoded,                                     // x-www-form-urlencoded
//JXHTTPRequestContentTypeFormDataText,                                       // form-data -> text
//JXHTTPRequestContentTypeFormDataFile,                                       // form-data -> file
//JXHTTPRequestContentTypeRawText,                                            // text/plain
//JXHTTPRequestContentTypeRawJSON,                                            // application/json
//JXHTTPRequestContentTypeRawJavascript,                                      // application/javascript
//JXHTTPRequestContentTypeRawXMLApp,                                          // application/xml
//JXHTTPRequestContentTypeRawXMLText,                                         // text/xml
//JXHTTPRequestContentTypeRawHTML,                                            // text/html
//JXHTTPRequestContentTypeBinary

#define kJXHTTPParamURL                             (@"kJXHTTPParamURL")
#define kJXHTTPParamHeader                          (@"kJXHTTPParamHeader")
#define kJXHTTPParamBodyFormURL                     (@"kJXHTTPParamBodyFormURL")
#define kJXHTTPParamBodyFormData                    (@"kJXHTTPParamBodyFormData")
#define kJXHTTPParamBodyRawJSON                     (@"kJXHTTPParamBodyRawJSON")
#define kJXHTTPParamBodyRawXML                      (@"kJXHTTPParamBodyRawXML")


/********************************************************************************************************
 数值常量
 ********************************************************************************************************/
#define kJXStdStsBarHeight                              (20.0f)
#define kJXStdNavBarHeight                              (44.0f)
#define kJXStdTabBarHeight                              (49.0f)
#define kJXStdCellHeight                                (JXScreenScale(44.0f))
#define kJXStdPadding                                   (JXScreenScale(8.0f))
#define kJXStdKeyboardDistance                          (8.0f)
#define kJXStdPageHeight                                (37.0f)

//// 边框
//#define kJXBorderMin                                (0.1)
//#define kJXBorderSmall                              (1.2)
//#define kJXBorderMiddle                             (2.0)
//#define kJXBorderLarge                              (4.0)
//#define kJXBorderMax                                (8.0)
//// 角度
//#define kJXRadiusMin                                (2.0)
//#define kJXRadiusSmall                              (4.0)
//#define kJXRadiusMiddle                             (8.0)
//#define kJXRadiusLarge                              (12.0)
//#define kJXRadiusMax                                (20.0)


/********************************************************************************************************
 动画
 ********************************************************************************************************/
#define kJXAnimKeyboard                             (@"kJXAnimKeyboard")
#define kJXAnimRootController                       (@"kJXAnimRootController")
#define kJXAnimPopRotation                          (@"kJXAnimPopRotation")


/********************************************************************************************************
 配置参数的key
 ********************************************************************************************************/
#define kJXKeyTranslucent                           (@"kJXKeyTranslucent")
#define kJXKeyBarTintColor                          (@"kJXKeyBarTintColor")
#define kJXKeyTintColor                             (@"kJXKeyTintColor")

#define kJXKeyTitleText                             (@"kJXKeyTitleText")

#define kJXKeyTitleColor                            (@"kJXKeyTitleColor")
#define kJXKeyTitleColorSelected                    (@"kJXKeyTitleColorSelected")
#define kJXKeyTitleColorDisabled                    (@"kJXKeyTitleColorDisabled")

#define kJXKeyTitleFont                             (@"kJXKeyTitleFont")
#define kJXKeyTitleFontSelected                     (@"kJXKeyTitleFontSelected")
#define kJXKeyTitleFontDisabled                     (@"kJXKeyTitleFontDisabled")

#define kJXKeyImage                                 (@"kJXKeyImage")
#define kJXKeyImageSelected                         (@"kJXKeyImageSelected")
#define kJXKeyImageBackground                       (@"kJXKeyImageBackground")



/********************************************************************************************************
 默认存储
 ********************************************************************************************************/
//#define kJXUdVersion                                        (@"kJXUdVersion")
#define kJXUdBaseURLString                                  (@"kJXUdBaseURLString")
#define kJXUdAccount                                        (@"kJXUdAccount")
#define kJXUdPassword                                       (@"kJXUdPassword")
#define kJXUdEnvType                                        (@"kJXUdEnvType")
//#define kJXUdAPIToken                                       (@"kJXUdAPIToken")
//#define kJXUdUserToken                                      (@"kJXUdUserToken")


/********************************************************************************************************
 table标识符
 ********************************************************************************************************/
// YJX_LIB 使用自定义类
//#define kJXIdentifierCellDefault                        (@"kJXIdentifierCellDefault")
//#define kJXIdentifierCellValue1                         (@"kJXIdentifierCellValue1")
//#define kJXIdentifierCellCustom1                        (@"kJXIdentifierCellCustom1")
//#define kJXIdentifierHeaderFooter                       (@"kJXIdentifierHeaderFooter")


#define kJXHTTPTimeout                                      (10)
//#define kJXHTTPRetryTimes                                   (2)
//#define kJXHTTPRetryDelay                                   (1)

// 备份
/********************************************************************************************************
 格式
 ********************************************************************************************************/
// 日期格式
#define kJXFormatDatetimeStyle1                     (@"YYYY-MM-dd HH:mm:ss")
#define kJXFormatDatetimeStyle2                     (@"YYYY-MM-dd HH:mm")
#define kJXFormatDatetimeStyle3                     (@"YYYY-MM-dd HH:mm:ss.SSS")
#define kJXFormatDatetimeStyle4                     (@"YYYY年MM月dd日 HH:mm")
#define kJXFormatDateStyle1                         (@"YYYY-MM-dd")
#define kJXFormatDateStyle2                         (@"YYYY年MM月dd日")
#define kJXFormatDateStyle3                         (@"MM-dd")
#define kJXFormatDateStyle4                         (@"YYYY/MM/dd")
#define kJXFormatTimeStyle2                         (@"HH:mm")
// 备份
#define kJXFormatDateItYYMMDD                       (@"YY-MM-dd")
#define kJXFormatForDateInternational               (@"YYYY-MM-dd")
#define kJXFormatForDateChinese                     (@"YYYY年MM月dd日")
#define kJXFormatForTimeInternational               (@"HH:mm:ss")
#define kJXFormatForTimeChinese                     (@"HH时mm分ss秒")
#define kJXFormatForDatetimeChinese                 (@"YYYY年MM月dd日 HH时mm分ss秒")
#define kJXFormatForDatetimeNormal                  (@"yyyy-MM-dd HH:mm")
#define kJXFormatJPG                                (@".jpg")
#define kJXFormatPNG                                (@".png")


/********************************************************************************************************
 默认图片
 ********************************************************************************************************/
#define kJXImagePHSquare                        JXImageWithName(@"jxres_placeholder_square")
#define kJXImagePHRectangle                     JXImageWithName(@"jxres_placeholder_rectangle")
//#define kJXImagePHSquare                    ([UIImage imageNamed:@"jx_loading_placeholder_square"])
//#define kJXImagePHRectangle                 ([UIImage imageNamed:@"jx_loading_placeholder_rectangle"])


/********************************************************************************************************
 其他
 ********************************************************************************************************/
// Page
#define kJXPageBegin                    (1)
#define kJXPageSize                     (20)
// Retry
#define kJXRetryTimes                               (3)
#define kJXRetryDelay                               (0.4)
// Animation

// Locale
#define kJXLocaleZhCN                                   (@"zh_CN")
#define kJXLocaleEnUS                                   (@"en_US")
// Bundle
#define kJXBundleName                                   (@"JXObjc")

// 备份
#define kJXMetricPhoneNumber                                    (11)
#define kJXMetricCustomPadding                                 (20.0)
#define kJXMetricSecondsInMinute                               (60)
#define kTimeTips                                           (1.2)
#define kJXCharsetNumbers       (@"0123456789")
#define kJXCharsetLetters       (@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
#define kJXCharsetLatin         (@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
#define kJXCharsetLatin2         (@"_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

#define kJXHTTPParamIgnoreNum                           (INT8_MIN)
#define kJXHTTPParamValueDatatypeJSON                   (@"json")
#define kJXHTTPFieldKeyCode                             (@"code")
#define kJXKeyboardDistanceFromTextField                (12.0f)


#define kJXNotifyDidChoose                          (@"kJXNotifyDidChoose")
#define kJXNotifyAlipay                             (@"kJXNotifyAlipay")
#define kJXNotifyWXpay                              (@"kJXNotifyWXpay")
#define kJXNotifyDidExpiredLogin                    (@"kJXNotifyDidExpiredLogin")
#define kJXNotifyUserDidLogin                           (@"kJXNotifyUserDidLogin")
#define kJXNotifyUserWillLogout                           (@"kJXNotifyUserWillLogout")
#define kJXNotifyUserDidLogout                           (@"kJXNotifyUserDidLogout")
#define kJXNotifyUserDidExpire                           (@"kJXNotifyUserDidExpire")
#define kJXNotifyServerDidChange                           (@"kJXNotifyServerDidChange")

#define kJXIdentifierCellSystem                     (@"kJXIdentifierCellSystem")
#define kJXIdentifierHeaderFooter                     (@"kJXIdentifierHeaderFooter")


#define kJXWebJSCallback            (@"jsCallback")
#define kJXWebNativeCallback        (@"nativeCallback")

//#if defined(JXEnableEnvDev) || defined(JXEnableEnvHoc) || defined(JXEnableEnvApp) || defined(JXEnableEnvEnt)
#define TMInstance              ([TMCache sharedCache])
//#define kTPJSPatchURL           (([NSURL jx_URLWithBase:CMInstance.baseURLString path:@"app/patch/ios.js"]))
//#endif

#define kJXTMUser                         (@"kJXTMUser")
#define kJXTMMisc                         (@"kJXTMMisc")


#define kJXImageTypePNG                     (@"image/png")
#define kJXImageTypeJPEG                    (@"image/jpeg")


#define kJXCurrentVC                    (JXCurrentViewController(void))


#define kJXWebAPITag                    (@"kJXWebAPITag")

#define kJXDidBorderIdentifer                    (@"kJXDidBorderIdentifer")

#endif /* JXConst_h */













