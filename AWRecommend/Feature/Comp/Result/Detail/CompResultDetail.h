//
//  CompResultDetail.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/10.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXObject.h"

@class CompResultDetailIntro;

@interface CompResultDetail : JXArchiveObject
@property (nonatomic, copy) NSString *graphicDetails;
@property (nonatomic, strong) CompResultDetailIntro *wiseDrugBrandInstructionsDto;
@property (nonatomic, strong) NSArray *instructionImgList;
@property (nonatomic, strong) NSArray *drugPriceList;
@property (nonatomic, assign) BOOL favorite;

@property (nonatomic, copy) NSString *fTime;

@end

@interface CompResultDetailIntro : JXArchiveObject
@property (nonatomic, assign) NSInteger dbdId;
@property (nonatomic, copy) NSString *dbiName;
@property (nonatomic, copy) NSString *dbiFactory;
@property (nonatomic, copy) NSString *dbiApprovalNumber;
@property (nonatomic, copy) NSString *dbiExpireDate;
@property (nonatomic, copy) NSString *dbiIngredient;
@property (nonatomic, copy) NSString *dbiProperty;
@property (nonatomic, copy) NSString *dbiSpec;
@property (nonatomic, copy) NSString *dbiIndication;
@property (nonatomic, copy) NSString *dbiReaction;
@property (nonatomic, copy) NSString *dbiAttention;
@property (nonatomic, copy) NSString *dbiContraindication;
@property (nonatomic, copy) NSString *dbiDrugInteractions;

@end

@interface CompResultDetailPrice : JXArchiveObject
@property (nonatomic, assign) CGFloat dddp;
@property (nonatomic, copy) NSString *dosage;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *drugName;
@property (nonatomic, copy) NSString *spec;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, strong) NSArray *dbSpecBuyList;

@end

@interface CompResultDetailBrand : JXArchiveObject
@property (nonatomic, assign) CGFloat platformPrice;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *drugName;
@property (nonatomic, copy) NSString *spec;
@property (nonatomic, copy) NSString *platformName;
@property (nonatomic, strong) NSArray *pfShopList;

@end


@interface CompResultDetailShop : JXArchiveObject
@property (nonatomic, assign) CGFloat platformPrice;
@property (nonatomic, copy) NSString *spec;
@property (nonatomic, copy) NSString *platfromShop;
@property (nonatomic, copy) NSString *buyUrl;
@property (nonatomic, assign) CGFloat dddp;

@end




