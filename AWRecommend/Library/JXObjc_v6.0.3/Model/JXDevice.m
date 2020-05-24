//
//  JXDevice.m
//  JXSamples
//
//  Created by 杨建祥 on 16/4/23.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXDevice.h"
#import <AdSupport/AdSupport.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

@interface JXDevice ()
@property (nonatomic, assign, readwrite) BOOL isSmall;
@property (nonatomic, assign, readwrite) JXDeviceInch inch;
@property (nonatomic, assign, readwrite) CGSize resolution;
@property (nonatomic, assign, readwrite) CGSize logicResolution;

@property (nonatomic, copy) void(^sendMessageFinishBlock)(MFMessageComposeViewController *controller, MessageComposeResult result);
@end

@implementation JXDevice
#pragma mark Override
- (instancetype)init {
    if (self = [super init]) {
        CGSize resolution = [UIScreen mainScreen].currentMode.size;
        if (CGSizeEqualToSize(resolution, CGSizeMake(640, 960))) {
            _inch = JXDeviceInch35;
        }else if (CGSizeEqualToSize(resolution, CGSizeMake(640, 1136))) {
            _inch = JXDeviceInch40;
        }else if (CGSizeEqualToSize(resolution, CGSizeMake(750, 1334))) {
            _inch = JXDeviceInch47;
        }else if (CGSizeEqualToSize(resolution, CGSizeMake(1242, 2208))) {
            _inch = JXDeviceInch55;
        }else {
            _inch = JXDeviceInchUnkown;
            JXLogError(kStringUnknown);
        }
        
        if (JXDeviceInch35 == _inch || JXDeviceInch40 == _inch) {
            _isSmall = YES;
        }
    }
    return self;
}

#pragma mark Accessor
- (CGSize)resolution {
    if (CGSizeEqualToSize(_resolution, CGSizeZero)) {
        _resolution = [UIScreen mainScreen].nativeBounds.size;
    }
    return _resolution;
}

- (CGSize)logicResolution {
    if (CGSizeEqualToSize(_logicResolution, CGSizeZero)) {
        _logicResolution = [UIScreen mainScreen].bounds.size;
    }
    return _logicResolution;
}



// logicResolution

//- (JXDeviceInch)inch {
//    if (JXDeviceInchNone == _inch) {
//        CGSize resolution = [UIScreen mainScreen].currentMode.size;
//        if (CGSizeEqualToSize(resolution, CGSizeMake(640, 960))) {
//            _inch = JXDeviceInch35;
//        }else if (CGSizeEqualToSize(resolution, CGSizeMake(640, 1136))) {
//            _inch = JXDeviceInch40;
//        }else if (CGSizeEqualToSize(resolution, CGSizeMake(750, 1334))) {
//            _inch = JXDeviceInch47;
//        }else if (CGSizeEqualToSize(resolution, CGSizeMake(1242, 2208))) {
//            _inch = JXDeviceInch55;
//        }else {
//            _inch = JXDeviceInchUnkown;
//            JXLogError(kStringUnknown);
//        }
//    }
//    return _inch;
//}

//- (BOOL)isSmall {
//    static dispatch_once_t onceToken;
//    
//    @weakify(self)
//    dispatch_once(&onceToken, ^{
//        @strongify(self)
//        if (JXDeviceInch35 == self.inch || JXDeviceInch40 == self.inch) {
//            self.isSmall = YES;
//        }else {
//            self.isSmall = NO;
//        }
//    });
//    
//    return _isSmall;
//}

#pragma mark Class
+ (JXDevice *)sharedInstance {
    static JXDevice *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JXDevice alloc] init];
    });
    return instance;
}

// 表示App的标识，重装App后改变
+ (NSString *)appUID {
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

// 表示设备的标识，重装App后不变
+ (NSString *)deviceUID {
    return [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
}


// backup
/**
 *  identifierForVendor对供应商来说是唯一的一个值，也就是说，由同一个公司发行的的app在相同的设备上运行的时候都会有这个相同的标识符。然而，如果用户删除了这个供应商的app然后再重新安装的话，这个标识符就会不一致。
 *
 *  @return uuidVendor
 */
+ (NSString *)uuidVendor {
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

+ (BOOL)supportCall {
    BOOL result = NO;
    if([[UIDevice currentDevice].model isEqualToString:kStringiPhone])
    {
        result = YES;
    }
    return result;
}

+ (void)dialNumber:(NSString *)mobile {
    if (![[self class] supportCall]) {
        NSLog(kStringYourDeviceNotSupportCallFunction);
        JXAlert(kStringTips, kStringYourDeviceNotSupportCallFunction);
        return;
    }
    
    if (0 == mobile.length) {
        JXAlert(kStringTips, @"无效的电话号码");
        return;
    }
    
    NSURL *mobileURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", mobile]];
    static UIWebView *callWebView;
    if (!callWebView) {
        callWebView = [[UIWebView alloc]initWithFrame:CGRectZero];
    }
    [callWebView loadRequest:[NSURLRequest requestWithURL:mobileURL]];
}

#pragma mark - Public methods
- (void)sendMessage:(NSString *)message
          receivers:(NSArray *)receivers
          container:(UIViewController *)container
         completion:(void (^)(void))completion
             finish:(void(^)(MFMessageComposeViewController *controller, MessageComposeResult result))finish {
    if (JXDeviceTypeiPhone != [[self class] type]) {
        NSLog(kStringYourDeviceNotSupportMessageFunction);
        JXAlert(kStringTips, kStringYourDeviceNotSupportMessageFunction);
        return;
    }
    _sendMessageFinishBlock = finish;
    
    MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
    messageVC.messageComposeDelegate = self;
    messageVC.recipients = receivers;
    messageVC.body = message;
    [container presentViewController:messageVC animated:YES completion:completion];
}

#pragma mark - Delegate methods
#pragma mark MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    if (_sendMessageFinishBlock) {
        _sendMessageFinishBlock(controller, result);
    }
}

#pragma mark - Class methods
+ (JXDeviceType)type {
    JXDeviceType type;
    NSString *model = [UIDevice currentDevice].model;
    if ([model rangeOfString:@"Simulator"].location != NSNotFound) {
        type = JXDeviceTypeSimulator;
    }else if ([model rangeOfString:@"iPhone"].location != NSNotFound) {
        type = JXDeviceTypeiPhone;
    }else if ([model rangeOfString:@"iPod"].location != NSNotFound) {
        type = JXDeviceTypeiPod;
    }else {
        type = JXDeviceTypeiPad;
    }
    return type;
}

+ (void)callNumber:(NSString *)number {
    if (JXDeviceTypeiPhone != [[self class] type]) {
        NSLog(kStringYourDeviceNotSupportCallFunction);
        JXAlert(kStringTips, kStringYourDeviceNotSupportCallFunction);
        return;
    }
    
    NSURL *numberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", number]];
    static UIWebView *callWebView;
    if (!callWebView) {
        callWebView = [[UIWebView alloc]initWithFrame:CGRectZero];
    }
    [callWebView loadRequest:[NSURLRequest requestWithURL:numberURL]];
}

+ (void)browseWeb:(NSString *)urlString {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

//+ (CGFloat)screenWidth {
//    static CGFloat result;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        result = [UIScreen mainScreen].bounds.size.width;
//    });
//    return result;
//}
//
//+ (CGFloat)screenHeight {
//    static CGFloat result;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        result = [UIScreen mainScreen].bounds.size.height;
//    });
//    return result;
//}
//
//+ (CGFloat)statusBarHeight {
//    static CGFloat result;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        result = [UIScreen mainScreen].bounds.size.height;
//    });
//    return result;
//}

+ (NSString *)brief {
    UIDevice *device = [UIDevice currentDevice];
    return [NSString stringWithFormat:@"%@_%@_%@", device.model, device.systemName, device.systemVersion];
}

+ (NSString *)adUUID {
    return [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
}

+ (NSString *)ssid {
    if (![AFNetworkReachabilityManager sharedManager].isReachableViaWiFi) {
        [JXDialog showPopup:@"未连接WIFI"];
        return nil;
    }
    
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    NSString *ssid;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        ssid = [(NSDictionary *)info objectForKey:@"SSID"];
    }
    
    return ssid;
}

+ (NSString *)ip {
    if (![JXNetworkManager isEnableInternet]) {
        return nil;
    }
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    
    return address;
}
@end
