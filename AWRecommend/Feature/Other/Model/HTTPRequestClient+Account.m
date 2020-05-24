//
//  HTTPRequestClient+Account.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/4/25.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "HTTPRequestClient+Account.h"

@implementation HTTPRequestClient (Account)
- (RACSignal *)getCode:(NSString *)mobile {
    JXCheck(mobile, JXArgErrSingal);
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"mobile": mobile};
    return [self requestWithPath:@"v1/general/getCode" param:param schema:[JXHTTPSchema schemaPost] class:[NSString class] tag:ApiTagNone isList:NO];
}

- (RACSignal *)exitLogin {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/wiseAccount/exitLogin" param:param schema:[JXHTTPSchema schemaPost] class:nil tag:ApiTagNone isList:NO];
}

- (RACSignal *)login:(NSString *)mobile code:(NSString *)code weChatOpenid:(NSString *)weChatOpenid {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (0 != mobile.length) {
        [params setObject:mobile forKey:@"mobile"];
    }
    if (0 != code.length) {
        [params setObject:code forKey:@"code"];
    }
    if (0 != weChatOpenid.length) {
        [params setObject:weChatOpenid forKey:@"appOpenid"];
    }
    
    //[param setObject:@1 forKey:@"loginType"];
    [params setObject:@1 forKey:@"source"];
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = params;
    
    
    return [self requestWithPath:@"v1/wiseAccount/login" param:param schema:[JXHTTPSchema schemaPostRawJSON2JSON] class:[User class] tag:ApiTagNone isList:NO];
}

- (RACSignal *)wxLogin:(NSString *)avatar
                  code:(NSString *)code
          isWeChatBind:(NSInteger)isWeChatBind
                mobile:(NSString *)mobile
              nickName:(NSString *)nickName
                   sex:(GenderType)sex
          weChatOpenid:(NSString *)weChatOpenid {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (0 != avatar.length) {
        [params setObject:avatar forKey:@"avatar"];
    }
    if (0 != code.length) {
        [params setObject:code forKey:@"code"];
    }
    if (0 != isWeChatBind) {
        [params setObject:@(isWeChatBind) forKey:@"isWeChatBind"];
    }
    if (0 != mobile.length) {
        [params setObject:mobile forKey:@"mobile"];
    }
    if (0 != nickName.length) {
        [params setObject:nickName forKey:@"nickName"];
    }
    if (0 != sex) {
        [params setObject:@(sex) forKey:@"sex"];
    }
    if (0 != weChatOpenid.length) {
        [params setObject:weChatOpenid forKey:@"appOpenid"];
    }
    [params setObject:@1 forKey:@"source"];
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = params;
    
    return [self requestWithPath:@"v1/wiseAccount/login" param:param schema:[JXHTTPSchema schemaPostRawJSON2JSON] class:[User class] tag:ApiTagNone isList:NO];
}

- (RACSignal *)findWiseAccountInfoByOpenId:(NSString *)openId {
    JXCheck(openId, JXArgErrSingal);
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"openId": openId};
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/wiseAccount/findWiseAccountInfoByOpenId" param:param schema:[JXHTTPSchema schemaPost] class:[User class] tag:ApiTagUserInfo isList:NO];
}

- (RACSignal *)addDrugFavorite:(NSInteger)brandId {
    JXCheck(@(brandId), JXArgErrSingal);
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"brandId": @(brandId)};
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/wiseAccount/addDrugFavorite" param:param schema:[JXHTTPSchema schemaPost] class:nil tag:ApiTagNone isList:NO];
}

- (RACSignal *)deleteDrugFavorite:(NSInteger)brandId {
    JXCheck(@(brandId), JXArgErrSingal);
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"brandId": @(brandId)};
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/wiseAccount/deleteDrugFavorite" param:param schema:[JXHTTPSchema schemaPost] class:[NSNumber class] tag:ApiTagFavoriteDel isList:NO];
}

- (RACSignal *)findDrugFavoriteList {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/wiseAccount/findDrugFavoriteList" param:param schema:[JXHTTPSchema schemaPost] class:[Favorite class] tag:ApiTagFavoriteMedicine isList:YES];
}

- (RACSignal *)addSuggestion:(NSString *)content {
    JXCheck(content, JXArgErrSingal);
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"source": @2,
                   @"content": content};
    param.header = [param commonHeader];
    

    return [self requestWithPath:@"v1/suggestion/addSuggestion" param:param schema:[JXHTTPSchema schemaPost] class:[NSString class] tag:ApiTagNone isList:NO];
}

- (RACSignal *)findWiseAccountDetails {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/wiseAccount/findWiseAccountDetails" param:param schema:[JXHTTPSchema schemaPost] class:[User class] tag:ApiTagUserInfo isList:NO];
}

- (RACSignal *)modifyWiseAccountInfo:(NSString *)nickName dateOfBirth:(NSString *)dateOfBirth sex:(GenderType)sex {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (nickName.length != 0) {
        [params setObject:nickName forKey:@"nickName"];
    }
    if (dateOfBirth.length != 0) {
        [params setObject:dateOfBirth forKey:@"dateOfBirth"];
    }
    if (GenderTypeNone != sex) {
        [params setObject:@(sex) forKey:@"sex"];
    }
//    if (0 != gUser.sig.length) {
//        [param setObject:gUser.sig forKey:@"selfSignature"];
//    }
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = params;
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/wiseAccount/modifyWiseAccountInfo" param:param schema:[JXHTTPSchema schemaPost] class:[User class] tag:ApiTagUserInfo isList:NO];
}

- (RACSignal *)modifyWiseAccountHeadImg:(UIImage *)imgFile {
    JXCheck(imgFile, JXArgErrSingal);
    
    JXHTTPFile *file = [[JXHTTPFile alloc] init];
    file.name = @"avatar";
    file.arg = @"imgFile";
    file.type = JXFileTypeImageJPEG;
    file.data = [imgFile jx_dataWithCompressionQuality:1.0 maxSize:1024];
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"imgFile": file};
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/wiseAccount/modifyWiseAccountHeadImg" param:param schema:[JXHTTPSchema schemaPostFormData2JSON] class:[NSString class] tag:ApiTagNone isList:NO];
}

- (RACSignal *)getUserCodeLogs {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/scanCode/getUserCodeLogs" param:param schema:[JXHTTPSchema schemaPost] class:[ScanRecord class] tag:ApiTagNone isList:YES];
}

- (RACSignal *)userRomoveCodeLog:(NSString *)uid {
    JXCheck(uid, JXArgErrSingal);
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"id": uid};
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/scanCode/userRomoveCodeLog" param:param schema:[JXHTTPSchema schemaPost] class:[NSString class] tag:ApiTagNone isList:NO];
}

- (RACSignal *)doctorsCustomersList {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/doctor/doctorsCustomersList" param:param schema:[JXHTTPSchema schemaPost] class:[Doctor class] tag:ApiTagNone isList:YES];
}

- (RACSignal *)userAdvisoryRecordWithDoctorId:(NSString *)doctorId currentPage:(NSInteger)currentPage pageSize:(NSInteger)pageSize {
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"doctorId": doctorId,
                   @"currentPage": @(currentPage),
                   @"pageSize": @(pageSize)};
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/tim/userAdvisoryRecord" param:param schema:[JXHTTPSchema schemaPost] class:[ChatHistoryList class] tag:ApiTagNone isList:NO];
}

- (RACSignal *)searchThroughDrug {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/drug/searchThroughDrug" param:param schema:[JXHTTPSchema schemaPost] class:[ShortcutName class] tag:ApiTagNone isList:YES];
}

- (RACSignal *)searchThroughDisease {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/drug/searchThroughDisease" param:param schema:[JXHTTPSchema schemaPost] class:[ShortcutSymptom class] tag:ApiTagNone isList:YES];
}

@end

















