//
//  JXAssetPickerController.h
//  JXObjc
//
//  Created by 杨建祥 on 16/1/14.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

/**
 *  媒体选择风格
 */
typedef NS_ENUM(NSInteger, JXAssetSheetMode){
    JXAssetSheetModeNone,
    JXAssetSheetModeOnlyPhoto,
    JXAssetSheetModeOnlyVideo,
    JXAssetSheetModeMedia
};

typedef NS_ENUM(NSInteger, JXAssetPickerMode){
    JXAssetPickerModeNone,
    JXAssetPickerModeTakePhoto,
    JXAssetPickerModeTakeVideo,
    JXAssetPickerModeAlbumPhoto,
    JXAssetPickerModeAlbumVideo,
    JXAssetPickerModeAlbumMedia
};

typedef void(^JXAssetPickerWillSuccessBlock)(UIImage *image, ALAsset *asset);
typedef void(^JXAssetPickerDidSuccessBlock)(UIImage *image, ALAsset *asset);
typedef void(^JXAssetPickerFailureBlock)(NSError *error);

@interface JXAssetPickerController : UIImagePickerController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
- (BOOL)setupWithMode:(JXAssetPickerMode)mode
          willSuccess:(JXAssetPickerWillSuccessBlock)willSuccess
           didSuccess:(JXAssetPickerDidSuccessBlock)didSuccess
              failure:(JXAssetPickerFailureBlock)failure;

@end
