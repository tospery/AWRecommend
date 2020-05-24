//
//  ScanResult.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/8.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXObject.h"

@class ScanResultDesc;
@class ScanResultDescBrand;
@class ScanResultBrand;


@interface ScanResult : JXObject
@property (nonatomic, assign) NSInteger resultDataType; // 0后台服务，1第三方
@property (nonatomic, strong) ScanResultDesc *drugDescriptionDto;
@property (nonatomic, strong) ScanResultBrand *drugBrandCodeDto;

@end

// 我们的后台
@interface ScanResultDesc : JXObject
@property (nonatomic, copy) NSString *chMedTag;
@property (nonatomic, copy) NSString *baseMedTag;
@property (nonatomic, copy) NSString *patentRightTag;

@property (nonatomic, assign) NSInteger brandId;
@property (nonatomic, copy) NSString *brandName;

@property (nonatomic, assign) CGFloat dSafety;
@property (nonatomic, assign) CGFloat dStability;
@property (nonatomic, assign) NSInteger drugId;
@property (nonatomic, assign) NSInteger natureType;
@property (nonatomic, assign) NSInteger searchCount;
@property (nonatomic, assign) NSInteger brandCount;
@property (nonatomic, assign) NSInteger buyChannelCount;
@property (nonatomic, assign) NSInteger ddd;
@property (nonatomic, copy) NSString *drugName;
@property (nonatomic, copy) NSString *durgPrescription;
@property (nonatomic, copy) NSString *indication;
@property (nonatomic, copy) NSString *pharmacistGuide;
@property (nonatomic, copy) NSString *ingredient;
@property (nonatomic, copy) NSString *attention;
@property (nonatomic, copy) NSString *reaction;
@property (nonatomic, copy) NSString *contraindication;
@property (nonatomic, copy) NSString *interactions;
@property (nonatomic, copy) NSString *dbdName;
@property (nonatomic, strong) NSArray *drugBandDtoList;

@end

@interface ScanResultDescBrand : JXObject
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) NSInteger brandId;
@property (nonatomic, assign) NSInteger monthAmount;
@property (nonatomic, assign) NSInteger satisfaceionRate;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *brandImg;
@property (nonatomic, copy) NSString *safety;
@property (nonatomic, copy) NSString *factory;

@property (nonatomic, copy) NSString *chMedTag;
@property (nonatomic, copy) NSString *baseMedTag;
@property (nonatomic, copy) NSString *patentRightTag;
@property (nonatomic, copy) NSString *ddd;

@end


// 第三方
@interface ScanResultBrand : JXObject
@property (nonatomic, copy) NSString *dbdName;
@property (nonatomic, copy) NSString *dbdFactoryName;
@property (nonatomic, copy) NSString *dbdBrandName;
@property (nonatomic, copy) NSString *dbdCode;
@property (nonatomic, copy) NSString *dbdImgUrl;
@property (nonatomic, copy) NSString *dbdSpec;
@property (nonatomic, copy) NSString *goodstype;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *engname;
@property (nonatomic, copy) NSString *ycg;
@property (nonatomic, copy) NSString *trademark;
@property (nonatomic, copy) NSString *kd;
@property (nonatomic, copy) NSString *gd;
@property (nonatomic, copy) NSString *sd;
@property (nonatomic, copy) NSString *dbdCreateTime;

@end




