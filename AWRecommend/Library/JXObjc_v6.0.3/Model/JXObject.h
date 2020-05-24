//
//  JXObject.h
//  MyCoding
//
//  Created by 杨建祥 on 16/4/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXObject : NSObject
@property (nonatomic, copy) NSString *jxID;
@property (nonatomic, copy) NSString *jxDescription;

- (instancetype)initWithUid:(NSString *)uid;

- (BOOL)isGreaterThan:(id)object;
- (BOOL)isLowerThan:(id)object;

@end
