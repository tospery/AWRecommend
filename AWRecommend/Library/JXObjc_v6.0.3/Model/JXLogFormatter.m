//
//  JXLogFormatter.m
//  MeijiaStore
//
//  Created by 杨建祥 on 15/12/29.
//  Copyright © 2015年 iOS开发组. All rights reserved.
//

#ifdef JXEnableLibCocoaLumberjack
#import "JXLogFormatter.h"
#import "JXObjc.h"

@implementation JXLogFormatter
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    return [NSString stringWithFormat:@"%@%@%@(%@)->\n%@",
            [logMessage.timestamp exStringWithFormat:kJXFormatDatetimeStyle3],
            [self levelString:logMessage.flag],
            logMessage.function,
            logMessage.threadID,
            logMessage.message];
}

- (NSString *)levelString:(DDLogFlag)level {
    NSString *result;
    switch (level) {
        case DDLogFlagError:
            result = @"【Error】";
            break;
        case DDLogFlagWarning:
            result = @"【Warning】";
            break;
        case DDLogFlagInfo:
            result = @"【Info】";
            break;
        case DDLogFlagDebug:
            result = @"【Debug】";
            break;
        case DDLogFlagVerbose:
            result = @"【Verbose】";
            break;
        default:
            break;
    }
    return result;
}
@end
#endif
