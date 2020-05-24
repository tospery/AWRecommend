//
//  SearchResultViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/2/16.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SearchResultCell.h"
#import "CompResultBrandViewController.h"
#import "CompResultAllViewController.h"
#import "SearchResultAllViewController.h"

@interface SearchResultViewController ()
//@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UILabel *tipsLabel;

@end

@implementation SearchResultViewController
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
    
//    RAC(self, dataSource) = [[[self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData] map:^id(NSArray *items) {
//        return JXArrValue(items, [NSArray new]);
//    }] map:^id(NSArray *items) {
//        return @[JXArrValue(items, [NSArray new])];
//    }];
    
    //RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RAC(self, dataSource) = [[self.requestRemoteDataCommand.executionSignals.switchToLatest deliverOnMainThread] map:^id(NSArray *items) {
        return @[JXArrValue(items, [NSArray new])];
    }];
    
//    [[RACObserve(self, requestMode) distinctUntilChanged] subscribeNext:^(NSNumber *requestMode) {
////        if (JXRequestModeLoad == requestMode.integerValue) {
////            self.tableView.tableHeaderView = [[UIView alloc] init];
////        }else {
////            self.tableView.tableHeaderView = self.headerView;
////            self.tableView.tableHeaderView.frame = CGRectMake(0, 0, JXScreenWidth, JXScreenScale(50));
////        }
//    }];
}

#pragma mark - Private methods
#pragma mark setup

- (void)setupVar {
}

- (void)setupData {
}

- (void)setupView {
    self.navigationItem.title = @"搜索结果";
    
    self.view.backgroundColor = JXColorHex(0xF5F5F5);
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.headerView.frame = CGRectMake(0, 0, JXScreenWidth, JXScreenScale(50));
    
    self.tipsLabel.text = JXStrWithFmt(@"以下是\"%@\"的搜索结果", self.searchText);
    
    UINib *nib = [UINib nibWithNibName:@"SearchResultCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[SearchResultCell identifier]];
    self.tableView.tableFooterView = [UIView new];
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
    if (self.fromTJ) {
        return [HRInstance getPageGroupBySocName2WithKeyword:self.searchText socName:self.searchScope page:page rows:JXInstance.pageSize];
    }
    return [HRInstance getPageGroupBySocNameWithKeyword:self.searchText socName:self.searchScope page:page rows:JXInstance.pageSize];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    SearchResultCell *myCell = (SearchResultCell *)cell;
    myCell.data = object;
    @weakify(self)
    [myCell setItemDidPressBlock:^(NSInteger dId) {
        @strongify(self)
        CompResultBrandViewController *vc = [[CompResultBrandViewController alloc] init];
        vc.dId = dId;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [myCell setMoreDidPressBlock:^(NSString *scope) {
        @strongify(self)
        // CompResultAllViewController *vc = [[CompResultAllViewController alloc] init];
        SearchResultAllViewController *vc = [[SearchResultAllViewController alloc] init];
        vc.searchText = self.searchText;
        vc.searchScope = scope;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *items = self.dataSource.firstObject;
    return [SearchResultCell heightWithData:items[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:[SearchResultCell identifier] forIndexPath:indexPath];
}

#pragma mark - Accessor methods
#pragma mark - Action methods
#pragma mark - Notification methods

#pragma mark - Delegate methods
- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    self.headerView.frame = CGRectMake(0, 0, JXScreenWidth, 0);
    self.tipsLabel.hidden = YES;
}

- (void)emptyDataSetWillDisappear:(UIScrollView *)scrollView {
    self.headerView.frame = CGRectMake(0, 0, JXScreenWidth, JXScreenScale(50));
    self.tipsLabel.hidden = NO;
}

#pragma mark UITableViewDataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return JXScreenScale(40);
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return nil;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}


#pragma mark - Public methods
#pragma mark - Class methods


@end
