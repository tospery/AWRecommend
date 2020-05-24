//
//  JXVersionManager.h
//  MeijiaStore
//
//  Created by 杨建祥 on 16/1/12.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXVersionManager : NSObject
@property (nonatomic, strong, readonly) NSString *current;

- (void)checkUpdateWithAppID:(NSString *)appID
                   beginning:(void(^)())beginning
                  completion:(void(^)(BOOL updated, NSString *newVersion, NSString *releaseNote, NSString *openURL, NSError *error))completion;

+ (JXVersionManager *)sharedInstance;
@end
