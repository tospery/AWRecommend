//
//  HTTPRequestClient+Shop.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/8/7.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "HTTPRequestClient+Shop.h"

@implementation HTTPRequestClient (Shop)
- (RACSignal *)getOrderStateNumber {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/shop/order/getOrderStateNumber" param:param schema:[JXHTTPSchema schemaPost] class:[OrderPendingAmount class] tag:ApiTagNone isList:NO];
}

- (RACSignal *)orderPay:(NSString *)orderSn cash:(NSInteger)cash type:(NSInteger)type{
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    param.data = @{@"orderSn": orderSn,
                   @"cash": @(cash),
                   @"payWay": @(type),
                   @"type": @2};
    
    return [self requestWithPath:@"v1/shop/pay/order" param:param schema:[JXHTTPSchema schemaPost] class:nil tag:ApiTagNone isList:NO];
}

- (RACSignal *)listMessagesByPage:(NSInteger)page {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    param.data = @{@"pages": @(page),
                   @"rows": @(20)};
    
    return [self requestWithPath:@"v1/shop/message/listMessagesByPage" param:param schema:[JXHTTPSchema schemaPost] class:[MessageList class] tag:ApiTagNone isList:NO];
}

- (RACSignal *)checkReadInfo {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/shop/message/checkReadInfo" param:param schema:[JXHTTPSchema schemaPost] class:[NSNumber class] tag:ApiTagNone isList:NO];
}

- (RACSignal *)getCartGoodsNum {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/shop/cart/getCartGoodsNum" param:param schema:[JXHTTPSchema schemaPost] class:[NSNumber class] tag:ApiTagNone isList:NO];
}


- (RACSignal *)createByAccountAddress:(NSDictionary *)input {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    param.data = input;
    
    return [self requestWithPath:@"v1/shop/address/createByAccountAddress" param:param schema:[JXHTTPSchema schemaPostRawJSON2JSON] class:nil tag:ApiTagNone isList:NO];
}

- (RACSignal *)updateByAccountAddress:(NSDictionary *)input {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    param.data = input;
    
    return [self requestWithPath:@"v1/shop/address/updateByAccountAddress" param:param schema:[JXHTTPSchema schemaPostRawJSON2JSON] class:nil tag:ApiTagNone isList:NO];
}


- (RACSignal *)listGoodsCollect {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/shop/collect/listGoodsCollect" param:param schema:[JXHTTPSchema schemaPost] class:[FavoriteLP class] tag:ApiTagNone isList:YES];
}

- (RACSignal *)removeGoodsCollect:(NSInteger)goodsId sceneId:(NSInteger)sceneId {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    param.data = @{@"goodsId": @(goodsId),
                   @"sceneId": @(sceneId)};
    
    return [self requestWithPath:@"v1/shop/collect/removeGoodsCollect" param:param schema:[JXHTTPSchema schemaPost] class:nil tag:ApiTagNone isList:NO];
}

- (RACSignal *)getOrderParticular:(NSString *)orderId {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    param.data = @{@"orderId": orderId};
    
    return [self requestWithPath:@"v1/shop/order/getOrderParticular" param:param schema:[JXHTTPSchema schemaPost] class:[OrderDetail class] tag:ApiTagNone isList:NO];
}

- (RACSignal *)addComments:(NSString *)orderId list:(NSArray *)list {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    // param.query = @{@"orderId": orderId};
    param.data = list;
    
    NSString *path = JXStrWithFmt(@"v1/shop/comment/addComments?orderId=%ld", (long)orderId.integerValue);
    
//    JXHTTPSchema *schema = [[JXHTTPSchema alloc] init];
//    schema.methodType = JXHTTPRequestMethodTypePost;
//    schema.paramType = JXHTTPRequestParamTypeRawJSON;
//    schema.dataType = JXHTTPResponseDataTypeHTML;
    
    return [self requestWithPath:path param:param schema:[JXHTTPSchema schemaPostRawJSON2JSON] class:nil tag:ApiTagNone isList:NO];
}


- (RACSignal *)addCommentsForMac:(NSDictionary *)input {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    param.data = input;
    
    return [self requestWithPath:@"v1/shop/comment/addCommentsForMac" param:param schema:[JXHTTPSchema schemaPostRawJSON2JSON] class:[NSString class] tag:ApiTagNone isList:NO];
}

- (RACSignal *)listItemBank {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/shop/physicalExamination/listItemBank" param:param schema:[JXHTTPSchema schemaPost] class:[Mytest class] tag:ApiTagNone isList:YES];
}

- (RACSignal *)saveEvaluate:(NSString *)physiqueName fractionJson:(NSString *)fractionJson {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    param.data = @{@"physiqueName": physiqueName, @"fractionJson": fractionJson};
    
    return [self requestWithPath:@"v1/shop/physicalExamination/saveEvaluate" param:param schema:[JXHTTPSchema schemaPost] class:nil tag:ApiTagNone isList:NO];
}

- (RACSignal *)listOldEvaluate {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/shop/physicalExamination/listOldEvaluate" param:param schema:[JXHTTPSchema schemaPost] class:[MytestResult class] tag:ApiTagNone isList:YES];
}

@end






