//
//  CompResultList.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/9.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "HTTPResponseList.h"

@class CompResultItem;
@class CompResultBrand;
@class CompResultSpec;

@interface CompResultList : HTTPResponseList
@property (nonatomic, assign) BOOL cellShow;
@property (nonatomic, copy) NSString *groupValue;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger chineseDrugCount;
@property (nonatomic, assign) NSInteger westernDrugCount;

@end


@interface CompResultItem : JXArchiveObject
@property (nonatomic, assign) NSInteger cellTotal;
@property (nonatomic, assign) NSInteger cellIndex;

@property (nonatomic, assign) NSInteger matchDegree;
@property (nonatomic, assign) NSInteger searchCount;
@property (nonatomic, assign) NSInteger brandCount;

@property (nonatomic, assign) CGFloat dSafety;
@property (nonatomic, assign) CGFloat dStability;

@property (nonatomic, assign) NSInteger dId;
@property (nonatomic, assign) NSInteger dcId;
@property (nonatomic, assign) double score;
@property (nonatomic, copy) NSString *dcName;
@property (nonatomic, copy) NSString *dName;
@property (nonatomic, copy) NSString *dNameAlias;
@property (nonatomic, copy) NSString *dIndicationKeys;
@property (nonatomic, copy) NSString *dNatureType;
@property (nonatomic, copy) NSString *dSocName;

@property (nonatomic, assign) NSInteger drugId;
@property (nonatomic, assign) NSInteger natureType;
@property (nonatomic, copy) NSString *drugName;
@property (nonatomic, copy) NSString *durgPrescription;
@property (nonatomic, copy) NSString *indication;
@property (nonatomic, copy) NSString *pharmacistGuide;
@property (nonatomic, copy) NSString *ingredient;
@property (nonatomic, copy) NSString *reaction;
@property (nonatomic, copy) NSString *contraindication;
@property (nonatomic, strong) NSArray *drugBandDtoList;

@property (nonatomic, assign) BOOL isExpansion1;
@property (nonatomic, assign) BOOL isExpansion2;
@property (nonatomic, assign) BOOL isExpansion3;
@property (nonatomic, assign) BOOL cantExpansion1;
@property (nonatomic, assign) BOOL cantExpansion2;
@property (nonatomic, assign) BOOL cantExpansion3;


@property (nonatomic, copy) NSString *attention;
@property (nonatomic, copy) NSString *interactions;
@property (nonatomic, copy) NSString *storage;
@property (nonatomic, assign) CGFloat ddd;
@property (nonatomic, assign) NSInteger buyChannelCount;


@end


@interface CompResultBrand : JXArchiveObject
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) NSInteger brandId;
@property (nonatomic, assign) NSInteger monthAmount;
@property (nonatomic, assign) NSInteger satisfaceionRate;
@property (nonatomic, copy) NSString *factory;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *brandImg;
@property (nonatomic, copy) NSString *drugName;
@property (nonatomic, copy) NSString *safety;
@property (nonatomic, strong) NSArray *dbspecDtoList;

@property (nonatomic, copy) NSString *chMedTag;
@property (nonatomic, copy) NSString *baseMedTag; // 基
@property (nonatomic, copy) NSString *patentRightTag;
@property (nonatomic, assign) CGFloat dddp;

@end


@interface CompResultSpec : JXArchiveObject
@property (nonatomic, assign) NSInteger specId;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, copy) NSString *spec;

@end





