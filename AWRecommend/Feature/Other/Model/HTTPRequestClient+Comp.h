//
//  HTTPRequestClient+Comp.h
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "HTTPRequestClient.h"
#import "CompQuote.h"
#import "CompClassify.h"
#import "CompResultList.h"
#import "CompResultDetail.h"
#import "SearchClassify.h"
#import "FilterSymptom.h"
#import "FilterName.h"
#import "ScanResult.h"

@interface HTTPRequestClient (Comp)
- (RACSignal *)getKnowledgeLibInfo;
- (RACSignal *)showHotWords;
- (RACSignal *)queryDrugDatasWithType:(NSInteger)type kind:(SearchKind)kind;
- (RACSignal *)queryDiseaseBySuitObjectId:(NSInteger)uid;
- (RACSignal *)queryDrugBySuitObjectId:(NSInteger)uid;
- (RACSignal *)getSearchSuggestWithKeyword:(NSString *)keyword;
- (RACSignal *)getPageGroupBySocNameWithKeyword:(NSString *)keyword socName:(NSString *)socName page:(NSInteger)page rows:(NSInteger)rows natureType:(NSString *)natureType;
- (RACSignal *)getPageGroupBySocName2WithKeyword:(NSString *)keyword socName:(NSString *)socName page:(NSInteger)page rows:(NSInteger)rows natureType:(NSString *)natureType;
- (RACSignal *)drugDescriptionWithDrugId:(NSInteger)drugId;
- (RACSignal *)drugDetailWithBrandId:(NSInteger)brandId;
- (RACSignal *)addDrugBrowseRecord:(NSString *)dName;
- (RACSignal *)queryDrugCategory;
- (RACSignal *)getCodeData:(NSString *)codeNum;
- (RACSignal *)addUserSeggestionsWithBarcode:(NSString *)barcode brandName:(NSString *)brandName drugName:(NSString *)drugName phone:(NSString *)phone;
- (RACSignal *)searchThroughDiseases:(NSDictionary *)jsonDict;

@end
