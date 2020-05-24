//
//  JXAssetPhoto.h
//  JXObjc
//
//  Created by 杨建祥 on 16/1/14.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface JXAssetPhoto : NSObject
- (instancetype)initWithAsset:(ALAsset *)asset;

@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, strong, readonly) UIImage *thumbnail;
@end

