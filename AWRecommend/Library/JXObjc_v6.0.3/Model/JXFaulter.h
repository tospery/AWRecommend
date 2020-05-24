//
//  JXFaulter.h
//  JXObjc
//
//  Created by 杨建祥 on 16/1/14.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface JXFaulter : NSObject
+ (void)faultObjectWithID:(NSManagedObjectID*)objectID
                inContext:(NSManagedObjectContext*)context;

@end
