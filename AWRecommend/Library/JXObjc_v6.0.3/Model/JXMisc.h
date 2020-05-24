//
//  JXMisc.h
//  JXSamples
//
//  Created by 杨建祥 on 16/12/26.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXArchiveObject.h"

@interface JXMisc : JXArchiveObject
// @property (nonatomic, assign) JXEnvType envType;

@property (nonatomic, copy) NSString *prevUserID;
@property (nonatomic, copy) NSString *curUserID;

@property (nonatomic, copy) NSString *baseURLString;
@property (nonatomic, copy) NSString *subURLString;
@property (nonatomic, copy) NSString *pathURLString;

//@property (nonatomic, copy) NSString *webURLString;
//
//@property (nonatomic, copy) NSString *pgyAppID;

- (void)configEnv;

@end
