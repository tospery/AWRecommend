//
//  JXVendorManager.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/1.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXVendorManager.h"

#ifdef JXEnableLibCocoaLumberjack
#ifdef DEBUG
DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif
#endif

//static NSURLCache *urlCache;

@implementation JXVendorManager
- (void)setupIQKeyboardManager {
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    //[IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = kJXStdKeyboardDistance;
    [IQKeyboardManager sharedManager].toolbarManageBehaviour = IQAutoToolbarByPosition;
    
    //    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //    manager.shouldShowTextFieldPlaceholder = NO;
    //    manager.toolbarManageBehaviour = IQAutoToolbarByPosition;
    //    manager.keyboardDistanceFromTextField = 12.0f;
    //
    //    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)setupAFNetworking {
    // YJX_LIB 网页缓存
    NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:100 * 1024 * 1024 diskCapacity:50 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:urlCache];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)setupJSPatch {
//#if defined(JXEnableEnvDev) || defined(JXEnableEnvHoc) || defined(JXEnableEnvApp) || defined(JXEnableEnvEnt)
//    JXApp *app = [JXApp sharedInstance];
//    NSString *name = [[[app identifier] componentsSeparatedByString:@"."] lastObject];
//    NSString *version = [app version];
//    NSString *path = JXStrWithFmt(@"patch/ios/%@/v%@.js", name, version);
//    NSURL *url = [NSURL jx_URLWithBase:NMInstance.baseURLString path:path];
//    
//    [JPEngine startEngine];
//    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if (data && !connectionError) {
//            NSString *script = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSString *prefix = JXStrWithFmt(@"/* %@-v%@-Patch */", [JXApp sharedInstance].name, [JXApp sharedInstance].version);
//            if ([script hasPrefix:prefix]) {
//                [JPEngine evaluateScript:script];
//            }
//        }
//    }];
//#endif
    
//#ifdef kTPJSPatchURL
//    [JPEngine startEngine];
//    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if (data && !connectionError) {
//            NSString *script = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSString *prefix = JXStrWithFmt(@"/* %@-v%@-Patch */", [JXApp sharedInstance].name, [JXApp sharedInstance].version);
//            if ([script hasPrefix:prefix]) {
//                [JPEngine evaluateScript:script];
//            }
//        }
//    }];
//#else
//    JXLogError(@"未定义kTPJSPatchURL！！！");
//#endif
}

- (void)setupBugtags {
//#ifdef kTPBugtagsAppKey
//    BTGInvocationEvent event = BTGInvocationEventNone;
//    BugtagsOptions *options = [[BugtagsOptions alloc] init];
//    
//#ifdef JXEnableEnvDev
//    options.channel = @"开发";
//#elif defined(JXEnableEnvHoc)
//    event = BTGInvocationEventShake;
//    options.channel = @"测试";
//#else
//    options.channel = @"正式";
//#endif
//    
//    [Bugtags startWithAppKey:kTPBugtagsAppKey invocationEvent:event options:options];
//#else
//    JXLogError(@"未定义kTPBugtagsAppKey！！！");
//#endif
}

- (void)setupPgy {
//#ifdef JXEnableEnvHoc
//    if (0 != gMisc.pgyAppID.length) {
//        [[PgyManager sharedPgyManager] setEnableDebugLog:NO];
//        [[PgyManager sharedPgyManager] setEnableFeedback:NO];
//        [[PgyManager sharedPgyManager] startManagerWithAppId:gMisc.pgyAppID];
//        [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:gMisc.pgyAppID];
//        [[PgyUpdateManager sharedPgyManager] checkUpdate];
//    }
//#endif
//    
    
//    if (JXAppEnvApp == [JXApp sharedInstance].env) {
//        [[PgyManager sharedPgyManager] setEnableDebugLog:NO];
//        [[PgyManager sharedPgyManager] setEnableFeedback:NO];
//        [[PgyManager sharedPgyManager] startManagerWithAppId:gMisc.pgyAppID];
//        [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:gMisc.pgyAppID];
//        [[PgyUpdateManager sharedPgyManager] checkUpdate];
//    }
    
//#ifdef kTPPgyAppId
//    
//    if (JXEnvTypeHoc == JXInstance.envType) {
//        [[PgyManager sharedPgyManager] setEnableDebugLog:NO];
//        [[PgyManager sharedPgyManager] setEnableFeedback:NO];
//        [[PgyManager sharedPgyManager] startManagerWithAppId:kTPPgyAppId];
//        [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:kTPPgyAppId];
//        [[PgyUpdateManager sharedPgyManager] checkUpdate];
//    }
//#endif
    
    // YJX_APP
//    if ((JXEnvTypeHoc == JXInstance.envType)
//        && (gMisc.pgyAppID.length != 0)) {
//        [[PgyManager sharedPgyManager] setEnableDebugLog:NO];
//        [[PgyManager sharedPgyManager] setEnableFeedback:NO];
//        [[PgyManager sharedPgyManager] startManagerWithAppId:gMisc.pgyAppID];
//        [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:gMisc.pgyAppID];
//        [[PgyUpdateManager sharedPgyManager] checkUpdate];
//    }
    
#if defined(JXEnableEnvHoc) && defined(kTPPgyAppId)
//    [[PgyManager sharedPgyManager] setEnableDebugLog:NO];
//    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
//    [[PgyManager sharedPgyManager] startManagerWithAppId:kTPPgyAppId];
//    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:kTPPgyAppId];
//    [[PgyUpdateManager sharedPgyManager] checkUpdate];
#endif
}

//- (void)versionWithInfo:(NSDictionary *)info {
//    int a = 0;
//}


//#ifdef JXEnableLibMagicalRecord
//+ (void)setupDatabase {
//#ifdef DEBUG
//    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelDebug];
//#else
//    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelInfo];
//#endif
//    [MagicalRecord setupCoreDataStackWithStoreNamed:@"AppData.sqlite"];
//}
//#endif
//
//#ifdef JXEnableLibCocoaLumberjack
//+ (void)setupLogger {
//    JXLogFormatter *formatter = [[JXLogFormatter alloc] init];
//    
//    [[DDASLLogger sharedInstance] setLogFormatter:formatter];
//    [DDLog addLogger:[DDASLLogger sharedInstance] withLevel:ddLogLevel];
//    
//    [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
//    [DDTTYLogger sharedInstance].colorsEnabled = YES;
//    [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:ddLogLevel];
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
//    NSString *logsDirectory = [baseDir stringByAppendingPathComponent:@"Logs"];
//    DDLogFileManagerDefault *logFileManagerDefault = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:logsDirectory];
//    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManagerDefault];
//    fileLogger.logFormatter = formatter;
//    fileLogger.rollingFrequency = 60 * 60 * 24;
//    fileLogger.maximumFileSize  = 1024 * 1024 * 1;
//    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
//    [DDLog addLogger:fileLogger];
//}
//#endif
//
//#ifdef JXEnableLibSIAlertView
- (void)setupAlert {
    [[SIAlertView appearance] setTitleFont:JXFont(16)];
    [[SIAlertView appearance] setMessageFont:JXFont(15)];
    [[SIAlertView appearance] setButtonFont:JXFont(17)];
    [[SIAlertView appearance] setTitleColor:JXColorHex(0xA5463B)];
    [[SIAlertView appearance] setMessageColor:JXColorHex(0xA5463B)];
    [[SIAlertView appearance] setCornerRadius:4];
    //[[SIAlertView appearance] setShadowRadius:12];
    [[SIAlertView appearance] setViewBackgroundColor:[UIColor whiteColor]];
    [[SIAlertView appearance] setButtonColor:[UIColor whiteColor]];
    [[SIAlertView appearance] setCancelButtonColor:[UIColor whiteColor]];
    
    [[SIAlertView appearance] setCancelButtonImage:[UIImage jx_imageWithColor:[JXColorHex(0xC34239) colorWithAlphaComponent:0.8]] forState:UIControlStateNormal];
    [[SIAlertView appearance] setCancelButtonImage:[UIImage jx_imageWithColor:JXColorHex(0xC34239)] forState:UIControlStateHighlighted];
    [[SIAlertView appearance] setDefaultButtonImage:[UIImage jx_imageWithColor:JXColorHex(0x554E54)] forState:UIControlStateNormal];
    [[SIAlertView appearance] setDefaultButtonImage:[UIImage jx_imageWithColor:JXColorHex(0x322F32)] forState:UIControlStateHighlighted];
    
    [[SIAlertView appearance] setTransitionStyle:SIAlertViewTransitionStyleBounce];
    [[SIAlertView appearance] setBackgroundStyle:SIAlertViewBackgroundStyleGradient];
    [[SIAlertView appearance] setButtonsListStyle:SIAlertViewButtonsListStyleNormal];
}

//#endif
//
//
////+ (NSURLCache *)urlCache {
////    return urlCache;
////}
//
//
//
//+ (void)setupBugtags {
//#ifdef kAppKeyBugtags
//    [Bugtags startWithAppKey:kAppKeyBugtags invocationEvent:BTGInvocationEventShake];
//    [Bugtags setBeforeSendingCallback:^{
//        // [Bugtags setUserData:[CurrentUser mj_JSONString] forKey:@"user"];
//    }];
//#else
//    JXLogError(@"未定义kAppKeyBugtags！！！");
//#endif
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




