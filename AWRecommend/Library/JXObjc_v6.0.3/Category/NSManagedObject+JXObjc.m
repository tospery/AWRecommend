//
//  NSManagedObject+JXObjc.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "NSManagedObject+JXObjc.h"

@implementation NSManagedObject (JXObjc)
+ (id)exCreateEntity:(NSString *)name {
    //#ifdef JXEnableAppAviationWeather
    //    NSEntityDescription *desc = [NSEntityDescription entityForName:name inManagedObjectContext:kJXContextAD];
    //    NSManagedObject *obj = [[NSManagedObject alloc] initWithEntity:desc insertIntoManagedObjectContext:[(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    //    return obj;
    //#else
    //    return nil;
    //#endif
    
    return nil;
}

+ (id)exCreateModel:(NSString *)name {
    //#ifdef JXEnableAppAviationWeather
    //    NSEntityDescription *desc = [NSEntityDescription entityForName:name inManagedObjectContext:kJXContextAD];
    //    NSManagedObject *newModel = [[NSManagedObject alloc] initWithEntity:desc insertIntoManagedObjectContext:nil];
    //    return newModel;
    //#else
    //    return nil;
    //#endif
    
    return nil;
}

//- (NSString *)description {
//    return [self mj_JSONString];
//}

@end
