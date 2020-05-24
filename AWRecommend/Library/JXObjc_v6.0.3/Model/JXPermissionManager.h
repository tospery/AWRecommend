//
//  JXPermissionManager.h
//  JXObjc
//
//  Created by 杨建祥 on 16/1/19.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXPermissionManager : NSObject
/**
 *  获取本地通知权限
 */
+ (void)acquireLocalNotification;
+ (void)acquireLocation;

+ (void)acquireMicrophone;
+ (void)acquireCamera;
+ (void)acquirePhotoAlbum;

+ (BOOL)hasCamera;

@end
