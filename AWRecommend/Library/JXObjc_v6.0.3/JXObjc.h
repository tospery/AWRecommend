//
//  JXObjc.h
//  JXSamples
//
//  Created by 杨建祥 on 16/4/23.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

//! Project version number for JXObjc.
FOUNDATION_EXPORT double JXObjcVersionNumber;

//! Project version string for JXObjc.
FOUNDATION_EXPORT const unsigned char JXObjcVersionString[];

// 关联项目：AWKSDoctor（爱为家医生）

// YJX_LIB 开发环境
//JXEnvDevelop
//JXEnvTest
//JXEnvProduct

#pragma mark - Feature（特性）
/****************************************************************************
 内置功能：
 JXEnableFuncAdaptFont                  自适应字体
 JXEnableFuncLocalize                   本地化
 JXEnableFuncStatistics                 页面统计
 类库配置：
 //kColorViewBackground                   视图的默认背景色（白色）
 应用控制：
 JXEnableAppiHealth                     健康钱包（YJX_LIB）
 其他类库：
 JXEnableLibCocoaLumberjack             日志库
 JXEnableLibSIAlertView                 提示框
 JXEnableLibRDVTabBarController         动态标签栏
 JXEnableLibMMDrawerController          侧边栏
 JXEnableLibHMSegmentedControl          标签页
 JXEnableLibLTNavigationBar
 JXEnableLibMasonry                     约束
 JXEnableLibWebViewJavascriptBridge     JS交互
 JXEnableLibNJKWebViewProgress
 JXEnableLibSVWebViewController
 
 环境配置： YJX_APP 发版本时，修改宏定义
 JXEnableEnvDev                         开发
 JXEnableEnvHoc                         测试
 JXEnableEnvApp                         正式（App Store）
 JXEnableEnvEnt                         正式（企业版发布）
 ***************************************************************************/

#pragma mark - Base（基础）
#import "JXType.h"
#import "JXConst.h"
#import "JXTool.h"
#import "JXString.h"


#pragma mark - Category（分类）
#import "UIFont+JXObjc.h"
#import "NSAttributedString+JXObjc.h"
#import "UIView+JXObjc.h"
#import "UIBarButtonItem+JXObjc.h"
#import "UINavigationBar+JXObjc.h"
#import "UIImage+JXObjc.h"
#import "UITabBarItem+JXObjc.h"
#import "UITabBar+JXObjc.h"
#import "UITextField+JXObjc.h"
#import "UITextView+JXObjc.h"
#import "UISearchBar+JXObjc.h"
#import "NSError+JXObjc.h"
#import "NSString+JXObjc.h"
#import "NSDate+JXObjc.h"
#import "NSObject+JXObjc.h"
#import "SVProgressHUD+JXObjc.h"
#import "CALayer+JXObjc.h"
#import "NSArray+JXObjc.h"
#import "NSData+JXObjc.h"
#import "NSDateFormatter+JXObjc.h"
#import "NSDictionary+JXObjc.h"
#import "NSManagedObject+JXObjc.h"
#import "NSMutableArray+JXObjc.h"
#import "NSMutableDictionary+JXObjc.h"
#import "NSURL+JXObjc.h"
#import "NSUserDefaults+JXObjc.h"
#import "UIColor+JXObjc.h"
#import "UINavigationItem+JXObjc.h"
#import "UIScrollView+JXObjc.h"
#import "UIViewController+JXObjc.h"
#import "UIWebView+JXObjc.h"
#import "MBProgressHUD+JXObjc.h"
#import "MMDrawerController+JXObjc.h"
#import "NSTimer+JXObjc.h"
#import "NSMutableAttributedString+JXObjc.h"
#import "UIViewController+JXPopup.h"
#import "UILabel+JXObjc.h"
#import "UIButton+JXObjc.h"
#import "UIFont+JXObjc.h"
#import "TTTAttributedLabel+JXObjc.h"

#pragma mark - Controller（控制器）
#import "JXViewController.h"
#import "JXTableViewController.h"
#import "JXTableViewController2.h"
#import "JXItemViewController.h"
#import "JXNavigationController.h"
#import "JXAssetPickerController.h"
#import "JXChooseViewController.h"
#import "JXMigrationController.h"
#import "JXScanViewController.h"
#import "JXWebViewController.h"
#import "JXSwipeNavigationController.h"
#import "JXLoginViewController.h"
#import "JXWebSVViewController.h"
#import "JXServerViewController.h"
#import "JXUIWebViewController.h"
#import "JXWKWebViewController.h"

#pragma mark - Model（模型）
#import "JXDevice.h"
#import "JXUtil.h"
#import "JXMemoryCache.h"
#import "JXHTTPSchema.h"
#import "JXHTTPRequestClient.h"
#import "JXObject.h"
//#import "JXHTTPResponseBase.h"
#import "JXApp.h"
#import "JXVendorManager.h"
#import "JXPersistenceManager.h"
#import "JXArchiveObject.h"
//#import "JXDataCache.h"
#import "JXUser.h"
#import "JXPage.h"
#import "JXAction.h"
#import "JXArrayToDataTransformer.h"
#import "JXAssetManager.h"
#import "JXAssetPhoto.h"
#import "JXAssetPhotoGroup.h"
#import "JXCacheURLProtocol.h"
#import "JXCoreDataHelper.h"
#import "JXCoreDataImporter.h"
#import "JXErrorHandler.h"
#import "JXFaulter.h"
#import "JXFlexCellHelper.h"
#import "JXHTTPFile.h"
#import "JXImageToDataTransformer.h"
#import "JXInputManager.h"
#import "JXLocationManager.h"
#import "JXLogFormatter.h"
#import "JXNetwork.h"
#import "JXNetworkManager.h"
#import "JXPermissionManager.h"
#import "JXVersionManager.h"
#import "JXObjcManager.h"
#import "JXScheduleHandler.h"
#import "JXSkinManager.h"
#import "JXMisc.h"
#import "JXURLProtocol.h"
#import "JXURLCache.h"
#import "JXDialog.h"

#pragma mark - Protocol（协议）
#import "JXPropertyProtocol.h"
#import "JXChooseObjectProtocol.h"


#pragma mark - View（视图）
#import "JXTableViewCell.h"
#import "JXCellDefault.h"
#import "JXCellValue1.h"
#import "JXButton.h"
#import "JXLoadView.h"
#import "JXBannerView2.h"
#import "JXBannerView.h"
#import "JXCaptchaButton.h"
#import "JXCollapsibleView.h"
#import "JXFilterView.h"
#import "JXFilterViewCategory.h"
#import "JXFilterViewSelection.h"
#import "JXFilterViewSelectionContentTable.h"
#import "JXInputView.h"
#import "JXPickerView.h"
#import "JXStarView.h"
#import "JXTermView.h"
#import "JXAutoRollView.h"
#import "JXActionBar.h"
#import "JXActionCategory.h"
#import "JXActionSelection.h"
#import "JXActionSelectionContent.h"
#import "JXActionSelectionContentTable.h"
#import "JXRatingView.h"
#import "JXClassifyView.h"
#import "JXCell.h"
#import "JXTextView.h"

#pragma mark - Vendor
#import "SVWebViewController.h"

// 备份
//#pragma mark - Feature
//
//
//#pragma mark - View
//#import "JXNavigationBar.h"
//#import "JXTableViewCellDefault.h"
//#import "JXTableViewCellValue1.h"
//#import "JXTableViewCellCustom1.h"
//
//
//#pragma mark - Model
//#import "JXUser.h"
//#import "JXHTTPResponseBase.h"
//#import "JXHTTPRequestSchema.h"
//#import "JXHTTPRequestParam.h"
//#import "JXHTTPClient.h"
//
//#pragma mark - Protocol
//#import "JXPropertiesProtocol.h"
//#import "JXChooseObjectProtocol.h"
//
//#pragma mark - Controller
//#import "JXTableViewController.h"
//#import "JXChooseViewController.h"
//
//#pragma mark - Variable
//#ifdef JXEnableLibCocoaLumberjack
//extern DDLogLevel ddLogLevel;
//#endif
//
//#pragma mark 备份
//
//
/////****************************************************************************
//// Base
//// ***************************************************************************/
//#pragma mark - Base
//#import "JXConst.h"
//#import "JXType.h"
//#import "JXTool.h"
//#import "JXString.h"
//#import "JXUtil.h"
//
///****************************************************************************
// Custom
// ***************************************************************************/
//#pragma mark - Custom
//#pragma mark Model
//#import "JXHUDManager.h"
//#import "JXApp.h"
//#import "JXDevice.h"
//#import "JXAction.h"
//#import "JXArrayToDataTransformer.h"
//#import "JXAssetManager.h"
//#import "JXAssetPhoto.h"
//#import "JXAssetPhotoGroup.h"
//#import "JXCoreDataHelper.h"
//#import "JXCoreDataImporter.h"
//#import "JXFaulter.h"
//#import "JXErrorHandler.h"
//#import "JXPage.h"
//#import "JXHTTPFile.h"
//#import "JXFlexCellHelper.h"
//#import "JXGlobal.h"
//#import "JXImageToDataTransformer.h"
//#import "JXInputManager.h"
//#import "JXLocationManager.h"
//#import "JXUserDefault.h"
//#import "JXPermissionManager.h"
//#import "JXHTTPClient.h"
//#import "JXLogFormatter.h"
//#import "JXNetwork.h"
//#import "JXNetworkManager.h"
//#import "JXObject.h"
//#import "JXVendorManager.h"
//#import "JXVersionManager.h"
//#import "JXCacheURLProtocol.h"
//#import "JXArchiveObject.h"
//#import "JXMemoryCache.h"
//#pragma mark View
//#import "JXButton.h"
//#import "JXCaptchaButton.h"
//#import "JXLoadView.h"
//#import "JXInputView.h"
//#import "JXPickerView.h"
//#import "JXBannerView.h"
//#import "JXFilterView.h"
//#import "JXFilterViewCategory.h"
//#import "JXFilterViewSelection.h"
//#import "JXFilterViewSelectionContentTable.h"
//#import "JXStarView.h"
//#import "JXTableViewCell.h"
//#import "JXImageButton.h"
//#import "JXCollapsibleView.h"
//#import "JXLabel.h"
//#import "JXTermView.h"
//#import "TSWealthCardManagerView.h"
//#import "JXAlignButton.h"
//#pragma mark Controller
//#import "JXItemViewController.h"
//#import "JXViewController.h"
//#import "JXAssetPickerController.h"
//#import "JXMigrationController.h"
//#import "JXNavigationController.h"
//#import "JXScanViewController.h"
//#import "JXWebViewController.h"
//#pragma mark - Protocol
//#pragma mark - ViewModel
//
///****************************************************************************
// Category
// ***************************************************************************/
//#pragma mark - Category
//#pragma mark System
//#import "NSMutableArray+JXObjc.h"
//#import "UIBarButtonItem+JXObjc.h"
//#import "CALayer+JXObjc.h"
//#import "NSArray+JXObjc.h"
//#import "NSAttributedString+JXObjc.h"
//#import "NSData+JXObjc.h"
//#import "NSDateFormatter+JXObjc.h"
//#import "NSDate+JXObjc.h"
//#import "NSDictionary+JXObjc.h"
//#import "NSError+JXObjc.h"
//#import "NSManagedObject+JXObjc.h"
//#import "NSMutableDictionary+JXObjc.h"
//#import "NSURL+JXObjc.h"
//#import "NSString+JXObjc.h"
//#import "NSUserDefaults+JXObjc.h"
//#import "UIColor+JXObjc.h"
//#import "UIFont+JXObjc.h"
//#import "UIImage+JXObjc.h"
//#import "UIView+JXObjc.h"
//#import "UINavigationBar+JXObjc.h"
//#import "UINavigationItem+JXObjc.h"
//#import "UIScrollView+JXObjc.h"
//#import "UITabBar+JXObjc.h"
//#import "UITabBarItem+JXObjc.h"
//#import "UIWebView+JXObjc.h"
//#import "UIViewController+JXObjc.h"
//#import "UITextField+JXObjc.h"
//#pragma mark Vendor
//#import "MBProgressHUD+JXObjc.h"
//#import "MMDrawerController+JXObjc.h"
//#import "SVProgressHUD+JXObjc.h"



