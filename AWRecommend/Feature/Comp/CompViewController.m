//
//  CompViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "CompViewController.h"
#import "CompHeaderView.h"
#import "SearchViewController.h"
#import "TestViewController.h"
#import "ScanViewController.h"
#import "ResultViewController.h"
#import "ScanPopupViewController.h"

@interface CompViewController ()
@property (nonatomic, strong) CompHeaderView *headerView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
//@property (nonatomic, weak) IBOutlet NSLayoutConstraint *ratioHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *realHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *mustHeightConstraint;

@property (nonatomic, weak) IBOutlet UIView *clearButton;
@property (nonatomic, weak) IBOutlet UIView *hisotryTitleView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *historyTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *historyHeightConstraint;

@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *imageViews;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *labels;

@property (nonatomic, strong) NSArray *historis;
@property (nonatomic, weak) IBOutlet UIView *hisotryView;

@property (nonatomic, strong) NSArray *hotwords;
@property (nonatomic, weak) IBOutlet UIView *hotwordView;

@property (nonatomic, strong) RACCommand *infoCommand;
//@property (nonatomic, strong) RACCommand *hotwordsCommand;
//@property (nonatomic, strong) RACCommand *quoteCommand;

@end

@implementation CompViewController
#pragma mark - Override methods
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
//    if (!self.scrollView.parallaxView) {
//        [self.scrollView addParallaxWithView:self.headerView andHeight:self.headerView.jx_height andShadow:NO];
//        [self.scrollView bringSubviewToFront:self.contentView];
//    }
}

- (void)bindViewModel {
    [super bindViewModel];
    
    [RACObserve(self, historis) subscribeNext:^(id x) {
        [self configShortcuts:self.historis isFixed:YES];
        [self configShortcuts:self.hotwords isFixed:NO];
    }];
    
    [self.infoCommand execute:nil];
 //   [self.quoteCommand execute:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
//    self.historis = @[@"标签框里只能十个汉字", @"标签框的距离两个汉字", @"超过十个字用省略号1234", @"腹泻", @"儿童腹泻儿童", @"小儿感冒", @"小儿咳嗽", @"小儿啼哭", @"小儿摔跤", @"小儿厌食", @"小儿拉肚子"];
//    self.hotwords = @[@"标签框里只能十个汉字", @"标签框的距离两个汉字", @"超过十个字用省略号1234", @"腹泻", @"儿童腹泻儿童", @"小儿感冒", @"小儿咳嗽", @"小儿啼哭", @"小儿摔跤", @"小儿厌食", @"小儿拉肚子", @"小儿拉肚子1", @"小儿拉肚子22", @"小儿拉肚子333", @"小儿拉肚子4444", @"小儿拉肚子55555", @"小儿拉肚子666666", @"小儿拉肚子7777777", @"小儿拉肚子88888888", @"小儿拉肚子999999999"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyHistoryDidChange:) name:kNotifyHistoryDidChange object:nil];
}

- (void)setupData {
    self.historis = [TMInstance objectForKey:kTMCompHistory];
}

- (void)setupView {
    self.navigationItem.title = @"药品比选";
    [self.navigationController.navigationBar jx_transparet];

    //self.navigationItem.rightBarButtonItem = [UIBarButtonItem jx_barItemWithImage:JXImageWithName(@"ic_doctor") size:CGSizeMake(26, 26) target:self action:@selector(doctorItemPressed:)];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"扫码" style:UIBarButtonItemStylePlain target:self action:@selector(scanItemPressed:)];
    
    self.scrollView.parallaxHeader.view = self.headerView;
    self.scrollView.parallaxHeader.height = self.headerView.jx_height;
    self.scrollView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.scrollView.parallaxHeader.minimumHeight = self.headerView.jx_height;
    
    //self.realHeightConstraint.constant += self.headerView.jx_height * -1;
    self.mustHeightConstraint.constant += self.headerView.jx_height * -1;
    self.realHeightConstraint.constant += self.headerView.jx_height * -1;
    
    //self.ratioHeightConstraint.constant = self.headerView.jx_height * -1 + 1;
    //self.realHeightConstraint.constant = JXScreenHeight - 49 - self.headerView.jx_height + 1;
    
    [self configUI];
    
    //[self configShortcuts:self.historis isFixed:YES];
}

- (void)setupSignal {
}

- (void)setupNet {
    
}

#pragma mark fetch
#pragma mark request
#pragma mark assist
- (void)configUI {
    for (UIImageView *imageView in self.imageViews) {
        imageView.backgroundColor = SMInstance.mainColor;
    }
    for (UILabel *label in self.labels) {
        label.textColor = SMInstance.mainColor;
        label.font = [UIFont jx_deviceBoldFontOfSize:14];
    }
}

- (void)configShortcuts:(NSArray *)shortcuts isFixed:(BOOL)isFixed {
    CGFloat interval = JXScreenScale(20);
    CGFloat height = JXScreenScale(34);
    CGFloat textHeight = JXScreenScale(22);
    CGFloat textMargin = JXScreenScale(12);
    CGFloat x = 0;
    CGFloat y = (height - textHeight) / 2.0;
    CGFloat lines = 0;
    UIFont *font = JXFont(11);
    UIButton *btn = nil;
    
    if (isFixed) {
        [self.hisotryView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }else {
        [self.hotwordView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    for (NSInteger i = 0; i < shortcuts.count; ++i) {
        NSString *str = shortcuts[i];
        if (str.length > 10) {
            str = JXStrWithFmt(@"%@...", [str substringToIndex:10]);
        }
        CGSize size = [str jx_sizeWithFont:font width:INT32_MAX];
        if (x + interval + size.width + textMargin + interval > JXScreenWidth) {
            if (isFixed && (2 == lines)) {
                break;
            }
            
            lines++;
            x = 0;
            y += height;
        }
        
//        if (isFixed && (3 == lines)) {
//            break;
//        }
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = font;
        btn.backgroundColor = JXColorHex(0xEAEAEA);
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:JXColorHex(0x666666) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(shortcutButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        btn.frame = CGRectMake(x + interval, y, btn.jx_width + textMargin, textHeight);
        [btn jx_borderWithColor:[UIColor clearColor] width:0.0 radius:8];
        if (isFixed) {
            [self.hisotryView addSubview:btn];
        }else {
            [self.hotwordView addSubview:btn];
        }
        
        x = btn.jx_x + btn.jx_width;
    }
    
    if (btn && !isFixed) {
        CGFloat offset = 0;
        if (!self.hisotryTitleView.hidden) {
            offset = JXScreenScale(44);
        }
        self.realHeightConstraint.constant = offset + self.historyHeightConstraint.constant + JXScreenScale(44) + btn.jx_y + textHeight + JXScreenScale(12);
    }
    
    if (isFixed) {
        self.clearButton.hidden = (0 == shortcuts.count);
        NSInteger multiples = (0 == shortcuts.count) ? 0 : (lines + 1);
        self.historyHeightConstraint.constant = JXScreenScale(34) * multiples;
        
        if (0 == shortcuts.count) {
            self.hisotryTitleView.hidden = YES;
            self.historyTopConstraint.constant = JXScreenScale(44) * -1;
        }else {
            self.hisotryTitleView.hidden = NO;
            self.historyTopConstraint.constant = 0;
        }
    }
}

//- (void)configHotwords {
//    CGFloat interval = JXScreenScale(20);
//    CGFloat height = JXScreenScale(34);
//    CGFloat textHeight = JXScreenScale(22);
//    CGFloat textMargin = JXScreenScale(12);
//    CGFloat x = 0;
//    CGFloat y = (height - textHeight) / 2.0;
//    // CGFloat lines = 0;
//    UIFont *font = JXFont(11);
//    for (NSInteger i = 0; i < self.hotwords.count; ++i) {
//        NSString *str = self.hotwords[i];
//        if (str.length > 10) {
//            str = JXStrWithFmt(@"%@...", [str substringToIndex:10]);
//        }
//        CGSize size = [str jx_sizeWithFont:font width:INT32_MAX];
//        if (x + interval + size.width + textMargin + interval > JXScreenWidth) {
//            x = 0;
//            y += height;
//        }
//
//        UILabel *label = [[UILabel alloc] init];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = font;
//        label.backgroundColor = JXColorHex(0xEAEAEA);
//        label.textColor = JXColorHex(0x666666);
//        label.text = str;
//        [label sizeToFit];
//        label.frame = CGRectMake(x + interval, y, label.jx_width + textMargin, textHeight);
//        [label jx_borderWithColor:[UIColor clearColor] width:0.0 radius:8];
//        [self.hotwordView addSubview:label];
//
//        x = label.jx_x + label.jx_width;
//    }
//}

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
- (CompHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"CompHeaderView" owner:nil options:nil] firstObject];
        @weakify(self)
        _headerView.didSearchBlock = ^() {
            @strongify(self)
            // CompSearchViewController *vc = [[CompSearchViewController alloc] init];
            SearchViewController *vc = [[SearchViewController alloc] init];
            //TestViewController *vc = [[TestViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        };
        _headerView.didScanBlock = ^() {
            @strongify(self)
            [self goScan];
        };
    }
    return _headerView;
}

- (RACCommand *)infoCommand {
    if (!_infoCommand) {
        _infoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal combineLatest:@[[HRInstance showHotWords], [HRInstance getKnowledgeLibInfo]]];
        }];
        //[_hotwordsCommand.executing subscribe:self.executing];
        [_infoCommand.errors subscribe:self.errors];

        @weakify(self)
        [_infoCommand.executionSignals.switchToLatest subscribeNext:^(RACTuple *tuple) {
            @strongify(self)
            self.hotwords = tuple.first;
            [self configShortcuts:self.hotwords isFixed:NO];
            
            CompQuote *q = tuple.second;
            self.headerView.quoteAuthLabel.text = JXStrWithFmt(@"---%@", JXStrWithDft(q.title, @""));
            self.headerView.quoteDescLabel.text = JXStrWithDft(q.content, @"");
            self.headerView.quoteImageView.hidden = NO;
            self.headerView.quoteImageView2.hidden = NO;
            
            //self.headerView.quoteAuthLabel.text = @"---健康智选";
            //self.headerView.quoteDescLabel.text = @"若眼睛干涩发痒，先将眼睛闭起来休息个几分钟再张开，千万不要用手去揉眼睛"; // @"帮助用户正确认知健康问题"; //
        }];
    }
    return _infoCommand;
}

//- (RACCommand *)hotwordsCommand {
//    if (!_hotwordsCommand) {
//        _hotwordsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//            return [HRInstance showHotWords];
//        }];
//        //[_hotwordsCommand.executing subscribe:self.executing];
//        [_hotwordsCommand.errors subscribe:self.errors];
//        
//        @weakify(self)
//        [_hotwordsCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *items) {
//            @strongify(self)
//            self.hotwords = items;
//            [self configShortcuts:self.hotwords isFixed:NO];
//        }];
//    }
//    return _hotwordsCommand;
//}
//
//- (RACCommand *)quoteCommand {
//    if (!_quoteCommand) {
//        _quoteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//            return [HRInstance getKnowledgeLibInfo];
//        }];
//        //[_quoteCommand.executing subscribe:self.executing];
//        [_quoteCommand.errors subscribe:self.errors];
//        
//        @weakify(self)
//        [_quoteCommand.executionSignals.switchToLatest subscribeNext:^(CompQuote *quote) {
//            @strongify(self)
//            int a = 0;
//        }];
//    }
//    return _quoteCommand;
//}



#pragma mark - Action methods
- (void)goScan {
    if (gUser.isLogined == NO && gMisc.skipScanPopup == NO) {
        ScanPopupViewController *vc = [[ScanPopupViewController alloc] init];
        
        @weakify(self)
        vc.didCloseBlock = ^() {
            @strongify(self)
            [self jx_dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeBounceOut];
        };
        
        vc.didSkipBlock = ^{
            @strongify(self)
            gMisc.skipScanPopup = YES;
            [self jx_dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeBounceOut dismissed:^{
                @strongify(self)
                ScanViewController *vc = [[ScanViewController alloc] init];
                //vc.useBackAsReturn = YES;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }];
        };
        
        vc.didLoginBlock = ^{
            @strongify(self)
            [self jx_dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeBounceOut dismissed:^{
                @strongify(self)
//                [gUser checkLoginWithFinish:^{
//                    @strongify(self)
//                    ScanViewController *vc = [[ScanViewController alloc] init];
//                    //vc.useBackAsReturn = YES;
//                    vc.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:vc animated:YES];
//                } error:nil];
                
                [gUser checkLoginWithFinish:^(BOOL isRelogin) {
                    @strongify(self)
                    ScanViewController *vc = [[ScanViewController alloc] init];
                    //vc.useBackAsReturn = YES;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                } error:nil];
            }];
        };
        
        [self jx_presentPopupViewController:vc animationType:JXPopupShowTypeBounceIn layout:JXPopupLayoutCenter bgTouch:NO dismissed:^{
            
        }];
        return;
    }
    
    ScanViewController *vc = [[ScanViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scanItemPressed:(id)sender {
    [self goScan];
}

- (void)doctorItemPressed:(id)sender {
    //JXHUDInfo(@"缺少效果图", YES);
    JXWebViewController *vc = [[JXWebViewController alloc] initWithURL:JXURLWithStr(@"https://www.appvworks.com/doctor/askDoctor/askDoctor.html") title:@"问医生"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)searchButtonPressed:(id)sender {
    
}

- (void)shortcutButtonPressed:(UIButton *)btn {
//    SearchResultViewController *vc = [[SearchResultViewController alloc] init];
//    vc.searchText = [btn titleForState:UIControlStateNormal];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    
////    CompResultDetailViewController *vc = [[CompResultDetailViewController alloc] init];
////    vc.hidesBottomBarWhenPushed = YES;
////    vc.brand = [CompResultBrand new];
////    vc.brand.brandId = 1;
////    [self.navigationController pushViewController:vc animated:YES];
    
    ResultViewController *vc = [[ResultViewController alloc] init];
    vc.keyword = [btn titleForState:UIControlStateNormal];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clearButtonPressed:(id)sender {
    [TMInstance removeObjectForKey:kTMCompHistory];
    self.historis = nil;
}

#pragma mark - Notification methods
- (void)notifyHistoryDidChange:(NSNotification *)n {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifyHistoryDidChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyHistoryDidChange:) name:kNotifyHistoryDidChange object:nil];
    
    self.historis = n.object;
}

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource

#pragma mark - Public methods
#pragma mark - Class methods

@end
