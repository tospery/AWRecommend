//
//  JXType.h
//  MyCoding
//
//  Created by 杨建祥 on 16/4/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#ifndef JXType_h
#define JXType_h



// #define JXErrorCodeTokenInvalidValue        (2)

/**
 *  HTTP的请求方式
 */
typedef NS_ENUM(NSInteger, JXHTTPRequestMethodType){
    JXHTTPRequestMethodTypeGet,
    JXHTTPRequestMethodTypePost,
    JXHTTPRequestMethodTypePut,
    JXHTTPRequestMethodTypePATCH,
    JXHTTPRequestMethodTypeDELETE
};

/**
 *  HTTP请求的Body类型
 */
typedef NS_ENUM(NSInteger, JXHTTPRequestParamType){
    JXHTTPRequestParamTypeQuery,                                               // 没有content，用于Get请求方式
    JXHTTPRequestParamTypeFormURLEncoded,                                     // x-www-form-urlencoded
    JXHTTPRequestParamTypeFormData,                                       // form-data -> text
    /*JXHTTPRequestContentTypeFormDataFile,*/                                       // form-data -> file
    JXHTTPRequestParamTypeRawText,                                            // text/plain
    JXHTTPRequestParamTypeRawJSON,                                            // application/json
    JXHTTPRequestParamTypeRawJavascript,                                      // application/javascript
    JXHTTPRequestParamTypeRawXMLApp,                                          // application/xml
    JXHTTPRequestParamTypeRawXMLText,                                         // text/xml
    JXHTTPRequestParamTypeRawHTML,                                            // text/html
    JXHTTPRequestParamTypeBinary
};

// http://docs.oracle.com/javaee/7/api/javax/ws/rs/core/MediaType.html
//typedef NS_ENUM(NSInteger, JXHTTPRequestParamType111){
//    TSScratchcardInfoTypeNone,
//    TSScratchcardInfoTypeCoin,
//    TSScratchcardInfoTypeCoupon,
//    TSScratchcardInfoTypeAll
//};

/**
 *  HTTP响应的Body类型
 */
typedef NS_ENUM(NSInteger, JXHTTPResponseDataType){
    JXHTTPResponseDataTypeJSON,
    JXHTTPResponseDataTypeXML,
    JXHTTPResponseDataTypeHTML,
    JXHTTPResponseDataTypeText
};

typedef void        (^JXVoidBlock)();
typedef BOOL        (^JXBoolBlock)();
typedef NSInteger   (^JXIntBlock) ();
typedef id          (^JXIDBlock)  ();

typedef void        (^JXVoidBlock_bool)(BOOL);
typedef BOOL        (^JXBoolBlock_bool)(BOOL);
typedef NSInteger   (^JXIntBlock_bool) (BOOL);
typedef id          (^JXIDBlock_bool)  (BOOL);

typedef void        (^JXVoidBlock_int)(NSInteger);
typedef BOOL        (^JXBoolBlock_int)(NSInteger);
typedef NSInteger   (^JXIntBlock_int) (NSInteger);
typedef id          (^JXIDBlock_int)  (NSInteger);

typedef void        (^JXVoidBlock_string)(NSString *);
typedef BOOL        (^JXBoolBlock_string)(NSString *);
typedef NSInteger   (^JXIntBlock_string) (NSString *);
typedef id          (^JXIDBlock_string)  (NSString *);

typedef void        (^JXVoidBlock_id)(id);
typedef BOOL        (^JXBoolBlock_id)(id);
typedef NSInteger   (^JXIntBlock_id) (id);
typedef id          (^JXIDBlock_id)  (id);


typedef NS_ENUM(NSInteger, JXRequestMode) {
    JXRequestModeNone,
    JXRequestModeLoad,
    JXRequestModeUpdate,
    JXRequestModeRefresh,
    JXRequestModeMore,
    JXRequestModeHUD
};

typedef NS_ENUM(NSInteger, JXScanLib){
    JXScanLibNone,
    JXScanLibNative,
    JXScanLibZXing,
    JXScanLibZBar
};

typedef NS_ENUM(NSInteger, JXAlertButtonStyle){
    JXAlertButtonStyleDefault,
    JXAlertButtonStyleDestructive,
    JXAlertButtonStyleCancel
};

typedef NS_ENUM(NSInteger, JXStatusBarStyle){
    JXStatusBarStyleNone,
    JXStatusBarStyleDefault,
    JXStatusBarStyleLightContent
};

//typedef NS_ENUM(NSInteger, UIStatusBarStyle) {
//    UIStatusBarStyleDefault                                     = 0, // Dark content, for use on light backgrounds
//    UIStatusBarStyleLightContent     NS_ENUM_AVAILABLE_IOS(7_0) = 1, // Light content, for use on dark backgrounds
//    
//    UIStatusBarStyleBlackTranslucent NS_ENUM_DEPRECATED_IOS(2_0, 7_0, "Use UIStatusBarStyleLightContent") = 1,
//    UIStatusBarStyleBlackOpaque      NS_ENUM_DEPRECATED_IOS(2_0, 7_0, "Use UIStatusBarStyleLightContent") = 2,
//}

//// 备份
///**
// *  网络请求的UI方式
// */
//typedef NS_ENUM(NSInteger, JXWebMode) {
//    JXWebModeSilent,
//    JXWebModeLoad,
//    JXWebModeHUD,
//    JXWebModeRefresh,
//    JXWebModeMore
//};

/**
 *  网络错误的UI显示方式
 */
typedef NS_ENUM(NSInteger, JXWebWay) {
    JXWebWaySilent,
    JXWebWayShow,
    JXWebWayPrompt
};


// 备份
typedef NS_ENUM(NSInteger, JXSlideDirection){
    JXSlideDirectionNone,
    JXSlideDirectionUp,
    JXSlideDirectionDown,
    JXSlideDirectionLeft,
    JXSlideDirectionRight
};

//typedef NS_ENUM(NSInteger, JXFlatButtonType) {
//    JXFlatButtonTypeDefault,             // Vertical line
//    JXFlatButtonTypeAdd,                 // +
//    JXFlatButtonTypeMinus,               // -
//    JXFlatButtonTypeClose,               // x
//    JXFlatButtonTypeBack,                // <
//    JXFlatButtonTypeForward,             // >
//    JXFlatButtonTypeMenu,                 // 3horizontal lines
//    JXFlatButtonTypeDownload,
//    JXFlatButtonTypeShare,
//    JXFlatButtonTypeDownBasic,
//    JXFlatButtonTypeUpBasic,
//    JXFlatButtonTypeDownArrow,
//    JXFlatButtonTypePaused,
//    JXFlatButtonTypeRightTriangle,
//    JXFlatButtonTypeLeftTriangle,
//    JXFlatButtonTypeUpTriangle,
//    JXFlatButtonTypeDownTriangle,
//    JXFlatButtonTypeOk,
//    JXFlatButtonTypeRewind,
//    JXFlatButtonTypeFastForward,
//    JXFlatButtonTypeSquare
//};

// typedef void (^JXLoginDidPassBlock)(void);

typedef void (^JXLoginDidSuccessBlock)(void);

// 登录相关block
typedef void (^JXLoginDidPresentCallback)(void);    // 登录控制器显示之后的callback
typedef void (^JXLoginDidPassCallback)(void);       // 通过登录验证
typedef void (^JXLoginReloginWillFinishCallback)(void);    // 重新登录成功
typedef void (^JXLoginReloginDidFinishCallback)(void);    // 重新登录成功
typedef void (^JXLoginDidPassOrReloginDidFinishCallback)(void);     // 已经登录或者完成重新登录（上面两个callback的集合）

// Web相关
//typedef void (^JXWebResultCallback)(void);

typedef void (^JXProcessViewCallbackBlock)(void);
//typedef void (^JXLoadResultCallback)(void);
typedef void (^JXLoginResultCallback)(BOOL isRelogin);


//typedef void (^JXHouseCheckCallback)(BOOL hasHouse);

//typedef void (^JXSimpleBlock)(void);


typedef NS_ENUM(NSInteger, JXPayResult){
    JXPayResultCanceled,
    JXPayResultSuccess,
    JXPayResultFailure
};

typedef NS_ENUM(NSInteger, JXFileType){
    JXFileTypeNone,
    JXFileTypeImagePNG,
    JXFileTypeImageJPEG
};

////JXEnableEnvDev                         开发
////JXEnableEnvHoc                         测试
////JXEnableEnvApp                         正式（App Store）
////JXEnableEnvEnt                         正式（企业版发布）
//typedef NS_ENUM(NSInteger, JXEnvType){
//    JXEnvTypeNone,
//    JXEnvTypeDev,
//    JXEnvTypeHoc,
//    JXEnvTypeApp,
//    JXEnvTypeEnt = JXEnvTypeApp
//};

//typedef NS_ENUM(NSInteger, JXAppEnv){
//    JXAppEnvNone,
//    JXAppEnvDev,
//    JXAppEnvHoc,
//    JXAppEnvEnt,
//    JXAppEnvApp
//};

#endif /* JXType_h */







