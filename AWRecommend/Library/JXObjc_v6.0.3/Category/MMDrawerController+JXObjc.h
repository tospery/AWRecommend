//
//  MMDrawerController+JXObjc.h
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#ifdef JXEnableLibMMDrawerController
#import <MMDrawerController/MMDrawerController.h>

@interface MMDrawerController (JXObjc)
+ (MMDrawerController *)exDrawerControllerWithCenterVC:(UIViewController *)centerVC
                                                leftVC:(UIViewController *)leftVC
                                               rightVC:(UIViewController *)rightVC
                                             leftWidth:(CGFloat)leftWidth
                                            rightWidth:(CGFloat)rightWidth;

@end
#endif
