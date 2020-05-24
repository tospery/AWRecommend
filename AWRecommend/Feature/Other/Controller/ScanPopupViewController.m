//
//  ScanPopupViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/2.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ScanPopupViewController.h"

@interface ScanPopupViewController ()

@end

@implementation ScanPopupViewController
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view jx_borderWithColor:[UIColor clearColor] width:0.0 radius:6.0];
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
//    self.navigationItem.title = @"待办任务";
//    
//    UINib *cellNib = [UINib nibWithNibName:@"DhzyDaibanCell" bundle:nil];
//    [self.tableView registerNib:cellNib forCellReuseIdentifier:[DhzyDaibanCell identifier]];
//    self.tableView.tableFooterView = [UIView new];
    
    self.view.frame = CGRectMake(0, 0, JXScreenScale(220), JXScreenScale(200));
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
- (IBAction)closeButtonPressed:(id)sender {
    if (self.didCloseBlock) {
        self.didCloseBlock();
    }
}

- (IBAction)skipButtonPressed:(id)sender {
    if (self.didSkipBlock) {
        self.didSkipBlock();
    }
}

- (IBAction)loginButtonPressed:(id)sender {
    if (self.didLoginBlock) {
        self.didLoginBlock();
    }
}

#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource

#pragma mark - Public methods
#pragma mark - Class methods


@end





