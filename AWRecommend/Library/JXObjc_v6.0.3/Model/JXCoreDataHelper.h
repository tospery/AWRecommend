//
//  JXCoreDataHelper.h
//  JXObjc
//
//  Created by 杨建祥 on 16/1/14.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JXMigrationController.h"

@interface JXCoreDataHelper : NSObject <UIAlertViewDelegate, NSXMLParserDelegate>
@property (nonatomic, readonly) NSManagedObjectContext       *parentContext;
@property (nonatomic, readonly) NSManagedObjectContext       *context;
@property (nonatomic, readonly) NSManagedObjectContext       *importContext;

@property (nonatomic, readonly) NSManagedObjectModel         *model;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, readonly) NSPersistentStore            *store;

@property (nonatomic, readonly) NSManagedObjectContext       *sourceContext;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *sourceCoordinator;
@property (nonatomic, readonly) NSPersistentStore            *sourceStore;

@property (nonatomic, retain) JXMigrationController *migrationVC;

@property (nonatomic, retain) UIAlertView *importAlertView;

@property (nonatomic, strong) NSXMLParser *parser;

@property (nonatomic, strong) NSTimer *importTimer;

- (void)setupCoreData;
- (void)saveContext;
- (void)backgroundSaveContext;
@end
