//
//  Addr.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/9/19.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXObject.h"

//"pinyin": "beijing",
//"firstletter": "bj",
//"cityAdcode": "110100",
//"cityCode": "010",
//"name": "北京市",
//"provinceName": "北京市",
//"provinceAdcode": "110000"

@interface AddrCollect : JXObject
@property (nonatomic, strong) NSArray *Hot;
@property (nonatomic, strong) NSArray *A;
@property (nonatomic, strong) NSArray *B;
@property (nonatomic, strong) NSArray *C;
@property (nonatomic, strong) NSArray *D;
@property (nonatomic, strong) NSArray *E;
@property (nonatomic, strong) NSArray *F;
@property (nonatomic, strong) NSArray *G;
@property (nonatomic, strong) NSArray *H;
//@property (nonatomic, strong) NSArray *I;
@property (nonatomic, strong) NSArray *J;
@property (nonatomic, strong) NSArray *K;
@property (nonatomic, strong) NSArray *L;
@property (nonatomic, strong) NSArray *M;
@property (nonatomic, strong) NSArray *N;
//@property (nonatomic, strong) NSArray *O;
@property (nonatomic, strong) NSArray *P;
@property (nonatomic, strong) NSArray *Q;
@property (nonatomic, strong) NSArray *R;
@property (nonatomic, strong) NSArray *S;
@property (nonatomic, strong) NSArray *T;
//@property (nonatomic, strong) NSArray *U;
//@property (nonatomic, strong) NSArray *V;
@property (nonatomic, strong) NSArray *W;
@property (nonatomic, strong) NSArray *X;
@property (nonatomic, strong) NSArray *Y;
@property (nonatomic, strong) NSArray *Z;

@end

@interface Addr : JXObject
@property (nonatomic, copy) NSString *pinyin;
@property (nonatomic, copy) NSString *firstletter;
@property (nonatomic, copy) NSString *cityAdcode;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, copy) NSString *provinceAdcode;

@end


//{
//    "addressId":181,
//    "buyerId":107,
//    "trueName":"骆驼",
//    "provinceId":510000,
//    "cityId":28,
//    "areaId":510107,
//    "province":"string",
//    "city":"成都市",
//    "area":"武侯区",
//    "gpsAddress":"22,99",
//    "address":"天府大道中段1248号附近",
//    "houseNumber":"222楼1号",
//    "zipCode":null,
//    "mobPhone":"18981974113",
//    "telPhone":"18981974113",
//    "createTime":"2017-09-21 17:11:24",
//    "defaultStatus":false,
//    "deleteStatus":false
//}
@interface AddrInfo : NSObject
@property (nonatomic, assign) BOOL defaultStatus;
@property (nonatomic, copy) NSString *addressId;
@property (nonatomic, copy) NSString *trueName;
@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *areaId;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *gpsAddress;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *houseNumber;
@property (nonatomic, copy) NSString *mobPhone;


@end














