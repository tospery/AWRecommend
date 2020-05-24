//
//  UINavigationItem+JXObjc.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "UINavigationItem+JXObjc.h"

@implementation UINavigationItem (JXObjc)
- (void)exSetTitleOnly:(NSString *)title color:(UIColor *)color {
    if (JXiOSVersionGreaterThanOrEqual(@"7.0")) {
        self.title = nil;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., 100., 21.)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = color;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:17.];
        label.text = title;
        self.titleView = label;
    }else {
        self.title = title;
    }
}

@end
