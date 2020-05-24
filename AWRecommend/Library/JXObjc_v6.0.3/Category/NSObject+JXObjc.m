//
//  NSObject+JXObjc.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "NSObject+JXObjc.h"

#define lJXIdentifier                  (@"lJXIdentifier")
#define lJXTag                  (@"lJXTag")

@implementation NSObject (JXObjc)
- (NSString *)jxIdentifier {
    return objc_getAssociatedObject(self, lJXIdentifier);
}

- (void)setJxIdentifier:(NSString *)identifier {
    objc_setAssociatedObject(self, lJXIdentifier, identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)jxTag {
    return objc_getAssociatedObject(self, lJXTag);
}

- (void)setJxTag:(id)tag {
    objc_setAssociatedObject(self, lJXTag, tag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSArray *)jx_getProperties {
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);

    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [mArray addObject:name];
    }
    free(properties);
    
    [mArray removeObjectsInArray:@[@"hash", @"superclass", @"description", @"debugDescription"]];
    
    return mArray.copy;
}

+ (void)jx_exchangeMethod:(SEL)origSel withNewMethod:(SEL)newSel{
    Class class = [self class];
    
    Method origMethod = class_getInstanceMethod(class, origSel);
    if (!origMethod){
        origMethod = class_getClassMethod(class, origSel);
    }
    if (!origMethod)
    @throw [NSException exceptionWithName:@"Original method not found" reason:nil userInfo:nil];
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!newMethod){
        newMethod = class_getClassMethod(class, newSel);
    }
    if (!newMethod)
    @throw [NSException exceptionWithName:@"New method not found" reason:nil userInfo:nil];
    if (origMethod==newMethod)
    @throw [NSException exceptionWithName:@"Methods are the same" reason:nil userInfo:nil];
    method_exchangeImplementations(origMethod, newMethod);
}
@end
