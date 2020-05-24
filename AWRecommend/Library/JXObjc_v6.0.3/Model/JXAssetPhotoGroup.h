//
//  JXAssetPhotoGroup.h
//  JXObjc
//
//  Created by 杨建祥 on 16/1/14.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface JXAssetPhotoGroup : NSObject
@property (nonatomic, assign, readonly) NSInteger numberOfPhotos;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *type;
@property (nonatomic, strong, readonly) NSString *persistentID;
@property (nonatomic, strong, readonly) NSString *url;
@property (nonatomic, strong, readonly) UIImage *posterImage;

- (instancetype)initWithAssetsGroup:(ALAssetsGroup *)assetsGroup;

- (void)fetchPhotosWithStartBlock:(void(^)())startBlock
                  completionBlock:(void(^)(NSArray *groups))completionBlock;
@end
