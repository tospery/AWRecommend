//
//  JXObjcManager.h
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JXObjcPageStyle){
    JXObjcPageStyleNone,
    JXObjcPageStyleGroup,
    JXObjcPageStyleOffset
};

#define JXInstance                  ([JXObjcManager sharedInstance])

/**
 *  JXObjc库的默认配置
 */
@interface JXObjcManager : NSObject
//@property (nonatomic, assign) JXEnvType envType;

@property (nonatomic, assign) BOOL mustLogin;

@property (nonatomic, strong) RACTuple *servers;

// @property (nonatomic, strong) RACTuple *serverEnvs;
@property (nonatomic, copy) NSString *systemFontName;
@property (nonatomic, assign) CGFloat fontFactor;

@property (nonatomic, assign) CGFloat screenFactor;

@property (nonatomic, assign) JXScanLib scanLib;

/**
 *  状态栏样式，默认为UIStatusBarStyleDefault
 */
@property (nonatomic, assign) JXStatusBarStyle statusBarStyle;
/**
 *  视图背景色，默认为0xEFEFF5
 */
@property (nonatomic, strong) UIColor   *viewBgColor;

@property (nonatomic, strong) UIColor   *mainColor;
/**
 *  导航栏项的颜色，默认为白色
 */
@property (nonatomic, strong) UIColor   *navItemColor;

//@property (nonatomic, strong) UIFont    *cellTitleFont;
//@property (nonatomic, strong) UIColor   *cellTitleColor;
//@property (nonatomic, strong) UIFont    *cellDetailFont;
//@property (nonatomic, strong) UIColor   *cellDetailColor;

@property (nonatomic, assign) JXObjcPageStyle pageStyle;
@property (nonatomic, assign) NSUInteger pageIndex;
@property (nonatomic, assign) NSUInteger pageSize;

/**
 *  单例类方法
 *
 *  @return 实例
 */
+ (instancetype)sharedInstance;
@end
