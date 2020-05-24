//
//  MytestResult.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/12/11.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXArchiveObject.h"

//"id": 11,
//"buyerId": 107,
//"title": null,
//"physicalName": "血瘀质",
//"fractionJson": "{\"平和质\":71.428571428571431,\"湿热质\":0,\"气虚质\":0,\"血瘀质\":71.428571428571431,\"阳虚质\":25}",
//"goodsRecommendId": null,
//"createTime": "2017-12-11 13:05:18"

@interface MytestResult : JXArchiveObject
@property (nonatomic, assign) NSInteger buyerId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *physicalName;
@property (nonatomic, copy) NSString *fractionJson;
@property (nonatomic, copy) NSString *goodsRecommendId;
@property (nonatomic, copy) NSString *createTime;

@end
