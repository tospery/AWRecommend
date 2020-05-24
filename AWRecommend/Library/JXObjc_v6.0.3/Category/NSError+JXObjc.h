//
//  NSError+JXObjc.h
//  MyCoding
//
//  Created by 杨建祥 on 16/4/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JXErrorCode){
    JXErrorCodeNone = 200,
    JXErrorCodeHTTPOK = JXErrorCodeNone, // 2xx的状态码表示请求成功
    JXErrorCodeHTTPCreated,
    JXErrorCodeHTTPAccepted,
    JXErrorCodeHTTPNonAuthInfo,
    JXErrorCodeHTTPNoContent,
    JXErrorCodeHTTPResetContent,
    JXErrorCodeHTTPPartialContent,
    JXErrorCodeHTTPMultipleChoices = 300, // 3xxx重定向错误
    JXErrorCodeHTTPMovedPermanently,
    JXErrorCodeHTTPFound,
    JXErrorCodeHTTPSeeOther,
    JXErrorCodeHTTPNotModified,
    JXErrorCodeHTTPUseProxy,
    JXErrorCodeHTTPUnused,
    JXErrorCodeHTTPTemporaryRedirect,
    JXErrorCodeHTTPBadRequest = 400,  // 4xx客户端错误
    JXErrorCodeHTTPUnauthorized,
    JXErrorCodeHTTPPaymentRequired,
    JXErrorCodeHTTPForbidden,
    JXErrorCodeHTTPNotFound,
    JXErrorCodeHTTPMethodNotAllowed,
    JXErrorCodeHTTPNotAcceptable,
    JXErrorCodeHTTPProxyAuthRequired,
    JXErrorCodeHTTPRequestTimeout,
    JXErrorCodeHTTPConflict,
    JXErrorCodeHTTPGone,
    JXErrorCodeHTTPLengthRequired,
    JXErrorCodeHTTPPreconditionFailed,
    JXErrorCodeHTTPRequestEntityTooLarge,
    JXErrorCodeHTTPRequestURITooLong,
    JXErrorCodeHTTPUnsupportedMediaType,
    JXErrorCodeHTTPRequestedRangeNotSatisfiable,
    JXErrorCodeHTTPExpectationFailed,
    JXErrorCodeHTTPInternalServerError = 500, // 5xx服务器错误
    JXErrorCodeHTTPNotImplemented,
    JXErrorCodeHTTPBadGateway,
    JXErrorCodeHTTPServiceUnavailable,
    JXErrorCodeHTTPGatewayTimeout,
    JXErrorCodeHTTPHTTPVersionNotSupported,
    
    JXErrorCodeCommon = 10000,      // App自定义错误
    
    JXErrorCodeNetworkException,
    JXErrorCodeServerException,
    
    JXErrorCodeDataEmpty,
    JXErrorCodeDataInvalid,
    
    JXErrorCodeLoginUnfinished,
    JXErrorCodeLoginExpired,
    JXErrorCodeLoginHasnotAccount,
    JXErrorCodeLoginWrongPassword,
    JXErrorCodeLoginNotPermission,
    JXErrorCodeLoginFailure,
    
    JXErrorCodeSigninFailure,
    
    JXErrorCodeLocateClosed,
    JXErrorCodeLocateDenied,
    JXErrorCodeLocateFailure,
    
    JXErrorCodeDeviceNotSupport,
    JXErrorCodeFileNotPicture,
    JXErrorCodeCheckUpdateFailure,
    JXErrorCodePlaceholder,
    JXErrorCodeArgumentError,
    JXErrorCodeExecuteFailure,
    JXErrorCodeActionFailure
};

///**
// *  错误码
// */
//typedef NS_ENUM(NSInteger, JXErrorCode) {
//    JXErrorCodeNone = 200,
//    JXErrorCodeTokenInvalid = 401,
//    JXErrorCodeDataEmpty = 402,
//    
//    JXErrorCodeCommon = 147000,
//    JXErrorCodeNetworkException,
//    JXErrorCodeServerException,
//    JXErrorCodeDataInvalid,
//    JXErrorCodeSessionInvalid,
//    JXErrorCodeUnlogined,
//    JXErrorCodeLoginUnregistered,
//    JXErrorCodeLoginWrongPassword,
//    JXErrorCodeLoginFailure,
//    JXErrorCodeLoginNotPermission,
//    JXErrorCodeSigninFailure,
//    JXErrorCodeDeviceNotSupport,
//    JXErrorCodeExecuteFailure,
//    JXErrorCodeActionFailure,
//    JXErrorCodeFileNotPicture,
//    JXErrorCodeLocateFailure,
//    JXErrorCodeLocateClosed,
//    JXErrorCodeLocateDenied,
//    JXErrorCodeCheckUpdate,
//    JXErrorCodeArgumentError,
//    JXErrorCodePlaceholder,
//    JXErrorCodeForNotNeedPrompt,
//    JXErrorCodeAll //    THErrorCodeSuccess = 0,
//    
//    //    THErrorCodeAccountNeed,
//    //    THErrorCodePasswordNeed,
//    //    THErrorCodeAccountNone,
//    //    THErrorCodeAccountRepeat,
//    //    THErrorCodePasswordFailure,
//    //    THErrorCodeAdminNeed,
//    //    THErrorCodePasswordOriginalNeed,
//    //    THErrorCodeAccountFailure,
//    //    THErrorCodeRecordNone,
//    //    THErrorCodeParamNeed,
//    //    THErrorCodeFormatIPFailure,
//    //    THErrorCodePhoneNumberFailure
//};

NSString * JXErrorCodeString(JXErrorCode code);

@interface NSError (JXObjc)
- (UIImage *)jx_reasonImage;
- (NSString *)jx_retryTitle;
- (NSError *)jx_adapt;

+ (NSError *)jx_errorWithCode:(JXErrorCode)code;
+ (NSError *)jx_errorWithCode:(NSInteger)code description:(NSString *)description;

//+ (NSError *)jx_errorWithCode:(JXErrorCode)code tag:(NSInteger)tag;
//+ (NSError *)jx_errorWithCode:(NSInteger)code description:(NSString *)description tag:(NSInteger)tag;

//+ (NSError *)jx_errorForAccountToken;
//
//+ (NSError *)jx_errorWithInfo:(JXErrorInfo *)info;

@end







