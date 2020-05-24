//
//  HTTPRequestClient+Nice.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/14.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "HTTPRequestClient+Nice.h"

@implementation HTTPRequestClient (Nice)
- (RACSignal *)showArticleListWithPage:(NSInteger)page {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"page": @(page),
                   @"rows": @(JXInstance.pageSize)};
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/excellent/showArticleList" param:param schema:[JXHTTPSchema schemaPost] class:[NiceList class] tag:ApiTagNone isList:NO];
}

- (RACSignal *)showArticleDetalis:(NSInteger)niceID {
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"articleId": @(niceID)};
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/excellent/showArticleDetalis" param:param schema:[JXHTTPSchema schemaPost] class:[Nice class] tag:ApiTagNone isList:NO];
}

- (RACSignal *)selectCommmentWithPage:(NSInteger)page articleId:(NSInteger)articleId {
    JXCheck(@(page), JXArgErrSingal);
    JXCheck(@(articleId), JXArgErrSingal);
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"page": @(page),
                   @"rows": @(JXInstance.pageSize), // YJX_TODO
                   @"articleId": @(articleId)};
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/excellent/selectCommmentList" param:param schema:[JXHTTPSchema schemaPost] class:[NiceCommentList class] tag:ApiTagNone isList:NO];
}

- (RACSignal *)addComment:(NSInteger)articleId comment:(NSString *)comment {
    JXCheck(@(articleId), JXArgErrSingal);
    JXCheck(comment, JXArgErrSingal);
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"articleId": @(articleId),
                   @"comment": comment};
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/excellent/addComment" param:param schema:[JXHTTPSchema schemaPost] class:nil tag:ApiTagNone isList:NO];
}

- (RACSignal *)collectArticle:(NSInteger)articleId {
    JXCheck(@(articleId), JXArgErrSingal);
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"articleId": @(articleId)};
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/excellent/collectArticle" param:param schema:[JXHTTPSchema schemaPost] class:nil tag:ApiTagNone isList:NO];
}

- (RACSignal *)praiseArticle:(NSInteger)articleId {
    JXCheck(@(articleId), JXArgErrSingal);
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"articleId": @(articleId)};
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/excellent/praiseArticle" param:param schema:[JXHTTPSchema schemaPost] class:nil tag:ApiTagNone isList:NO];
}

- (RACSignal *)showCollectionList:(NSInteger)page {
    JXCheck(@(page), JXArgErrSingal);
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"page": @(page),
                   @"rows": @(/*JXInstance.pageSize*/200)};
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/excellent/showCollectionList" param:param schema:[JXHTTPSchema schemaPost] class:[FavoriteArticleList class] tag:ApiTagFavoriteArticle isList:NO];
}

- (RACSignal *)selectCommmentListForAPP:(NSInteger)articleId commentId:(NSInteger)commentId offset:(NSInteger)offset {
    
    HTTPRequestParam *param = [[HTTPRequestParam alloc] init];
    param.data = @{@"articleId": @(articleId),
                   @"commentId": @(commentId), // YJX_TODO
                   @"offset": @(offset)};
    param.header = [param commonHeader];
    
    return [self requestWithPath:@"v1/excellent/selectCommmentListForAPP" param:param schema:[JXHTTPSchema schemaPost] class:[NiceCommentList class] tag:ApiTagNone isList:NO];
}
@end






