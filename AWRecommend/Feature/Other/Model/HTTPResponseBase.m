//
//  HTTPResponseBase.m
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "HTTPResponseBase.h"

ApiTag lTag = ApiTagNone;

@implementation HTTPResponseBase
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([oldValue isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return oldValue;
}

- (void)mj_keyValuesDidFinishConvertingToObject {
    switch (lTag) {
        case ApiTagUserInfo: {
            _data = @{@"wiseAccountInfoDto": JXNil2Val(_data, @{})};
        }
            break;
        case ApiTagFavoriteDel: {
            if ([_msg isEqualToString:@"成功"]) {
                _data = @(YES);
            }else {
                _data = @(NO);
            }
        }
            break;
        default:
            break;
    }
    
    if (401 == _code) {
        _code = JXErrorCodeLoginExpired;
    }
}

+ (void)setTag:(ApiTag)tag {
    lTag = tag;
}

@end
