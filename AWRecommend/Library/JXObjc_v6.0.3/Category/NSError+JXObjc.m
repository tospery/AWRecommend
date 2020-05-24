//
//  NSError+JXObjc.m
//  MyCoding
//
//  Created by 杨建祥 on 16/4/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "NSError+JXObjc.h"

@implementation NSError (JXObjc)
- (NSError *)jx_adapt {
    NSError *error = self;
    switch (self.code) {
        case -1009:
            error = [NSError jx_errorWithCode:JXErrorCodeNetworkException];
            break;
        case -1011:
        case -1004:
        case -1001:
        case 3840:
            error = [NSError jx_errorWithCode:JXErrorCodeServerException];
            break;
        default:
            break;
    }
    return error;
}

////+ (NSError *)jx_errorForAccountToken {
////    return [NSError jx_errorWithCode:401 description:kStringTokenInvalid];
////}
////
////+ (NSError *)jx_errorWithInfo:(JXErrorInfo *)info {
////    return [NSError jx_errorWithCode:info.code description:info.descript];
////}
//
//+ (NSError *)jx_errorWithCode:(JXErrorCode)code {
//    return [NSError jx_errorWithCode:code tag:-1];
//}
//
//+ (NSError *)jx_errorWithCode:(JXErrorCode)code tag:(NSInteger)tag {
//    // YJX_LIB
////    if (!((code >= JXErrorCodeCommon && code < JXErrorCodeAll) || (JXErrorCodeTokenInvalid == code))) {
////        return nil;
////    }
//    
//    NSString *description;
//    switch (code) {
//        case JXErrorCodeNetworkException:
//            description = kStringNetworkException;
//            break;
//        case JXErrorCodeServerException:
//            description = kStringServerException;
//            break;
//        case JXErrorCodeDataEmpty:
//            description = kStringDataEmpty;
//            break;
//        case JXErrorCodeTokenInvalid:
//            description = kStringTokenInvalid;
//            break;
//        case JXErrorCodeDeviceNotSupport:
//            description = kStringDeviceNotSupport;
//            break;
//        case JXErrorCodeActionFailure:
//            description = kStringActionFailure;
//            break;
//        case JXErrorCodeLocateFailure:
//            description = kStringLocateFailure;
//            break;
//        case JXErrorCodeLocateClosed:
//            description = kStringLocateClosed;
//            break;
//        case JXErrorCodeLocateDenied:
//            description = kStringLocateDenied;
//            break;
//        case JXErrorCodeCheckUpdate:
//            description = kStringErrorCheckUpdate;
//            break;
//        case JXErrorCodeArgumentError:
//            description = kStringArgumentError;
//            break;
//        case JXErrorCodeDataInvalid:
//            description = kStringDataInvalid;
//            break;
//        case JXErrorCodePlaceholder:
//            description = @"占位Error";
//            break;
//        case JXErrorCodeForNotNeedPrompt:
//            description = @"";
//            break;
//        default:
//            description = kStringUnknown;
//            break;
//    }
//    
//    return [NSError jx_errorWithCode:code description:description tag:tag];
//}
//
//+ (NSError *)jx_errorWithCode:(NSInteger)code description:(NSString *)description {
//    return [NSError jx_errorWithCode:code description:description tag:-1];
//}
//
//+ (NSError *)jx_errorWithCode:(NSInteger)code description:(NSString *)description tag:(NSInteger)tag {
//    return [NSError errorWithDomain:[JXApp sharedInstance].identifier
//                               code:code
//                           userInfo:@{NSLocalizedDescriptionKey: JXStrWithDft(description, kStringUnknown),
//                                      kJXWebAPITag: @(tag)}];
//}

- (UIImage *)jx_reasonImage {
    UIImage *image = JXImageWithName(@"jxres_error_empty");
    if (JXErrorCodeNetworkException == self.code) {
        image = JXImageWithName(@"jxres_error_network");
    }else if (JXErrorCodeServerException == self.code) {
        image = JXImageWithName(@"jxres_error_server");
    }else if (JXErrorCodeLoginExpired == self.code) {
        image = JXImageWithName(@"jxres_error_expired");
    }
    
    return JXAdaptImage(image);
}

- (NSString *)jx_retryTitle {
    NSString *title = kStringReload;
    if (JXErrorCodeLoginExpired == self.code) {
        title = kStringReLogin;
    }else if (JXErrorCodeDataEmpty == self.code) {
        title = kStringRefreshNow;
    }
    return title;
}

+ (NSError *)jx_errorWithCode:(JXErrorCode)code {
    return [NSError jx_errorWithCode:code description:JXErrorCodeString(code)];
}

+ (NSError *)jx_errorWithCode:(NSInteger)code description:(NSString *)description {
    return [NSError errorWithDomain:[JXApp sharedInstance].identifier
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey: JXStrWithDft(description, kStringUnknownError)}];
}

@end


NSString * JXErrorCodeString(JXErrorCode code) {
    NSString *str = kStringUnknownError;

    switch (code) {
        case JXErrorCodeHTTPCreated:
        case JXErrorCodeHTTPAccepted:
        case JXErrorCodeHTTPNonAuthInfo:
        case JXErrorCodeHTTPNoContent:
        case JXErrorCodeHTTPResetContent:
        case JXErrorCodeHTTPPartialContent:
            str = kStringHTTPRequestError;
            break;
        case JXErrorCodeHTTPMultipleChoices:
        case JXErrorCodeHTTPMovedPermanently:
        case JXErrorCodeHTTPFound:
        case JXErrorCodeHTTPSeeOther:
        case JXErrorCodeHTTPNotModified:
        case JXErrorCodeHTTPUseProxy:
        case JXErrorCodeHTTPUnused:
        case JXErrorCodeHTTPTemporaryRedirect:
            str = kStringHTTPRedirectError;
            break;
        case JXErrorCodeHTTPBadRequest:
        case JXErrorCodeHTTPUnauthorized:
        case JXErrorCodeHTTPPaymentRequired:
        case JXErrorCodeHTTPForbidden:
        case JXErrorCodeHTTPNotFound:
        case JXErrorCodeHTTPMethodNotAllowed:
        case JXErrorCodeHTTPNotAcceptable:
        case JXErrorCodeHTTPProxyAuthRequired:
        case JXErrorCodeHTTPRequestTimeout:
        case JXErrorCodeHTTPConflict:
        case JXErrorCodeHTTPGone:
        case JXErrorCodeHTTPLengthRequired:
        case JXErrorCodeHTTPPreconditionFailed:
        case JXErrorCodeHTTPRequestEntityTooLarge:
        case JXErrorCodeHTTPRequestURITooLong:
        case JXErrorCodeHTTPUnsupportedMediaType:
        case JXErrorCodeHTTPRequestedRangeNotSatisfiable:
        case JXErrorCodeHTTPExpectationFailed:
            str = kStringHTTPClientError;
            break;
        case JXErrorCodeHTTPInternalServerError:
        case JXErrorCodeHTTPNotImplemented:
        case JXErrorCodeHTTPBadGateway:
        case JXErrorCodeHTTPServiceUnavailable:
        case JXErrorCodeHTTPGatewayTimeout:
        case JXErrorCodeHTTPHTTPVersionNotSupported:
            str = kStringHTTPServerError;
            break;
        case JXErrorCodeCommon:
            break;
        case JXErrorCodeNetworkException:
            str = kStringNetworkException;
            break;
        case JXErrorCodeServerException:
            str = kStringServerException;
            break;
        case JXErrorCodeDataEmpty:
            str = kStringDataEmpty;
            break;
        case JXErrorCodeDataInvalid:
            str = kStringDataInvalid;
            break;
        case JXErrorCodeLoginUnfinished:
            str = kStringLoginUnfinished;
            break;
        case JXErrorCodeLoginExpired:
            str = kStringLoginExpired;
            break;
        case JXErrorCodeLoginHasnotAccount:
            str = kStringLoginHasnotAccount;
            break;
        case JXErrorCodeLoginWrongPassword:
            str = kStringLoginWrongPassword;
            break;
        case JXErrorCodeLoginNotPermission:
            str = kStringLoginNotPermission;
            break;
        case JXErrorCodeLoginFailure:
            str = kStringLoginFailure;
            break;
        case JXErrorCodeSigninFailure:
            str = kStringSigninFailure;
            break;
        case JXErrorCodeLocateClosed:
            str = kStringLocateClosed;
            break;
        case JXErrorCodeLocateDenied:
            str = kStringLocateDenied;
            break;
        case JXErrorCodeLocateFailure:
            str = kStringLocateFailure;
            break;
        case JXErrorCodeDeviceNotSupport:
            str = kStringDeviceNotSupport;
            break;
        case JXErrorCodeFileNotPicture:
            str = kStringFileNotPicture;
            break;
        case JXErrorCodeCheckUpdateFailure:
            str = kStringCheckUpdateFailure;
            break;
        case JXErrorCodePlaceholder:
            break;
        case JXErrorCodeArgumentError:
            str = kStringArgumentError;
            break;
        case JXErrorCodeExecuteFailure:
            str = kStringExecuteFailure;
            break;
        case JXErrorCodeActionFailure:
            str = kStringActionFailure;
            break;
        default:
            break;
    }
    
    return str;
}










