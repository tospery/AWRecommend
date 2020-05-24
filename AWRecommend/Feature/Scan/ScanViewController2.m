//
//  ScanViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/6.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ScanViewController2.h"
#import "ScanManualViewController.h"
#import "ScanEmptyViewController.h"
#import "BrandViewController.h"
#import "ScanResultThirdViewController.h"
#import "ScanResultServerViewController.h"

@interface ScanViewController2 ()
//<ZXCaptureDelegate>
//@property (nonatomic, strong) ZXCapture *capture;
//@property (nonatomic, strong) NSTimer *timer;
//@property (nonatomic, assign) CGFloat scanViewHeight;
//@property (nonatomic, assign) BOOL indicatorToUp;
//@property (nonatomic, assign) BOOL scanToken;
//
//@property (nonatomic, weak) IBOutlet UILabel *tipsLabel;
//@property (nonatomic, weak) IBOutlet UIButton *manualButton;
//
//@property (nonatomic, weak) IBOutlet UIView *scanView;
//@property (nonatomic, weak) IBOutlet UIImageView *indicatorImageView;
//
//@property (nonatomic, weak) IBOutlet NSLayoutConstraint *indicatorTopConstraint;
//@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *aroundViews;
//
////@property (nonatomic, strong) RACCommand *codeCommand;
//@property (nonatomic, strong) RACCommand *resultCommand;

@end

@implementation ScanViewController2
//#pragma mark - Override methods
//- (instancetype)init {
//    if (self = [super init]) {
////        self.shouldRequestRemoteDataOnViewDidLoad = YES;
////        self.shouldPullToRefresh = YES;
//    }
//    return self;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self setupVar];
//    [self setupData];
//    [self setupView];
//    [self setupSignal];
//    [self setupNet];
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
////    if (!_timeToken) {
////        _timeToken = YES;
////        
////        _scanTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(scanTimerSchedule) userInfo:nil repeats:YES];
////        [_scanTimer fire];
////        _startDate = [NSDate date];
////    }
//    
//    if (!self.scanViewHeight) {
//        self.scanViewHeight = self.scanView.jx_height;
//    }
//    
////    if (!self.timer) {
////        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.012 target:self selector:@selector(timerScheduled) userInfo:nil repeats:YES];
////        [self.timer fire];
////    }
//    [self startScan];
//}
//
//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    
//    [self.manualButton jx_borderWithColor:[UIColor whiteColor] width:1.0 radius:6.0];
//
//    if (CGRectEqualToRect(self.capture.scanRect, CGRectZero)) {
//        CGRect captureFrame = self.scrollView.bounds;
//        self.capture.layer.frame = captureFrame;
//        
//        CGSize captureSize = CGSizeMake(360, 480);
//        if ([self.capture.sessionPreset isEqualToString:AVCaptureSessionPresetHigh]) {
//            captureSize = CGSizeMake(1080, 1920);
//        }
//        CGAffineTransform transform = CGAffineTransformMakeScale(captureSize.width / captureFrame.size.width, captureSize.height / captureFrame.size.height);
//        self.capture.scanRect = CGRectApplyAffineTransform(self.scanView.frame, transform);
//    }
//}
//
//- (void)bindViewModel {
//    [super bindViewModel];
//    
////    RAC(self, dataSource) = [[[self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData] map:^id(NSArray *items) {
////        return JXArrValue(items, [NSArray new]);
////    }] map:^id(NSArray *items) {
////        return @[JXArrValue(items, [NSArray new])];
////    }];
//}
//
//- (void)dealloc {
//    [self stopScan];
//    
//    [self.capture.layer removeFromSuperlayer];
//    self.timer = nil;
//}
//
//#pragma mark - Private methods
//#pragma mark setup
//- (void)setupVar {
//    
//}
//
//- (void)setupData {
//}
//
//- (void)setupView {
//    self.navigationItem.title = @"条形码扫描";
//    
//    [self.contentView.layer addSublayer:self.capture.layer];
//    [self.contentView bringSubviewToFront:self.scanView];
//    for (UIView *view in self.aroundViews) {
//        [self.contentView bringSubviewToFront:view];
//    }
//    
//    self.tipsLabel.font = JXFont(14);
//    JXAdaptButton(self.manualButton, JXFont(15));
//    self.indicatorImageView.backgroundColor = SMInstance.mainColor;
//}
//
//- (void)setupSignal {
//}
//
//- (void)setupNet {
//}
//
//#pragma mark fetch
//#pragma mark request
//#pragma mark assist
//- (void)startScan {
//    self.scanToken = NO;
//    
//    if (!self.capture.running) {
//        [self.capture start];
//    }
//    
//    if (!self.timer.valid) {
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.014 target:self selector:@selector(timerScheduled) userInfo:nil repeats:YES];
//        [self.timer fire];
//    }
//}
//
//- (void)stopScan {
//    self.scanToken = YES;
//    
//    // [self.capture.layer removeFromSuperlayer];
//    if (self.capture.running) {
//       [self.capture stop];
//    }
//    
//    if (self.timer.valid) {
//        [self.timer invalidate];
//    }
//    
////    [_scanTimer invalidate];
////    _scanTimer = nil;
//}
//
////#pragma mark - Table
////- (id)fetchLocalData {
////    return nil;
////}
////
////- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
////    return [HRInstance requestDhzyDaibanListWithPage:1];
////}
////
////- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
////    DhzyDaibanCell *myCell = (DhzyDaibanCell *)cell;
////    myCell.data = object;
////}
////
////- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
////    return [DhzyDaibanCell height];
////}
////
////- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
////    return [tableView dequeueReusableCellWithIdentifier:[DhzyDaibanCell identifier] forIndexPath:indexPath];
////}
//
//#pragma mark - Accessor methods
//- (RACCommand *)resultCommand {
//    if (!_resultCommand) {
//        _resultCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//            return [HRInstance getCodeData:input];
//        }];
//        [_resultCommand.executing subscribe:self.executing];
//        [_resultCommand.errors subscribe:self.errors];
//        
//        @weakify(self)
//        [_resultCommand.executionSignals.switchToLatest subscribeNext:^(ScanResult *result) {
//            @strongify(self)
//            if (0 == result.resultDataType) {
//                ScanResultServerViewController *vc = [[ScanResultServerViewController alloc] init];
//                vc.dataSource = result;
//                [self.navigationController pushViewController:vc animated:YES];
//            }else if (1 == result.resultDataType) {
//                ScanResultThirdViewController *vc = [[ScanResultThirdViewController alloc] init];
//                vc.dataSource = result;
//                [self.navigationController pushViewController:vc animated:YES];
//            }else {
//                ScanEmptyViewController *vc = [[ScanEmptyViewController alloc] init];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//            [JXDialog hideHUD];
//        }];
//    }
//    return _resultCommand;
//}
//
//
//- (ZXCapture *)capture {
//    if (!_capture) {
//        _capture = [[ZXCapture alloc] init];
//        _capture.sessionPreset = AVCaptureSessionPresetHigh;
//        _capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
//        _capture.camera = _capture.back;
//        _capture.rotation = 90.0f;
//        _capture.delegate = self;
//    }
//    return _capture;
//}
//
////- (RACCommand *)codeCommand {
////    if (!_codeCommand) {
////        _codeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
////            return [HRInstance getCodeData:input];
////        }];
////        [_codeCommand.executing subscribe:self.executing];
////        [_codeCommand.errors subscribe:self.errors];
////        
////        @weakify(self)
////        [_codeCommand.executionSignals.switchToLatest subscribeNext:^(CompResultItem *item) {
////            @strongify(self)
////            [JXDialog hideHUD];
////            if (item) {
////                CompResultItem *ds = [CompResultItem new];
////                ds.dId = 6575;
////                
////                BrandViewController *vc = [[BrandViewController alloc] initWithoutRequest];
////                vc.dataSource = ds;
////                [self.navigationController pushViewController:vc animated:YES];
////            }else {
////                ScanEmptyViewController *vc = [[ScanEmptyViewController alloc] init];
////                [self.navigationController pushViewController:vc animated:YES];
////            }
////        }];
////    }
////    return _codeCommand;
////}
//
//
//#pragma mark - Action methods
//- (void)timerScheduled {
//    CGFloat adjust = 0;
//    if (self.indicatorToUp) {
//        adjust = self.indicatorTopConstraint.constant - 3;
//        if (adjust < 0) {
//            self.indicatorToUp = NO;
//            adjust += 6;
//        }
//    }else {
//        adjust = self.indicatorTopConstraint.constant + 3;
//        if (adjust > self.scanViewHeight) {
//            self.indicatorToUp = YES;
//            adjust -= 6;
//        }
//    }
//    self.indicatorTopConstraint.constant = adjust;
//}
//
//- (IBAction)manualButtonPressed:(id)sender {
//    ScanManualViewController *vc = [[ScanManualViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//#pragma mark - Notification methods
//
//#pragma mark - Delegate methods
//- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
//    if (self.scanToken) {
//        return;
//    }
//    //self.scanToken = YES;
//    
//    [self stopScan];
//    
////    CompResultItem *ds = [CompResultItem new];
////    ds.uid = @"6901424286206"; //  result.text;
////    
////    BrandViewController *vc = [[BrandViewController alloc] init];
////    vc.fromScan = YES;
////    vc.dataSource = ds;
////    [self.navigationController pushViewController:vc animated:YES];
//    
////    [self.codeCommand execute:result.text];
////    
////    [self stopScan];
////    NSLog(@"code = %@", result.text);
//    
//    
//    [self.resultCommand execute:result.text/*@"6926316888504"*/ /*@"6901424286206"*/];
//}
//
//#pragma mark - Public methods
//#pragma mark - Class methods


@end




