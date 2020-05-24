//
//  AppDelegate.h
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/27.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, LLTabBarDelegate, WXApiDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MainViewController *mainTbController;
@property (nonatomic, strong) LLTabBar *tabBar;

@end

