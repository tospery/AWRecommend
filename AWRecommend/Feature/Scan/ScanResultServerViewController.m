//
//  ScanResultServerViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/9.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ScanResultServerViewController.h"
#import "BrandDetailViewController.h"
#import "BrandViewController.h"
#import "MedicineViewController.h"
#import "ChatViewController.h"

@interface ScanResultServerViewController ()
@property (nonatomic, weak) IBOutlet UIView *topBgView;
@property (nonatomic, weak) IBOutlet UIView *bottomBgView;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailTitleLabel;
//@property (nonatomic, weak) IBOutlet UILabel *tag1Label;
//@property (nonatomic, weak) IBOutlet UILabel *tag2Label;

@property (nonatomic, weak) IBOutlet TTTAttributedLabel *syzLabel;

@property (nonatomic, weak) IBOutlet UILabel *pyTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *pyDescLabel;

@property (nonatomic, weak) IBOutlet UILabel *dsTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *dsDescLabel;

@property (nonatomic, weak) IBOutlet UILabel *ddTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *ddDescLabel;

@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *tagViews;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *tagLabels1;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *tagLabels2;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *tagLabels3;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *tagLabels4;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *tagLabels5;


@property (nonatomic, strong) RACCommand *doctorCommand;

@end

@implementation ScanResultServerViewController
#pragma mark - Override methods
- (instancetype)init {
    if (self = [super init]) {
        //        self.shouldRequestRemoteDataOnViewDidLoad = YES;
        //        self.shouldPullToRefresh = YES;
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
    [self.navigationController.navigationBar jx_transparet];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar jx_reset];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.topBgView jx_borderWithColor:[UIColor clearColor] width:0.0 radius:6.0];
    [self.bottomBgView jx_borderWithColor:[UIColor clearColor] width:0.0 radius:6.0];
    //    [self.tag1Label jx_borderWithColor:[UIColor clearColor] width:0.0 radius:8.0];
    //    [self.tag2Label jx_borderWithColor:[UIColor clearColor] width:0.0 radius:8.0];
    
    for (UIView *view in self.tagViews) {
        NSArray *labels = view.subviews;
        for (UILabel *label in labels) {
            [label jx_borderWithColor:[UIColor clearColor] width:0.0 radius:8.0];
        }
    }
}

- (void)bindViewModel {
    [super bindViewModel];
    
    //    RAC(self, dataSource) = [[[self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData] map:^id(NSArray *items) {
    //        return JXArrValue(items, [NSArray new]);
    //    }] map:^id(NSArray *items) {
    //        return @[JXArrValue(items, [NSArray new])];
    //    }];
}

#pragma mark - Private methods
#pragma mark setup

- (void)setupVar {
}

- (void)setupData {
}

- (void)setupView {
    self.navigationItem.title = @"扫码结果";
    [self.navigationController.navigationBar jx_transparet];
    //self.navigationItem.rightBarButtonItem = [UIBarButtonItem jx_barItemWithImage:JXImageWithName(@"ic_doctor") size:CGSizeMake(26, 26) target:self action:@selector(doctorItemPressed:)];
    
    //    UINib *cellNib = [UINib nibWithNibName:@"DhzyDaibanCell" bundle:nil];
    //    [self.tableView registerNib:cellNib forCellReuseIdentifier:[DhzyDaibanCell identifier]];
    //    self.tableView.tableFooterView = [UIView new];
    
    //self.nameLabel.font = [UIFont fontWithName:@"NotoSansHans-DemiLight" size:17.0];
    
    UIFont *font = [UIFont jx_boldSystemFontOfSize:13]; //JXFontBold(13); // [UIFont boldSystemFontOfSize:14];
    self.pyTitleLabel.font = font;
    self.dsTitleLabel.font = font;
    self.ddTitleLabel.font = font;
    
    self.detailTitleLabel.font = font;
    
    self.syzLabel.font = JXFont(13);
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

- (void)setupSignal {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
#pragma mark assist
- (void)reloadData {
    [super reloadData];
    
    ScanResult *r = self.dataSource;
    
    NSString *brandName = JXStrWithDft(r.drugDescriptionDto.brandName, @"");
    NSString *drugName = JXStrWithDft(r.drugDescriptionDto.drugName, @"");
    self.nameLabel.text = JXStrWithFmt(@"【%@】%@", brandName, drugName);
    
    //self.tag1Label.text = JXStrWithDft(r.drugDescriptionDto.durgPrescription, @"");
    //self.tag2Label.text = [Util stringWithNatureType:r.drugDescriptionDto.natureType];
    
    //    @property (nonatomic, copy) NSString *chMedTag;
    //    @property (nonatomic, copy) NSString *baseMedTag;
    //    @property (nonatomic, copy) NSString *patentRightTag;
    
    NSMutableArray *tags = [NSMutableArray arrayWithCapacity:5];
    if ([r.drugDescriptionDto.baseMedTag isEqualToString:@"是"]) {
        [tags addObject:@"基药"];
    }
    if ([r.drugDescriptionDto.patentRightTag isEqualToString:@"是"]) {
        [tags addObject:@"专利"];
    }
    if ([r.drugDescriptionDto.chMedTag isEqualToString:@"是"]) {
        [tags addObject:@"保护"];
    }
    [tags addObject:JXStrWithDft(r.drugDescriptionDto.durgPrescription, @"")];
    [tags addObject:[Util stringWithNatureType:r.drugDescriptionDto.natureType]];
    
    
    UIView *tagView = nil;
    for (UIView *view in self.tagViews) {
        if (view.tag == tags.count) {
            tagView = view;
        }else {
            view.hidden = YES;
        }
    }
    
    if (tagView) {
        tagView.hidden = NO;
        
        NSArray *labels = tagView.subviews;
        for (NSInteger i = 0; i < labels.count; ++i) {
            UILabel *label = labels[i];
            label.text = tags[i];
        }
    }
    
    self.syzLabel.text = JXStrWithDft(r.drugDescriptionDto.indication, @"暂无");
    
    NSString *text = JXStrWithFmt(@"此药品还有%ld个不同品牌", (long)r.drugDescriptionDto.brandCount);
    NSMutableAttributedString *mas = [NSMutableAttributedString jx_attributedStringWithString:text color:JXColorHex(0x333333) font:JXFont(13)];
    [mas jx_addAttributeWithColor:kColorGreenDark font:JXFontBold(13) range:NSMakeRange(5, text.length - 10)];
    self.pyDescLabel.attributedText = mas;
    
    text = JXStrWithFmt(@"有%ld个电商平台销售此药品", (long)r.drugDescriptionDto.buyChannelCount);
    mas = [NSMutableAttributedString jx_attributedStringWithString:text color:JXColorHex(0x333333) font:JXFont(13)];
    [mas jx_addAttributeWithColor:kColorGreenDark font:JXFontBold(13) range:NSMakeRange(1, text.length - 11)];
    self.dsDescLabel.attributedText = mas;
    
    text = @"根据药品日均服用量DDD得出不同品牌药品每日最低的用药成本"; //JXStrWithFmt(@"根据药品日均服用量%ld得出不同品牌药品每日最低的用药成本", (long)r.drugDescriptionDto.ddd);
    mas = [NSMutableAttributedString jx_attributedStringWithString:text color:JXColorHex(0x333333) font:JXFont(13)];
    [mas jx_addAttributeWithColor:kColorGreenDark font:JXFontBold(13) range:NSMakeRange(9, 3)];
    self.ddDescLabel.attributedText = mas;
}

#pragma mark - Table
//- (id)fetchLocalData {
//    return nil;
//}
//
//- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
//    return [HRInstance requestDhzyDaibanListWithPage:1];
//}
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
#pragma mark - Action methods
- (IBAction)brandButtonPressed:(id)sender {
    //    @weakify(self)
    //    [gUser checkLoginWithFinish:^{
    //        @strongify(self)
    ScanResult *r = self.dataSource;
    
    CompResultItem *item = [CompResultItem new];
    item.dId = r.drugDescriptionDto.drugId;
    item.dName = r.drugDescriptionDto.drugName;
    
    BrandViewController *vc = [[BrandViewController alloc] init];
    vc.dataSource = item;
    [self.navigationController pushViewController:vc animated:YES];
    //} error:nil];
}

- (IBAction)productButtonPressed:(id)sender {
    @weakify(self)
//    [gUser checkLoginWithFinish:^{
//        @strongify(self)
//        ScanResult *r = self.dataSource;
//        
//        CompResultBrand *b = [CompResultBrand new];
//        b.brandId = r.drugDescriptionDto.brandId;
//        //b.brandName = r.drugDescriptionDto.brandCount;
//        b.drugName = r.drugDescriptionDto.drugName;
//        b.brandName = r.drugDescriptionDto.brandName;
//        
//        MedicineViewController *vc = [MedicineViewController medicineNCWithDataSource:b];
//        [self.navigationController presentViewController:vc animated:YES completion:NULL];
//    } error:nil];
    
    [gUser checkLoginWithFinish:^(BOOL isRelogin) {
        @strongify(self)
        ScanResult *r = self.dataSource;
        
        CompResultBrand *b = [CompResultBrand new];
        b.brandId = r.drugDescriptionDto.brandId;
        //b.brandName = r.drugDescriptionDto.brandCount;
        b.drugName = r.drugDescriptionDto.drugName;
        b.brandName = r.drugDescriptionDto.brandName;
        
        MedicineViewController *vc = [MedicineViewController medicineNCWithDataSource:b];
        [self.navigationController presentViewController:vc animated:YES completion:NULL];
    } error:nil];
}

- (IBAction)detailButtonPressed:(id)sender {
    //    [UIView animateWithDuration:0.7 animations:^{
    //        self.detailView.frame = CGRectMake(0, 70, self.detailView.jx_width, self.detailView.jx_height);
    //    } completion:^(BOOL finished) {
    //
    //    }];
    
    CGRect orig = self.topBgView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.topBgView.frame = CGRectMake(self.topBgView.jx_x, 64 + 8, self.topBgView.jx_width, self.topBgView.jx_height);
    } completion:^(BOOL finished) {
        ScanResult *item = self.dataSource;
        NSString *syz = JXStrWithDft(item.drugDescriptionDto.indication, @"暂无");
        NSString *yszd = JXStrWithDft(item.drugDescriptionDto.pharmacistGuide, @"暂无");
        NSString *blfy = JXStrWithDft(item.drugDescriptionDto.reaction, @"暂无");
        NSString *jj = JXStrWithDft(item.drugDescriptionDto.contraindication, @"暂无");
        NSString *ypcf = JXStrWithDft(item.drugDescriptionDto.ingredient, @"暂无");
        NSArray *arr = @[RACTuplePack(@"适应症", syz),
                         RACTuplePack(@"药师指导", yszd),
                         RACTuplePack(@"不良反应", blfy),
                         RACTuplePack(@"禁  忌", jj),
                         RACTuplePack(@"药品成分", ypcf)];
        
        
        BrandDetailViewController *vc = [[BrandDetailViewController alloc] init];
        vc.dataSource = @[arr];
        [self.navigationController pushViewController:vc animated:NO];
        
        self.topBgView.frame = orig;
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
#pragma mark UITableViewDataSource

#pragma mark - Public methods
#pragma mark - Class methods


@end
