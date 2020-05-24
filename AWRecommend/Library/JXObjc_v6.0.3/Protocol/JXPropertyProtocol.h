//
//  JXPropertyProtocol.h
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JXPropertyProtocol <NSObject>
@optional
- (void)setupProperties:(id)another;
- (void)resetProperties;

@end
