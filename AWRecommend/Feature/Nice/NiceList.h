//
//  NiceList.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/14.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "HTTPResponseList.h"

@class Nice;

@interface NiceList : HTTPResponseList

@end

@interface Nice : JXObject
@property (nonatomic, assign) BOOL top;
@property (nonatomic, assign) BOOL expired;
@property (nonatomic, assign) NSInteger scanNum;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *articleTitle;
@property (nonatomic, copy) NSString *classify;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *tileImage;
@property (nonatomic, copy) NSString *priceRemark;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, copy) NSString *classifyImage;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSString *phone;


@property (nonatomic, assign) BOOL articleIsTop;
@property (nonatomic, assign) BOOL articleIsExpired;
@property (nonatomic, assign) BOOL articleAcessType;
@property (nonatomic, assign) BOOL deleteTag;
@property (nonatomic, assign) BOOL myFavorite;
@property (nonatomic, assign) BOOL myAppreciate;
@property (nonatomic, assign) NSInteger articlePageviews;
@property (nonatomic, assign) NSInteger articleAppreciateNumber;
@property (nonatomic, assign) NSInteger articleFavoriteNumbers;
@property (nonatomic, assign) NSInteger articleCommentsNumbers;
@property (nonatomic, copy) NSString *articlePrice;
@property (nonatomic, copy) NSString *articlePriceRemark;
@property (nonatomic, copy) NSString *articleSource;
@property (nonatomic, copy) NSString *articlePublishDate;
@property (nonatomic, copy) NSString *articleTitleImage;
@property (nonatomic, copy) NSString *articleAuthor;
@property (nonatomic, copy) NSString *discountStartTime;
@property (nonatomic, copy) NSString *discountEndTime;
@property (nonatomic, copy) NSString *articleContext;
@property (nonatomic, copy) NSString *articleAcessWay;
@property (nonatomic, strong) NSArray *detailsImages;
@property (nonatomic, strong) NSArray *articleDetailsImages;
@property (nonatomic, strong) NSArray *wiseExcellentArticleRelatedDiscountDtos;
@property (nonatomic, strong) NSArray *wiseExcellentTagsDtos;
@property (nonatomic, strong) NSArray *wiseExcellentArticleBuyAcessDtos;

@end


//"id": 7,
//"articleTitleImage": "http://img-test.appvworks.com/6812e180eda84599b4a71f94c740d212",
//"articleTitle": "特殊医疗",
//"articlePrice": "30~50/人",
//"articlePriceRemark": "限时免费"
@interface NiceRelate : JXObject
@property (nonatomic, copy) NSString *articleTitleImage;
@property (nonatomic, copy) NSString *articleTitle;
@property (nonatomic, copy) NSString *articlePrice;
@property (nonatomic, copy) NSString *articlePriceRemark;

@end

@interface NiceTag : JXObject
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *name;

@end

@interface NiceBuy : JXObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;

@end

