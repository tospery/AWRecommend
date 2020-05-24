//
//  MMDrawerController+JXObjc.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#ifdef JXEnableLibMMDrawerController
#import "MMDrawerController+JXObjc.h"

@implementation MMDrawerController (JXObjc)
+ (MMDrawerController *)exDrawerControllerWithCenterVC:(UIViewController *)centerVC
                                                leftVC:(UIViewController *)leftVC
                                               rightVC:(UIViewController *)rightVC
                                             leftWidth:(CGFloat)leftWidth
                                            rightWidth:(CGFloat)rightWidth{
    MMDrawerController *drawerController = [[MMDrawerController alloc]
                                            initWithCenterViewController:centerVC
                                            leftDrawerViewController:leftVC
                                            rightDrawerViewController:rightVC];
    [drawerController setShowsShadow:NO];
    //[drawerController setShouldStretchDrawer:NO];
    if (leftWidth > 0) {
        [drawerController setMaximumLeftDrawerWidth:leftWidth];
    }
    if (rightWidth > 0) {
        [drawerController setMaximumRightDrawerWidth:rightWidth];
    }
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    return drawerController;
}

@end
#endif
