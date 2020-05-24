//
//  ChatHistory.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/12.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXObject.h"

//"id": 3000,
//"sdkAppId": null,
//"command": null,
//"cllientIp": null,
//"platform": "iOS",
//"fromAccount": "A28",
//"toAccount": "Game-主任医师",
//"msgBody": "[{\"MsgContent\":{\"Text\":\"呵呵哈哈哈\"},\"MsgType\":\"TIMTextElem\"}]",
//"receiveTime": "2017-05-17 16:37:18",
//"userName": null,
//"mobile": null,
//"signTime": null,
//"doctorId": 409,
//"headimgurl": null,
//"doctorName": null,
//"context": "呵呵哈哈哈",
//"fromValue": "A28"

@interface ChatHistory : JXObject
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *fromAccount;
@property (nonatomic, copy) NSString *toAccount;
@property (nonatomic, copy) NSString *msgBody;
@property (nonatomic, copy) NSString *receiveTime;
@property (nonatomic, copy) NSString *context;

@end
