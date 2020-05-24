//
//  Misc.h
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/27.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXMisc.h"

@interface Misc : JXMisc
@property (nonatomic, assign) NSInteger cartCount;

@property (nonatomic, assign) BOOL skipScanPopup;
@property (nonatomic, assign) BOOL hasFirstGuide;
@property (nonatomic, copy) NSString *kIMAppId;

@property (nonatomic, copy) NSString *kUMessageAppKey;
@property (nonatomic, copy) NSString *kUMessageAppSecret;

@end
