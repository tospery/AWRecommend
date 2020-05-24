//
//  FilterNameViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/4/24.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "FilterNameViewController.h"
#import "BrandViewController.h"

@interface FilterNameViewController ()
@property (nonatomic, strong) NSArray *keys;

@end

@implementation FilterNameViewController
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

- (void)bindViewModel {
    [super bindViewModel];
    
    //RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[requestRemoteDataSignal deliverOnMainThread] map:^id _Nullable(NSDictionary *result) {
        NSArray *keys = [[result allKeys] sortedArrayUsingSelector:@selector(compare:)];
        NSMutableArray *sections = [NSMutableArray arrayWithCapacity:keys.count];
        NSMutableArray *rows = [NSMutableArray arrayWithCapacity:keys.count];
        for (NSString *key in keys) {
            NSArray *arr = result[key];
            if (0 != arr.count) {
                [sections addObject:key];
                [rows addObject:arr];
            }
        }
        self.keys = sections;
        
        if (0 == rows.count) {
            self.error = [NSError jx_errorWithCode:JXErrorCodeDataEmpty];
        }
        
        return JXArrWithDft(rows, nil);
    }];
//    RAC(self, dataSource) = [[[self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData] map:^id(NSArray *items) {
//        return JXArrValue(items, [NSArray new]);
//    }] map:^id(NSArray *items) {
//        return @[JXArrValue(items, [NSArray new])];
//    }];
    
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
        
        FilterNameItem *i = [FilterNameItem mj_objectWithKeyValues:input.second];
        
        CompResultItem *item = [CompResultItem new];
        item.dId = i.jxID.integerValue;
        item.dName = i.drugName;
        
        BrandViewController *vc = [[BrandViewController alloc] init];
        vc.dataSource = item;
        [self.navigationController pushViewController:vc animated:YES];

        
        return [RACSignal empty];
    }];
}

#pragma mark - Private methods
#pragma mark setup

- (void)setupVar {
}

- (void)setupData {
}

- (void)setupView {
    NSString *title = JXStrWithFmt(@"%@%@", self.classify.categoryName, [Util titleWithSearchKind:self.classify.kind]);
    self.navigationItem.title = title;
    
//    UINib *cellNib = [UINib nibWithNibName:@"DhzyDaibanCell" bundle:nil];
//    [self.tableView registerNib:cellNib forCellReuseIdentifier:[DhzyDaibanCell identifier]];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = JXColorHex(0x333333);
    //cell.preservesSuperviewLayoutMargins = NO;
    //self.tableView.separatorInset = UIEdgeInsetsZero;
    //self.tableView.layoutMargins = UIEdgeInsetsZero;
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
    return nil;
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    //return [HRInstance requestDhzyDaibanListWithPage:1];
    return [HRInstance queryDrugBySuitObjectId:[self.classify.jxID integerValue]];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    JXCellDefault *myCell = (JXCellDefault *)cell;
    
    //myCell.data = object;
    FilterNameItem *item = [FilterNameItem mj_objectWithKeyValues:object];
    myCell.textLabel.text = item.drugName;
    myCell.textLabel.font = JXFont(14);
    myCell.textLabel.textColor = JXColorHex(0x333333);
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JXCellDefault height];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [self.tableView dequeueReusableCellWithIdentifier:[JXCellDefault identifier] forIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.keys[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.keys;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return JXScreenScale(30);
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kJXIdentifierHeaderFooter];
//    header.backgroundView.backgroundColor = [UIColor redColor];
//    header.textLabel.textColor = [UIColor orangeColor];
//
//    return header;
//}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.backgroundView.backgroundColor = JXColorHex(0xE9E9E9);
    header.textLabel.textColor = JXColorHex(0x333333);
    header.textLabel.font = JXFont(15);
}

#pragma mark - Accessor methods
#pragma mark - Action methods
#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource

#pragma mark - Public methods
#pragma mark - Class methods


@end





