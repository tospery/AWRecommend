//
//  HTTPRequestClient+Nice.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/14.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "HTTPRequestClient.h"
#import "NiceList.h"
#import "NiceComment.h"
#import "NiceCommentList.h"
#import "FavoriteArticle.h"

@interface HTTPRequestClient (Nice)
- (RACSignal *)showArticleListWithPage:(NSInteger)page;
- (RACSignal *)showArticleDetalis:(NSInteger)niceID;
- (RACSignal *)selectCommmentWithPage:(NSInteger)page articleId:(NSInteger)articleId;
- (RACSignal *)addComment:(NSInteger)articleId comment:(NSString *)comment;
- (RACSignal *)collectArticle:(NSInteger)articleId;
- (RACSignal *)praiseArticle:(NSInteger)articleId;
- (RACSignal *)showCollectionList:(NSInteger)page;
- (RACSignal *)selectCommmentListForAPP:(NSInteger)articleId commentId:(NSInteger)commentId offset:(NSInteger)offset;

@end
