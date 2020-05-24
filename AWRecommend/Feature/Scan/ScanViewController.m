//
//  ScanViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/13.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ScanViewController.h"
#import "ScanManualViewController.h"
#import "ScanEmptyViewController.h"
#import "BrandViewController.h"
#import "ScanResultThirdViewController.h"
#import "ScanResultServerViewController.h"

@interface ScanViewController ()
@property (nonatomic, weak) IBOutlet UIButton *manualButton;
@property (nonatomic, weak) IBOutlet UIView *diyBottomView;

@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) RACCommand *resultCommand;

@end

@implementation ScanViewController
- (instancetype)init {
    if (self = [super init]) {
        self.navItemColor = JXColorHex(0x333333);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"条形码扫描";
    self.view.backgroundColor = [UIColor blackColor];
    
    self.isNeedScanImage = YES;
    self.isOpenInterestRect = YES;
    
    self.style = [[LBXScanViewStyle alloc] init];
    self.style.centerUpOffset = JXAdaptScreen(60);
    self.style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    self.style.photoframeLineW = 3;
    self.style.photoframeAngleW = 18;
    self.style.photoframeAngleH = 18;
    self.style.isNeedShowRetangle = NO;
    self.style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    self.style.colorAngle = [UIColor colorWithRed:0./255 green:200./255. blue:20./255. alpha:1.0];
    self.style.animationImage = [JXScanViewController imageInBundle:@"qrcode_Scan_weixin_Line"];
    self.style.notRecoginitonArea = [JXColorHex(0x333333) colorWithAlphaComponent:0.8]; //[UIColor colorWithRed:247./255. green:202./255 blue:15./255 alpha:0.2];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.view bringSubviewToFront:self.diyBottomView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.manualButton jx_borderWithColor:[UIColor whiteColor] width:1.0 radius:6.0];
}

- (void)showError:(NSString*)str {
    [super showError:str];
    
    // [UIAlertView bk_showAlertViewWithTitle:@"提示" message:str cancelButtonTitle:@"知道了" otherButtonTitles:nil handler:NULL];
}

- (void)willStartScan {
    self.diyBottomView.hidden = NO;
}

- (void)scanResultWithArray:(NSArray<LBXScanResult*> *)array {
    if (0 == array.count) {
        [self showError:@"识别失败"];
        return;
    }
    
    LBXScanResult *result = array[0];
    if (0 == result.strScanned.length) {
        [self showError:@"识别失败"];
        return;
    }
    
    self.code = result.strScanned;
    [self.resultCommand execute:result.strScanned /*@"6926316888504"*/ /*@"6901424286206"*/];
    //[self.resultCommand execute:@"6913991300575" /*@"6913991300575" @"6901424286206"*/];
}

//- (void)popAlertMsgWithScanResult:(NSString *)strResult
//{
//    if (0 == strResult.length) {
//        
//        strResult = @"识别失败";
//    }
//    
//    @weakify(self)
//    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:strResult cancelButtonTitle:@"知道了" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//        @strongify(self)
//        [self reStartDevice];
//    }];
//}
//
//- (void)showNextVCWithScanResult:(LBXScanResult*)strResult {
//    NSString *msg = JXStrWithFmt(@"码值：%@\n类型：%@", strResult.strScanned, strResult.strBarCodeType);
//    [UIAlertView bk_showAlertViewWithTitle:@"结果" message:msg cancelButtonTitle:@"确定" otherButtonTitles:nil handler:NULL];
//}

- (RACCommand *)resultCommand {
    if (!_resultCommand) {
        _resultCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance getCodeData:input];
        }];
        [_resultCommand.executing subscribe:self.executing];
        [_resultCommand.errors subscribe:self.errors];
        
        @weakify(self)
        [_resultCommand.executionSignals.switchToLatest subscribeNext:^(ScanResult *result) {
            @strongify(self)
            if (0 == result.resultDataType) {
                ScanResultServerViewController *vc = [[ScanResultServerViewController alloc] init];
                vc.dataSource = result;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (1 == result.resultDataType) {
                ScanResultThirdViewController *vc = [[ScanResultThirdViewController alloc] init];
                vc.dataSource = result;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                ScanResultThird1ViewController *vc = [[ScanResultThird1ViewController alloc] init];
                vc.barcode = self.code;
                [self.navigationController pushViewController:vc animated:YES];
            }
            [JXDialog hideHUD];
        }];
    }
    return _resultCommand;
}


- (IBAction)manualButtonPressed:(id)sender {
    ScanManualViewController *vc = [[ScanManualViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

////绘制扫描区域
//- (void)drawTitle {
//    if (!_topTitle)
//    {
//        self.topTitle = [[UILabel alloc]init];
//        _topTitle.bounds = CGRectMake(0, 0, 145, 60);
//        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 50);
//        
//        //3.5inch iphone
//        if ([UIScreen mainScreen].bounds.size.height <= 568 )
//        {
//            _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 38);
//            _topTitle.font = [UIFont systemFontOfSize:14];
//        }
//        
//        
//        _topTitle.textAlignment = NSTextAlignmentCenter;
//        _topTitle.numberOfLines = 0;
//        _topTitle.text = @"将取景框对准二维码即可自动扫描";
//        _topTitle.textColor = [UIColor whiteColor];
//        [self.view addSubview:_topTitle];
//    }
//}
//
//- (void)drawBottomItems {
//    if (_bottomItemsView) {
//        return;
//    }
//    
//    self.bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-164,
//                                                                   CGRectGetWidth(self.view.frame), 100)];
//    _bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
//    
//    [self.view addSubview:_bottomItemsView];
//    
//    CGSize size = CGSizeMake(65, 87);
//    self.btnFlash = [[UIButton alloc]init];
//    _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
//    _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/2, CGRectGetHeight(_bottomItemsView.frame)/2);
//    [_btnFlash setImage:[UIImage jx_imageName:@"qrcode_scan_btn_flash_nor" frameworkName:@"LBXScan" bundleName:@"CodeScan"] forState:UIControlStateNormal];
//    [_btnFlash addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchUpInside];
//    
//    self.btnPhoto = [[UIButton alloc]init];
//    _btnPhoto.bounds = _btnFlash.bounds;
//    _btnPhoto.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/4, CGRectGetHeight(_bottomItemsView.frame)/2);
//    [_btnPhoto setImage:[UIImage jx_imageName:@"qrcode_scan_btn_photo_nor" frameworkName:@"LBXScan" bundleName:@"CodeScan"] forState:UIControlStateNormal];
//    [_btnPhoto setImage:[UIImage jx_imageName:@"qrcode_scan_btn_photo_down" frameworkName:@"LBXScan" bundleName:@"CodeScan"] forState:UIControlStateHighlighted];
//    [_btnPhoto addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
//    
//    self.btnMyQR = [[UIButton alloc]init];
//    _btnMyQR.bounds = _btnFlash.bounds;
//    _btnMyQR.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame) * 3/4, CGRectGetHeight(_bottomItemsView.frame)/2);
//    [_btnMyQR setImage:[UIImage jx_imageName:@"qrcode_scan_btn_myqrcode_nor" frameworkName:@"LBXScan" bundleName:@"CodeScan"] forState:UIControlStateNormal];
//    [_btnMyQR setImage:[UIImage jx_imageName:@"qrcode_scan_btn_myqrcode_down" frameworkName:@"LBXScan" bundleName:@"CodeScan"] forState:UIControlStateHighlighted];
//    [_btnMyQR addTarget:self action:@selector(myQRCode) forControlEvents:UIControlEventTouchUpInside];
//    
//    [_bottomItemsView addSubview:_btnFlash];
//    [_bottomItemsView addSubview:_btnPhoto];
//    [_bottomItemsView addSubview:_btnMyQR];
//    
//}

//#pragma mark -底部功能项
////打开相册
//- (void)openPhoto
//{
//    if ([JXPermissionManager hasCamera])
//        [self openLocalPhoto];
//    else
//    {
//        [self showError:@"      请到设置->隐私中开启本程序相册权限     "];
//    }
//}
//
////开关闪光灯
//- (void)openOrCloseFlash
//{
//    
//    [super openOrCloseFlash];
//    
//    
//    if (self.isOpenFlash)
//    {
//        [_btnFlash setImage:[UIImage jx_imageName:@"qrcode_scan_btn_flash_down" frameworkName:@"LBXScan" bundleName:@"CodeScan"] forState:UIControlStateNormal];
//    }
//    else
//    [_btnFlash setImage:[UIImage jx_imageName:@"qrcode_scan_btn_flash_nor" frameworkName:@"LBXScan" bundleName:@"CodeScan"] forState:UIControlStateNormal];
//}
//
//
//#pragma mark -底部功能项
//
//
//- (void)myQRCode
//{
////    CreateBarCodeViewController *vc = [CreateBarCodeViewController new];
////    [self.navigationController pushViewController:vc animated:YES];
//}

@end



