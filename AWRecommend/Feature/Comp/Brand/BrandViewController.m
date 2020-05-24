//
//  BrandViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/15.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "BrandViewController.h"
#import "BrandCell.h"
#import "MedicineViewController.h"
#import "ScanCommitViewController.h"
#import "BrandDetailViewController.h"
#import "JXTipsViewController.h"
#import "ChatViewController.h"
#import "BrandInfoViewController.h"

@interface BrandViewController () <UITableViewDataSource, UITableViewDelegate>
// @property (nonatomic, strong) JXButton *menuButton;

@property (nonatomic, weak) IBOutlet UIButton *searchCountButton;
@property (nonatomic, weak) IBOutlet UIButton *searchTotalButton;

@property (nonatomic, weak) IBOutlet UIButton *goButton;

@property (nonatomic, assign) BOOL isEmpty;
@property (nonatomic, weak) IBOutlet UIView *emptyView;

@property (nonatomic, weak) IBOutlet UIView *topView;
@property (nonatomic, weak) IBOutlet UIButton *securityButton;
@property (nonatomic, weak) IBOutlet UIButton *stabilityButton;

@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UILabel *otcLabel;

@property (nonatomic, weak) IBOutlet UILabel *detailTitle1Label;
@property (nonatomic, weak) IBOutlet UILabel *detailTitle2Label;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *detailLabel;
@property (nonatomic, weak) IBOutlet UIView *detailView;

@property (nonatomic, weak) IBOutlet UILabel *searchTitle1Label;
@property (nonatomic, weak) IBOutlet UILabel *searchTitle2Label;
@property (nonatomic, weak) IBOutlet UILabel *searchCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *searchTotalLabel;


@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet UILabel *brandTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *brandTipsLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dtos;

@property (nonatomic, strong) ProgressViewController *progressVC;

@property (nonatomic, strong) RACCommand *recordCommand;

@property (nonatomic, strong) RACCommand *doctorCommand;

@property (nonatomic, strong) UILabel *navTitleLabel;
@property (nonatomic, strong) UIButton *navInfoButton;

@end

@implementation BrandViewController
#pragma mark - Override methods
- (instancetype)init {
    if (self = [super init]) {
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVar];
    [self setupData];
    [self setupView];
    [self setupSignal];
    [self setupNet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.isEmpty) {
        [self.navigationController.navigationBar jx_transparet];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.isEmpty) {
        [self.navigationController.navigationBar jx_reset];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.detailView jx_borderWithColor:[UIColor clearColor] width:0.0 radius:6.0];
    [self.bottomView jx_borderWithColor:[UIColor clearColor] width:0.0 radius:6.0];
    [self.typeLabel jx_borderWithColor:[UIColor clearColor] width:0.0 radius:8.0];
    [self.otcLabel jx_borderWithColor:[UIColor clearColor] width:0.0 radius:8.0];
    
    [SMInstance configButtonStyle1:self.goButton fontSize:16.0f borderRadius:2.0];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    //    RAC(self, dataSource) = [[[self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData] map:^id(NSArray *items) {
    //        return JXArrValue(items, [NSArray new]);
    //    }] map:^id(NSArray *items) {
    //        return @[JXArrValue(items, [NSArray new])];
    //    }];
    
    //RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[requestRemoteDataSignal deliverOnMainThread] map:^id _Nullable(CompResultItem *result) {
        if (result.drugName.length != 0) {
            [self.recordCommand execute:result.drugName];
        }
        self.progressVC.toFinish = YES;
        if (result) {
            for (CompResultBrand *b in result.drugBandDtoList) {
                b.drugName = result.drugName;
            }
        }else {
            self.isEmpty = YES;
        }
        
        self.dtos = result.drugBandDtoList;
        if (result.drugBandDtoList.count <= 5) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];
            int i = 0;
            for (CompResultBrand *b in self.dtos) {
                i++;
                if (6 == i) {
                    break;
                }
                [arr addObject:b];
            }
            result.drugBandDtoList = arr;
        }
        
        return result;
    }];
}

- (void)beginUpdate {
    // self.navigationItem.title = @"更新中";
    //JXHUDProcessing(nil);
}

- (void)endUpdate {
    //self.navigationItem.title = self.navTitle;
    //[JXDialog hideHUD];
}

//- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter {
//    return ^(NSError *error) {
//        BOOL isFilter = YES;
//        [self catchError:error];
//        switch (self.requestMode) {
//            case JXRequestModeLoad: {
//                if (JXErrorCodeTokenInvalid == error.code) {
//                    self.error = error;
//                }else if (JXErrorCodeDataEmpty == error.code) {
//                    self.error = error;
//                    isFilter = NO;
//                }
//                self.requestMode = JXRequestModeNone;
//                self.dataSource = nil;
//                break;
//            }
//            case JXRequestModeUpdate: {
//                if (JXErrorCodeTokenInvalid == error.code) {
//                    self.error = error;
//                }else if (JXErrorCodeDataEmpty == error.code) {
//                    self.error = error;
//                    isFilter = YES;
//                }
//                self.requestMode = JXRequestModeNone;
//                self.dataSource = nil;
//                break;
//            }
//            case JXRequestModeRefresh: {
//                if (JXErrorCodeTokenInvalid == error.code) {
//                    self.error = error;
//                }else if (JXErrorCodeDataEmpty == error.code) {
//                    self.error = error;
//                    isFilter = YES;
//                }
//                [self.scrollView.mj_header endRefreshing];
//                self.requestMode = JXRequestModeNone;
//                self.dataSource = nil;
//                break;
//            }
//            case JXRequestModeMore: {
//                if (JXErrorCodeTokenInvalid == error.code) {
//                    self.error = error;
//                    [self.scrollView.mj_footer endRefreshing];
//                }else if (JXErrorCodeDataEmpty == error.code) {
//                    isFilter = YES;
//                    [self.scrollView.mj_footer endRefreshingWithNoMoreData];
//                }else {
//                    [self.scrollView.mj_footer endRefreshing];
//                }
//                
//                self.requestMode = JXRequestModeNone;
//                break;
//            }
//            case JXRequestModeHUD: {
//                if (JXErrorCodeTokenInvalid == error.code) {
//                    self.error = error;
//                }else if (JXErrorCodeDataEmpty == error.code) {
//                    self.error = error;
//                    isFilter = YES;
//                }
//                [JXDialog hideHUD];
//                self.requestMode = JXRequestModeNone;
//                self.dataSource = nil;
//                break;
//            }
//            default:
//                break;
//        }
//        
//        return isFilter;
//    };
//}


#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
    
}

- (void)setupData {
    
}

- (void)setupView {
    // self.navigationItem.rightBarButtonItem = [UIBarButtonItem jx_barItemWithImage:JXImageWithName(@"ic_doctor") size:CGSizeMake(26, 26) target:self action:@selector(doctorItemPressed:)];
    
//    @property (nonatomic, strong) UILabel *navTitleLabel;
//    @property (nonatomic, strong) UIButton *navInfoButton;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStylePlain target:self action:@selector(homeItemPressed:)];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JXAdaptScreenWidth() - 100, 44)];
    self.navTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.navTitleLabel.font = JXFont(16.0);
    self.navTitleLabel.textColor = [UIColor whiteColor];
    [navView addSubview:self.navTitleLabel];
    [self.navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(navView);
    }];
    self.navInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navInfoButton setImage:JXAdaptImage(JXImageWithName(@"img_warning_info")) forState:UIControlStateNormal];
    [self.navInfoButton addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:self.navInfoButton];
    [self.navInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(navView);
        make.leading.equalTo(self.navTitleLabel.mas_trailing).offset(4.0);
    }];
    self.navigationItem.titleView = navView;
    
    UINib *nib = [UINib nibWithNibName:@"BrandCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[BrandCell identifier]];
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CompResultItem *item = self.dataSource;
            item.drugBandDtoList = self.dtos;
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        });
    }];
    
    [self configUI];
    [self reloadData];
    
    [self jx_presentPopupViewController:self.progressVC animationType:JXPopupShowTypeNone layout:JXPopupLayoutCenter bgTouch:NO dismissed:^{
        
    }];
    // self.progressVC.view.frame = CGRectMake(0, 64, JXScreenWidth, JXScreenHeight);
}

- (void)setupSignal {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
#pragma mark assist
- (void)configUI {
    [self.navigationController.navigationBar jx_transparet];
    
    self.topView.backgroundColor = JXColorHex(0xF5F5F5);
    JXAdaptButton(self.securityButton, JXFont(9));
    JXAdaptButton(self.stabilityButton, JXFont(9));
    
    self.typeLabel.font = JXFont(10);
    self.otcLabel.font = JXFont(10);
    
    self.detailTitle1Label.textColor = kColorGreenDark;
    self.detailTitle1Label.font = [UIFont jx_boldSystemFontOfSize:13];// JXFontBold(13);
    self.detailTitle2Label.font = JXFont(13);
    self.detailLabel.font = JXFont(13);
    
    
    self.brandTitleLabel.textColor = kColorGreenDark;
    self.brandTitleLabel.font = [UIFont jx_boldSystemFontOfSize:13]; // JXFontBold(13);
    self.brandTipsLabel.font = JXFont(10);
}

- (void)reloadData {
    [super reloadData];
    
    CompResultItem *item = self.dataSource;
    //self.navigationItem.title = JXStrWithDft(item.dName, item.drugName);
    self.navTitleLabel.text = JXStrWithDft(item.dName, item.drugName);
    
//    self.searchCountLabel.text = JXStrWithInt(item.searchCount + 1);
//    self.searchTotalLabel.text = JXStrWithInt(item.brandCount);
    
    [self.searchCountLabel jx_animateCountWithDuration:1.0 count:(item.searchCount + 1) isInt:YES format:@"%ld"];
    [self.searchTotalLabel jx_animateCountWithDuration:1.0 count:(item.brandCount) isInt:YES format:@"%ld"];
    
    NSString *countStr = JXStrWithFmt(@"  被搜索%ld次", (long)(item.searchCount + 1));
    NSString *totalStr = JXStrWithFmt(@"  %ld种品牌", (long)(item.brandCount));
    [self.searchCountButton setTitle:countStr forState:UIControlStateNormal];
    [self.searchTotalButton setTitle:totalStr forState:UIControlStateNormal];
    
    NSString *security = JXStrWithFmt(@" %@", [Util securityWithValue:item.dSafety]);
    [self.securityButton setTitle:security forState:UIControlStateNormal];
    
    NSString *stability = JXStrWithFmt(@" %@", [Util stabilityWithValue:item.dStability]);
    [self.stabilityButton setTitle:stability forState:UIControlStateNormal];
    
    self.typeLabel.text = [Util stringWithNatureType:item.natureType];
    self.otcLabel.text = item.durgPrescription;
    
    self.detailLabel.text = JXStrWithDft(item.indication, @"暂无");
    
    [self.tableView reloadData];
}

- (RACCommand *)recordCommand {
    if (!_recordCommand) {
        _recordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance addDrugBrowseRecord:input];
        }];
        //[_recordCommand.executing subscribe:self.executing];
        //[_recordCommand.errors subscribe:self.errors];
        
        [_recordCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *items) {

        }];
    }
    return _recordCommand;
}


#pragma mark - Table
//- (id)fetchLocalData {
//    return nil;
//}
//
//- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter {
//    self.progressVC.toFinish = YES;
//    return [super requestRemoteDataErrorsFilter];
//}

- (BOOL)catchError:(NSError *)error {
    BOOL result = [super catchError:error];
    self.progressVC.toFinish = YES;
    self.isEmpty = YES;
    return result;
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    if (self.fromScan) {
        CompResultItem *item = self.dataSource;
        return [HRInstance getCodeData:item.jxID];
    }
    
    CompResultItem *item = self.dataSource;
    return [HRInstance drugDescriptionWithDrugId:item.dId];
}
//
//- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
//    DhzyDaibanCell *myCell = (DhzyDaibanCell *)cell;
//    myCell.data = object;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [DhzyDaibanCell height];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
//    return [tableView dequeueReusableCellWithIdentifier:[DhzyDaibanCell identifier] forIndexPath:indexPath];
//}

#pragma mark - Accessor methods
- (ProgressViewController *)progressVC {
    if (!_progressVC) {
        _progressVC = [[ProgressViewController alloc] init];
        _progressVC.isBrand = YES;
        @weakify(self)
        _progressVC.finishBlock = ^() {
            @strongify(self)

            if (self.isEmpty) {
                [self.navigationController.navigationBar jx_reset];
                self.emptyView.hidden = NO;
                self.navigationItem.title = @"药品详情";
            }
            
            [self jx_dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeNone];
            
            if (!self.isEmpty) {
                [self reloadData];
            }
        };
        _progressVC.backBlock = ^() {
            @strongify(self)
            [self jx_dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeNone];
            [self.navigationController popViewControllerAnimated:NO];
        };
    }
    return _progressVC;
}

#pragma mark - Action methods
- (IBAction)goButtonPressed:(id)sender {
    ScanCommitViewController *vc = [[ScanCommitViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)dddButtonPressed:(id)sender {
    NSString *text = @"DDD(Defined Daily Dose): 药物平均日剂量。以DDD作为测量单位，解决了同一通用名下，药物的不同品牌价格对比问题，较以往单纯的药品金额和使用量更合理，不会受到药品销售价格、包装剂量以及各种药物每日剂量不同的影响，不会因为不同药物一次用量不同、一日用药次数不同而无法比较的问题；可以精确地反映出同一通用名下，不同品牌药物的每日平均用量价格。";
    NSMutableAttributedString *mas = [NSMutableAttributedString jx_attributedStringWithString:text color:[UIColor whiteColor] font:[UIFont jx_systemFontOfSize:13]];
    [mas jx_addAttributeWithColor:[UIColor whiteColor] font:[UIFont jx_boldSystemFontOfSize:13] range:NSMakeRange(0, 33)];
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setLineSpacing:2];
    [mas addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, mas.length)];
    
    JXTipsViewController *vc = [[JXTipsViewController alloc] initWithMessage:mas];
    [self jx_presentPopupViewController:vc animationType:JXPopupShowTypeBounceIn layout:JXPopupLayoutCenter bgTouch:YES dismissed:NULL];
}

- (RACCommand *)doctorCommand {
    if (!_doctorCommand) {
        _doctorCommand = EntryChat(self);
    }
    return _doctorCommand;
//    if (!_doctorCommand) {
//        _doctorCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//            return [HRInstance doctorsCustomersList];
//        }];
//        [_doctorCommand.executing subscribe:self.executing];
//        [_doctorCommand.errors subscribe:self.errors];
//        
//        @weakify(self)
//        [_doctorCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *doctors) {
//            @strongify(self)
//            if (0 == doctors.count) {
//                JXHUDInfo(@"没有可用的医师", YES);
//            }else {
//                Doctor *d = doctors[0];
//                if (0 == d.doctorId.length) {
//                    JXHUDError(@"无效的医师", YES);
//                }else {
//                    // d.doctorId = @"D260";
//                    if (0 == d.doctorName.length) {
//                        d.doctorName = d.doctorId;
//                    }
//                    
//                    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
//                    // SDImageCache *cache = [SDImageCache sharedImageCache];
//                    [downloader downloadImageWithURL:JXURLWithStr(d.avatar) options:0 progress:NULL completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//                        if (image && finished) {
//                            d.dImage = image;
//                        }else {
//                            d.dImage = JXImageWithName(@"img_UserCenter_consultant");
//                        }
//                        
//                        [downloader downloadImageWithURL:JXURLWithStr(gUser.avatar) options:0 progress:NULL completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//                            if (image && finished) {
//                                d.aImage = image;
//                            }else {
//                                d.aImage = JXImageWithName(@"img_UserCenter_default");
//                            }
//                            
//                            
//                            dispatch_sync(dispatch_get_main_queue(), ^{
//                                TIMConversation *conv = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:d.doctorId];
//                                
//                                NSMutableArray *msgs = [NSMutableArray array];
//                                [conv getMessage:20 last:nil succ:^(NSArray * msgList) {
//                                    for (TIMMessage *message in msgList) {
//                                        int cnt = [message elemCount];
//                                        
//                                        for (int i = 0; i < cnt; i++) {
//                                            TIMElem *elem = [message getElem:i];
//                                            
//                                            if ([elem isKindOfClass:[TIMTextElem class]]) {
//                                                TIMTextElem *textElem = (TIMTextElem * )elem;
//                                                
//                                                NSString *sid = [message sender];
//                                                NSString *sname = d.doctorName;
//                                                if (![sid isEqualToString:d.doctorId]) {
//                                                    sid = JXStrWithFmt(@"A%@", gUser.uid);
//                                                    sname = gUser.nickName;
//                                                    if (0 == sname.length) {
//                                                        sname = gUser.mobile;
//                                                    }
//                                                    if (0 == sname.length) {
//                                                        sname = @"我";
//                                                    }
//                                                }
//                                                NSDate *date = [message timestamp];
//                                                JSQMessage *m = [[JSQMessage alloc] initWithSenderId:sid senderDisplayName:sname date:date text:textElem.text];
//                                                [msgs addObject:m];
//                                            }
//                                        }
//                                    }
//                                    
//                                    ChatViewController *vc = [[ChatViewController alloc] init];
//                                    vc.doctor = d;
//                                    vc.msgs = msgs;
//                                    vc.hidesBottomBarWhenPushed = YES;
//                                    [self.navigationController pushViewController:vc animated:YES];
//                                    
//                                    [JXDialog hideHUD];
//                                    
//                                }fail:^(int code, NSString * err) {
//                                    ChatViewController *vc = [[ChatViewController alloc] init];
//                                    vc.doctor = d;
//                                    vc.hidesBottomBarWhenPushed = YES;
//                                    [self.navigationController pushViewController:vc animated:YES];
//                                    
//                                    [JXDialog hideHUD];
//                                }];
//                            });
//                            
//                            
//                            //                        dispatch_sync(dispatch_get_main_queue(), ^{
//                            //                            ChatViewController *vc = [[ChatViewController alloc] init];
//                            //                            vc.doctor = d;
//                            //                            vc.hidesBottomBarWhenPushed = YES;
//                            //                            [self.navigationController pushViewController:vc animated:YES];
//                            //
//                            //                            [JXDialog hideHUD];
//                            //                        });
//                        }];
//                    }];
//                }
//            }
//        }];
//    }
//    return _doctorCommand;
}


- (void)doctorItemPressed:(id)sender {
//    [gUser checkLoginWithFinish:^{
//        [self.doctorCommand execute:nil];
//    } error:nil];
    
    [gUser checkLoginWithFinish:^(BOOL isRelogin) {
        [self.doctorCommand execute:nil];
    } error:nil];
}

- (IBAction)doctorButtonPressed:(id)sender {
    [gUser checkLoginWithFinish:^(BOOL isRelogin) {
        [self.doctorCommand execute:nil];
    } error:nil];
}

- (void)infoButtonPressed:(id)sender {
    CompResultItem *item = self.dataSource;
    NSString *security = JXStrWithFmt(@" %@", [Util securityWithValue:item.dSafety]);
    NSString *stability = JXStrWithFmt(@" %@", [Util stabilityWithValue:item.dStability]);
    
    BrandInfoViewController *vc = [[BrandInfoViewController alloc] init];
    vc.security = security;
    vc.stability = stability;
    [self jx_presentPopupViewController:vc animationType:JXPopupShowTypeBounceIn layout:JXPopupLayoutCenter bgTouch:YES dismissed:NULL];
}

- (void)homeItemPressed:(id)sender {
//    [self dismissViewControllerAnimated:NO completion:^{
//        UIViewController *vc = JXCurrentViewController();
//        [vc.navigationController popToRootViewControllerAnimated:NO];
//        
//        LLTabBar *tabBar = [JXAppDelegate tabBar];
//        [tabBar itemSelected:tabBar.tabBarItems[0]];
//    }];
//    
    [self.navigationController popToRootViewControllerAnimated:NO];
//    LLTabBar *tabBar = [JXAppDelegate tabBar];
//    [tabBar itemSelected:tabBar.tabBarItems[0]];
    
    UITabBarController *mainVC = [JXAppDelegate mainTbController];
    [mainVC setSelectedIndex:0];
}

- (IBAction)detailButtonPressed:(id)sender {
//    [UIView animateWithDuration:0.7 animations:^{
//        self.detailView.frame = CGRectMake(0, 70, self.detailView.jx_width, self.detailView.jx_height);
//    } completion:^(BOOL finished) {
//        
//    }];
    
    CGRect orig = self.detailView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.detailView.frame = CGRectMake(self.detailView.jx_x, 64 + 8, self.detailView.jx_width, self.detailView.jx_height);
    } completion:^(BOOL finished) {
        CompResultItem *item = self.dataSource;
        NSString *syz = JXStrWithDft(item.indication, @"暂无");
        NSString *yszd = JXStrWithDft(item.pharmacistGuide, @"暂无");
        NSString *blfy = JXStrWithDft(item.reaction, @"暂无");
        NSString *jj = JXStrWithDft(item.contraindication, @"暂无");
        NSString *ypcf = JXStrWithDft(item.ingredient, @"暂无");
        NSArray *arr = @[RACTuplePack(@"适应症", syz),
                         RACTuplePack(@"药师指导", yszd),
                         RACTuplePack(@"不良反应", blfy),
                         RACTuplePack(@"禁  忌", jj),
                         RACTuplePack(@"药品成分", ypcf)];
        
        
        BrandDetailViewController *vc = [[BrandDetailViewController alloc] init];
        vc.dataSource = @[arr];
        [self.navigationController pushViewController:vc animated:NO];
        
        self.detailView.frame = orig;
    }];
    
//    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
//    CGRect frame = CGRectMake(self.detailView.jx_x, 64 + 8, self.detailView.jx_width, self.detailView.jx_height);
//    springAnimation.toValue = [NSValue valueWithCGRect:frame];
//    springAnimation.springBounciness = 5.0;
//    springAnimation.springSpeed = 2.0;
//    springAnimation.completionBlock = ^ (POPAnimation *anim, BOOL finished) {
//        CompResultItem *item = self.dataSource;
//        NSString *syz = JXStrWithDft(item.indication, @"暂无");
//        NSString *yszd = JXStrWithDft(item.pharmacistGuide, @"暂无");
//        NSString *blfy = JXStrWithDft(item.reaction, @"暂无");
//        NSString *jj = JXStrWithDft(item.contraindication, @"暂无");
//        NSString *ypcf = JXStrWithDft(item.ingredient, @"暂无");
//        NSArray *arr = @[RACTuplePack(@"适应症", syz),
//                         RACTuplePack(@"药师指导", yszd),
//                         RACTuplePack(@"不良反应", blfy),
//                         RACTuplePack(@"禁  忌", jj),
//                         RACTuplePack(@"药品成分", ypcf)];
//        
//        
//        BrandDetailViewController *vc = [[BrandDetailViewController alloc] init];
//        vc.dataSource = @[arr];
//        [self.navigationController pushViewController:vc animated:NO];
//
//        self.detailView.frame = orig;
//    };
//    [self.detailView pop_addAnimation:springAnimation forKey:@"changeframe"];
}

#pragma mark - Notification methods

#pragma mark - Delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CompResultItem *item = self.dataSource;
    return item.drugBandDtoList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BrandCell height];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BrandCell *cell = [tableView dequeueReusableCellWithIdentifier:[BrandCell identifier] forIndexPath:indexPath];
    CompResultItem *item = self.dataSource;
    cell.data = item.drugBandDtoList[indexPath.row];
    cell.tagBlock = ^(UIButton *btn) {
        NSString *message = MedicineTagString(btn.tag);
        UIColor *color = MedicineTagColor(btn.tag); //  btn.jxIdentifier; // [btn titleColorForState:UIControlStateNormal];
        CMPopTipView *popTipView = [[CMPopTipView alloc] initWithMessage:message];
        popTipView.backgroundColor = [UIColor whiteColor];
        popTipView.textColor = color;
        popTipView.textFont = [UIFont systemFontOfSize:JXAdaptFontSize(12)];
        popTipView.borderColor = color;
        popTipView.borderWidth = 1.0f;
        popTipView.cornerRadius = 3.0f;
        popTipView.has3DStyle = NO;
        popTipView.hasGradientBackground = NO;
        popTipView.dismissTapAnywhere = YES;
        popTipView.pointerSize = 6;
        popTipView.bubblePaddingX = 2;
        popTipView.bubblePaddingY = 2;
        popTipView.maxWidth = JXAdaptScreen(120);
        [popTipView presentPointingAtView:btn inView:self.view animated:YES];
    };
    cell.dddpBlock = ^{
        NSString *text = @"关于DDDP: 同一种药物不同品牌，产生了不同价格、不同包装和不同的日均使用剂量(DDD: Defined Daily Dose)，根据以上数据计算得出的DDDP（Defined Daily Dose Price）可作为统一衡量指标，进行直观对比。";
        NSMutableAttributedString *mas = [NSMutableAttributedString jx_attributedStringWithString:text color:[UIColor whiteColor] font:[UIFont jx_systemFontOfSize:13]];
        [mas jx_addAttributeWithColor:[UIColor whiteColor] font:[UIFont jx_boldSystemFontOfSize:13] range:NSMakeRange(0, 7)];
        NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
        [ps setLineSpacing:2];
        [mas addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, mas.length)];
        
        JXTipsViewController *vc = [[JXTipsViewController alloc] initWithMessage:mas];
        [self jx_presentPopupViewController:vc animationType:JXPopupShowTypeBounceIn layout:JXPopupLayoutCenter bgTouch:YES dismissed:NULL];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self)
//    [gUser checkLoginWithFinish:^{
//        @strongify(self)
//        CompResultItem *item = self.dataSource;
//        
//        MedicineViewController *vc = [MedicineViewController medicineNCWithDataSource:item.drugBandDtoList[indexPath.row]];
//        [self.navigationController presentViewController:vc animated:YES completion:NULL];
//    } error:nil];
    
    [gUser checkLoginWithFinish:^(BOOL isRelogin) {
        @strongify(self)
        CompResultItem *item = self.dataSource;
        
        MedicineViewController *vc = [MedicineViewController medicineNCWithDataSource:item.drugBandDtoList[indexPath.row]];
        [self.navigationController presentViewController:vc animated:YES completion:NULL];
    } error:nil];
}


#pragma mark - Public methods
#pragma mark - Class methods


@end




