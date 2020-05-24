//
//  OrderDetailData.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/11/3.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXObject.h"

@class OrderDetailData;


@interface OrderDetail : JXObject
@property (nonatomic, strong) OrderDetailData *detailData;
@property (nonatomic, strong) NSArray *stateData;
@property (nonatomic, strong) id expressInfos;

@end

@interface OrderDetailData : JXObject
@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, copy) NSString *orderSn;
@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, assign) NSInteger goodsAmount;
@property (nonatomic, assign) NSInteger orderPrice;
@property (nonatomic, assign) NSInteger shippingFree;
@property (nonatomic, assign) NSInteger orderState;
@property (nonatomic, assign) NSInteger payWay;
@property (nonatomic, copy) NSString *reciverName;
@property (nonatomic, copy) NSString *receiverPhone;
@property (nonatomic, copy) NSString *receiverAddress;
@property (nonatomic, copy) NSString *orderMessage;
@property (nonatomic, assign) NSInteger couponId;
@property (nonatomic, strong) NSArray *goods;

@end

@interface OrderDetailDataGoods : JXObject
@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, assign) NSInteger goodsSpecId;
@property (nonatomic, assign) CGFloat goodsPrice;
@property (nonatomic, assign) CGFloat goodsPayPrice;
@property (nonatomic, assign) NSInteger goodsNum;
@property (nonatomic, assign) NSInteger gcId;
@property (nonatomic, assign) NSInteger sceneId;
@property (nonatomic, copy) NSString *goodsSpecInfo;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *goodsImage;
@property (nonatomic, copy) NSString *goodsSpecSerial;
@property (nonatomic, copy) NSString *goodsSerial;
// 扩展
@property (nonatomic, copy) NSString *commentStar;
@property (nonatomic, copy) NSString *commentContent;
@property (nonatomic, strong) NSMutableArray *commentTagIds;
@property (nonatomic, strong) NSMutableArray *commentTagNames;

@end

@interface OrderStateData : JXObject
@property (nonatomic, assign) NSInteger orderState;
@property (nonatomic, copy) NSString *logTime;

@end















