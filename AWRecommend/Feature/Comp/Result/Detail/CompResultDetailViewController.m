//
//  CompResultDetailViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/10.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "CompResultDetailViewController.h"
#import "CompResultDetailCell.h"
#import "CompResultDetailHeader.h"
#import "CompResultDetailIntroCell.h"

@interface CompResultDetailViewController ()
@property (nonatomic, assign) BOOL onceToken;
@property (nonatomic, assign) BOOL isHScrolling;
@property (nonatomic, assign) CGFloat scrollViewHeight;
@property (nonatomic, strong) NSMutableArray *attrs;
@property (nonatomic, weak) IBOutlet HMSegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) CompResultDetail *detail;
@property (nonatomic, strong) RACCommand *detailCommand;

@property (nonatomic, weak) IBOutlet UITableView *tableView1;

@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, weak) IBOutlet JXBannerView *bannerView;
@property (nonatomic, weak) IBOutlet UIView *headerView2;
@property (nonatomic, weak) IBOutlet UITableView *tableView2;

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@property (nonatomic, weak) IBOutlet UIButton *favoriteButton;

@end

@implementation CompResultDetailViewController
#pragma mark - Override methods
//- (instancetype)init {
//    if (self = [super init]) {
//        self.shouldRequestRemoteDataOnViewDidLoad = YES;
//        self.shouldPullToRefresh = YES;
//    }
//    return self;
//}

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
    self.bannerView.frame = CGRectMake(0, 0, JXScreenWidth, JXScreenScale(120));
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setShadowImage:nil];
//}

- (void)bindViewModel {
    [super bindViewModel];
    
//    RAC(self, dataSource) = [[[self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData] map:^id(NSArray *items) {
//        return JXArrValue(items, [NSArray new]);
//    }] map:^id(NSArray *items) {
//        return @[JXArrValue(items, [NSArray new])];
//    }];
    [self.detailCommand execute:nil];
}

#pragma mark - Private methods
#pragma mark setup

- (void)setupVar {
}

- (void)setupData {
}

- (void)setupView {
    self.navigationItem.title = @"药品详情";
    
    UINib *nib = [UINib nibWithNibName:@"CompResultDetailCell" bundle:nil];
    [self.tableView1 registerNib:nib forCellReuseIdentifier:[CompResultDetailCell identifier]];
    [self.tableView1 registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kJXIdentifierHeaderFooter];
    self.tableView1.tableFooterView = [UIView new];
    
    nib = [UINib nibWithNibName:@"CompResultDetailIntroCell" bundle:nil];
    [self.tableView2 registerNib:nib forCellReuseIdentifier:[CompResultDetailIntroCell identifier]];
    self.tableView2.tableFooterView = [UIView new];
    
    self.headerView2.frame = CGRectMake(0, 0, 320, JXScreenScale(130));
    
    self.segmentedControl.sectionTitles = @[@"价格", @"说明书", @"图文详情"];
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : JXColorHex(0x333333), NSFontAttributeName: JXFont(14)};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : JXColorHex(0x52bc8e), NSFontAttributeName: JXFont(14)};
    self.segmentedControl.selectionIndicatorColor = JXColorHex(0x66d6a6);
    self.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.selectionIndicatorHeight = 2.0f;
    @weakify(self)
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        @strongify(self)
        [self.scrollView scrollRectToVisible:CGRectMake(JXScreenWidth * index, 0, JXScreenWidth, self.scrollViewHeight) animated:YES];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            //[self requestGoodsAttrsIfNeedWithIndex:index];
//        });
    }];
}

- (void)setupSignal {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
#pragma mark assist
- (void)loadWebdata {
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"<html>"];
    [str appendString:@"<html lang=\"zh-CN\">"];
    [str appendString:@"<head>"];
    [str appendString:@"<meta charset=\"UTF-8\">"];
    [str appendString:@"<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\">"];
    [str appendString:@"<meta content=\"yes\" name=\"apple-mobile-web-app-capable\">"];
    [str appendString:@"<meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no\">"];
    [str appendString:@"<style type=\"text/css\">"];
    [str appendString:@"img{width:100%;margin:0;padding:0;}"];
    [str appendString:@"body{width:95%;font-size:12px}"];
    [str appendString:@"div{width:100%;}"];
    [str appendString:@"table{width:100%;}"];
    [str appendString:@"span{font-size:12px;}"];
    [str appendString:@"</style>"];
    [str appendString:@"<title></title>"];
    [str appendString:@"</head>"];
    [str appendString:@"<body>"];
    
    NSMutableString *ms = [NSMutableString stringWithString:JXStrWithDft(self.detail.graphicDetails, @"")];
    [ms replaceOccurrencesOfString:@".jpg_.webp" withString:@".jpg" options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.detail.graphicDetails.length)];
    
    [str appendString:JXStrWithDft(ms, @"")];
    [str appendString:@"</body>"];
    [str appendString:@"</html>"];
    [self.webView loadHTMLString:str baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]  bundlePath]]];
    
 
    
    
    
//    [str appendString:@"<html>"];
//    [str appendString:@"<head>"];
//    [str appendString:@"<title></title>"];
//    [str appendString:@"<style>"];
//    [str appendString:@"body{width:95%;}"];
//    [str appendString:@"body>div{ width:100%;}"];
//    [str appendString:@"body>div>img{width:100%; margin:0;padding:0;}"];
//    [str appendString:@"body p{font-size:12px}"];
//    [str appendString:@"body p>img{width:100%; margin:0;padding:0;}"];
//    [str appendString:@"</style>"];
//    [str appendString:@"</head>"];
//    [str appendString:@"<body>"];
}

- (RACTuple *)introWithRow:(NSInteger)row {
    NSString *title = nil;
    NSString *content = nil;
    if (0 == row) {
        title = @"产品名称";
        content = self.detail.wiseDrugBrandInstructionsDto.dbiName;
    }else if (1 == row) {
        title = @"生产厂商";
        content = self.detail.wiseDrugBrandInstructionsDto.dbiFactory;
    }else if (2 == row) {
        title = @"批准文号";
        content = self.detail.wiseDrugBrandInstructionsDto.dbiApprovalNumber;
    }else if (3 == row) {
        title = @"有效期";
        content = self.detail.wiseDrugBrandInstructionsDto.dbiExpireDate;
    }else if (4 == row) {
        title = @"成分";
        content = self.detail.wiseDrugBrandInstructionsDto.dbiIngredient;
    }else if (5 == row) {
        title = @"适应症状";
        content = self.detail.wiseDrugBrandInstructionsDto.dbiIndication;
    }else if (6 == row) {
        title = @"不良反应";
        content = self.detail.wiseDrugBrandInstructionsDto.dbiReaction;
    }else if (7 == row) {
        title = @"注意事项";
        content = self.detail.wiseDrugBrandInstructionsDto.dbiAttention;
    }else if (8 == row) {
        title = @"禁忌";
        content = self.detail.wiseDrugBrandInstructionsDto.dbiContraindication;
    }else if (9 == row) {
        title = @"药物相互作用";
        content = self.detail.wiseDrugBrandInstructionsDto.dbiDrugInteractions;
    }
    return RACTuplePack(title, content, @(row));
}

//#pragma mark - Table
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
- (void)setBanners:(NSArray *)banners {
    _banners = banners;
    
    NSMutableArray *views = [NSMutableArray array];
    for (NSString *urlString in banners) {
        if (0 == urlString.length) {
            continue;
        }
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView sd_setImageWithURL:JXURLWithStr(urlString) placeholderImage:kJXImagePHRectangle];
        [views addObject:imageView];
    }
    
    //    @weakify(self)
    //    [self.bannerView setupViews:views didTapBlock:^(NSInteger index) {
    //        @strongify(self)
    //        JXLogInfo(@"index = %@", @(index));
    ////        Open02TestViewController *vc = [[Open02TestViewController alloc] init];
    ////        [self.navigationController pushViewController:vc animated:YES];
    //    }];
    
    [self.bannerView setupViews:views didTapBlock:NULL];
}

- (CGFloat)scrollViewHeight {
    if (0 == _scrollViewHeight) {
        _scrollViewHeight = JXScreenHeight - 64 - JXScreenScale(40) - JXScreenScale(44);
    }
    return _scrollViewHeight;
}

- (RACCommand *)detailCommand {
    if (!_detailCommand) {
        @weakify(self)
        _detailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [HRInstance drugDetailWithBrandId:self.brand.brandId];
        }];
        [_detailCommand.executing subscribe:self.executing];
        [_detailCommand.errors subscribe:self.errors];
        
        [_detailCommand.executionSignals.switchToLatest subscribeNext:^(CompResultDetail *detail) {
            @strongify(self)
            detail.uid = JXStrWithInt(self.brand.brandId);
            self.detail = detail;
            self.banners = self.detail.instructionImgList;
            [self.tableView1 reloadData];
            [self.tableView2 reloadData];
            [self loadWebdata];

            NSArray *arr = [TMInstance objectForKey:kTMCompFavorite];
            for (CompResultDetail *d in arr) {
                if (d.uid.integerValue == self.detail.uid.integerValue) {
                    self.favoriteButton.selected = YES;
                    break;
                }
            }
            
            JXHUDHide();
        }];
    }
    return _detailCommand;
}


#pragma mark - Action methods
- (IBAction)favoriteButtonPressed:(UIButton *)btn {
    if (btn.selected) {
        NSArray *arr = [TMInstance objectForKey:kTMCompFavorite];
        NSMutableArray *ma = [NSMutableArray arrayWithArray:arr];
        
        CompResultDetail *detail = nil;
        for (CompResultDetail *d in ma) {
            if ([d.graphicDetails isEqualToString:self.detail.graphicDetails]) {
                detail = d;
                break;
            }
        }
        
        [ma removeObject:detail];
        [TMInstance setObject:ma forKey:kTMCompFavorite];
        btn.selected = NO;
        
        return;
    }
    
    NSArray *arr = [TMInstance objectForKey:kTMCompFavorite];
    NSMutableArray *ma = [NSMutableArray arrayWithArray:arr];
    self.detail.fTime = [[NSDate date] jx_stringWithFormat:kJXFormatDateStyle1];
    [ma addObject:self.detail];
    [TMInstance setObject:ma forKey:kTMCompFavorite];
    btn.selected = YES;
}

- (IBAction)shareButtonPressed:(id)sender {
    if (![WXApi isWXAppInstalled]) {
        JXHUDInfo(@"未安装微信，无法分享", YES);
        return;
    }
    
    if (0 == self.detail.drugPriceList.count) {
        JXHUDInfo(@"无效的详情数据", YES);
        return;
    }
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        CompResultDetailPrice *p = self.detail.drugPriceList[0];
        
        JXHUDProcessing(nil);
        [[SDWebImageManager sharedManager] downloadImageWithURL:JXURLWithStr(p.imgUrl) options:SDWebImageRefreshCached progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            JXHUDHide();
            if (finished && image) {
                NSString *title = JXStrWithDft(self.detail.wiseDrugBrandInstructionsDto.dbiName, @"");
                NSString *desc = JXStrWithDft(self.detail.wiseDrugBrandInstructionsDto.dbiIndication, @"");
                UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:image];
                shareObject.webpageUrl = @"https://www.appvworks.com/doctor/user_app/index.html";
                
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                messageObject.shareObject = shareObject;
                
                [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                    //            if (error) {
                    //                JXHUDError(error.localizedDescription, YES);
                    //            }
                }];
            }else {
                NSString *title = JXStrWithDft(self.detail.wiseDrugBrandInstructionsDto.dbiName, @"");
                NSString *desc = JXStrWithDft(self.detail.wiseDrugBrandInstructionsDto.dbiIndication, @"");
                UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:JXImageWithName(@"my_appicon")];
                shareObject.webpageUrl = @"https://www.appvworks.com/doctor/user_app/index.html";
                
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                messageObject.shareObject = shareObject;
                
                [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                    //            if (error) {
                    //                JXHUDError(error.localizedDescription, YES);
                    //            }
                }];
            }
        }];
        
//        NSString *title = JXStrWithDft(self.detail.wiseDrugBrandInstructionsDto.dbiName, @"");
//        NSString *desc = JXStrWithDft(self.detail.wiseDrugBrandInstructionsDto.dbiIndication, @"");
//        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:p.imgUrl];
//        shareObject.webpageUrl = @"https://www.appvworks.com/doctor/user_app/index.html";
//        
//        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//        messageObject.shareObject = shareObject;
//        
//        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
////            if (error) {
////                JXHUDError(error.localizedDescription, YES);
////            }
//        }];
    }];
}

#pragma mark - Notification methods

#pragma mark - Delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView1) {
        return self.detail.drugPriceList.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView1) {
        CompResultDetailPrice *p = self.detail.drugPriceList[section];
        return p.dbSpecBuyList.count;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView1) {
        return [CompResultDetailCell height];
    }
    return [CompResultDetailIntroCell heightWithData:[self introWithRow:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView1) {
        CompResultDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[CompResultDetailCell identifier]];
        CompResultDetailPrice *p = self.detail.drugPriceList[indexPath.section];
        cell.data = p.dbSpecBuyList[indexPath.row];
        return cell;
    }
    
    CompResultDetailIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:[CompResultDetailIntroCell identifier]];
    cell.data = [self introWithRow:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView1) {
        return JXScreenScale(80);
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView1) {
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kJXIdentifierHeaderFooter];
        CompResultDetailHeader *coverView = [headerView viewWithTag:101];
        if (!coverView) {
            coverView = [[[NSBundle mainBundle] loadNibNamed:@"CompResultDetailHeader" owner:nil options:nil] firstObject];
            coverView.tag = 101;
            [headerView addSubview:coverView];
            [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(headerView);
            }];
        }
        coverView.price = self.detail.drugPriceList[section];
        
        return headerView;
    }
    return nil;
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x != 0 && scrollView.contentOffset.y == 0) {
        self.isHScrolling = YES;
    }else {
        self.isHScrolling = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!self.isHScrolling) {
        return;
    }
    
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
    //[self requestGoodsAttrsIfNeedWithIndex:page];
}

#pragma mark - Public methods
#pragma mark - Class methods


@end
