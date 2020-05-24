//
//  JXErrorHandler.h
//  JXObjc
//
//  Created by 杨建祥 on 16/1/14.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXErrorHandler : NSObject
@property (nonatomic, assign) BOOL fatal;
@property (nonatomic, strong) NSError *error;

- (instancetype)initWithError:(NSError *)error fatal:(BOOL)fatal;

+ (void)handleError:(NSError *)error fatal:(BOOL)fatal;
@end
