//
//  NiceDetailViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/15.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "NiceDetailViewController.h"
#import "NiceRelateView.h"
#import "NiceChannelViewController.h"
#import "NiceChannelView.h"
#import "NiceCommentViewController.h"

#define lNiceDetailNavChangeOffset       (20)

@interface NiceDetailViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *expiredImageView;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) MWPhotoBrowser *browser;

@property (nonatomic, strong) NiceChannelView *channelView;

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *buttons;

@property (nonatomic, assign) CGFloat webHeight;

@property (nonatomic, weak) IBOutlet JXBannerView *bannerView;

@property (nonatomic, weak) IBOutlet UILabel *sourceLabel;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *nameLabel;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *priceLabel;

@property (nonatomic, weak) IBOutlet UILabel *discountTimeLabel;

@property (nonatomic, weak) IBOutlet UIView *webBgView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *webHConstraint;
@property (nonatomic, strong) WKWebView *webView;

// @property (nonatomic, weak) IBOutlet UIView *tagBgView;
@property (nonatomic, weak) IBOutlet UIView *tagView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tagRConstraint;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *relateRConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *relateWConstraint;
@property (nonatomic, weak) IBOutlet UIView *relateContentView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentRConstraint;

@property (nonatomic, weak) IBOutlet UIView *toolView;

@property (nonatomic, strong) UILabel *myTitleLabel;

@property (nonatomic, weak) IBOutlet UIButton *zanButton;
@property (nonatomic, weak) IBOutlet UIButton *commentButton;
@property (nonatomic, weak) IBOutlet UIButton *favButton;
@property (nonatomic, weak) IBOutlet UIButton *buyButton;

@property (nonatomic, strong) RACCommand *favCommand;
@property (nonatomic, strong) RACCommand *zanCommand;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *xgbqTopConstraint;
@property (nonatomic, weak) IBOutlet UIView *tjsjView;
@property (nonatomic, weak) IBOutlet UIView *xgyhView;
@property (nonatomic, weak) IBOutlet UIView *xgbqView;

@end

@implementation NiceDetailViewController
#pragma mark - Override
#pragma mark init
- (instancetype)init {
    if (self = [super init]) {
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
        self.shouldPullToRefresh = YES;
    }
    return self;
}

- (void)dealloc {
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
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
    self.scrollView.delegate = self;
    [self scrollViewDidScroll:self.scrollView];
    [self.navigationController.navigationBar jx_transparet];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.scrollView.delegate = nil;
    [self.navigationController.navigationBar jx_reset];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark setup
- (void)setupVar {
}

- (void)setupView {
    self.discountTimeLabel.font = [UIFont jx_boldSystemFontOfSize:15];
    
    // self.navigationItem.title = @"详情";
    self.navigationItem.titleView = self.myTitleLabel;
    
    [self.navigationController.navigationBar jx_transparet];
    
    //    UINib *nib = [UINib nibWithNibName:@"JXCell" bundle:nil];
    //    [self.tableView registerNib:nib forCellReuseIdentifier:[JXCell identifier]];
    //    self.tableView.tableFooterView = [UIView new];
    
    self.bannerView.pageControl.pageIndicatorTintColor = JXColorHex(0xF4F4F4);
    self.bannerView.pageControl.currentPageIndicatorTintColor = JXColorHex(0xBCBCBC);
    
    self.nameLabel.lineSpacing = 0.0f;
    self.priceLabel.lineSpacing = 0.0f;
    
    
    for (UIButton *btn in self.buttons) {
        JXAdaptButton(btn, nil);
        if (1001 == btn.tag
            || 1002 == btn.tag
            || 1003 == btn.tag) {
            btn.titleLabel.font = [UIFont jx_boldSystemFontOfSize:13.0f];
        }
    }
    
    //    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    //    config.allowsInlineMediaPlayback = YES;
    //    if (JXiOSVersionGreaterThanOrEqual(@"9.0")) {
    //        config.allowsPictureInPictureMediaPlayback = YES;
    //    }
    //
    //    _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    //    _webView.navigationDelegate = self;
    //    _webView.UIDelegate = self;
    
    [self.webBgView addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        // make.edges.equalTo(self.webBgView);
        make.leading.equalTo(self.webBgView).offset(10);
        make.top.equalTo(self.webBgView);
        make.trailing.equalTo(self.webBgView).offset(-10);
        make.bottom.equalTo(self.webBgView);
    }];
    
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    //    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    //    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    //    [webView loadHTMLString:appHtml baseURL:baseURL];
    
    //    self.view.backgroundColor = [UIColor whiteColor];
    //    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setupNet {
    
}

#pragma mark scroll
- (void)bindViewModel {
    [super bindViewModel];
    
    // RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[requestRemoteDataSignal deliverOnMainThread] map:^id _Nullable(Nice *n) {
        //        n.articleDetailsImages = @[@"http://www.tianlonggroup.com.cn/up/img/20150501/20150501_60e52f425af97047.jpg ",
        //                                   @"http://www.tianlonggroup.com.cn/up/img/20150501/20150501_788b71aa3f0f3888.jpg",
        //                                   @"http://www.tianlonggroup.com.cn/up/img/20150430/20150430_5eb973cedc383810.jpg",
        //                                   @"http://www.tianlonggroup.com.cn/up/img/20150501/20150501_60e52f425af97047.jpg"];
        return n;
    }];
    
    RAC(self.toolView, hidden) = [RACObserve(self, dataSource) map:^id _Nullable(id  _Nullable value) {
        return @(value == nil);
    }];
}

- (id)fetchLocalData {
    return nil;
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    return [HRInstance showArticleDetalis:self.niceID];
}

- (void)setupRefresh {
    RefreshGifHeader *header = [RefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(triggerRefresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.scrollView.mj_header = header;
}

- (void)reloadData {
    [super reloadData];
    
    if (self.webHeight != 0) {
        self.webHeight = 0.0f;
    }
    if (self.contentRConstraint.constant != 0) {
        self.contentRConstraint.constant = 0.0f;
    }
    
    Nice *n = self.dataSource;
    NSMutableArray *views = [NSMutableArray array];
    
    UIImage *dftImage = JXImageWithName(@"img_default2");
    for (NSString *link in n.detailsImages) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:JXURLWithStr(link) placeholderImage:dftImage];
        [views addObject:imageView];
    }
    
    self.sourceLabel.text = JXStrWithFmt(@"%@ | %@ | 特价情报员：小爱", n.articleSource, [n.articlePublishDate substringToIndex:10]);
    self.nameLabel.text = n.articleTitle;
    if (0 != n.articlePriceRemark.length) {
        self.priceLabel.text = JXStrWithFmt(@"%@ %@", n.articlePrice, n.articlePriceRemark);
    }else {
        self.priceLabel.text = n.articlePrice;
    }
    
    NSString *startTime = [n.discountStartTime substringToIndex:16];
    NSString *endTime = [n.discountEndTime substringToIndex:16];
    
    CGFloat offset = JXAdaptScreenWidth() / 10.0 * 3.0;
    if (0 == startTime.length && 0 != endTime.length) {
        self.xgbqTopConstraint.constant = 0;
        self.discountTimeLabel.text = JXStrWithFmt(@"%@结束", endTime);
        self.tjsjView.hidden = NO;
    }else if (0 != startTime.length && 0 == endTime.length) {
        self.xgbqTopConstraint.constant = 0;
        self.discountTimeLabel.text = JXStrWithFmt(@"%@开始", startTime);
        self.tjsjView.hidden = NO;
    }else if (0 != startTime.length && 0 != endTime.length) {
        self.xgbqTopConstraint.constant = 0;
        self.discountTimeLabel.text = JXStrWithFmt(@"%@至%@", startTime, endTime);
        self.tjsjView.hidden = NO;
    }else {
        self.discountTimeLabel.text = @"永久有效";
        self.xgbqTopConstraint.constant = -1 * offset;
        self.tjsjView.hidden = YES;
    }
    
    
    @weakify(self)
    [self.bannerView setupViews:views didTapBlock:^(NSInteger index) {
        @strongify(self)
        //        ServeAdv *obj = banners[index];
        //        JXWebViewController *vc = [[JXWebViewController alloc] initWithLink:obj.targetUrl];
        //        vc.hidesBottomBarWhenPushed = YES;
        //        [self.navigationController pushViewController:vc animated:YES];
        
        if (!self.photos) {
            self.photos = [NSMutableArray arrayWithCapacity:n.detailsImages.count];
        }
        [self.photos removeAllObjects];
        for (NSString *link in n.detailsImages) {
            [self.photos addObject:[MWPhoto photoWithURL:JXURLWithStr(link)]];
        }
        
        ////        for
        ////        MWPhoto *p = [MWPhoto photoWithURL:<#(NSURL *)#>
        //        if (!browser) {
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
        browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
        browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
        browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
        browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
        browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
        browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
        browser.autoPlayOnAppear = NO; // Auto-play first video
        //}
        
        [browser setCurrentPhotoIndex:index];
        [self.navigationController pushViewController:browser animated:YES];
        //[self.navigationController presentViewController:browser animated:YES completion:NULL];
    }];
    
    BOOL noTags = [self configTags:n.wiseExcellentTagsDtos];
    BOOL isEmpty = [self configRelates:n.wiseExcellentArticleRelatedDiscountDtos];
    
    self.contentRConstraint.constant = (self.tagRConstraint.constant + self.relateRConstraint.constant);
    
    self.contentRConstraint.constant += self.xgbqTopConstraint.constant;
    
    offset = JXAdaptScreenWidth() / 80.0 * 21.0f;
    if (isEmpty) {
        self.contentRConstraint.constant -= offset;
    }else {
        self.contentRConstraint.constant += offset;
    }
    //    offset = JXAdaptScreenWidth() / 8.0;
    //    if (noTags) {
    //        self.contentRConstraint.constant -= offset;
    //    }else {
    //        self.contentRConstraint.constant += offset;
    //    }
    
    if (0 != n.articleContext.length) {
        //        NSURLRequest *request = [NSURLRequest requestWithURL:JXURLWithStr(@"https://www.baidu.com/")];
        //        [self.webView loadRequest:request];
        [self.webView loadHTMLString:n.articleContext baseURL:nil];
    }
    
    NSString *zanString = n.articleAppreciateNumber >= 100 ? @" 99+" : JXStrWithFmt(@" %ld", (long)n.articleAppreciateNumber);
    [self.zanButton setTitle:zanString forState:UIControlStateNormal];
    
    NSString *cmtString = n.articleCommentsNumbers >= 100 ? @" 99+" : JXStrWithFmt(@" %ld", (long)n.articleCommentsNumbers);
    [self.commentButton setTitle:cmtString forState:UIControlStateNormal];
    
    self.zanButton.selected = n.myAppreciate;
    self.favButton.selected = n.myFavorite;
    
    if (n.articleAcessType == 0) {
        [self.buyButton setTitle:@"立即咨询" forState:UIControlStateNormal];
    }else {
        [self.buyButton setTitle:@"直达链接" forState:UIControlStateNormal];
    }
    
    self.expiredImageView.hidden = !n.expired;
    [self.bannerView bringSubviewToFront:self.expiredImageView];
}

//#pragma mark table
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
- (WKWebView *)webView {
    if (!_webView) {
        //        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        //        config.allowsInlineMediaPlayback = YES;
        //        if (JXiOSVersionGreaterThanOrEqual(@"9.0")) {
        //            config.allowsPictureInPictureMediaPlayback = YES;
        //        }
        //
        //        // _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        //        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        //        _webView.navigationDelegate = self;
        //        _webView.UIDelegate = self;
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (NiceChannelView *)channelView {
    if (!_channelView) {
        _channelView = [[[NSBundle mainBundle] loadNibNamed:@"NiceChannelView" owner:self options:nil] firstObject];
        _channelView.platforms = [(Nice *)self.dataSource wiseExcellentArticleBuyAcessDtos];
        
        @weakify(self)
        _channelView.clickBlock = ^(NSString *link) {
            @strongify(self)
            [self.channelView removeFromSuperview];
            if (0 != link.length) {
                JXWebViewController *vc = [[JXWebViewController alloc] initWithURL:JXURLWithStr(link)];
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
    }
    return _channelView;
}

- (UILabel *)myTitleLabel {
    if (!_myTitleLabel) {
        _myTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _myTitleLabel.font = [UIFont systemFontOfSize:17];
        _myTitleLabel.textColor = JXColorHex(0x333333);
        _myTitleLabel.text = @"好价详情";
        [_myTitleLabel sizeToFit];
    }
    return _myTitleLabel;
}

- (RACCommand *)favCommand {
    if (!_favCommand) {
        @weakify(self)
        _favCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [[HRInstance collectArticle:[[(Nice *)self.dataSource jxID] integerValue]] takeUntil:self.rac_willDeallocSignal];
        }];
        [_favCommand.executing subscribe:self.executing];
        [_favCommand.errors subscribe:self.errors];
        
        [_favCommand.executionSignals.switchToLatest subscribeNext:^(NSString *msg) {
            @strongify(self)
            Nice *n = self.dataSource;
            n.myFavorite = !n.myFavorite;
            self.favButton.selected = n.myFavorite;
            [JXDialog hideHUD];
        }];
    }
    return _favCommand;
}

- (RACCommand *)zanCommand {
    if (!_zanCommand) {
        @weakify(self)
        _zanCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [[HRInstance praiseArticle:[[(Nice *)self.dataSource jxID] integerValue]] takeUntil:self.rac_willDeallocSignal];
        }];
        [_zanCommand.executing subscribe:self.executing];
        [_zanCommand.errors subscribe:self.errors];
        
        [_zanCommand.executionSignals.switchToLatest subscribeNext:^(NSString *msg) {
            @strongify(self)
            Nice *n = self.dataSource;
            n.myAppreciate = !n.myAppreciate;
            self.zanButton.selected = n.myAppreciate;
            
            if (n.myAppreciate) {
                n.articleAppreciateNumber++;
            }else {
                n.articleAppreciateNumber--;
            }
            NSString *zanString = n.articleAppreciateNumber >= 100 ? @" 99+" : JXStrWithFmt(@" %ld", (long)n.articleAppreciateNumber);
            [self.zanButton setTitle:zanString forState:UIControlStateNormal];
            
            [JXDialog hideHUD];
        }];
    }
    return _zanCommand;
}


#pragma mark - Private
- (BOOL)configTags:(NSArray *)tags {
    CGFloat interval = JXAdaptScreen(20);
    CGFloat height = JXAdaptScreen(44);
    CGFloat textHeight = JXAdaptScreen(22);
    CGFloat textMargin = JXAdaptScreen(12);
    CGFloat x = 0;
    CGFloat y = (height - textHeight) / 2.0;
    CGFloat lines = 0;
    UIFont *font = JXFont(11);
    UIButton *btn = nil;
    
    [self.tagView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSInteger i = 0; i < tags.count; ++i) {
        NSString *str = [(NiceTag *)tags[i] name];
        NSInteger tid = [[(NiceTag *)tags[i] jxID] integerValue];
        if (str.length > 10) {
            str = JXStrWithFmt(@"%@...", [str substringToIndex:10]);
        }
        CGSize size = [str jx_sizeWithFont:font width:INT32_MAX];
        if (x + interval + size.width + textMargin + interval > JXAdaptScreenWidth()) {
            lines++;
            x = 0;
            y += height;
        }
        
        //        if (isFixed && (3 == lines)) {
        //            break;
        //        }
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = tid;
        btn.titleLabel.font = font;
        btn.backgroundColor = [UIColor clearColor];// JXColorHex(0xEAEAEA);
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:JXColorHex(0x999999) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tagButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        btn.frame = CGRectMake(x + interval, y, btn.jx_width + textMargin, textHeight);
        [btn jx_borderWithColor:JXColorHex(0xE1E1E1) width:1.0 radius:2.0];
        [self.tagView addSubview:btn];
        
        x = btn.jx_x + btn.jx_width;
    }
    
    //    if (btn && !isFixed) {
    //        CGFloat offset = 0;
    //        if (!self.hisotryTitleView.hidden) {
    //            offset = JXScreenScale(44);
    //        }
    //        // self.realHeightConstraint.constant = offset + self.historyHeightConstraint.constant + JXScreenScale(44) + btn.jx_y + textHeight + JXScreenScale(12);
    //    }
    
    //    if (isFixed) {
    //        self.clearButton.hidden = (0 == shortcuts.count);
    //        NSInteger multiples = (0 == shortcuts.count) ? 0 : (lines + 1);
    //        self.hotwordHeightConstraint.constant = JXScreenScale(34) * multiples;
    //
    //        if (0 == shortcuts.count) {
    //            self.hisotryTitleView.hidden = YES;
    //            self.historyTopConstraint.constant = JXScreenScale(40) * -1;
    //        }else {
    //            self.hisotryTitleView.hidden = NO;
    //            self.historyTopConstraint.constant = 0;
    //        }
    //    }
    
    //    if (isFixed) {
    //        //        self.clearButton.hidden = (0 == shortcuts.count);
    //        //        NSInteger multiples = (0 == shortcuts.count) ? 0 : (lines + 1);
    //        //        self.hotwordHeightConstraint.constant = JXScreenScale(34) * multiples;
    //        //
    //        if (0 == shortcuts.count) {
    //            self.hisotryTitleView.hidden = YES;
    //            self.historyTopConstraint.constant = JXScreenScale(40) * -1;
    //        }else {
    //            self.hisotryTitleView.hidden = NO;
    //            self.historyTopConstraint.constant = 0;
    //        }
    //    }else {
    //        NSInteger multiples = (0 == shortcuts.count) ? 0 : (lines + 1);
    //        self.hotwordHeightConstraint.constant = height * multiples;
    //    }
    
    NSInteger multiples = (0 == tags.count) ? 0 : (lines + 1);
    self.tagRConstraint.constant = height * multiples;
    
    NSLog(@"self.tagRConstraint.constant = %.2f", self.tagRConstraint.constant);
    if (tags.count == 0) {
        self.xgbqView.hidden = YES;
        return YES;
    }
    
    self.xgbqView.hidden = NO;
    return NO;
}

- (BOOL)configRelates:(NSArray *)relates {
    CGFloat width = JXAdaptScreenWidth() / 3.0f;
    CGFloat height = width / 107.0f * 160.0f;
    
    NSInteger count = relates.count;
    CGSize size = CGSizeZero;
    if (0 == count) {
        size.width = JXAdaptScreenWidth();
        size.height = 0.0f;
    }else if (count > 0 && count <= 3) {
        size.width = JXAdaptScreenWidth();
        size.height = height;
    }else {
        size.width = JXAdaptScreenWidth() * (count / 6 + 1);
        size.height = height * 2.0f;
    }
    
    self.relateRConstraint.constant = size.height;
    self.relateWConstraint.constant = (size.width - JXAdaptScreenWidth());
    
    NSLog(@"self.relateRConstraint.constant = %.2f", self.relateRConstraint.constant);
    
    [self.relateContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat x = 0.0f, y = 0.0f;
    //NSInteger x = 0, y = 0;
    for (NSInteger i = 0; i < relates.count; ++i) {
        // NiceRelate *r = relates[i];
        
        // NiceRelateView *v = [[[NSBundle mainBundle] loadNibNamed:@"NiceRelateView" owner:nil options:nil] firstObject];
        x = i % 3 * width + i / 6 * JXAdaptScreenWidth();
        y = i % 6 / 3 * height;
        
        NiceRelateView *v = [[NiceRelateView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        v.clickBlock = ^(NiceRelate *r) {
            NiceDetailViewController *vc = [[NiceDetailViewController alloc] init];
            vc.navItemColor = JXColorHex(0x333333);
            vc.niceID = r.jxID.integerValue;
            vc.shareIcon = r.articleTitleImage;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        };
        v.r = relates[i];
        
        //v.frame = CGRectMake(x, y, width, height);
        [self.relateContentView addSubview:v];
    }
    
    if (relates.count == 0) {
        self.xgyhView.hidden = YES;
        return YES;
    }
    
    self.xgyhView.hidden = NO;
    return NO;
}

#pragma mark - Public
#pragma mark - Action
- (void)tagButtonPressed:(UIButton *)btn {
    
}

- (IBAction)channelButtonPressed:(id)sender {
    Nice *n = self.dataSource;
    if (n.articleAcessType == 0) {
        if (0 == n.phone.length) {
            [JXDialog showPopup:@"无效的电话号码"];
            return;
        }
        [JXDevice dialNumber:n.phone];
        return;
    }
    
    self.channelView.frame = CGRectMake(0, JXAdaptScreenHeight(), JXAdaptScreenWidth(), JXAdaptScreenHeight());
    self.channelView.topView.backgroundColor = [UIColor clearColor];
    self.channelView.topView.alpha = 1.0;
    
    [JXAppWindow addSubview:self.channelView];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.channelView.frame = CGRectMake(0, 0, JXAdaptScreenWidth(), JXAdaptScreenHeight());
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.channelView.topView.backgroundColor = [UIColor blackColor];
            self.channelView.topView.alpha = 0.3;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (IBAction)commentButtonPressed:(id)sender {
    [gUser checkLoginWithFinish:^(BOOL isRelogin) {
        Nice *n = self.dataSource;
        
        NiceCommentViewController *vc = [NiceCommentViewController new];
        vc.nice = self.dataSource;
        vc.submitBlock = ^{
            n.articleCommentsNumbers++;
            NSString *cmtString = n.articleCommentsNumbers >= 100 ? @" 99+" : JXStrWithFmt(@" %ld", (long)n.articleCommentsNumbers);
            [self.commentButton setTitle:cmtString forState:UIControlStateNormal];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } error:NULL];
}

- (IBAction)zanButtonPressed:(id)sender {
    [gUser checkLoginWithFinish:^(BOOL isRelogin) {
        [self.zanCommand execute:nil];
    } error:NULL];
}

- (IBAction)favoriteButtonPressed:(id)sender {
    [gUser checkLoginWithFinish:^(BOOL isRelogin) {
        [self.favCommand execute:nil];
    } error:NULL];
}

- (IBAction)shareButtonPressed:(id)sender {
    if (![WXApi isWXAppInstalled]) {
        [JXDialog showPopup:@"请先安装微信客户端"];
        return;
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:2];
    if ([WXApi isWXAppInstalled]) {
        [arr addObject:@(UMSocialPlatformType_WechatSession)];
        [arr addObject:@(UMSocialPlatformType_WechatTimeLine)];
    }
    //[arr addObject:@(UMSocialPlatformType_QQ)];
    
    [UMSocialUIManager setPreDefinePlatforms:arr];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        Nice *n = self.dataSource;
        
        NSString *title = @"健康智选，为您优选：";
        NSString *desc = JXStrWithDft(n.articleTitle, @"");
        
        JXHUDProcessing(nil);
        [UIImage jx_imageWithRemoteURL:JXURLWithStr(n.articleTitleImage) localName:n.articleTitleImage dftImage:JXImageWithName(@"my_appicon") finish:^(UIImage *img) {
            JXHUDHide();
            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:img];
            
#ifdef JXEnableEnvHoc
            shareObject.webpageUrl = JXStrWithFmt(@"http://m.appvworks.com/dev/page/productInfo.html?shareApp=true&id=%@", n.jxID);
#else
            shareObject.webpageUrl = JXStrWithFmt(@"http://m.appvworks.com/page/productInfo.html?shareApp=true&id=%@", n.jxID);
#endif
            
            
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            messageObject.shareObject = shareObject;
            
            [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            }];
        }];
        // id icon = (n.articleTitleImage.length != 0 ? n.articleTitleImage: JXImageWithName(@"my_appicon"));
    }];
}

#pragma mark - Notification
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.webView.scrollView && [keyPath isEqual:@"contentSize"]) {
        UIScrollView *scrollView = self.webView.scrollView;
        if (JXAdaptScreenWidth() == (scrollView.contentSize.width + 20)) {
            
            if (self.webHeight == scrollView.contentSize.height) {
                return;
            }
            self.webHeight = scrollView.contentSize.height;
            
            NSLog(@"web contentSize = %@", NSStringFromCGSize(scrollView.contentSize));
            
            //                    self.bottomConstraint.constant = kbSize.height + 8.0;
            //                    [self.view setNeedsUpdateConstraints];
            //                    [self.view updateConstraintsIfNeeded];
            //                    [UIView animateWithDuration:0.4 animations:^{
            //                            [self.view layoutIfNeeded];
            //                        } completion:NULL];
            
            //            if (0 != self.webHConstraint.constant) {
            //                self.contentRConstraint.constant -= self.webHConstraint.constant;
            //            }
            
            
            self.webHConstraint.constant = self.webHeight;
            self.contentRConstraint.constant += self.webHeight;
            
            //            [self.contentView setNeedsUpdateConstraints];
            //            [self.contentView updateConstraintsIfNeeded];
            //            [UIView animateWithDuration:0.3 animations:^{
            //                [self.contentView layoutIfNeeded];
            //            } completion:NULL];
        }
    }
}

#pragma mark - Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIColor *color = [UIColor whiteColor]; // SMInstance.mainColor;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > lNiceDetailNavChangeOffset) {
        // self.navigationItem.title = @"好价详情";
        self.navigationItem.titleView.hidden = NO;
        [self.navigationController.navigationBar setShadowImage:nil];
        CGFloat alpha = MIN(1, 1 - ((lNiceDetailNavChangeOffset + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        // self.navigationItem.title = nil;
        self.navigationItem.titleView.hidden = YES;
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //    //开始加载网页时展示出progressView
    //    self.progressView.hidden = NO;
    //    //开始加载网页的时候将progressView的Height恢复为1.5倍
    //    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //    //防止progressView被网页挡住
    //    //[self.navigationController.navigationBar bringSubviewToFront:self.progressView];
    //    //[self.webView bringSubviewToFront:self.progressView];
    //    [self.view bringSubviewToFront:self.progressView];
}

// 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    //    //加载完成后隐藏progressView
    //    //    self.progressView.hidden = YES;
    //    if (0 == self.navigationItem.title.length) {
    //        //self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    //        [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    //            if ([result isKindOfClass:[NSString class]]) {
    //                self.navigationItem.title = result;
    //            }
    //        }];
    //    }
    //
    //    if (self.canRefresh) {
    //        [self.webView.scrollView.mj_header endRefreshing];
    //    }
    
    //    [webView evaluateJavaScript:@"document.getElementById(\"content\").offsetHeight;"completionHandler:^(id_Nullable result,NSError *_Nullable error) {
    //        //获取页面高度，并重置webview的frame
    //        CGFloat documentHeight = [resultdoubleValue];
    //        CGRect frame = webView.frame;
    //        frame.size.height = documentHeight;
    //        webView.frame = frame;
    //    }];
    //    [webView evaluateJavaScript:@"document.getElementById(\"content\").offsetHeight;" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    //        //获取页面高度，并重置webview的frame
    //        CGFloat documentHeight = [result doubleValue];
    //        NSLog(@"documentHeight = %.2f", documentHeight);
    ////        CGRect frame = webView.frame;
    ////        frame.size.height = documentHeight;
    ////        webView.frame = frame;
    //    }];
    //
    //    CGFloat ddd = webView.scrollView.contentSize.height;
    //    int a = 0;
}

// 加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    //    self.progressView.hidden = YES;
    //    if (self.canRefresh) {
    //        [self.webView.scrollView.mj_header endRefreshing];
    //    }
}

// 页面跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //Nice *n = self.dataSource;
    //NSString *str1 = n.articleContext;
    NSString *str2 = navigationAction.request.URL.absoluteString;
    
    if (![str2 hasPrefix:@"http"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    JXWebViewController *vc = [[JXWebViewController alloc] initWithURL:navigationAction.request.URL];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    decisionHandler(WKNavigationActionPolicyCancel);
    
    //decisionHandler(WKNavigationActionPolicyAllow);
    // decisionHandler(WKNavigationActionPolicyCancel);
    
    //    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    if([strRequest isEqualToString:@"about:blank"]) {//主页面加载内容
    //        decisionHandler(WKNavigationActionPolicyAllow);//允许跳转
    //    } else {//截获页面里面的链接点击
    //        //do something you want
    //        decisionHandler(WKNavigationActionPolicyCancel);//不允许跳转
    //    }
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}

#pragma mark - Class

@end
