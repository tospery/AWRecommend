//
//  ScanRecord.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/9.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXObject.h"

@interface ScanRecord : JXObject
@property (nonatomic, copy) NSString *drugName;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *createTime;

@end
