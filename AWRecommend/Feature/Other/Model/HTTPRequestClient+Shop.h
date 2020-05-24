//
//  HTTPRequestClient+Shop.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/8/7.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "HTTPRequestClient.h"
#import "OrderPendingAmount.h"
#import "MessageList.h"
#import "FavoriteLP.h"
#import "OrderDetailData.h"
#import "Mytest.h"
#import "MytestResult.h"

@interface HTTPRequestClient (Shop)
- (RACSignal *)getOrderStateNumber;
- (RACSignal *)orderPay:(NSString *)orderSn cash:(NSInteger)cash type:(NSInteger)type;
- (RACSignal *)listMessagesByPage:(NSInteger)page;
- (RACSignal *)checkReadInfo;
- (RACSignal *)removeMessageById:(NSInteger)messageId;
- (RACSignal *)getCartGoodsNum;
- (RACSignal *)createByAccountAddress:(NSDictionary *)input;
- (RACSignal *)updateByAccountAddress:(NSDictionary *)input;
- (RACSignal *)listGoodsCollect;
- (RACSignal *)removeGoodsCollect:(NSInteger)goodsId sceneId:(NSInteger)sceneId;
- (RACSignal *)getOrderParticular:(NSString *)orderId;
- (RACSignal *)addComments:(NSString *)orderId list:(NSArray *)list;
- (RACSignal *)addCommentsForMac:(NSDictionary *)input;
- (RACSignal *)listItemBank;
- (RACSignal *)saveEvaluate:(NSString *)physiqueName fractionJson:(NSString *)fractionJson;
- (RACSignal *)listOldEvaluate;

@end
