//
//  JXPermissionManager.m
//  JXObjc
//
//  Created by 杨建祥 on 16/1/19.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import "JXPermissionManager.h"
#import "JXObjc.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/PHPhotoLibrary.h>

JXLocationManager *lManager;

@implementation JXPermissionManager
+ (void)acquireLocalNotification {
    if (JXiOSVersionGreaterThanOrEqual(@"8.0")) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
}

+ (void)acquireMicrophone {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
    }];
}

+ (void)acquireCamera {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
    }];
}

+ (void)acquirePhotoAlbum {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
    }];
}

+ (void)acquireLocation {
    if (JXiOSVersionGreaterThanOrEqual(@"8.0")) {
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        [locationManager requestWhenInUseAuthorization];
        return;
    }
    
    if (!lManager) {
        lManager = [[JXLocationManager alloc] init];
        // lManager.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    }
    
    [[lManager locateSignal] subscribeNext:^(id  _Nullable x) {
        
    } error:^(NSError * _Nullable error) {
        
    }];
    // [lManager startLocatingWithSuccess:NULL failure:NULL];
}

+ (BOOL)hasCamera {
    BOOL has = YES;
    AVAuthorizationStatus permission =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (permission) {
            case AVAuthorizationStatusAuthorized: {
                has = YES;
                break;
            }
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted: {
                has = NO;
                break;
            }
            case AVAuthorizationStatusNotDetermined: {
                has = YES;
                break;
            }
        default:
            break;
    }
    
    return has;
}
@end
