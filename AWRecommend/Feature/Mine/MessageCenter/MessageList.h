//
//  MessageList.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/8/17.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "HTTPResponseList.h"

@interface MessageList : HTTPResponseList

@end


@interface Message : JXObject
@property (nonatomic, assign) NSInteger isRead; // 1未读，2已读
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *parseTime;

@end
