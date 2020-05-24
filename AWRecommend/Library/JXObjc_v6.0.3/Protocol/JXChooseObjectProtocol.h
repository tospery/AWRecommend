//
//  JXChooseObjectProtocol.h
//  ihealth
//
//  Created by 杨建祥 on 16/4/13.
//  Copyright © 2016年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JXChooseObjectProtocol <NSObject>
- (BOOL)hasSelected;
- (void)setupSelected:(BOOL)selected;
- (NSString *)cellTitle;

@end
