//
//  FavoriteArticle.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/23.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "HTTPResponseList.h"

@interface FavoriteArticleList : HTTPResponseList

@end

@interface FavoriteArticle : JXObject
@property (nonatomic, copy) NSString *articleTitle;
@property (nonatomic, copy) NSString *classify;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, assign) BOOL top;
@property (nonatomic, assign) BOOL expired;
@property (nonatomic, copy) NSString *tileImage;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *priceRemark;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, assign) NSInteger scanNum;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, copy) NSString *classifyImage;

@end











