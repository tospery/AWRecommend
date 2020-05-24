//
//  WebInteraction.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/8/8.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebInteractionData;

/********************************************
 {
 "code":1,
 "msg":"同步登录状态",
 "data":{
 "token":""
 }
 }
 
 {
 "code":101,
 "msg":"用户未登录"
 }
 
 {
 "code":102,
 "msg":"登录已过期，请重新登录"
 }
 
 {
 "code":180,
 "msg":"支付",
 "data":{
 "token":"",
 "orderId":"aaaaaabb",
 "price":13.7
 }
 }
 
 {
 "code":202,
 "msg":"好价详情",
 "data":{
 "token":"",
 "niceId":"aaaaaabb",
 "niceUrl":"http://www...."
 }
 }
 
 
 {
 "code":105,
 "msg":"购物车操作后数量",
 "data":{
 "cartCount":"39"
 }
 }
 
 code定义：
 1   app向web传递token
 *******************************************/

@interface WebInteraction : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) WebInteractionData *data;

@end

//{"code":120,"msg":"商品详情页-分享","data":{"id":10182,"title":"【太极】海氏海诺创可贴防水性","desc":"111","imgUrl":"http://img-test.appvworks.com/178c668688c6418ca5753fdc1f62a679"}}

@interface WebInteractionData : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) NSInteger cartCount;
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *imgUrl;

//@property (nonatomic, assign) NSInteger orderType;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger platform;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *niceId;
@property (nonatomic, copy) NSString *niceUrl;
@property (nonatomic, copy) NSString *token;


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









