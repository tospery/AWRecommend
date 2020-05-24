//
//  JXLocationManager.h
//  JXObjc
//
//  Created by 杨建祥 on 16/1/14.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^JXLocationSuccessBlock)(CLLocation *location);
typedef void(^JXLocationFailureBlock)(NSError *error);

@interface JXLocationManager : NSObject <CLLocationManagerDelegate>
- (void)startLocatingWithSuccess:(JXLocationSuccessBlock)success
                         failure:(JXLocationFailureBlock)failure JXAPIDeprecated601;

- (RACSignal *)locateSignal;
- (RACSignal *)geocodeSignalWithLocation:(CLLocation *)location;

//#pragma mark - Class methods
//+ (JXLocationManager *)sharedManager;
@end

