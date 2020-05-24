//
//  FavoriteLP.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/10/31.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXObject.h"

//"collectId": 2,
//"buyerId": 107,
//"sceneId": 186,
//"goodsId": 10210,
//"goodsName": "氯雷他定片",
//"brandId": null,
//"brandName": "太极",
//"specId": null,
//"specName": null,
//"goodsSpecPrice": null,
//"goodsImage": "http://img-test.appvworks.com/26ff808ecbd544fca0e470dc1d8ea357",
//"goodsPrice": 2,
//"goodsSerial": "CCC111",
//"goodsValidStatus": false,
//"deleteStatus": false,
//"createDateTime": "2017-10-31 14:53:37",
//"updateDateTime": null

@interface FavoriteLP : JXObject
@property (nonatomic, assign) BOOL goodsValidStatus;
@property (nonatomic, assign) BOOL deleteStatus;
@property (nonatomic, assign) NSInteger collectId;
@property (nonatomic, assign) NSInteger buyerId;
@property (nonatomic, assign) NSInteger sceneId;
@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *brandId;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *specId;
@property (nonatomic, copy) NSString *specName;
@property (nonatomic, copy) NSString *goodsSpecPrice;
@property (nonatomic, copy) NSString *goodsImage;
@property (nonatomic, copy) NSString *goodsPrice;
@property (nonatomic, copy) NSString *goodsSerial;
@property (nonatomic, copy) NSString *goodsMarketPrice;
@property (nonatomic, copy) NSString *createDateTime;
@property (nonatomic, copy) NSString *updateDateTime;

@end










