//
//  JXLocationManager.m
//  JXObjc
//
//  Created by 杨建祥 on 16/1/14.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import "JXLocationManager.h"
#import "JXObjc.h"

@interface JXLocationManager ()
@property (nonatomic, assign) BOOL flag;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) JXLocationSuccessBlock success;
@property (nonatomic, copy) JXLocationFailureBlock failure;

@property (nonatomic, strong) id<RACSubscriber> locateSubscriber;
@property (nonatomic, strong) id<RACSubscriber> geocodeSubscriber;

@end

@implementation JXLocationManager
#pragma mark - Private methods
- (void)dealloc {
    _locationManager = nil;
}

#pragma mark - Private methods
- (void)callbackIfNeedWithError:(NSError *)error {
    if (!_flag) {
        _flag = YES;
        if (_failure) {
            _failure(error);
        }
    }
}

- (void)genLocationManager {
    if(!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.delegate = self;
    }
    
    if (JXiOSVersionGreaterThanOrEqual(@"8.0")) {
        [_locationManager requestWhenInUseAuthorization];
    }
}

#pragma mark - Public methods
- (RACSignal *)locateSignal {
    if (![CLLocationManager locationServicesEnabled]) {
        return [RACSignal error:[NSError jx_errorWithCode:JXErrorCodeLocateClosed]];
    }
    [self genLocationManager];
    
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        self.locateSubscriber = subscriber;
        [self.locationManager startUpdatingLocation];
        
        return [RACDisposable disposableWithBlock:^{
            self.locateSubscriber = nil;
        }];
    }];
}

- (RACSignal *)geocodeSignalWithLocation:(CLLocation *)location {
    if (![CLLocationManager locationServicesEnabled]) {
        return [RACSignal error:[NSError jx_errorWithCode:JXErrorCodeLocateClosed]];
    }
    [self genLocationManager];
    
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        self.geocodeSubscriber = subscriber;

        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error) {
                if (self.geocodeSubscriber) {
                    [self.geocodeSubscriber sendError:error];
                }
            }else {
                if (placemarks.count > 0) {
                    CLPlacemark *placemark = [placemarks objectAtIndex:0];
                    if (self.geocodeSubscriber) {
                        [self.geocodeSubscriber sendNext:placemark];
                        [self.geocodeSubscriber sendCompleted];
                    }
                }else {
                    if (self.geocodeSubscriber) {
                        [self.geocodeSubscriber sendError:[NSError jx_errorWithCode:JXErrorCodeLocateFailure]];
                    }
                }
            }
        }];
        
        return [RACDisposable disposableWithBlock:^{
            self.geocodeSubscriber = nil;
        }];
    }];
}

- (void)startLocatingWithSuccess:(JXLocationSuccessBlock)success
                         failure:(JXLocationFailureBlock)failure{
    if (![CLLocationManager locationServicesEnabled]) {
        if (failure) {
            failure([NSError jx_errorWithCode:JXErrorCodeCommon description:kStringLocateClosed]);
        }
        return;
    }
    
    _success = success;
    _failure = failure;
    
    if(!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.delegate = self;
    }
    
    if (JXiOSVersionGreaterThanOrEqual(@"8.0")) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    _flag = NO;
    [_locationManager startUpdatingLocation];
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [_locationManager stopUpdatingLocation];
    
    CLLocation *newLocation = [locations lastObject];
    if (newLocation) {
        if (self.success) {
            self.success(newLocation);
        }
        
        if (self.locateSubscriber) {
            [self.locateSubscriber sendNext:newLocation];
            [self.locateSubscriber sendCompleted];
        }
    }else {
        [self callbackIfNeedWithError:[NSError jx_errorWithCode:JXErrorCodeLocateFailure]];
        
        if (self.locateSubscriber) {
            [self.locateSubscriber sendError:[NSError jx_errorWithCode:JXErrorCodeLocateFailure]];
        }
    }
    
    // 经纬度 -> 位置信息
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation: newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        if (error) {
//            [self callbackIfNeedWithError:error];
//        }else {
//            if (placemarks.count > 0) {
//                CLPlacemark *placemark = [placemarks objectAtIndex:0];
//                if (self.success) {
//                    self.success(placemark);
//                }
//            }else {
//                [self callbackIfNeedWithError:[NSError exErrorWithCode:JXErrorCodeLocateFailure]];
//            }
//        }
//    }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (kCLAuthorizationStatusNotDetermined == status) {
        if (JXiOSVersionGreaterThanOrEqual(@"8.0")) {
            [manager requestWhenInUseAuthorization];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.locationManager stopUpdatingLocation];
    if (kCLErrorDenied == error.code) {
        if (_failure) {
            _failure([NSError jx_errorWithCode:JXErrorCodeLocateDenied]);
        }
        
        if (self.locateSubscriber) {
            [self.locateSubscriber sendError:[NSError jx_errorWithCode:JXErrorCodeLocateDenied]];
        }
    }else {
        [self callbackIfNeedWithError:[NSError jx_errorWithCode:JXErrorCodeLocateFailure]];
        
        if (self.locateSubscriber) {
            [self.locateSubscriber sendError:[NSError jx_errorWithCode:JXErrorCodeLocateFailure]];
        }
    }
}

//#pragma mark - Class methods
//+ (JXLocationManager *)sharedManager {
//    static JXLocationManager *instance;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[JXLocationManager alloc] init];
//    });
//    return instance;
//}
@end
