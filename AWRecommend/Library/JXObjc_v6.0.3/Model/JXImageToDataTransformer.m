//
//  JXImageToDataTransformer.m
//  JXObjc
//
//  Created by 杨建祥 on 16/1/14.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import "JXImageToDataTransformer.h"

@implementation JXImageToDataTransformer
+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return [NSData class];
}


- (id)transformedValue:(id)value {
    return UIImagePNGRepresentation(value);
}


- (id)reverseTransformedValue:(id)value {
    return [[UIImage alloc] initWithData:value];
}

@end
