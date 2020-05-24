//
//  JXViewController.h
//  JXSamples
//
//  Created by 杨建祥 on 16/4/23.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXViewController : UIViewController
//@property (nonatomic, assign) BOOL hidesDismissBtnWhenPresented;
//@property (nonatomic, assign) BOOL hidesBackItemWhenPushed;
@property (nonatomic, assign) BOOL hidesReturnBarItem;
//@property (nonatomic, assign) BOOL useBackAsReturn;
@property (nonatomic, assign) BOOL useCloseAsReturn;

@property (nonatomic, strong) UIColor *viewBgColor;
@property (nonatomic, strong) UIColor *navItemColor;
@property (nonatomic, assign) JXStatusBarStyle statusBarStyle;

//@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

//@property (nonatomic, assign) BOOL shouldFetchLocalDataOnViewModelInitialize;
@property (nonatomic, assign) BOOL shouldRequestRemoteDataOnViewDidLoad;

@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong, readonly) RACSubject *errors;
@property (nonatomic, strong, readonly) RACSubject *executing;

@property (nonatomic, strong) id param;
@property (nonatomic, copy) JXVoidBlock_id resultBlock;

- (void)bindViewModel;
- (void)returnItemPressed:(id)sender;

@end


//@interface JXViewControllerManager : NSObject
//@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
//@property (nonatomic, strong) UIColor *backgroundColor;
//
//// + (JXViewControllerManager *)sharedInstance;
//+ (instancetype)sharedInstance;
//@end
