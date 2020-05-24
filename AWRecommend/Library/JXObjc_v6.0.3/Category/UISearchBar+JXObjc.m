
//
//  UISearchBar+JXObjc.m
//  MyCoding
//
//  Created by 杨建祥 on 16/4/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "UISearchBar+JXObjc.h"

@implementation UISearchBar (JXObjc)
+ (void)jx_appearanceWithParam:(NSDictionary *)param {
    JXCheckWithoutRet(param);
    
    UISearchBar *searchBar = [UISearchBar appearance];
    
    UIColor *barTintColor = [param objectForKey:kJXKeyBarTintColor];
    if (barTintColor) {
        if (JXiOSVersionGreaterThanOrEqual(@"7.0")) {
            searchBar.barTintColor = barTintColor;
        }else {
            [searchBar setBackgroundImage:[UIImage jx_imageWithColor:barTintColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        }
    }
}

@end
