//
//  JXAMapLocationManager.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/9/19.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXAMapLocationManager.h"

@interface JXAMapLocationManager ()
@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, strong) id<RACSubscriber> locateSubscriber;
@property (nonatomic, strong) id<RACSubscriber> geocodeSubscriber;

@end

@implementation JXAMapLocationManager
- (void)dealloc {
    _locationManager = nil;
    [self cleanUpAction];
    
    // self.completionBlock = nil;
}

- (void)cleanUpAction {
    if (_locationManager) {
        [_locationManager stopUpdatingLocation];
        [_locationManager setDelegate:nil];
        _locationManager = nil;
    }
}

- (void)genLocationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        [_locationManager setDelegate:self];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        [_locationManager setAllowsBackgroundLocationUpdates:NO];
        [_locationManager setLocationTimeout:10];
        [_locationManager setReGeocodeTimeout:5];
    }
}

- (RACSignal *)locateSignal {
    if (![CLLocationManager locationServicesEnabled]) {
        return [RACSignal error:[NSError jx_errorWithCode:JXErrorCodeLocateClosed]];
    }
    [self genLocationManager];
    
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        self.locateSubscriber = subscriber;
        
        [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            @strongify(self)
            if (error) {
                [self.locateSubscriber sendError:error];
            }else {
                [self.locateSubscriber sendNext:RACTuplePack(location, regeocode)];
                [self.locateSubscriber sendCompleted];
            }
        }];
        
        return [RACDisposable disposableWithBlock:^{
            self.locateSubscriber = nil;
        }];
    }];
}

@end











