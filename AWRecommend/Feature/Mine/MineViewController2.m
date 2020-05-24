//
//  MineViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/29.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "MineViewController2.h"
#import "MineHeaderView2.h"
#import "SettingViewController.h"
#import "FavoriteViewController.h"
#import "FeedbackViewController.h"
#import "ScanRecordViewController.h"
#import "ChatViewController.h"
#import "ShareViewController.h"

@interface MineViewController2 ()
@property (nonatomic, strong) MineHeaderView2 *topView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *realHeightConstraint;
@property (nonatomic, strong) RACCommand *infoCommand;
@property (nonatomic, strong) RACCommand *doctorCommand;

@end

@implementation MineViewController2
#pragma mark - Override methods
- (instancetype)init {
    if (self = [super init]) {
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
        //self.shouldPullToRefresh = YES;
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar jx_transparet];
    
    if (gUser.isLogined) {
        [self.infoCommand execute:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar jx_reset];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    //    RAC(self, dataSource) = [[[self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData] map:^id(NSArray *items) {
    //        return JXArrValue(items, [NSArray new]);
    //    }] map:^id(NSArray *items) {
    //        return @[JXArrValue(items, [NSArray new])];
    //    }];
    
    RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    //RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[fetchLocalDataSignal deliverOnMainThread] map:^id _Nullable(id result) {
        return JXArrEmpty(result, nil);
    }];
    
    @weakify(self)
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self)
        //        // YJX_TODO
        //        //         *vc = [[CompResultDetailViewController alloc] init];
        //        //
        //        //        CompResultBrand *b = [CompResultBrand new];
        //        //        b.brandId = [[(CompResultDetail *)input.second uid] integerValue];
        //        //        vc.brand = b;
        //
        //        //        CompResultItem *item = [CompResultItem new];
        //        //        item.dId = [[(CompResultDetail *)input.second uid] integerValue];
        //        //
        //        //        CompResultDetail *d = input.second;
        //        //
        //        //        CompResultBrand
        //        //
        //        CompResultDetail *d = input.second;
        //        CompResultBrand *b = [CompResultBrand new];
        //        b.brandId = d.uid.integerValue;
        //
        //        MedicineViewController *vc = [MedicineViewController medicineNCWithDataSource:b];
        //        [self.navigationController presentViewController:vc animated:YES completion:NULL];
        //        //
        //        //        vc.hidesBottomBarWhenPushed = YES;
        //        //        [self.navigationController pushViewController:vc animated:YES];
        
        NSString *text = [(RACTuple *)input.second first];
        if ([text isEqualToString:@"好友推荐"]) {
            ShareViewController *vc = [[ShareViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.navItemColor = JXColorHex(0x333333);
            vc.statusBarStyle = JXStatusBarStyleDefault;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            @weakify(self)
            
            [gUser checkLoginWithFinish:^(BOOL isRelogin) {
                @strongify(self)
                NSString *text = [(RACTuple *)input.second first];
                if ([text isEqualToString:@"我的收藏"]) {
                    FavoriteViewController *vc = [[FavoriteViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if ([text isEqualToString:@"意见反馈"]) {
                    FeedbackViewController *vc = [[FeedbackViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if ([text isEqualToString:@"扫码记录"]) {
                    ScanRecordViewController *vc = [[ScanRecordViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if ([text isEqualToString:@"立即咨询"]) {
                    [self requestDoctors];
                    //                ChatViewController *vc = [[ChatViewController alloc] init];
                    //                vc.hidesBottomBarWhenPushed = YES;
                    //                [self.navigationController pushViewController:vc animated:YES];
                }else if ([text isEqualToString:@"好友推荐"]) {
                    ShareViewController *vc = [[ShareViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.navItemColor = JXColorHex(0x333333);
                    vc.statusBarStyle = JXStatusBarStyleDefault;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } error:nil];
        }
        
        return [RACSignal empty];
    }];
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
//                                
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
//                        }];
//                    }];
//                }
//            }
//        }];
//    }
//    return _doctorCommand;
}


- (void)requestDoctors {
    [self.doctorCommand execute:nil];
    //RACCommand *doctorCommand = EntryChat(self);
    //[doctorCommand execute:nil];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
}

- (void)setupData {
}

- (void)setupView {
    
    [self.navigationController.navigationBar jx_configWithParam:@{kJXKeyTranslucent: @NO, kJXKeyBarTintColor: [UIColor whiteColor], kJXKeyTitleColor: JXColorHex(0x333333), kJXKeyTitleFont: JXFont(16.0)}];
    [self.navigationItem.leftBarButtonItem jx_configWithParam:@{kJXKeyTitleColor: JXColorHex(0x333333), kJXKeyTitleColorDisabled: [UIColor lightTextColor], kJXKeyTitleFont: JXFont(14)}];
    [self.navigationItem.rightBarButtonItem jx_configWithParam:@{kJXKeyTitleColor: JXColorHex(0x333333), kJXKeyTitleColorDisabled: [UIColor lightTextColor], kJXKeyTitleFont: JXFont(14)}];
    
    self.navigationItem.title = @"个人中心";
    [self.navigationController.navigationBar jx_transparet];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem jx_barItemWithImage:JXImageWithName(@"img_UserCenter_setting") size:CGSizeMake(24, 24) target:self action:@selector(settingItemPressed:)];
    
    self.scrollView.parallaxHeader.view = self.topView;
    self.scrollView.parallaxHeader.height = self.topView.jx_height;
    self.scrollView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.scrollView.parallaxHeader.minimumHeight = self.topView.jx_height;
    
    self.realHeightConstraint.constant += self.topView.jx_height * -1;
    
    //    UINib *cellNib = [UINib nibWithNibName:@"DhzyDaibanCell" bundle:nil];
    //    [self.tableView registerNib:cellNib forCellReuseIdentifier:[DhzyDaibanCell identifier]];
    // [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kJXIdentifierCellSystem]
    
    self.tableView.backgroundColor = JXColorHex(0xf5f5f5);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.sectionHeaderHeight = 12.0f;
    self.tableView.sectionFooterHeight = 0.0f;
    // self.tableView.backgroundColor = [UIColor redColor];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // self.tableView.separatorColor = [UIColor orangeColor];
    
//    self.tableView.tintColor = [UIColor redColor];
//    self.tableView.layoutMargins = UIEdgeInsetsZero;
//    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    self.contentView.backgroundColor = JXColorHex(0xf5f5f5);
    self.scrollView.backgroundColor = JXColorHex(0xf5f5f5);
}

- (void)setupSignal {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
#pragma mark assist

#pragma mark - Table
- (id)fetchLocalData {
    return @[@[RACTuplePack(@"扫码记录", JXAdaptImage(JXImageWithName(@"img_UserCenter_record"))),
               RACTuplePack(@"立即咨询", JXAdaptImage(JXImageWithName(@"img_UserCenter_consultant"))),
               RACTuplePack(@"我的收藏", JXAdaptImage(JXImageWithName(@"img_UserCenter_collection")))],
             @[RACTuplePack(@"好友推荐", JXAdaptImage(JXImageWithName(@"img_UserCenter_recommend"))),
               RACTuplePack(@"意见反馈", JXAdaptImage(JXImageWithName(@"img_UserCenter_feedback")))]];
    
    
//    return @[@[RACTuplePack(@"扫码记录", JXAdaptImage(JXImageWithName(@"img_UserCenter_record"))),
//               RACTuplePack(@"立即咨询", JXAdaptImage(JXImageWithName(@"img_UserCenter_consultant"))),
//               RACTuplePack(@"药品收藏", JXAdaptImage(JXImageWithName(@"img_UserCenter_collection"))),
//             RACTuplePack(@"好友推荐", JXAdaptImage(JXImageWithName(@"img_UserCenter_recommend"))),
//               RACTuplePack(@"意见反馈", JXAdaptImage(JXImageWithName(@"img_UserCenter_feedback")))]];
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    //return [HRInstance requestDhzyDaibanListWithPage:1];
    return [RACSignal empty];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(RACTuple *)object {
    JXCell *myCell = (JXCell *)cell;
    
//    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
//    
//    UIFont *font = nil;
//    NSInteger size = 25;
//    if (0 == section) {
//        if (0 == row) {
//            font = [UIFont systemFontOfSize:size];
//        }else if (1 == row) {
//            font = [UIFont systemFontOfSize:size+1];
//        }else if (2 == row) {
//            font = [UIFont systemFontOfSize:size+2];
//        }
//    }else if (1 == section) {
//        if (0 == row) {
//            font = [UIFont systemFontOfSize:size+3];
//        }else if (1 == row) {
//            font = [UIFont systemFontOfSize:size+4];
//        }
//    }
    
    myCell.textLabel.font = JXFont(14);
    myCell.textLabel.textColor = JXColorHex(0x333333);
    myCell.textLabel.text = object.first;
    myCell.imageView.image = object.second;
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    myCell.tintColor = [UIColor redColor];
    // myCell.accessoryImageView.hidden = NO;
    
    if ((0 == indexPath.section && 2 == indexPath.row)
        || (1 == indexPath.section && 1 == indexPath.row)) {
        myCell.separatorImageView.hidden = YES;
    }else {
        myCell.separatorImageView.hidden = NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JXCell height];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [self.tableView dequeueReusableCellWithIdentifier:[JXCell identifier] forIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return JXScreenScale(12);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UITableViewHeaderFooterView *)view forSection:(NSInteger)section {
    view.contentView.backgroundColor = JXColorHex(0xF5F5F5);
//    view.contentView.backgroundColor = [UIColor redColor];
//    view.backgroundColor = [UIColor redColor];
}

#pragma mark - Accessor methods
- (RACCommand *)infoCommand {
    if (!_infoCommand) {
        _infoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance findWiseAccountDetails];
        }];
        [_infoCommand.errors subscribe:self.errors];
        
        [_infoCommand.executionSignals.switchToLatest subscribeNext:^(User *user) {
            gUser.mobile = user.mobile;
            gUser.nickName = user.nickName;
            gUser.dateOfBirth = user.dateOfBirth;
            gUser.avatar = user.avatar;
            gUser.sex = user.sex;
        }];
    }
    return _infoCommand;
}


- (MineHeaderView2 *)topView {
    if (!_topView) {
        _topView = [[[NSBundle mainBundle] loadNibNamed:@"MineHeaderView2" owner:nil options:nil] firstObject];
        //        @weakify(self)
        //        _headerView.didSearchBlock = ^() {
        //            @strongify(self)
        //            // CompSearchViewController *vc = [[CompSearchViewController alloc] init];
        //            SearchViewController *vc = [[SearchViewController alloc] init];
        //            //TestViewController *vc = [[TestViewController alloc] init];
        //            vc.hidesBottomBarWhenPushed = YES;
        //            [self.navigationController pushViewController:vc animated:YES];
        //        };
        //        _headerView.didScanBlock = ^() {
        //            @strongify(self)
        //            ScanViewController *vc = [[ScanViewController alloc] init];
        //            vc.hidesBottomBarWhenPushed = YES;
        //            [self.navigationController pushViewController:vc animated:YES];
        //        };
        
        @weakify(self)
        _topView.loginDidPress = ^() {
            @strongify(self)
            if (gUser.isLogined) {
                SettingViewController *vc = [[SettingViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.navItemColor = JXColorHex(0x333333);
                vc.statusBarStyle = JXStatusBarStyleDefault;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                LoginViewController *vc = [[LoginViewController alloc] init];
                JXNavigationController *nc = [[JXNavigationController alloc] initWithRootViewController:vc];
                
                //[nc.navigationBar jx_configWithParam:@{kJXKeyTranslucent: @NO, kJXKeyBarTintColor: SMInstance.mainColor, kJXKeyTitleColor: SMInstance.navItemColor, kJXKeyTitleFont: JXFont(16.0)}];
                
                [self.navigationController presentViewController:nc animated:YES completion:NULL];
            }
        };
    }
    return _topView;
}

#pragma mark - Action methods
- (void)settingItemPressed:(id)sender {
    SettingViewController *vc = [[SettingViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navItemColor = JXColorHex(0x333333);
    vc.statusBarStyle = JXStatusBarStyleDefault;
    [self.navigationController pushViewController:vc animated:YES];
    
//    [gUser checkLoginWithFinish:^{
//        SettingViewController *vc = [[SettingViewController alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    } error:nil];
}

#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource

#pragma mark - Public methods
#pragma mark - Class methods


@end
