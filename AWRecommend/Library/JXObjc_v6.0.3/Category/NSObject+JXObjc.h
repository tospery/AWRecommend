//
//  NSObject+JXObjc.h
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JXObjc)
@property (nonatomic, strong) NSString *jxIdentifier; // YJX_TODO
@property (nonatomic, strong) id jxTag;

+ (NSArray *)jx_getProperties;

+ (void)jx_exchangeMethod:(SEL)origSel withNewMethod:(SEL)newSel;

@end
