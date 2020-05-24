//
//  JXAssetManager.h
//  JXObjc
//
//  Created by 杨建祥 on 16/1/14.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXAssetManager : NSObject
+ (JXAssetManager *)sharedInstance;

- (void)setupPhotoGroupBlocksWithStart:(void(^)())startBlock
                               success:(void(^)(NSArray *groups))successBlock
                               failure:(void(^)(NSError *error))failureBlock
                            completion:(void(^)())completionBlock;
- (void)fetchPhotoGroup;
@end

