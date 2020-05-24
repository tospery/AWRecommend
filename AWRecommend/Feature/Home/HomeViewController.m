//
//  HomeViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/27.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "HomeViewController.h"
#import "SearchViewController.h"
#import "TestViewController.h"
#import "ScanViewController.h"
#import "ResultViewController.h"
#import "ScanPopupViewController.h"
#import "ShortcutViewController.h"
#import "WXPayRequest.h"
#import "JXPayManager.h"

@interface HomeViewController ()
@property (nonatomic, weak) IBOutlet UIView *searchView;
@property (nonatomic, weak) IBOutlet JXButton *scanButton;

@property (nonatomic, weak) IBOutlet TTTAttributedLabel *quoteDescLabel;
@property (nonatomic, weak) IBOutlet UILabel *quoteAuthLabel;

@property (nonatomic, strong) RACCommand *quoteCommand;
@end

@implementation HomeViewController
#pragma mark - Override
#pragma mark init
- (instancetype)init {
    if (self = [super init]) {
//        self.shouldRequestRemoteDataOnViewDidLoad = YES;
//        self.shouldPullToRefresh = YES;
    }
    return self;
}

#pragma mark view
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVar];
    [self setupView];
    [self setupNet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar jx_transparet];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar jx_reset];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.searchView jx_borderWithColor:[UIColor clearColor] width:0.0 radius:6.0];
}

#pragma mark setup
- (void)setupVar {
}

- (void)setupView {
    [self.navigationController.navigationBar jx_transparet];
    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    titleLabel.font = JXFontBold(16);
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.text = @"健康智选";
//    [titleLabel sizeToFit];
//    self.navigationItem.titleView = titleLabel;
    
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:JXImageWithName(@"img_home_logo")];
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.adjustsImageWhenHighlighted = NO;
    [titleButton setBackgroundImage:JXImageWithName(@"img_home_logo") forState:UIControlStateNormal];
    //[titleButton setImage:JXImageWithName(@"img_home_logo") forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(titleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [titleButton sizeToFit];

    self.navigationItem.titleView = titleButton;
    
    JXAdaptButton(self.scanButton, JXFont(8));
    self.scanButton.style = JXButtonStyleBottom;
    self.scanButton.distance = 2;
    
    
//    self.quoteDescLabel.text = @"买椟还珠的现象层出不穷，在批发市场，塑料袋简装的花生既便宜，又实惠，却滞销；而有一种精美铁盒包装的花生，仅仅因为物美，就经常卖断货。消费者永远是对的，只买贵的，不买对的，自有其不可与外人道的非常道理。";
//    self.quoteAuthLabel.text = JXStrWithFmt(@"---%@", @"健康智选");
    
////    UINib *nib = [UINib nibWithNibName:@"JXCell" bundle:nil];
////    [self.tableView registerNib:nib forCellReuseIdentifier:[JXCell identifier]];
////    self.tableView.tableFooterView = [UIView new];
//    
//    UIImage *image = JXAdaptImage([self.symptomButton imageForState:UIControlStateNormal]);
//    [self.symptomButton setImage:image forState:UIControlStateNormal];
//    self.symptomButton.style = JXButtonStyleBottom;
//    self.symptomButton.distance = JXAdaptScreen(6.0);
//    self.symptomButton.titleLabel.numberOfLines = 0.0;
//    self.symptomButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    
//    NSString *text = @"按症状查\n分类更具体查药更方便";
//    NSMutableAttributedString *mas = [NSMutableAttributedString jx_attributedStringWithString:text color:JXColorHex(0x333333) font:JXFont(15)];
//    [mas jx_addLineSpacing:4.0f];
//    [mas jx_addAttributeWithColor:JXColorHex(0x999999) font:JXFont(12) range:NSMakeRange(5, text.length - 5)];
//    [self.symptomButton setAttributedTitle:mas forState:UIControlStateNormal];
}

- (void)setupNet {
    [self.quoteCommand execute:nil];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [JXPayManager sharedInstance].delegate = self;
//        [[HRInstance orderPay:@"S17081615462200467025" cash:2] subscribeNext:^(id  _Nullable x) {
//            WXPayRequest *info = [WXPayRequest mj_objectWithKeyValues:x];
//            PayReq *req = [[PayReq alloc] init];
//            req.partnerId = info.partnerid;
//            req.prepayId = info.prepayid;
//            req.nonceStr = info.noncestr;
//            req.timeStamp = (UInt32)info.timestamp;
//            req.package = info.packages;
//            req.sign = info.sign;
//            [WXApi sendReq:req];
//            
//            int a = 0;
//        } error:^(NSError * _Nullable error) {
//            int b= 0;
//        }];
//    });
}

- (void)managerDidRecvPayResp:(PayResp *)resp {
    switch (resp.errCode) {
        case WXSuccess: {
            JXHUDInfo(@"微信支付成功", YES);
            //[self paySuccess];
        }
            break;
        default: {
            JXHUDInfo(@"微信支付支付失败呃", YES);
        }
            break;
    }
}

#pragma mark scroll
- (void)bindViewModel {
    [super bindViewModel];
    
//    RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
//    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
//    RAC(self, dataSource) = [[[fetchLocalDataSignal merge:requestRemoteDataSignal] deliverOnMainThread] map:^id _Nullable(id result) {
//        return JXArrTable(result);
//    }];
}

//- (id)fetchLocalData {
//    return nil;
//}
//
//- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
//    return [HRInstance requestDhzyDaibanListWithPage:1];
//}

#pragma mark table
//- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
//    return [JXCell height];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath object:(id)object {
//    return [tableView dequeueReusableCellWithIdentifier:[JXCell identifier] forIndexPath:indexPath];
//}
//
//- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
//    JXCell *myCell = (JXCell *)cell;
//    myCell.data = object;
//}

#pragma mark - Accessor
- (RACCommand *)quoteCommand {
    if (!_quoteCommand) {
        _quoteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance getKnowledgeLibInfo];
        }];
        [_quoteCommand.errors subscribe:self.errors];
        
        @weakify(self)
        [_quoteCommand.executionSignals.switchToLatest subscribeNext:^(CompQuote *quote) {
            @strongify(self)
            self.quoteAuthLabel.text = JXStrWithFmt(@"---%@", JXStrWithDft(quote.title, @""));
            self.quoteDescLabel.text = JXStrWithDft(quote.content, @"");
        }];
    }
    return _quoteCommand;
}


#pragma mark - Private
#pragma mark - Public
#pragma mark - Action
- (IBAction)scanButtonPressed:(id)sender {
    EntryScan(self.navigationController);
}

- (IBAction)searchButtonPressed:(id)sender {
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)symptomButtonPressed:(id)sender {
    ShortcutViewController *vc = [[ShortcutViewController alloc] init];
    vc.type = ShortcutTypeSymptom;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)nameButtonPressed:(id)sender {
    ShortcutViewController *vc = [[ShortcutViewController alloc] init];
    vc.type = ShortcutTypeName;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)titleButtonPressed:(id)sender {
//    static NSInteger tappedCount = 0;
//    if (tappedCount++ == 10) {
//        tappedCount = 0;
//     
//        JXServerViewController *vc = [[JXServerViewController alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.changeBlock = ^(JXEnvType t) {
//            gMisc.kIMAppId = (JXEnvTypeApp == t ? @"1400016593" : @"1400016498");
//        };
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

#pragma mark - Notification
#pragma mark - Delegate
#pragma mark - Class


@end
