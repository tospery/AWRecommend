//
//  FavoriteArticle.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/23.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "FavoriteArticle.h"

@implementation FavoriteArticleList
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"currPage": @"currentPage",
             @"totalPage": @"totalPages",
             @"totalSize": @"totalRows",
             @"datas": @"data"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"datas": [FavoriteArticle class]};
}

@end

@implementation FavoriteArticle

@end
