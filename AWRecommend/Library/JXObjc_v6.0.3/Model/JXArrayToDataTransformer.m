//
//  JXArrayToDataTransformer.m
//  JXObjc
//
//  Created by 杨建祥 on 16/1/14.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import "JXArrayToDataTransformer.h"

@implementation JXArrayToDataTransformer
+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return [NSData class];
}


- (id)transformedValue:(NSArray *)value {
    //    NSMutableData *data = [NSMutableData data];
    //    for (id obj in value) {
    //        [data appendData:[obj mj_JSONData]];
    //    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
    return data;
}


- (id)reverseTransformedValue:(NSData *)value {
    id arr = [NSKeyedUnarchiver unarchiveObjectWithData:value];
    return arr;
}

@end
