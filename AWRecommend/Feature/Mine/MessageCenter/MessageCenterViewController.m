//
//  MessageCenterViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/8/2.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "MessageCenterViewController.h"

@interface MessageCenterViewController ()
@property (nonatomic, weak) IBOutlet UILabel *promotionLabel;
@property (nonatomic, weak) IBOutlet UILabel *systemLabel;

@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *unreadLabels;

@end

@implementation MessageCenterViewController
#pragma mark - Override
#pragma mark init
- (instancetype)init {
    if (self = [super init]) {
//        self.shouldRequestRemoteDataOnViewDidLoad = YES;
//        self.shouldPullToRefresh = YES;
    }
    return self;
}

#pragma mark view
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVar];
    [self setupView];
    [self setupNet];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    for (UILabel *label in self.unreadLabels) {
        [label jx_circleWithColor:[UIColor clearColor] border:0.0];
    }
}

#pragma mark setup
- (void)setupVar {
}

- (void)setupView {
    self.navigationItem.title = @"消息中心";
    
//    UINib *nib = [UINib nibWithNibName:@"JXCell" bundle:nil];
//    [self.tableView registerNib:nib forCellReuseIdentifier:[JXCell identifier]];
//    self.tableView.tableFooterView = [UIView new];
}

- (void)setupNet {
    
}

#pragma mark scroll
- (void)bindViewModel {
    [super bindViewModel];
    
//    RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
//    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
//    RAC(self, dataSource) = [[[fetchLocalDataSignal merge:requestRemoteDataSignal] deliverOnMainThread] map:^id _Nullable(id result) {
//        return JXArrTable(result);
//    }];
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    return [RACSignal empty]; //  [HRInstance requestDhzyDaibanListWithPage:1];
}

#pragma mark empty
#pragma mark - Accessor
#pragma mark - Private
#pragma mark - Public
#pragma mark - Action
#pragma mark - Notification
#pragma mark - Delegate
#pragma mark - Class

@end
