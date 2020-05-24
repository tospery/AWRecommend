//
//  HTTPRequestClient+Comp.m
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "HTTPRequestClient+Comp.h"

@implementation HTTPRequestClient (Comp)
- (RACSignal *)getKnowledgeLibInfo {
    return [self requestWithPath:@"v1/drugindex/getKnowledgeLibInfo" param:nil schema:[JXHTTPSchema schemaPost] class:[CompQuote class] tag:ApiTagNone isList:NO];
}


- (RACSignal *)showHotWords {
    return [self requestWithPath:@"v1/words/showHotWords" param:nil schema:[JXHTTPSchema schemaPost] class:[NSString class] tag:ApiTagNone isList:YES];
}

- (RACSignal *)queryDrugDatasWithType:(NSInteger)type kind:(SearchKind)kind {
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"type": @(type),
                   @"kind": @(kind)};
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/drug/queryDrugDatas" param:param schema:[JXHTTPSchema schemaPost] class:[CompClassify class] tag:ApiTagNone isList:YES];
}

//{
//    "code": "string",
//    "loginType": 0,  // 1. app 2. 微信第三方
//    "mobile": "string",
//    "source": 0, // 1. app 2. 微信第三方
//    "weChatOpenid": "string" //
//}


- (RACSignal *)queryDiseaseBySuitObjectId:(NSInteger)uid {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"id": @(uid)};
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/drug/queryDiseaseBySuitObjectId" param:param schema:[JXHTTPSchema schemaPost] class:[FilterSymptom class] tag:ApiTagNone isList:YES];
}

- (RACSignal *)queryDrugBySuitObjectId:(NSInteger)uid {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"id": @(uid)};
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/drug/queryDrugBySuitObjectId" param:param schema:[JXHTTPSchema schemaPost] class:nil tag:ApiTagNone isList:NO];
}

- (RACSignal *)getSearchSuggestWithKeyword:(NSString *)keyword {
    JXCheck(keyword, JXArgErrSingal);
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"searchCond": keyword};
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/drugindex/getSearchSuggestThroughtES" param:param schema:[JXHTTPSchema schemaPost] class:[NSString class] tag:ApiTagNone isList:YES];
}

- (RACSignal *)getPageGroupBySocNameWithKeyword:(NSString *)keyword socName:(NSString *)socName page:(NSInteger)page rows:(NSInteger)rows natureType:(NSString *)natureType {
    JXCheck(keyword, JXArgErrSingal);
    JXCheck(@(page), JXArgErrSingal);
    JXCheck(@(rows), JXArgErrSingal);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:keyword forKey:@"keyword"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(rows) forKey:@"rows"];
    [params setObject:JXStrWithDft([JXDevice deviceUID], @"") forKey:@"terminalMark"];
    if (0 != socName.length) {
        [params setObject:socName forKey:@"socName"];
    }
    if (0 != natureType.length) {
        [params setObject:natureType forKey:@"natureType"];
    }
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = params;
    param.header = [param commonHeader];

    return [self requestWithPath:@"v1/drugindex/getPageGroupBySocNameThroughtES" param:param schema:[JXHTTPSchema schemaPost] class:[CompResultList class] tag:ApiTagNone isList:YES];
}

- (RACSignal *)searchThroughDiseases:(NSDictionary *)jsonDict {
    JXCheck(jsonDict, JXArgErrSingal);
    
    NSLog(@"%@", jsonDict);
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = jsonDict;
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/drug/searchThroughDiseases" param:param schema:[JXHTTPSchema schemaPostRawJSON2JSON] class:[CompResultList class] tag:ApiTagNone isList:YES];
}

- (RACSignal *)getPageGroupBySocName2WithKeyword:(NSString *)keyword socName:(NSString *)socName page:(NSInteger)page rows:(NSInteger)rows natureType:(NSString *)natureType{
    JXCheck(keyword, JXArgErrSingal);
    JXCheck(@(page), JXArgErrSingal);
    JXCheck(@(rows), JXArgErrSingal);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:keyword forKey:@"keyword"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(rows) forKey:@"rows"];
    [params setObject:JXStrWithDft([JXDevice deviceUID], @"") forKey:@"terminalMark"];
    if (0 != socName.length) {
        [params setObject:socName forKey:@"socName"];
    }
    if (0 != natureType.length) {
        [params setObject:natureType forKey:@"natureType"];
    }
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = params;
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/drugindex/getPageGroupByDNameThroughtES" param:param schema:[JXHTTPSchema schemaPost] class:[CompResultList class] tag:ApiTagNone isList:YES];
}

- (RACSignal *)drugDescriptionWithDrugId:(NSInteger)drugId {
    //JXCheck(@(drugId), JXArgErrSingal);
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"drugId": @(drugId)};
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/drugindex/drugDescription" param:param schema:[JXHTTPSchema schemaPost] class:[CompResultItem class] tag:ApiTagNone isList:NO];
}

- (RACSignal *)drugDetailWithBrandId:(NSInteger)brandId {
    JXCheck(@(brandId), JXArgErrSingal);
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"brandId": @(brandId)};
    param.header = [param commonHeader];

    return [self requestWithPath:@"v1/drugindex/drugDetail" param:param schema:[JXHTTPSchema schemaPost] class:[CompResultDetail class] tag:ApiTagNone isList:NO];
}

- (RACSignal *)addDrugBrowseRecord:(NSString *)dName {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"dName": JXStrWithDft(dName, @"")};
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/drugindex/addDrugBrowseRecord" param:param schema:[JXHTTPSchema schemaPost] class:[CompResultDetail class] tag:ApiTagNone isList:NO];
}

- (RACSignal *)queryDrugCategory {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/drug/queryDrugCategory" param:param schema:[JXHTTPSchema schemaPost] class:[SearchClassify class] tag:ApiTagNone isList:YES];
}

- (RACSignal *)getCodeData:(NSString *)code {
    JXCheck(code, JXArgErrSingal);
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"code": code};
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/scanCode/getCodeData" param:param schema:[JXHTTPSchema schemaPost] class:[ScanResult class] tag:ApiTagNone isList:NO];
}

- (RACSignal *)addUserSeggestionsWithBarcode:(NSString *)barcode brandName:(NSString *)brandName drugName:(NSString *)drugName phone:(NSString *)phone {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (0 != barcode.length) {
        [params setObject:barcode forKey:@"barcode"];
    }
    if (0 != brandName.length) {
        [params setObject:brandName forKey:@"brandName"];
    }
    if (0 != drugName.length) {
        [params setObject:drugName forKey:@"drugName"];
    }
    if (0 != phone.length) {
        [params setObject:phone forKey:@"phone"];
    }
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = params;
    param.header = [param commonHeader];

    return [self requestWithPath:@"v1/drug/addUserSeggestions" param:param schema:[JXHTTPSchema schemaPostRawJSON2JSON] class:nil tag:ApiTagNone isList:NO];
}

@end








