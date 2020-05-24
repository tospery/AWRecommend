//
//  JXDevice.h
//  JXSamples
//
//  Created by 杨建祥 on 16/4/23.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

typedef NS_ENUM(NSInteger, JXDeviceInch) {
    JXDeviceInchNone,
    JXDeviceInch35,
    JXDeviceInch40,
    JXDeviceInch47,
    JXDeviceInch55,
    JXDeviceInch79,
    JXDeviceInch97,
    JXDeviceInch105,
    JXDeviceInch129,
    JXDeviceInchUnkown,
};

// 设备类型
typedef NS_ENUM(NSInteger, JXDeviceType){
    JXDeviceTypeSimulator,
    JXDeviceTypeiPhone,
    JXDeviceTypeiPod,
    JXDeviceTypeiPad
};

// 设备分辨率
typedef NS_ENUM(NSInteger, JXDeviceResolution){
    JXDeviceResolution640x960,         // earlier than iPhone 5
    JXDeviceResolution640x1136,        // iPhone 5/5S
    JXDeviceResolution750x1334,        // iPhone 6
    JXDeviceResolution1242x2208,        // iPhone 6 Plus
    JXDeviceResolution2048x1536,
    JXDeviceResolution2224x1668,
    JXDeviceResolution2732x2048
};

// 导航栏高度
typedef NS_ENUM(NSInteger, JXDeviceNavBarHeight){
    JXDeviceNavBarHeightStandalone = 44,
    JXDeviceNavBarHeightIntertwine = 64
};

@interface JXDevice : NSObject <MFMessageComposeViewControllerDelegate>
@property (nonatomic, assign, readonly) BOOL isSmall;
@property (nonatomic, assign, readonly) JXDeviceInch inch;
//@property (nonatomic, assign, readonly) CGSize resolution;
//@property (nonatomic, assign, readonly) CGSize logicResolution;

//+ (CGSize)resolution;

+ (JXDevice *)sharedInstance;

+ (NSString *)appUID;
+ (NSString *)deviceUID;

// 备份
/**
 *  identifierForVendor对供应商来说是唯一的一个值，也就是说，由同一个公司发行的的app在相同的设备上运行的时候都会有这个相同的标识符。然而，如果用户删除了这个供应商的app然后再重新安装的话，这个标识符就会不一致。
 *
 *  @return uuidVendor
 */
+ (NSString *)uuidVendor;

+ (BOOL)supportCall;
+ (void)dialNumber:(NSString *)mobile;


- (void)sendMessage:(NSString *)message
          receivers:(NSArray *)receivers
          container:(UIViewController *)container
         completion:(void (^)(void))completion
             finish:(void(^)(MFMessageComposeViewController *controller, MessageComposeResult result))finish;

+ (JXDeviceType)type;
+ (void)callNumber:(NSString *)number;
+ (void)browseWeb:(NSString *)urlString;

//+ (CGFloat)screenWidth;
+ (NSString *)brief;

/**
 *  advertisingIdentifier会返回给在这个设备上所有软件供应商相同的一个值，所以只能在广告的时候使用。这个值会因为很多情况而有所变化，比如说用户初始化设备的时候便会改变。
 *
 *  @return adUUID
 */
+ (NSString *)adUUID;


/**
 *  获取当前连接的WIFI热点名
 *
 *  @return WIFI热点名
 */
+ (NSString *)ssid;

+ (NSString *)ip;

@end
