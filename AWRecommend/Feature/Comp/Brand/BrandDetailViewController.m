//
//  BrandDetailViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/23.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "BrandDetailViewController.h"
#import "BrandDetailCell.h"

@interface BrandDetailViewController ()

@end

@implementation BrandDetailViewController
#pragma mark - Override methods
- (instancetype)init {
    if (self = [super init]) {
        //self.shouldRequestRemoteDataOnViewDidLoad = YES;
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
    
    [self.tableView jx_borderWithColor:JXColorHex(0xeaeaea) width:1.0 radius:8];
}

- (void)bindViewModel {
    [super bindViewModel];
    
//    RAC(self, dataSource) = [[[self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData] map:^id(NSArray *items) {
//        return JXArrValue(items, [NSArray new]);
//    }] map:^id(NSArray *items) {
//        return @[JXArrValue(items, [NSArray new])];
//    }];
    
    //RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
//    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
//    RAC(self, dataSource) = [[requestRemoteDataSignal deliverOnMainThread] map:^id _Nullable(id result) {
//        return JXArrDataSource(result);
//    }];
}

#pragma mark - Private methods
#pragma mark setup
- (void)returnItemPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)setupVar {
}

- (void)setupData {
}

- (void)setupView {
    self.navigationItem.title = @"药品详情";
    
    UINib *nib = [UINib nibWithNibName:@"BrandDetailCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[BrandDetailCell identifier]];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor whiteColor];// self.contentView.backgroundColor;
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
//- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
//    return [HRInstance drugDetailWithBrandId:self.brand.brandId];
//}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    BrandDetailCell *myCell = (BrandDetailCell *)cell;
    myCell.data = object;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *dt = self.dataSource.firstObject;
    return [BrandDetailCell heightWithData:dt[indexPath.row]];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [self.tableView dequeueReusableCellWithIdentifier:[BrandDetailCell identifier] forIndexPath:indexPath];
}

#pragma mark - Accessor methods
#pragma mark - Action methods
#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource

#pragma mark - Public methods
#pragma mark - Class methods


@end
