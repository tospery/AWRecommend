//
//  JXVendorManager.h
//  MyCoding
//
//  Created by 杨建祥 on 16/5/1.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VMInstance              ([JXVendorManager sharedInstance])

@interface JXVendorManager : NSObject
- (void)setupIQKeyboardManager;
- (void)setupAFNetworking;
- (void)setupJSPatch;
- (void)setupBugtags;
- (void)setupPgy;

//#ifdef JXEnableLibMagicalRecord
//+ (void)setupDatabase;
//#endif
//
//#ifdef JXEnableLibCocoaLumberjack
//+ (void)setupLogger;
//#endif
//
//#ifdef JXEnableLibSIAlertView
- (void)setupAlert JXAPIDeprecated601;
//#endif
//
//+ (void)setupBugtags;

+ (instancetype)sharedInstance;
@end
