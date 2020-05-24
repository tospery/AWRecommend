//
//  JXPayManager.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/8/10.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMengUShare/WXApi.h>

@protocol JXPayManagerDelegate <NSObject>
@optional
- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;
- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request;
- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;
- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;
- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response;
- (void)managerDidRecvPayResp:(PayResp *)response;

@end

@protocol JXAliPayManagerDelegate <NSObject>
@optional
- (void)didRecvPayResp:(NSDictionary *)response;

@end

@interface JXPayManager : NSObject <WXApiDelegate>
@property (nonatomic, weak) id<JXPayManagerDelegate> delegate;
@property (nonatomic, weak) id<JXAliPayManagerDelegate> aliDelegate;

- (void)handleAlipay:(NSDictionary *)result;

+ (instancetype)sharedInstance;
@end



