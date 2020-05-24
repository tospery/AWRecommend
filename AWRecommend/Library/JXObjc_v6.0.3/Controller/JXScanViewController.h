//
//  JXScanViewController.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/13.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXViewController.h"

// #ifdef JXEnableLibLBXScan
#ifdef JXEnableLibLBXNative

@interface JXScanViewController : JXViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, assign) BOOL isNeedScanImage;
@property (nonatomic, assign) BOOL isOpenInterestRect;
@property (nonatomic, assign) BOOL isOpenFlash;

@property (nonatomic, strong) LBXScanNative *scanObj;

#ifdef JXEnableLibLBXZXing
@property (nonatomic, strong) ZXingWrapper *zxingObj;
#endif

#ifdef JXEnableLibLBXZBar
@property (nonatomic, strong) LBXZBarWrapper *zbarObj;
#endif

@property (nonatomic, strong) LBXScanView *qRScanView;
@property (nonatomic, strong) LBXScanViewStyle *style;

@property (nonatomic, strong) UIImage *scanImage;

- (void)reStartDevice;
- (void)willStartScan;

- (void)openLocalPhoto;
- (void)openOrCloseFlash;

- (void)scanResultWithArray:(NSArray<LBXScanResult *> *)array;
- (void)showError:(NSString *)str;

+ (UIImage *)imageInBundle:(NSString *)name;

#pragma mark -模仿qq界面
+ (LBXScanViewStyle*)qqStyle;

#pragma mark --模仿支付宝
+ (LBXScanViewStyle*)ZhiFuBaoStyle;

#pragma mark -无边框，内嵌4个角
+ (LBXScanViewStyle*)InnerStyle;

#pragma mark -无边框，内嵌4个角
+ (LBXScanViewStyle*)weixinStyle;

#pragma mark -框内区域识别
+ (LBXScanViewStyle*)recoCropRect;

#pragma mark -4个角在矩形框线上,网格动画
+ (LBXScanViewStyle*)OnStyle;

#pragma mark -自定义4个角及矩形框颜色
+ (LBXScanViewStyle*)changeColor;

#pragma mark -改变扫码区域位置
+ (LBXScanViewStyle*)changeSize;

#pragma mark -非正方形，可以用在扫码条形码界面
+ (LBXScanViewStyle*)notSquare;

#pragma mark -ZXing码格式类型转native
+ (NSString*)convertZXBarcodeFormat:(ZXBarcodeFormat)barCodeFormat;

@end

#endif
