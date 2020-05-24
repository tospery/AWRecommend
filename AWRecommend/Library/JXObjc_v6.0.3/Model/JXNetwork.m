//
//  JXNetwork.m
//  MeijiaStore
//
//  Created by 杨建祥 on 16/1/12.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

//#ifdef JXEnableLibReachability
#import "JXNetwork.h"
//#include <sys/socket.h>
//#include <sys/sysctl.h>
//#include <net/if.h>
//#include <net/if_dl.h>
//#include <ifaddrs.h>
//#include <arpa/inet.h>

// static Reachability *reachability;

@interface JXNetwork ()
@property (nonatomic, strong, readwrite) NSString *ip;
//@property (nonatomic, copy) void(^changeBlock)(NetworkStatus status);
@end

@implementation JXNetwork
#pragma mark - Accessor methods
// YJX_LIB 避免ipv6问题
- (NSString *)ip {
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        return nil;
    }

    return [NSString stringWithContentsOfURL:JXURLWithStr(@"https://api.ipify.org/") encoding:NSUTF8StringEncoding error:nil];
}

//- (NSString *)ip {
//    if (![AFNetworkReachabilityManager sharedManager].reachable) {
//        return nil;
//    }
//
//#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 90000) || (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && __MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
//    return [self getIPv6Address];
//#else
//    return [self getIPv4Address];
//#endif
//}
//
//- (NSString *)getIPv4Address {
//    NSString *address = @"error";
//    struct ifaddrs *interfaces = NULL;
//    struct ifaddrs *temp_addr = NULL;
//    int success = 0;
//    
//    // retrieve the current interfaces - returns 0 on success
//    success = getifaddrs(&interfaces);
//    if (success == 0) {
//        // Loop through linked list of interfaces
//        temp_addr = interfaces;
//        while (temp_addr != NULL) {
//            if( temp_addr->ifa_addr->sa_family == AF_INET) {
//                // Check if interface is en0 which is the wifi connection on the iPhone
//                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
//                    // Get NSString from C String
//                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
//                }
//            }
//            
//            temp_addr = temp_addr->ifa_next;
//        }
//    }
//    freeifaddrs(interfaces);
//    
//    return address;
//}
//
//- (NSString *)getIPv6Address {
//    struct ifaddrs *interfaces = NULL;
//    struct ifaddrs *temp_addr = NULL;
//    NSString *wifiAddress = nil;
//    NSString *cellAddress = nil;
//    
//    // retrieve the current interfaces - returns 0 on success
//    if(!getifaddrs(&interfaces)) {
//        // Loop through linked list of interfaces
//        temp_addr = interfaces;
//        while(temp_addr != NULL) {
//            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
//            if(sa_type == AF_INET || sa_type == AF_INET6) {
//                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
//                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
//                NSLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
//                
//                if([name isEqualToString:@"en0"]) {
//                    // Interface is the wifi connection on the iPhone
//                    wifiAddress = addr;
//                } else
//                    if([name isEqualToString:@"pdp_ip0"]) {
//                        // Interface is the cell connection on the iPhone
//                        cellAddress = addr;
//                    }
//            }
//            temp_addr = temp_addr->ifa_next;
//        }
//        // Free memory
//        freeifaddrs(interfaces);
//    }
//    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
//    return addr ? addr : @"0.0.0.0";
//}

//#pragma mark - Notification methods
//- (void)notifyReachabilityChanged:(NSNotification *)notification {
//    Reachability *currentReachability = [notification object];
//    NetworkStatus networkStatus = currentReachability.currentReachabilityStatus;
//    if (_changeBlock) {
//        _changeBlock(networkStatus);
//    }
//}
//
//#pragma mark - Pulibc methods
//- (void)setupChangeBlock:(void (^)(NetworkStatus status))changeBlock {
//    if (changeBlock) {
//        _changeBlock = changeBlock;
//        [reachability startNotifier];
//    }else {
//        [reachability stopNotifier];
//    }
//}
//
//- (BOOL)isEnabled {
//    return [Reachability reachabilityForInternetConnection].currentReachabilityStatus != NotReachable;
//}
//
//#pragma Class methods
//+ (void)load {
//    [super load];
//    
//    JXNetwork *network = [JXNetwork sharedInstance];
//    [[NSNotificationCenter defaultCenter] addObserver:network
//                                             selector:@selector(notifyReachabilityChanged:)
//                                                 name:kReachabilityChangedNotification
//                                               object:nil];
//    reachability = [Reachability reachabilityForInternetConnection];
//}
//
//+ (NetworkStatus)currentNetworkStatus {
//    return [Reachability reachabilityForInternetConnection].currentReachabilityStatus;
//}

+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

@end
//#endif
