//
//  HTTPRequestClient.m
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "HTTPRequestClient.h"
#import "HTTPResponseBase.h"

static HTTPRequestClient *lInstance;

@implementation HTTPRequestClient
- (instancetype)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyServerDidChange:) name:kJXNotifyServerDidChange object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)notifyServerDidChange:(NSNotification *)notify {
    lInstance = nil;
}

- (RACSignal *)requestWithPath:(NSString *)path param:(JXHTTPRequestParam *)param schema:(JXHTTPSchema *)schema class:(Class)cls tag:(NSInteger)tag isList:(BOOL)isList {
    NSURL *url = [NSURL jx_URLWithBase:self.baseURL.absoluteString path:path];
    JXLogInfo(@"【请求】-> %@, params = \n%@", url.absoluteString, param.data);
    
    @weakify(self)
    return [[[super requestWithPath:path param:param schema:schema class:cls] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable response) {
        @strongify(self)
        JXLogError(@"【响应.成功】-> %@：\n%@", url.absoluteString, response);
        return [self handleResponse:response class:cls tag:tag isList:isList];
    }] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        @strongify(self)
        JXLogError(@"【响应.失败】-> %@：\n%@", url.absoluteString, error);
        return [self handleError:error tag:tag];
    }];
}

- (RACSignal *)handleResponse:(NSDictionary *)response class:(Class)cls tag:(ApiTag)tag isList:(BOOL)isList {
    if (![response isKindOfClass:[NSDictionary class]] &&
        ![response isKindOfClass:[NSArray class]]) {
        NSError *error = [NSError jx_errorWithCode:JXErrorCodeServerException];
        error.jxIdentifier = JXStrWithInt(tag);
        return [RACSignal error:error];
    }
    
    [HTTPResponseBase setTag:tag];
    response = [self adaptResponse:response tag:tag];
    
    HTTPResponseBase *base = [HTTPResponseBase mj_objectWithKeyValues:response];
    if (JXErrorCodeNone != base.code) {
        // YJX_TODO 登录过期
        NSError *error = [NSError jx_errorWithCode:base.code description:JXStrWithDft(base.msg, kStringServerException)];
        error.jxIdentifier = JXStrWithInt(tag);
        return [RACSignal error:error];
    }
    
    id data = base.data;
    if (!cls) {
        // 对于NSString或NSNumber必须带上class参数！！！
        // 此处表示不关心data，比如签到等操作接口。
        return [RACSignal return:data];
    }
    
    if (!data && !isList) {
        NSError *error = [NSError jx_errorWithCode:JXErrorCodeDataEmpty];
        error.jxIdentifier = JXStrWithInt(tag);
        return [RACSignal error:error];
    }
    
    id obj = nil;
    if (isList) {
        obj = [cls mj_objectArrayWithKeyValuesArray:data];
        if (0 == [(NSArray *)obj count]) {
            NSError *error = [NSError jx_errorWithCode:JXErrorCodeDataEmpty];
            error.jxIdentifier = JXStrWithInt(tag);
            return [RACSignal error:error];
        }
    }else {
        if (!data) {
            NSError *error = [NSError jx_errorWithCode:JXErrorCodeServerException];
            error.jxIdentifier = JXStrWithInt(tag);
            return [RACSignal error:error];
        }
        
        if ([NSString class] == cls ||
            [NSNumber class] == cls) {
            obj = data;
        }else {
            obj = [cls mj_objectWithKeyValues:data];
        }
    }
    
    return [RACSignal return:obj];
}

- (RACSignal *)handleError:(NSError *)error tag:(NSInteger)tag {
    if (3840 == error.code ||
        -1011 == error.code) {
        NSError *error = [NSError jx_errorWithCode:JXErrorCodeServerException];
        error.jxIdentifier = JXStrWithInt(tag);
        return [RACSignal error:error];
    }
    
    error.jxIdentifier = JXStrWithInt(tag);
    return [RACSignal error:error];
}

- (id)adaptResponse:(id)response tag:(ApiTag)tag {
    id ret = response;
    
//    switch (tag) {
//        case ApiTagUserInfo: {
//            ret = @{@"wiseAccountInfoDto": JXNil2Val(ret, @{})};
//            break;
//        }
//        default:
//            break;
//    }
    
//    id result = response;
//    
//    if ([response isKindOfClass:[NSDictionary class]]) {
//        NSNumber *code = [response objectForKey:@"code"];
//        if (0 != code.integerValue) {
//            return result;
//        }
//    }
//    
//    if (ApiTagAccountPermissionList == tag ||
//        ApiTagQiangxianFuncList == tag) {
//        NSArray *rows = nil;
//        if ([response isKindOfClass:[NSArray class]]) {
//            rows = (NSArray *)response;
//        }
//        BOOL success = YES;
//        if (0 == rows.count) {
//            success = NO;
//        }
//        result = @{@"success": @(success),
//                   @"rows": JXArrValue(rows, [NSArray new])};
//    }else if (ApiTagDonghuoDaibanDetail == tag ||
//              ApiTagDonghuoZuoyeDetail == tag ||
//              ApiTagDonghuoTingqiDetail == tag ||
//              ApiTagQiangxianFilterInfoTongji == tag ||
//              ApiTagQiangxianFilterInfoKanban == tag ||
//              ApiTagQiangxianTongjiRatio == tag ||
//              ApiTagQiangxianDiaodu == tag) {
//        NSDictionary *rows = nil;
//        if ([response isKindOfClass:[NSDictionary class]]) {
//            rows = (NSDictionary *)response;
//        }
//        
//        BOOL success = YES;
//        if (!rows) {
//            success = NO;
//        }
//        result = @{@"success": @(success),
//                   @"rows": rows};
//    }else if (tag >= ApiTagQiangxianTongjiDimType1 &&
//              tag <= ApiTagQiangxianTongjiDimType25) {
//        [TongjiDimList setType:tag];
//        
//        if (ApiTagQiangxianTongjiDimType25 == tag) {
//            NSArray *datalist = [response objectForKey:@"datalist"];
//            if ([datalist isKindOfClass:[NSArray class]] &&
//                0 != datalist.count) {
//                response = datalist[0];
//                //                if ([dict isKindOfClass:[NSDictionary class]]) {
//                //                    TongjiDimList *list = [TongjiDimList mj_objectWithKeyValues:dict];
//                //                    return [RACSignal return:list];
//                //                }
//            }
//        }
//        
//        NSDictionary *rows = nil;
//        if ([response isKindOfClass:[NSDictionary class]]) {
//            rows = (NSDictionary *)response;
//        }
//        
//        BOOL success = YES;
//        if (!rows) {
//            success = NO;
//        }
//        result = @{@"success": @(success),
//                   @"rows": rows};
//    }
//    
//    return result;
    
    return ret;
}

//- (NSDictionary *)commonHeaders {
//    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
//    if (0 != gUser.token) {
//        [headers setObject:gUser.token forKey:@"token"];
//    }
//    
//    return headers;
//}
//
//- (NSDictionary *)commonQueries {
////    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
////    [params setObject:@3 forKey:@"rs_type"];
////    [params setObject:@YES forKey:@"isMobile"];
////    if (0 != gUser.token.length) {
////        [params setObject:gUser.token forKey:@"js_s"];
////    }
////    return params;
//    return nil;
//}

+ (instancetype)sharedInstance {
    if (nil == lInstance) {
        NSURL *baseURL = [NSURL jx_URLWithBase:gMisc.baseURLString path:gMisc.pathURLString];
        lInstance = [[HTTPRequestClient alloc] initWithBaseURL:baseURL];
    }
    return lInstance;
}
@end
