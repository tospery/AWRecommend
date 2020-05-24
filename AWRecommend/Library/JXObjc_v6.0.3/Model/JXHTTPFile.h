//
//  JXHTTPFile.h
//  JXObjc
//
//  Created by 杨建祥 on 16/1/14.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXHTTPFile : NSObject
@property (nonatomic, assign) JXFileType type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *arg;
// @property (nonatomic, copy) NSString *type; // image/png, image/jpeg
@property (nonatomic, strong) NSData *data;

@end
