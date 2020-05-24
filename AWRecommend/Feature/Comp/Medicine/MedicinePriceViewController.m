//
//  MedicinePriceViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/20.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "MedicinePriceViewController.h"
#import "MedicinePriceCell.h"
#import "MedicinePriceHeader.h"

@interface MedicinePriceViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) BOOL onceToken;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) RACCommand *addFavoriteCommand;
@property (nonatomic, strong) RACCommand *delFavoriteCommand;

@end

@implementation MedicinePriceViewController
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyFavoriteDidAdd:) name:kNotifyFavoriteDidAdd object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyFavoriteDidDel:) name:kNotifyFavoriteDidDel object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
////    if (!self.onceToken) {
////        self.onceToken = YES;
////    }else {
////        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyMedicineDidBuy object:@0];
////    }
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.tableView jx_borderWithColor:[UIColor clearColor] width:0.0 radius:6.0];
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
    RAC(self, dataSource) = [[requestRemoteDataSignal deliverOnMainThread] map:^id _Nullable(id result) {
        CompResultDetail *d = result;
        d.jxID = JXStrWithInt(self.medicine.brandId);
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyMedicineDidRequest object:d];
        return d;
    }];
}

- (void)reloadData {
    [super reloadData];
    [self.tableView reloadData];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyFavoriteDidAdd:) name:kNotifyFavoriteDidAdd object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyFavoriteDidDel:) name:kNotifyFavoriteDidDel object:nil];
}

- (void)setupData {
}

- (void)setupView {
    //[self.navigationController.navigationBar jx_transparet];
    self.nameLabel.text = JXStrWithFmt(@"【%@】%@", self.medicine.brandName, self.medicine.drugName);
    
    UINib *nib = [UINib nibWithNibName:@"MedicinePriceCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[MedicinePriceCell identifier]];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kJXIdentifierHeaderFooter];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = JXColorHex(0xF5F5F5);
    
    //self.navigationItem.leftBarButtonItem = JXCreateBackItem(self, @selector(returnItemPressed:), [UIColor whiteColor]);
}

- (void)setupSignal {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
#pragma mark assist

#pragma mark - Table
//- (id)fetchLocalData {
//    return nil;
//}
//
- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    return [HRInstance drugDetailWithBrandId:self.medicine.brandId];
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
- (RACCommand *)addFavoriteCommand {
    if (!_addFavoriteCommand) {
        _addFavoriteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance addDrugFavorite:([(NSNumber *)input integerValue])];
        }];
        [_addFavoriteCommand.executing subscribe:self.executing];
        [_addFavoriteCommand.errors subscribe:self.errors];
        [_addFavoriteCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *items) {
            // JXHUDSuccess(@"收藏成功", YES);
            [JXDialog showPopup:@"收藏成功"];
        }];
    }
    return _addFavoriteCommand;
}

- (RACCommand *)delFavoriteCommand {
    if (!_delFavoriteCommand) {
        _delFavoriteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance deleteDrugFavorite:([(NSNumber *)input integerValue])];
        }];
        [_delFavoriteCommand.executing subscribe:self.executing];
        [_delFavoriteCommand.errors subscribe:self.errors];
        [_delFavoriteCommand.executionSignals.switchToLatest subscribeNext:^(NSNumber *flag) {
            // JXHUDSuccess(@"取消收藏成功", YES);
            [JXDialog showPopup:@"取消收藏成功"];
        }];
    }
    return _delFavoriteCommand;
}

#pragma mark - Action methods
#pragma mark - Notification methods
- (void)notifyFavoriteDidAdd:(NSNotification *)notification {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyFavoriteDidAdd:) name:kNotifyFavoriteDidAdd object:nil];
    
    [self.addFavoriteCommand execute:notification.object];
}

- (void)notifyFavoriteDidDel:(NSNotification *)notification {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyFavoriteDidDel:) name:kNotifyFavoriteDidDel object:nil];
    
    [self.delFavoriteCommand execute:notification.object];
}

#pragma mark - Delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    CompResultDetail *d = self.dataSource;
//    return d.drugPriceList.count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    CompResultDetail *d = self.dataSource;
//    CompResultDetailPrice *p = d.drugPriceList[section];
//    return p.dbSpecBuyList.count;
    //return 1;
    
    CompResultDetail *d = self.dataSource;
    return d.drugPriceList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompResultDetail *d = self.dataSource;
    CompResultDetailPrice *p = d.drugPriceList[indexPath.row];
    return [MedicinePriceCell heightWithData:p];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MedicinePriceCell *cell = [tableView dequeueReusableCellWithIdentifier:[MedicinePriceCell identifier] forIndexPath:indexPath];
    CompResultDetail *d = self.dataSource;
    CompResultDetailPrice *p = d.drugPriceList[indexPath.row];
    cell.data = p;
    cell.buyBlock = ^(NSString *url) {
        NSString *openingURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        JXWebViewController *vc = [[JXWebViewController alloc] initWithURL:JXURLWithStr(openingURL)];
        //vc.useBackAsReturn = YES;
        
        //NSString *openingURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //JXWebSVViewController *vc = [[JXWebSVViewController alloc] initWithLink:openingURL];
        
        JXNavigationController *nc = [[JXNavigationController alloc] initWithRootViewController:vc];
        //nc.navigationItem.leftBarButtonItem = JXCreateBackItem(vc, @selector(returnItemPressed:), [UIColor whiteColor]);
        
        [nc.navigationBar jx_configWithParam:@{kJXKeyTranslucent: @NO, kJXKeyBarTintColor: SMInstance.mainColor, kJXKeyTitleColor: SMInstance.navItemColor, kJXKeyTitleFont: [UIFont systemFontOfSize:17.0f]}];
        
        [self presentViewController:nc animated:YES completion:NULL];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return JXScreenScale(80);
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return JXScreenScale(10);
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kJXIdentifierHeaderFooter];
//    MedicinePriceHeader *cover = [header viewWithTag:101];
//    if (!cover) {
//        cover = [[[NSBundle mainBundle] loadNibNamed:@"MedicinePriceHeader" owner:nil options:nil] firstObject];
//        cover.tag = 101;
//        [header addSubview:cover];
//        [cover mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(header);
//        }];
//    }
//    CompResultDetail *d = self.dataSource;
//    CompResultDetailPrice *p = d.drugPriceList[section];
//    cover.p = p;
//    
//    return header;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kJXIdentifierHeaderFooter];
//    footer.contentView.backgroundColor = JXColorHex(0xF5F5F5);
//    return footer;
//}

#pragma mark - Public methods
#pragma mark - Class methods


@end






