//
//  MedicineViewController.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/20.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXScrollViewController.h"

@protocol MedicineViewControllerDelegate <NSObject>

@end

@interface MedicineViewController : JXNavigationController <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSMutableArray *controllers;

@property (nonatomic, weak) id<MedicineViewControllerDelegate> swipeDelegate;

@property (nonatomic, strong) UIView *selectionBar;
@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) UIView *navigationView;

- (UIViewController *)curViewController;
+ (instancetype)medicineNCWithDataSource:(id)dataSource;
@end
