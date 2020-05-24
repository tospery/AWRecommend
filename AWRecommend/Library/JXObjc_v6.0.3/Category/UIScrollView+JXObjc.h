//
//  UIScrollView+JXObjc.h
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (JXObjc)
@property (nonatomic, assign) JXRequestMode requestMode;
@property (nonatomic, strong) NSError *requestError;
@property (nonatomic, strong) NSString *cellName;

@end
