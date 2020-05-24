//
//  JXScanViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/13.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXScanViewController.h"

#ifdef JXEnableLibLBXNative

@interface JXScanViewController ()

@end

@implementation JXScanViewController
#pragma mark - Override
#pragma mark View
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = JXScanLibString(JXInstance.scanLib);
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self drawScanView];
    
    //不延时，可能会导致界面黑屏并卡住一会
    [self performSelector:@selector(startScan) withObject:nil afterDelay:0.2];
}

//绘制扫描区域
- (void)drawScanView {
    if (!_qRScanView) {
        CGRect rect = self.view.frame;
        rect.origin = CGPointMake(0, 0);
        
        self.qRScanView = [[LBXScanView alloc]initWithFrame:rect style:_style];
        
        [self.view addSubview:_qRScanView];
    }
    [_qRScanView startDeviceReadyingWithText:@"相机启动中"];
}

- (void)reStartDevice {
    switch (JXInstance.scanLib) {
            case JXScanLibNative: {
            [_scanObj startScan];
        }
            break;
#ifdef JXEnableLibLBXZXing
            case JXScanLibZXing: {
            [_zxingObj start];
        }
            break;
#endif
            
#ifdef JXEnableLibLBXZBar
            case JXScanLibZBar: {
            [_zbarObj start];
        }
            break;
#endif
        default:
            break;
    }
}

//启动设备
- (void)startScan {
    [self willStartScan];
    
    if (![JXPermissionManager hasCamera]) {
        [_qRScanView stopDeviceReadying];
        [self showError:@"请到设置->隐私中开启本程序相册权限"];
        return;
    }
    
    UIView *videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    videoView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:videoView atIndex:0];
    
    @weakify(self)
    switch (JXInstance.scanLib) {
            case JXScanLibNative: {
            if (!_scanObj ) {
                CGRect cropRect = CGRectZero;
                
                if (_isOpenInterestRect) {
                    //设置只识别框内区域
                    cropRect = [LBXScanView getScanRectWithPreView:self.view style:_style];
                }
                
                //NSString *strCode = AVMetadataObjectTypeQRCode;
                //AVMetadataObjectTypeITF14Code 扫码效果不行,另外只能输入一个码制，虽然接口是可以输入多个码制
                self.scanObj = [[LBXScanNative alloc]initWithPreView:videoView ObjectType:nil/*@[strCode]*/ cropRect:cropRect success:^(NSArray<LBXScanResult *> *array) {
                    @strongify(self)
                    [self scanResultWithArray:array];
                }];
                [_scanObj setNeedCaptureImage:_isNeedScanImage];
            }
            [_scanObj startScan];
        }
            break;
            #ifdef JXEnableLibLBXZXing
            case JXScanLibZXing: {
            if (!_zxingObj) {
                self.zxingObj = [[ZXingWrapper alloc]initWithPreView:videoView block:^(ZXBarcodeFormat barcodeFormat, NSString *str, UIImage *scanImg) {
                    @strongify(self)
                    LBXScanResult *result = [[LBXScanResult alloc]init];
                    result.strScanned = str;
                    result.imgScanned = scanImg;
                    result.strBarCodeType = [self convertZXBarcodeFormat:barcodeFormat];
                    [self scanResultWithArray:@[result]];
                }];
                
                if (_isOpenInterestRect) {
                    //设置只识别框内区域
                    CGRect cropRect = [LBXScanView getZXingScanRectWithPreView:videoView style:_style];
                    [_zxingObj setScanRect:cropRect];
                }
            }
            [_zxingObj start];
        }
            break;
#endif
            
            #ifdef JXEnableLibLBXZBar
            case JXScanLibZBar: {
            if (!_zbarObj) {
                self.zbarObj = [[LBXZBarWrapper alloc]initWithPreView:videoView barCodeType:ZBAR_I25 block:^(NSArray<LBXZbarResult *> *result) {
                    @strongify(self)
                    //测试，只使用扫码结果第一项
                    LBXZbarResult *firstObj = result[0];
                    
                    LBXScanResult *scanResult = [[LBXScanResult alloc]init];
                    scanResult.strScanned = firstObj.strScanned;
                    scanResult.imgScanned = firstObj.imgScanned;
                    scanResult.strBarCodeType = [LBXZBarWrapper convertFormat2String:firstObj.format];
                    
                    [self scanResultWithArray:@[scanResult]];
                }];
            }
            [_zbarObj start];
        }
            break;
#endif
        default:
            break;
    }
    
    [_qRScanView stopDeviceReadying];
    [_qRScanView startScanAnimation];
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self stopScan];
    
    [_qRScanView stopScanAnimation];
}

- (void)stopScan {
    switch (JXInstance.scanLib) {
            case JXScanLibNative: {
            [_scanObj stopScan];
        }
            break;
#ifdef JXEnableLibLBXZXing
            case JXScanLibZXing: {
            [_zxingObj stop];
        }
            break;
#endif
#ifdef JXEnableLibLBXZBar
            case JXScanLibZBar: {
            [_zbarObj stop];
        }
            break;
#endif
        default:
            break;
    }
    
}

#pragma mark -实现类继承该方法，作出对应处理
- (void)scanResultWithArray:(NSArray<LBXScanResult *> *)array {
    if (0 == array.count) {
        [self showError:@"识别失败"];
        return;
    }
    
    LBXScanResult *result = array[0];
    if (0 == result.strScanned.length) {
        [self showError:@"识别失败"];
        return;
    }
    
    NSString *msg = JXStrWithFmt(@"码值：%@\n类型：%@", result.strScanned, result.strBarCodeType);
    [UIAlertView bk_showAlertViewWithTitle:@"结果" message:msg cancelButtonTitle:@"确定" otherButtonTitles:nil handler:NULL];
    
    
//    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
//    //    for (LBXScanResult *result in array) {
//    //
//    //        NSLog(@"scanResult:%@",result.strScanned);
//    //    }
//    
//    LBXScanResult *scanResult = array[0];
//    
//    NSString *strResult = scanResult.strScanned;
//    
//    self.scanImage = scanResult.imgScanned;
//    
//    if (!strResult) {
//        
//        [self popAlertMsgWithScanResult:nil];
//        
//        return;
//    }
//    
//    //震动提醒
//    // [LBXScanWrapper systemVibrate];
//    //声音提醒
//    //[LBXScanWrapper systemSound];
//    
//    [self showNextVCWithScanResult:scanResult];
}

//- (void)popAlertMsgWithScanResult:(NSString*)strResult {
//    if (0 == strResult.length) {
//        strResult = @"识别失败";
//    }
//    
//    @weakify(self)
//    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:strResult cancelButtonTitle:@"知道了" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//       @strongify(self)
//        [self reStartDevice];
//    }];
//}

//- (void)showNextVCWithScanResult:(LBXScanResult*)strResult {
//    NSString *msg = JXStrWithFmt(@"码值：%@\n类型：%@", strResult.strScanned, strResult.strBarCodeType);
//    [UIAlertView bk_showAlertViewWithTitle:@"结果" message:msg cancelButtonTitle:@"确定" otherButtonTitles:nil handler:NULL];
//}

//子类继承必须实现的提示
- (void)showError:(NSString*)str {
    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:str cancelButtonTitle:@"知道了" otherButtonTitles:nil handler:NULL];
}

//开关闪光灯
- (void)openOrCloseFlash {
    switch (JXInstance.scanLib) {
            case JXScanLibNative: {
            [_scanObj changeTorch];
        }
            break;
#ifdef JXEnableLibLBXZXing
            case JXScanLibZXing: {
            [_zxingObj openOrCloseTorch];
        }
            break;
#endif
#ifdef JXEnableLibLBXZBar
            case JXScanLibZBar: {
            [_zbarObj openOrCloseFlash];
        }
            break;
#endif
        default:
            break;
    }
    self.isOpenFlash =!self.isOpenFlash;
}

- (void)willStartScan {
    
}

#pragma mark --打开相册并识别图片

/*!
 *  打开本地照片，选择图片识别
 */
- (void)openLocalPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    
    //部分机型有问题
    //    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
}



//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    __block UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    @weakify(self)
    switch (JXInstance.scanLib) {
            case JXScanLibNative: {
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)
            {
                [LBXScanNative recognizeImage:image success:^(NSArray<LBXScanResult *> *array) {
                    @strongify(self)
                    [self scanResultWithArray:array];
                }];
            }
            else
            {
                [self showError:@"native低于ios8.0系统不支持识别图片条码"];
            }
        }
            break;
            #ifdef JXEnableLibLBXZXing
            case JXScanLibZXing:
        {
            [ZXingWrapper recognizeImage:image block:^(ZXBarcodeFormat barcodeFormat, NSString *str) {
                @strongify(self)
                LBXScanResult *result = [[LBXScanResult alloc]init];
                result.strScanned = str;
                result.imgScanned = image;
                result.strBarCodeType = [self convertZXBarcodeFormat:barcodeFormat];
                
                [self scanResultWithArray:@[result]];
            }];
            
        }
            break;
#endif
            #ifdef JXEnableLibLBXZBar
            case JXScanLibZBar:
        {
            [LBXZBarWrapper recognizeImage:image block:^(NSArray<LBXZbarResult *> *result) {
                @strongify(self)
                //测试，只使用扫码结果第一项
                LBXZbarResult *firstObj = result[0];
                
                LBXScanResult *scanResult = [[LBXScanResult alloc]init];
                scanResult.strScanned = firstObj.strScanned;
                scanResult.imgScanned = firstObj.imgScanned;
                scanResult.strBarCodeType = [LBXZBarWrapper convertFormat2String:firstObj.format];
                
                [self scanResultWithArray:@[scanResult]];
                
            }];
        }
            break;
#endif
        default:
            break;
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"cancel");
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

+ (UIImage *)imageInBundle:(NSString *)name {
    return [UIImage jx_imageName:name frameworkName:@"LBXScan" bundleName:@"CodeScan"];
}

- (NSString*)convertZXBarcodeFormat:(ZXBarcodeFormat)barCodeFormat {
    NSString *strAVMetadataObjectType = nil;
    
    switch (barCodeFormat) {
            case kBarcodeFormatQRCode:
            strAVMetadataObjectType = AVMetadataObjectTypeQRCode;
            break;
            case kBarcodeFormatEan13:
            strAVMetadataObjectType = AVMetadataObjectTypeEAN13Code;
            break;
            case kBarcodeFormatEan8:
            strAVMetadataObjectType = AVMetadataObjectTypeEAN8Code;
            break;
            case kBarcodeFormatPDF417:
            strAVMetadataObjectType = AVMetadataObjectTypePDF417Code;
            break;
            case kBarcodeFormatAztec:
            strAVMetadataObjectType = AVMetadataObjectTypeAztecCode;
            break;
            case kBarcodeFormatCode39:
            strAVMetadataObjectType = AVMetadataObjectTypeCode39Code;
            break;
            case kBarcodeFormatCode93:
            strAVMetadataObjectType = AVMetadataObjectTypeCode93Code;
            break;
            case kBarcodeFormatCode128:
            strAVMetadataObjectType = AVMetadataObjectTypeCode128Code;
            break;
            case kBarcodeFormatDataMatrix:
            strAVMetadataObjectType = AVMetadataObjectTypeDataMatrixCode;
            break;
            case kBarcodeFormatITF:
            strAVMetadataObjectType = AVMetadataObjectTypeITF14Code;
            break;
            case kBarcodeFormatRSS14:
            break;
            case kBarcodeFormatRSSExpanded:
            break;
            case kBarcodeFormatUPCA:
            break;
            case kBarcodeFormatUPCE:
            strAVMetadataObjectType = AVMetadataObjectTypeUPCECode;
            break;
        default:
            break;
    }
    
    
    return strAVMetadataObjectType;
}


+ (LBXScanViewStyle *)qqStyle {
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 44;
    
    //扫码框周围4个角的类型,设置为外挂式
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 6;
    
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //线条上下移动图片
    style.animationImage = [JXScanViewController imageInBundle:@"qrcode_scan_light_green"];
    
    return style;
}

#pragma mark --模仿支付宝
+ (LBXScanViewStyle*)ZhiFuBaoStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 60;
    style.xScanRetangleOffset = 30;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480 )
    {
        //3.5inch 显示的扫码缩小
        style.centerUpOffset = 40;
        style.xScanRetangleOffset = 20;
    }
    
    style.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2.0;
    style.photoframeAngleW = 16;
    style.photoframeAngleH = 16;
    
    style.isNeedShowRetangle = NO;
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    //使用的支付宝里面网格图片
    UIImage *imgFullNet = [JXScanViewController imageInBundle:@"qrcode_scan_full_net"];
    style.animationImage = imgFullNet;
    
    return style;
}

#pragma mark -无边框，内嵌4个角
+ (LBXScanViewStyle*)InnerStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 3;
    style.photoframeAngleW = 18;
    style.photoframeAngleH = 18;
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //qq里面的线条图片
    UIImage *imgLine = [JXScanViewController imageInBundle:@"qrcode_scan_light_green"];
    style.animationImage = imgLine;
    
    return style;
}

#pragma mark -无边框，内嵌4个角
+ (LBXScanViewStyle*)weixinStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2;
    style.photoframeAngleW = 18;
    style.photoframeAngleH = 18;
    style.isNeedShowRetangle = YES;
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    style.colorAngle = [UIColor colorWithRed:0./255 green:200./255. blue:20./255. alpha:1.0];
    
    //qq里面的线条图片
    UIImage *imgLine = [JXScanViewController imageInBundle:@"qrcode_Scan_weixin_Line"];
    
    style.animationImage = imgLine;
    
    return style;
}

#pragma mark -框内区域识别
+ (LBXScanViewStyle*)recoCropRect
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_On;
    style.photoframeLineW = 6;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    style.isNeedShowRetangle = YES;
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    //矩形框离左边缘及右边缘的距离
    style.xScanRetangleOffset = 80;
    
    //使用的支付宝里面网格图片
    UIImage *imgPartNet = [JXScanViewController imageInBundle:@"qrcode_scan_part_net"];
    style.animationImage = imgPartNet;
    
    return style;
}

#pragma mark -4个角在矩形框线上,网格动画
+ (LBXScanViewStyle*)OnStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_On;
    style.photoframeLineW = 6;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    style.isNeedShowRetangle = YES;
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    //使用的支付宝里面网格图片
    UIImage *imgPartNet = [JXScanViewController imageInBundle:@"qrcode_scan_part_net"];
    style.animationImage = imgPartNet;
    
    return style;
}

#pragma mark -自定义4个角及矩形框颜色
+ (LBXScanViewStyle*)changeColor
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    style.centerUpOffset = 44;
    //扫码框周围4个角的类型设置为在框的上面
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_On;
    //扫码框周围4个角绘制线宽度
    style.photoframeLineW = 6;
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    //显示矩形框
    style.isNeedShowRetangle = YES;
    //动画类型：网格形式，模仿支付宝
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    style.animationImage = [JXScanViewController imageInBundle:@"qrcode_scan_part_net"];

    //码框周围4个角的颜色
    style.colorAngle = [UIColor colorWithRed:65./255. green:174./255. blue:57./255. alpha:1.0];
    //矩形框颜色
    style.colorRetangleLine = [UIColor colorWithRed:247/255. green:202./255. blue:15./255. alpha:1.0];
    //非矩形框区域颜色
    style.notRecoginitonArea = [UIColor colorWithRed:247./255. green:202./255 blue:15./255 alpha:0.2];
    
    return style;
}

#pragma mark -改变扫码区域位置
+ (LBXScanViewStyle*)changeSize
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形框向上移动
    style.centerUpOffset = 60;
    //矩形框离左边缘及右边缘的距离
    style.xScanRetangleOffset = 100;
    
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_On;
    style.photoframeLineW = 6;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    style.isNeedShowRetangle = YES;
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //qq里面的线条图片
    UIImage *imgLine = [JXScanViewController imageInBundle:@"qrcode_scan_light_green"];

    style.animationImage = imgLine;
    
    return style;
}

#pragma mark -非正方形，可以用在扫码条形码界面
+ (LBXScanViewStyle*)notSquare
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 4;
    style.photoframeAngleW = 28;
    style.photoframeAngleH = 16;
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_LineStill;
    style.animationImage = [UIImage jx_imageWithColor:[UIColor redColor]];
    //非正方形
    //设置矩形宽高比
    style.whRatio = 4.3/2.18;
    //离左边和右边距离
    style.xScanRetangleOffset = 30;
    
    return style;
}


+ (NSString*)convertZXBarcodeFormat:(ZXBarcodeFormat)barCodeFormat
{
    NSString *strAVMetadataObjectType = nil;
    
    switch (barCodeFormat) {
        case kBarcodeFormatQRCode:
            strAVMetadataObjectType = AVMetadataObjectTypeQRCode;
            break;
        case kBarcodeFormatEan13:
            strAVMetadataObjectType = AVMetadataObjectTypeEAN13Code;
            break;
        case kBarcodeFormatEan8:
            strAVMetadataObjectType = AVMetadataObjectTypeEAN8Code;
            break;
        case kBarcodeFormatPDF417:
            strAVMetadataObjectType = AVMetadataObjectTypePDF417Code;
            break;
        case kBarcodeFormatAztec:
            strAVMetadataObjectType = AVMetadataObjectTypeAztecCode;
            break;
        case kBarcodeFormatCode39:
            strAVMetadataObjectType = AVMetadataObjectTypeCode39Code;
            break;
        case kBarcodeFormatCode93:
            strAVMetadataObjectType = AVMetadataObjectTypeCode93Code;
            break;
        case kBarcodeFormatCode128:
            strAVMetadataObjectType = AVMetadataObjectTypeCode128Code;
            break;
        case kBarcodeFormatDataMatrix:
            strAVMetadataObjectType = AVMetadataObjectTypeDataMatrixCode;
            break;
        case kBarcodeFormatITF:
            strAVMetadataObjectType = AVMetadataObjectTypeITF14Code;
            break;
        case kBarcodeFormatRSS14:
            break;
        case kBarcodeFormatRSSExpanded:
            break;
        case kBarcodeFormatUPCA:
            break;
        case kBarcodeFormatUPCE:
            strAVMetadataObjectType = AVMetadataObjectTypeUPCECode;
            break;
        default:
            break;
    }
    
    
    return strAVMetadataObjectType;
}



@end

#endif






