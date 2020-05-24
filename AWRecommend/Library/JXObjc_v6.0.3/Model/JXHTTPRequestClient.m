//
//  JXHTTPRequestClient.m
//  MyCoding
//
//  Created by 杨建祥 on 16/4/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXHTTPRequestClient.h"

#define kJXHTTPRequestTagNone           (0)

@interface JXHTTPRequestClient ()
//@property (nonatomic, strong) Class responseClass;
@property (nonatomic, assign) NSInteger delayTimes;
@property (nonatomic, assign) NSInteger retryTimes;

@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, strong) JXHTTPSchema *schema;

@end

@implementation JXHTTPRequestClient
- (instancetype)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        self.securityPolicy.allowInvalidCertificates = YES;
        self.securityPolicy.validatesDomainName = NO;
        
        _delayTimes = 1;
        _retryTimes = 2;
        _timeoutInterval = kJXHTTPTimeout;
    }
    return self;
}

//- (Class)responseClass {
//    if (JXDataIsEmpty(_responseClass)) {
//        _responseClass = [JXHTTPResponseBase class];
//    }
//    return _responseClass;
//}

- (void)setSchema:(JXHTTPSchema *)schema {
    _schema = schema;
    
    switch (schema.paramType) {
        case JXHTTPRequestParamTypeQuery:
        case JXHTTPRequestParamTypeFormURLEncoded: {
            self.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        }
        case JXHTTPRequestParamTypeRawJSON: {
            self.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        }
        default: {
            self.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        }
    }
    
    switch (schema.dataType) {
        case JXHTTPResponseDataTypeJSON: {
            self.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        }
        default: {
            self.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        }
    }
    
    
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setValue:self.baseURL.absoluteString forHTTPHeaderField:@"Referer"];
    self.requestSerializer.timeoutInterval = self.timeoutInterval;
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", @"text/xml", nil];
}

- (RACSignal *)requestWithPath:(NSString *)path param:(JXHTTPRequestParam *)param schema:(JXHTTPSchema *)schema class:(Class)cls {
    self.schema = schema;
    
    @weakify(self)
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)

        NSURLSessionDataTask *task = nil;
        
        if (![AFNetworkReachabilityManager sharedManager].isReachable) {
            JXLogError(@"网络未通，重试请求");
            [[RACScheduler currentScheduler] afterDelay:self.delayTimes schedule:^{
                [subscriber sendError:[NSError jx_errorWithCode:JXErrorCodeNetworkException]];
            }];
        }else {
            switch (schema.methodType) {
                case JXHTTPRequestMethodTypeGet: {
                    NSMutableDictionary *queries = [NSMutableDictionary dictionaryWithDictionary:param.data];
                    for (id key in param.query.allKeys) {
                        [queries setObject:param.query[key] forKey:key];
                    }

                    task = [self GET:path parameters:queries progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        [subscriber sendNext:responseObject];
                        [subscriber sendCompleted];
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [[RACScheduler currentScheduler] afterDelay:self.delayTimes schedule:^{
                            [subscriber sendError:error];
                        }];
                    }];
                }
                    break;
                case JXHTTPRequestMethodTypePost: {
                    switch (schema.paramType) {
                        case JXHTTPRequestParamTypeFormURLEncoded: {
                            NSDictionary *formURLEncodeds = param.data;
                            
                            for (id key in param.header.allKeys) {
                                [self.requestSerializer setValue:param.header[key] forHTTPHeaderField:key];
                            }
                            
                            task = [self POST:path parameters:formURLEncodeds progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                [subscriber sendNext:responseObject];
                                [subscriber sendCompleted];
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                [[RACScheduler currentScheduler] afterDelay:self.delayTimes schedule:^{
                                    [subscriber sendError:error];
                                }];
                            }];
                        }
                            break;
                        case JXHTTPRequestParamTypeFormData: {
                            NSMutableDictionary *fileParam = [NSMutableDictionary dictionary];
                            for (NSString *key in [(NSDictionary *)param.data allKeys]) {
                                id obj = param.data[key];
                                if ([obj isKindOfClass:[JXHTTPFile class]]) {
                                    [fileParam setObject:obj forKey:key];
                                }
                            }
                            
                            NSMutableDictionary *textParam = [NSMutableDictionary dictionaryWithDictionary:param.data];
                            [textParam removeObjectsForKeys:fileParam.allKeys];
                            
                            
                            NSURL *url = [NSURL jx_URLWithBase:self.baseURL.absoluteString path:path];
                            NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url.absoluteString parameters:textParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                for (NSString *key in fileParam.allKeys) {
                                    id obj = fileParam[key];
                                    if ([obj isKindOfClass:[JXHTTPFile class]]) {
                                        JXHTTPFile *file = obj;
                                        [formData appendPartWithFileData:file.data
                                                                    name:file.arg
                                                                fileName:file.name
                                                                mimeType:JXFileTypeString(file.type)];
                                    }
                                }
                            } error:nil];
                            
                            for (id key in param.header.allKeys) {
                                [request addValue:param.header[key] forHTTPHeaderField:key];
                            }
                            
                            NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
                            sessionConfig.timeoutIntervalForRequest  = 60;
                            
                            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfig];
                            
                            
                            //if (JXHTTPResponseContentTypeJSON == responseContentType) {
                            manager.responseSerializer = self.responseSerializer; // [AFJSONResponseSerializer serializer];
                            //}
                            
                            task = [manager uploadTaskWithStreamedRequest:request progress:NULL completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                if (!error) {
                                    [subscriber sendNext:responseObject];
                                    [subscriber sendCompleted];
                                }else {
                                    [[RACScheduler currentScheduler] afterDelay:self.delayTimes schedule:^{
                                        [subscriber sendError:error];
                                    }];
                                }
                            }];
                            
                            [task resume];
                        }
                            break;
                        case JXHTTPRequestParamTypeRawJSON: {
                            NSDictionary *rawJSONs = param.data;
                            
                            for (id key in param.header.allKeys) {
                                [self.requestSerializer setValue:param.header[key] forHTTPHeaderField:key];
                            }
                        
                            task = [self POST:path parameters:rawJSONs progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                [subscriber sendNext:responseObject];
                                [subscriber sendCompleted];
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                [[RACScheduler currentScheduler] afterDelay:self.delayTimes schedule:^{
                                    [subscriber sendError:error];
                                }];
                            }];
                            break;
                        }
                            break;
                        default: {
//                            NSDictionary *headers = [self commonHeaders];
//                            for (id key in headers.allKeys) {
//                                [self.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
//                            }
//                            
//                            task = [self POST:path parameters:param progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                                [subscriber sendNext:responseObject];
//                                [subscriber sendCompleted];
//                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                                [[RACScheduler currentScheduler] afterDelay:self.delayTimes schedule:^{
//                                    [subscriber sendError:error];
//                                }];
//                            }];
                        }
                            break;
                    }
                }
                    break;
                default:
                    break;
            }
        }
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] retry:self.retryTimes];
}

//- (void)setupRequestContentType:(JXHTTPRequestContentType)type {
//    switch (type) {
//        case JXHTTPRequestContentTypeNone: {
//            //self.requestSerializer = [AFHTTPRequestSerializer serializer];
//        }
//            break;
//        case JXHTTPRequestContentTypeFormURLEncoded: {
//
//        }
//            break;
//        default:
//            break;
//    }
//}
//
//- (void)setupResponseContentType:(JXHTTPResponseContentType)type {
//    switch (type) {
//        case JXHTTPResponseContentTypeJSON: {
//            if (![self.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]) {
//                self.responseSerializer = [AFJSONResponseSerializer serializer];
//            }
//        }
//            break;
//
//        default:
//            break;
//    }
//}

//- (RACSignal *)requestWithPath:(NSString *)path isArr:(BOOL)isArr {
//    return [self requestWithPath:path param:nil schema:[JXHTTPSchema schemaPost] class:nil isArr:isArr];
//}
//
//- (RACSignal *)requestWithPath:(NSString *)path tag:(NSInteger)tag isArr:(BOOL)isArr {
//    return [self requestWithPath:path param:nil schema:[JXHTTPSchema schemaPost] class:nil tag:tag isArr:isArr];
//}
//
//- (RACSignal *)requestWithPath:(NSString *)path param:(NSDictionary *)param isArr:(BOOL)isArr {
//    return [self requestWithPath:path param:param schema:[JXHTTPSchema schemaPost] class:nil];
//}
//
//- (RACSignal *)requestWithPath:(NSString *)path param:(NSDictionary *)param tag:(NSInteger)tag {
//    return [self requestWithPath:path param:param schema:[JXHTTPSchema schemaPost] class:nil tag:tag];
//}
//
//- (RACSignal *)requestWithPath:(NSString *)path param:(NSDictionary *)param schema:(JXHTTPSchema *)schema{
//    return [self requestWithPath:path param:param schema:schema class:nil];
//}
//
//- (RACSignal *)requestWithPath:(NSString *)path param:(NSDictionary *)param schema:(JXHTTPSchema *)schema tag:(NSInteger)tag {
//    return [self requestWithPath:path param:param schema:schema class:nil tag:tag];
//}
//
//- (RACSignal *)requestWithPath:(NSString *)path param:(NSDictionary *)param class:(Class)cls {
//    return [self requestWithPath:path param:param schema:[JXHTTPSchema schemaPost] class:cls];
//}
//
//- (RACSignal *)requestWithPath:(NSString *)path param:(NSDictionary *)param class:(Class)cls tag:(NSInteger)tag {
//    return [self requestWithPath:path param:param schema:[JXHTTPSchema schemaPost] class:cls tag:tag];
//}
//
//- (RACSignal *)requestWithPath:(NSString *)path class:(Class)cls {
//    return [self requestWithPath:path param:nil schema:[JXHTTPSchema schemaPost] class:cls];
//}
//
//- (RACSignal *)requestWithPath:(NSString *)path class:(Class)cls tag:(NSInteger)tag {
//    return [self requestWithPath:path param:nil schema:[JXHTTPSchema schemaPost] class:cls tag:tag];
//}
//
//- (RACSignal *)requestWithPath:(NSString *)path param:(NSDictionary *)param schema:(JXHTTPSchema *)schema class:(Class)cls {
//    return [self requestWithPath:path param:param schema:schema class:cls tag:kJXHTTPRequestTagNone];
//}

//- (RACSignal *)requestWithPath:(NSString *)path param:(NSDictionary *)param schema:(JXHTTPSchema *)schema class:(Class)cls {
//    self.schema = schema;
//    
//    // JXLogDebug(@"请求 -> %@\nurlParams = %@\nheaderParams = %@\nbodyParams = %@", pathURLString, urlParams, headerParams, bodyParams);
//    // JXLogDebug(@"请求 -> %@\nparam = %@", path, param);
//    //    [self.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    //#ifdef kHTTPTimeout
//    //    self.requestSerializer.timeoutInterval = kHTTPTimeout;
//    //#else
//    //    self.requestSerializer.timeoutInterval = kJXHTTPTimeout;
//    //#endif
//    //    [self.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//    
//    @weakify(self)
//    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        @strongify(self)
//        
//        // AFHTTPRequestOperation *operation = nil;
//        NSURLSessionDataTask *task = nil;
//        // NSURLSessionUploadTask *task = nil;
//        
//        if (![AFNetworkReachabilityManager sharedManager].isReachable) {
//            JXLogError(@"网络未通，重试请求");
//            [[RACScheduler currentScheduler] afterDelay:self.delayTimes schedule:^{
//                [subscriber sendError:[NSError jx_errorWithCode:JXErrorCodeNetworkException]];
//            }];
//        }else {
//            switch (schema.methodType) {
//                case JXHTTPRequestMethodTypeGet: {
//                    //                    operation = [self GET:path parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//                    //                        JXLogDebug(@"响应【成功】-> %@：\n%@", path, responseObject);
//                    //                        [subscriber sendNext:responseObject];
//                    //                        [subscriber sendCompleted];
//                    //                    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//                    //                        JXLogError(@"响应【失败】-> %@：\n%@", path, error);
//                    //                        [[RACScheduler currentScheduler] afterDelay:kJXHTTPRetryDelay schedule:^{
//                    //                            [subscriber sendError:error];
//                    //                        }];
//                    //                    }];
//                    
//                    
//                    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:param];
//                    NSDictionary *commonURLParams = [self commonQueries];
//                    for (id key in commonURLParams.allKeys) {
//                        [params setObject:commonURLParams[key] forKey:key];
//                    }
//                    
////#if defined(JXEnableEnvDev) || defined(JXEnableEnvHoc)
////                    NSURL *url = [NSURL jx_URLWithBase:self.baseURL.absoluteString path:path];
////                    NSMutableString *str = [NSMutableString stringWithString:url.absoluteString];
////                    [str appendString:@"?"];
////                    for (NSString *key in params.allKeys) {
////                        [str appendFormat:@"%@=%@&", key, params[key]];
////                    }
////                    [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
////                    JXLogInfo(@"【GET】请求 -> %@", str);
////#endif
//                    
//                    task = [self GET:path parameters:params progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////#if defined(JXEnableEnvDev) || defined(JXEnableEnvHoc)
////                        if ([responseObject isKindOfClass:[NSDictionary class]] ||
////                            [responseObject isKindOfClass:[NSArray class]]) {
////                            JXLogInfo(@"响应【成功】-> %@：\n%@", path, [(NSObject *)responseObject mj_JSONString]);
////                        }else {
////                            JXLogInfo(@"响应【成功】-> %@：\n%@", path, responseObject);
////                        }
////#endif
//                        
//                        //JXLogDebug(@"响应【成功】-> %@：\n%@", path, responseObject);
//                        [subscriber sendNext:responseObject];
//                        [subscriber sendCompleted];
//                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                        //JXLogError(@"响应【失败】-> %@：\n%@", path, error);
//                        [[RACScheduler currentScheduler] afterDelay:self.delayTimes schedule:^{
//                            [subscriber sendError:error];
//                        }];
//                    }];
//                }
//                    break;
//                case JXHTTPRequestMethodTypePost: {
//                    switch (schema.paramType) {
//                        case JXHTTPRequestParamTypeFormURLEncoded: {
//                            NSDictionary *headers = [self commonHeaders];
//                            for (id key in headers.allKeys) {
//                                [self.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
//                            }
//                            
////#if defined(JXEnableEnvDev) || defined(JXEnableEnvHoc)
////                            NSURL *url = [NSURL jx_URLWithBase:self.baseURL.absoluteString path:path];
////                            JXLogInfo(@"【POST】请求 -> %@, params = \n%@", url.absoluteString, param);
////#endif
//                            
//                            task = [self POST:path parameters:param progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                                //JXLogInfo(@"响应【成功】-> %@：\n%@", path, responseObject);
//                                [subscriber sendNext:responseObject];
//                                [subscriber sendCompleted];
//                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                                //JXLogError(@"响应【失败】-> %@：\n%@", path, error);
//                                [[RACScheduler currentScheduler] afterDelay:self.delayTimes schedule:^{
//                                    [subscriber sendError:error];
//                                }];
//                            }];
//                        }
//                            break;
//                        case JXHTTPRequestParamTypeFormData: {
//                            NSMutableDictionary *fileParam = [NSMutableDictionary dictionary];
//                            for (NSString *key in param.allKeys) {
//                                id obj = param[key];
//                                //        if ([obj isKindOfClass:[UIImage class]] ||
//                                //            [obj isKindOfClass:[NSArray class]]) {
//                                //            [myFileParams setObject:obj forKey:key];
//                                //        }
//                                if ([obj isKindOfClass:[JXHTTPFile class]]) {
//                                    [fileParam setObject:obj forKey:key];
//                                }
//                            }
//                            
//                            NSMutableDictionary *textParam = [NSMutableDictionary dictionaryWithDictionary:param];
//                            [textParam removeObjectsForKeys:fileParam.allKeys];
//                            
//                            
//                            NSURL *url = [NSURL jx_URLWithBase:self.baseURL.absoluteString path:path];
//                            NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url.absoluteString parameters:textParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//                                for (NSString *key in fileParam.allKeys) {
//                                    //            id obj = myFileParams[key];
//                                    //            if ([obj isKindOfClass:[UIImage class]]) {
//                                    //                [formData appendPartWithFileData:UIImagePNGRepresentation(obj)
//                                    //                                            name:key
//                                    //                                        fileName:@"image.png"
//                                    //                                        mimeType:@"image/png"];
//                                    //            }else if ([obj isKindOfClass:[NSArray class]]) {
//                                    //                for (id val in obj) {
//                                    //                    if ([val isKindOfClass:[UIImage class]]) {
//                                    //                        [formData appendPartWithFileData:UIImagePNGRepresentation(val)
//                                    //                                                    name:key
//                                    //                                                fileName:@"image.png"
//                                    //                                                mimeType:@"image/png"];
//                                    //                    }
//                                    //                }
//                                    //            }
//                                    
//                                    id obj = fileParam[key];
//                                    if ([obj isKindOfClass:[JXHTTPFile class]]) {
//                                        JXHTTPFile *file = obj;
//                                        [formData appendPartWithFileData:file.data
//                                                                    name:file.arg
//                                                                fileName:file.name
//                                                                mimeType:JXFileTypeString(file.type)];
//                                    }
//                                }
//                            } error:nil];
//                            
//                            
//                            //            for (NSString *key in headerParams.allKeys) {
//                            //                [request addValue:headerParams[key] forHTTPHeaderField:key];
//                            //            }
//                            
//                            //            // YJX_LIB 优化
//                            //            if (gUser.token.length != 0) {
//                            //                [request addValue:gUser.token forHTTPHeaderField:@"token"];
//                            //            }
//                            
//                            NSDictionary *headers = [self commonHeaders];
//                            for (id key in headers.allKeys) {
//                                [request addValue:headers[key] forHTTPHeaderField:key];
//                            }
//                            
//                            NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//                            sessionConfig.timeoutIntervalForRequest  = 60;
//                            
//                            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfig];
//                            
//                            
//                            //if (JXHTTPResponseContentTypeJSON == responseContentType) {
//                            manager.responseSerializer = self.responseSerializer; // [AFJSONResponseSerializer serializer];
//                            //}
//                            
//                            // NSProgress *pg = nil;
//                            
//                            task = [manager uploadTaskWithStreamedRequest:request progress:NULL completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//                                if (!error) {
//                                    //#ifdef JXEnableEnvDev
//                                    //                                    if ([responseObject isKindOfClass:[NSDictionary class]] ||
//                                    //                                        [responseObject isKindOfClass:[NSArray class]]) {
//                                    //                                        JXLogDebug(@"响应【成功】-> %@：\n%@", path, [(NSObject *)responseObject mj_JSONString]);
//                                    //                                    }else {
//                                    //                                        JXLogDebug(@"响应【成功】-> %@：\n%@", path, responseObject);
//                                    //                                    }
//                                    //#endif
//                                    
//                                    //JXLogInfo(@"响应【成功】-> %@：\n%@", path, responseObject);
//                                    [subscriber sendNext:responseObject];
//                                    [subscriber sendCompleted];
//                                }else {
//                                    //JXLogError(@"响应【失败】-> %@：\n%@", path, error);
//                                    [[RACScheduler currentScheduler] afterDelay:self.delayTimes schedule:^{
//                                        [subscriber sendError:error];
//                                    }];
//                                }
//                            }];
//                            
//                            //            JXHTTPClient *client = [JXHTTPClient sharedInstance];
//                            //            client.progress = progress;
//                            //            //[pg addObserver:client forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
//                            
//                            [task resume];
//                        }
//                            break;
//                        case JXHTTPRequestParamTypeRawJSON: {
//                            NSDictionary *headers = [self commonHeaders];
//                            for (id key in headers.allKeys) {
//                                [self.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
//                            }
//                            
////#ifdef JXEnableEnvDev
////                            NSURL *url = [NSURL jx_URLWithBase:self.baseURL.absoluteString path:path];
////                            JXLogInfo(@"【POST】请求 -> %@, params = \n%@", url.absoluteString, param);
////#endif
//                            
//                            task = [self POST:path parameters:param progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                                //JXLogInfo(@"响应【成功】-> %@：\n%@", path, responseObject);
//                                [subscriber sendNext:responseObject];
//                                [subscriber sendCompleted];
//                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                                //JXLogError(@"响应【失败】-> %@：\n%@", path, error);
//                                [[RACScheduler currentScheduler] afterDelay:self.delayTimes schedule:^{
//                                    [subscriber sendError:error];
//                                }];
//                            }];
//                            break;
//                        }
//                            break;
//                        default: {
//                            NSDictionary *headers = [self commonHeaders];
//                            for (id key in headers.allKeys) {
//                                [self.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
//                            }
//                            
//////#ifdef JXEnableEnvDev
////                            NSURL *url = [NSURL jx_URLWithBase:self.baseURL.absoluteString path:path];
////                            JXLogInfo(@"【POST】请求 -> %@, params = \n%@", url.absoluteString, param);
//////#endif
////                            
//                            task = [self POST:path parameters:param progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                               // JXLogInfo(@"响应【成功】-> %@：\n%@", path, responseObject);
//                                [subscriber sendNext:responseObject];
//                                [subscriber sendCompleted];
//                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                                //JXLogError(@"响应【失败】-> %@：\n%@", path, error);
//                                [[RACScheduler currentScheduler] afterDelay:self.delayTimes schedule:^{
//                                    [subscriber sendError:error];
//                                }];
//                            }];
//                        }
//                            break;
//                    }
//                    //                    operation = [self POST:path parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//                    //                        JXLogDebug(@"响应【成功】-> %@：\n%@", path, responseObject);
//                    //                        [subscriber sendNext:responseObject];
//                    //                        [subscriber sendCompleted];
//                    //                    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//                    //                        JXLogError(@"响应【失败】-> %@：\n%@", path, error);
//                    //                        [[RACScheduler currentScheduler] afterDelay:kJXHTTPRetryDelay schedule:^{
//                    //                            [subscriber sendError:error];
//                    //                        }];
//                    //                    }];
//                }
//                    break;
//                default:
//                    break;
//            }
//        }
//        
//        return [RACDisposable disposableWithBlock:^{
//            //[operation cancel];
//            [task cancel];
//        }];
//    }] retry:self.retryTimes];
//}

//- (RACSignal *)uploadWithPath:(NSString *)path param:(NSDictionary *)param schema:(JXHTTPSchema *)schema class:(Class)cls {
//    self.schema = schema;
//
//    JXLogDebug(@"请求 -> %@\nparam = %@", path, param);
//
//    @weakify(self)
//    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        @strongify(self)
//
//        // AFHTTPRequestOperation *operation = nil;
//        NSURLSessionUploadTask *task = nil;
//
//        if (![AFNetworkReachabilityManager sharedManager].isReachable) {
//            JXLogError(@"网络未通，重试请求");
//            [[RACScheduler currentScheduler] afterDelay:kJXHTTPRetryDelay schedule:^{
//                [subscriber sendError:[NSError jx_errorWithCode:JXErrorCodeNetworkException]];
//            }];
//        }else {
//            NSMutableDictionary *myFileParams = [NSMutableDictionary dictionary];
//            for (NSString *key in param.allKeys) {
//                id obj = param[key];
//                //        if ([obj isKindOfClass:[UIImage class]] ||
//                //            [obj isKindOfClass:[NSArray class]]) {
//                //            [myFileParams setObject:obj forKey:key];
//                //        }
//                if ([obj isKindOfClass:[JXHTTPFile class]]) {
//                    [myFileParams setObject:obj forKey:key];
//                }
//            }
//
//            NSMutableDictionary *myBodyParams = [NSMutableDictionary dictionaryWithDictionary:param];
//            [myBodyParams removeObjectsForKeys:myFileParams.allKeys];
//
//
//            NSURL *url = [NSURL exURLWithBase:self.baseURL.absoluteString path:path];
//            NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url.absoluteString parameters:myBodyParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//                for (NSString *key in myFileParams.allKeys) {
//                    //            id obj = myFileParams[key];
//                    //            if ([obj isKindOfClass:[UIImage class]]) {
//                    //                [formData appendPartWithFileData:UIImagePNGRepresentation(obj)
//                    //                                            name:key
//                    //                                        fileName:@"image.png"
//                    //                                        mimeType:@"image/png"];
//                    //            }else if ([obj isKindOfClass:[NSArray class]]) {
//                    //                for (id val in obj) {
//                    //                    if ([val isKindOfClass:[UIImage class]]) {
//                    //                        [formData appendPartWithFileData:UIImagePNGRepresentation(val)
//                    //                                                    name:key
//                    //                                                fileName:@"image.png"
//                    //                                                mimeType:@"image/png"];
//                    //                    }
//                    //                }
//                    //            }
//
//                    id obj = myFileParams[key];
//                    if ([obj isKindOfClass:[JXHTTPFile class]]) {
//                        JXHTTPFile *file = obj;
//                        [formData appendPartWithFileData:file.data
//                                                    name:file.arg
//                                                fileName:file.name
//                                                mimeType:file.type];
//                    }
//                }
//            } error:nil];
//
//
//            //            for (NSString *key in headerParams.allKeys) {
//            //                [request addValue:headerParams[key] forHTTPHeaderField:key];
//            //            }
//
////            // YJX_LIB 优化
////            if (gUser.token.length != 0) {
////                [request addValue:gUser.token forHTTPHeaderField:@"token"];
////            }
//
//            NSDictionary *headers = [self commonHeaders];
//            for (id key in headers.allKeys) {
//                [request addValue:headers[key] forHTTPHeaderField:key];
//            }
//
//            NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//            sessionConfig.timeoutIntervalForRequest  = 60;
//
//            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfig];
//
//
//            //if (JXHTTPResponseContentTypeJSON == responseContentType) {
//            manager.responseSerializer = [AFJSONResponseSerializer serializer];
//            //}
//
//            // NSProgress *pg = nil;
//            NSURLSessionUploadTask *task = [manager uploadTaskWithStreamedRequest:request progress:NULL completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//                if (!error) {
//                    JXLogDebug(@"响应【成功】-> %@：\n%@", path, responseObject);
//                    [subscriber sendNext:responseObject];
//                    [subscriber sendCompleted];
//                }else {
//                    JXLogError(@"响应【失败】-> %@：\n%@", path, error);
//                    [[RACScheduler currentScheduler] afterDelay:kJXHTTPRetryDelay schedule:^{
//                        [subscriber sendError:error];
//                    }];
//                }
//            }];
//
//            //            JXHTTPClient *client = [JXHTTPClient sharedInstance];
//            //            client.progress = progress;
//            //            //[pg addObserver:client forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
//
//            [task resume];
//
//            //            switch (schema.requestMethodType) {
//            //                case JXHTTPRequestMethodTypeGet: {
//            //                    //                    operation = [self GET:path parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//            //                    //                        JXLogDebug(@"响应【成功】-> %@：\n%@", path, responseObject);
//            //                    //                        [subscriber sendNext:responseObject];
//            //                    //                        [subscriber sendCompleted];
//            //                    //                    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//            //                    //                        JXLogError(@"响应【失败】-> %@：\n%@", path, error);
//            //                    //                        [[RACScheduler currentScheduler] afterDelay:kJXHTTPRetryDelay schedule:^{
//            //                    //                            [subscriber sendError:error];
//            //                    //                        }];
//            //                    //                    }];
//            //
//            //                    task = [self GET:path parameters:param progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            //                        JXLogDebug(@"响应【成功】-> %@：\n%@", path, responseObject);
//            //                        [subscriber sendNext:responseObject];
//            //                        [subscriber sendCompleted];
//            //                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            //                        JXLogError(@"响应【失败】-> %@：\n%@", path, error);
//            //                        [[RACScheduler currentScheduler] afterDelay:kJXHTTPRetryDelay schedule:^{
//            //                            [subscriber sendError:error];
//            //                        }];
//            //                    }];
//            //                }
//            //                    break;
//            //                case JXHTTPRequestMethodTypePost: {
//            //                    //                    operation = [self POST:path parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//            //                    //                        JXLogDebug(@"响应【成功】-> %@：\n%@", path, responseObject);
//            //                    //                        [subscriber sendNext:responseObject];
//            //                    //                        [subscriber sendCompleted];
//            //                    //                    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//            //                    //                        JXLogError(@"响应【失败】-> %@：\n%@", path, error);
//            //                    //                        [[RACScheduler currentScheduler] afterDelay:kJXHTTPRetryDelay schedule:^{
//            //                    //                            [subscriber sendError:error];
//            //                    //                        }];
//            //                    //                    }];
//            //
//            //                    task = [self POST:path parameters:param progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            //                        JXLogDebug(@"响应【成功】-> %@：\n%@", path, responseObject);
//            //                        [subscriber sendNext:responseObject];
//            //                        [subscriber sendCompleted];
//            //                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            //                        JXLogError(@"响应【失败】-> %@：\n%@", path, error);
//            //                        [[RACScheduler currentScheduler] afterDelay:kJXHTTPRetryDelay schedule:^{
//            //                            [subscriber sendError:error];
//            //                        }];
//            //                    }];
//            //                }
//            //                    break;
//            //                default:
//            //                    break;
//            //            }
//        }
//
//        return [RACDisposable disposableWithBlock:^{
//            //[operation cancel];
//            [task cancel];
//        }];
//    }] retry:kJXHTTPRetryTimes];
//}

//- (NSDictionary *)commonHeaders {
//    return nil;
//}
//
//- (NSDictionary *)commonQueries {
//    return nil;
//}

//- (RACSignal *)requestWithPath:(NSString *)path param:(NSDictionary *)param schema:(JXHTTPSchema *)schema class:(Class)cls retry:(NSInteger)retry {
//    // YJX_LIB 网路重试
//    //    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
//    //        if (retryTimes > 0) {
//    //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kJXRetryDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    //                [JXHTTPClient sendBaseRequestWithBaseURLString:baseURLString pathURLString:pathURLString methodType:methodType requestContentType:requestContentType responseContentType:responseContentType pathVariable:pathVariable urlParams:urlParams headerParams:headerParams bodyParams:bodyParams retryTimes:(retryTimes - 1) success:success failure:failure];
//    //            });
//    //        }else {
//    //            if (failure) {
//    //                failure(nil, [NSError exErrorWithCode:JXErrorCodeNetworkException]);
//    //            }
//    //        }
//    //        return nil;
//    //    }
//
//    JXLogDebug(@"重试1");
//
//    static int times = 10;
//    if (times > 0) {
//        --times;
////        // return [RACSignal error:[NSError jx_errorWithCode:JXErrorCodeServerException]];
////        return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
////            int bbb = times;
////            if (0 == times) {
////                [subscriber sendNext:@1];
////            }else {
////                [subscriber sendError:[NSError jx_errorWithCode:JXErrorCodeSessionInvalid]];
////            }
////
//////            return [RACDisposable disposableWithBlock:^{
//////            }];
////            return nil;
////        }] delay:0.001];
//
//
//        return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            id a = [RACScheduler currentScheduler];
//            id b = [RACScheduler mainThreadScheduler];
//            JXLogDebug(@"重试2");
//            int bbb = times;
//            if (0 == times) {
//                [subscriber sendNext:@1];
//            }else {
//                [[RACScheduler currentScheduler] afterDelay:kJXHTTPRetryDelay schedule:^{
//                    [subscriber sendError:[NSError jx_errorWithCode:JXErrorCodeSessionInvalid]];
//                }];
//            }
//            return [RACDisposable disposableWithBlock:^{
//            }];
//        }] retry:kJXHTTPRetryTimes];
//
//        // return [RACSignal empty];
//    }
//
//    self.schema = schema;
//
//    // JXLogDebug(@"请求 -> %@\nurlParams = %@\nheaderParams = %@\nbodyParams = %@", pathURLString, urlParams, headerParams, bodyParams);
//    JXLogDebug(@"请求 -> %@\nparam = %@", path, param);
//
//    @weakify(self)
//    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        @strongify(self)
//        AFHTTPRequestOperation *operation = nil;
//
////        if (retry > 0 ) {
////            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////                JXLogInfo(@"aaaaaa");
////                [self requestWithPath:path param:param schema:schema class:cls retry:(retry - 1)];
////            });
////        }else {
//            switch (schema.requestMethodType) {
//                case JXHTTPRequestMethodTypeGet: {
//                    operation = [self GET:path parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//                        JXLogDebug(@"响应【成功】-> %@：\n%@", path, responseObject);
//                        [subscriber sendNext:responseObject];
//                        [subscriber sendCompleted];
//                    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//                        JXLogError(@"响应【失败】-> %@：\n%@", path, error);
//                        [subscriber sendError:error];
//                    }];
//                }
//                    break;
//                case JXHTTPRequestMethodTypePost: {
//
//                }
//                    break;
//                default:
//                    break;
//            }
//        //}
//        return [RACDisposable disposableWithBlock:^{
//            [operation cancel];
//        }];
//    }];
//}


//- (void)handleResponse:(id)response subscriber:(id<RACSubscriber>)subscriber class:(Class)cls {
//    HTTPResponseBase *base = [HTTPResponseBase mj_objectWithKeyValues:response];
//    if (kHTTPResponseSuccess != base.code) {
//        [subscriber sendError:[NSError exErrorWithCode:base.code description:base.msg]];
//        return;
//    }
//
//    id data = [response objectForKey:JXWebAPIServiceImplDataKey];
//    id obj = data;
//
//    if (cls) {
//        if ([data isKindOfClass:[NSDictionary class]]) {
//            obj = [cls mj_objectWithKeyValues:data];
//        }else if ([data isKindOfClass:[NSArray class]]) {
//            obj = [cls mj_objectArrayWithKeyValuesArray:data];
//        }
//    }
//
//    //    if ([cls isSubclassOfClass:NSManagedObject.class]) {
//    ////        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
//    ////        NSArray *fetchedObjects = [_coreDataHelper.context executeFetchRequest:request error:nil];
//    ////        for (Item *item in fetchedObjects) {
//    ////            [_coreDataHelper.context deleteObject:item];
//    ////        }
//    //       // NSString *bb = NSStringFromClass(cls);
//    //
//    //    }else if (!cls) {
//    //        if ([data isKindOfClass:[NSDictionary class]]) {
//    //            obj = [cls mj_objectWithKeyValues:data];
//    //        }else if ([data isKindOfClass:[NSArray class]]) {
//    //            obj = [cls mj_objectArrayWithKeyValuesArray:data];
//    //        }
//    //    }else {
//    //        obj = data;
//    //    }
//
//    if (cls && [obj isKindOfClass:[NSNull class]]) {
//        [subscriber sendError:[NSError exErrorWithCode:JXErrorCodeServerException]];
//    }else {
//        [subscriber sendNext:obj];
//        [subscriber sendCompleted];
//    }
//}
//
//- (void)handleError:(NSError *)error subscriber:(id<RACSubscriber>)subscriber {
//    if (3840 == error.code ||
//        -1011 == error.code) {
//        error = [NSError exErrorWithCode:JXErrorCodeServerException];
//    }
//    // YJX_TODO 登录失效的error
//    [subscriber sendError:error];
//}


//+ (instancetype)sharedInstance {
//    static id instance;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[[self class] alloc] init];
//    });
//    return instance;
//}
@end
