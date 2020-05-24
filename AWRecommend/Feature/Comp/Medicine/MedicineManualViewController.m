//
//  MedicineManualViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/20.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "MedicineManualViewController.h"
#import "CompResultDetailIntroCell.h"

@interface MedicineManualViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, weak) IBOutlet JXBannerView *bannerView;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation MedicineManualViewController
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
    self.bannerView.frame = CGRectMake(0, 0, JXScreenWidth, JXScreenScale(120));
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
    
//    detail.uid = JXStrWithInt(self.brand.brandId);
//    self.detail = detail;
//    self.banners = self.detail.instructionImgList;
//    [self.tableView1 reloadData];
//    [self.tableView2 reloadData];
//    [self loadWebdata];
//    
//    NSArray *arr = [TMInstance objectForKey:kTMCompFavorite];
//    for (CompResultDetail *d in arr) {
//        if (d.uid.integerValue == self.detail.uid.integerValue) {
//            self.favoriteButton.selected = YES;
//            break;
//        }
//    }
//    
//    [JXDialog hideHUD];
    
    CompResultDetail *detail = self.dataSource;
    self.banners = detail.instructionImgList;
    
    [self.tableView reloadData];
}

#pragma mark - Private methods
#pragma mark setup

- (void)setupVar {
}

- (void)setupData {
}

- (void)setupView {
    UINib *nib = [UINib nibWithNibName:@"CompResultDetailIntroCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[CompResultDetailIntroCell identifier]];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = JXColorHex(0xF5F5F5);
    self.headerView.frame = CGRectMake(0, 0, 320, JXScreenScale(130));
    
    //self.navigationItem.leftBarButtonItem = JXCreateBackItem(self, @selector(returnItemPressed:), [UIColor whiteColor]);
}

- (void)setupSignal {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
#pragma mark assist
- (RACTuple *)introWithRow:(NSInteger)row {
    CompResultDetail *detail = self.dataSource;
    
    NSString *title = nil;
    NSString *content = nil;
    if (0 == row) {
        title = @"产品名称";
        content = detail.wiseDrugBrandInstructionsDto.dbiName;
    }else if (1 == row) {
        title = @"生产厂商";
        content = detail.wiseDrugBrandInstructionsDto.dbiFactory;
    }else if (2 == row) {
        title = @"批准文号";
        content = detail.wiseDrugBrandInstructionsDto.dbiApprovalNumber;
    }else if (3 == row) {
        title = @"有效期";
        content = detail.wiseDrugBrandInstructionsDto.dbiExpireDate;
    }else if (4 == row) {
        title = @"成分";
        content = detail.wiseDrugBrandInstructionsDto.dbiIngredient;
    }else if (5 == row) {
        title = @"适应症状";
        content = detail.wiseDrugBrandInstructionsDto.dbiIndication;
    }else if (6 == row) {
        title = @"不良反应";
        content = detail.wiseDrugBrandInstructionsDto.dbiReaction;
    }else if (7 == row) {
        title = @"注意事项";
        content = detail.wiseDrugBrandInstructionsDto.dbiAttention;
    }else if (8 == row) {
        title = @"禁忌";
        content = detail.wiseDrugBrandInstructionsDto.dbiContraindication;
    }else if (9 == row) {
        title = @"药物相互作用";
        content = detail.wiseDrugBrandInstructionsDto.dbiDrugInteractions;
    }
    return RACTuplePack(title, content, @(row));
}

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

#pragma mark - Action methods
#pragma mark - Notification methods

#pragma mark - Delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CompResultDetailIntroCell heightWithData:[self introWithRow:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompResultDetailIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:[CompResultDetailIntroCell identifier]];
    cell.data = [self introWithRow:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

#pragma mark - Public methods
#pragma mark - Class methods


@end


