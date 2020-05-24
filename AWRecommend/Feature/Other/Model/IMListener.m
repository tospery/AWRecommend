//
//  IMListener.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/5.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "IMListener.h"

@implementation IMListener
#pragma mark - TIMMessageListener
- (void)onNewMessage:(NSArray *)msgs {
//    int a = 0;
//    for (TIMMessage *message in msgs) {
//        int cnt = [message elemCount];
//        
//        for (int i = 0; i < cnt; i++) {
//            TIMElem * elem = [message getElem:i];
//            
//            if ([elem isKindOfClass:[TIMTextElem class]]) {
//                TIMTextElem * text_elem = (TIMTextElem * )elem;
//            }
//            else if ([elem isKindOfClass:[TIMImageElem class]]) {
//                TIMImageElem * image_elem = (TIMImageElem * )elem;
//            }
//        }
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyChatDidReceive object:msgs];
}

#pragma mark - TIMConnListener
- (void)onConnSucc {
    
}

- (void)onConnFailed:(int)code err:(NSString*)err {
    
}

- (void)onDisconnect:(int)code err:(NSString*)err {
    
}

- (void)onConnecting {
    
}

#pragma mark - TIMUserStatusListener
- (void)onForceOffline {
    
}

- (void)onReConnFailed:(int)code err:(NSString*)err {
    
}

- (void)onUserSigExpired {
    
}

+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

@end
