//
//  NiceViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/14.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "NiceViewController.h"
#import "NiceCell.h"
#import "NiceDetailViewController.h"

@interface NiceViewController ()

@end

@implementation NiceViewController
#pragma mark - Override
#pragma mark init
- (instancetype)init {
    if (self = [super init]) {
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
        self.shouldPullToRefresh = YES;
        self.shouldInfiniteScrolling = YES;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.navigationController.navigationBar jx_configWithParam:@{kJXKeyTranslucent: @NO, kJXKeyBarTintColor: [UIColor whiteColor], kJXKeyTitleColor: JXColorHex(0x333333), kJXKeyTitleFont: JXFont(16.0)}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self.navigationController.navigationBar jx_configWithParam:@{kJXKeyTranslucent: @NO, kJXKeyBarTintColor: SMInstance.mainColor, kJXKeyTitleColor: SMInstance.navItemColor, kJXKeyTitleFont: JXFont(16.0)}];
}

#pragma mark setup
- (void)setupVar {
}

- (void)setupView {
    self.navigationItem.title = @"好价";
    
    // [UINavigationBar jx_appearanceWithParam:@{kJXKeyTranslucent: @NO, kJXKeyBarTintColor: SMInstance.mainColor, kJXKeyTitleColor: SMInstance.navItemColor, kJXKeyTitleFont: [UIFont fontWithName:@"NotoSansHans-DemiLight" size:17.0]}];
    //[self.navigationController.navigationBar jx_configWithParam:@{kJXKeyTranslucent: @NO, kJXKeyBarTintColor: [UIColor whiteColor], kJXKeyTitleColor: JXColorHex(0x333333), kJXKeyTitleFont: JXFont(16.0)}];
    
    UINib *nib = [UINib nibWithNibName:@"NiceCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[NiceCell identifier]];
    //self.tableView.tableFooterView = [UIView new];
}

- (void)setupNet {
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark scroll
- (void)bindViewModel {
    [super bindViewModel];
    
    //RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    @weakify(self)
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[requestRemoteDataSignal deliverOnMainThread] map:^id _Nullable(NiceList *list) {
//        NSMutableArray *items = [NSMutableArray arrayWithArray:self.dataSource];
//        [items addObjectsFromArray:list.datas];
        
        @strongify(self)
        NSArray *items = [self handleData:list.datas];
        if (list.totalSize == 0) {
            self.error = [NSError jx_errorWithCode:JXErrorCodeDataEmpty];
        }
        
        if (list.totalSize <= items.count) {
            self.isNoMoreData = YES;
        }
        
        return JXArrTable(items);
    }];
    
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self)
        Nice *n = input.second;
        
        NiceDetailViewController *vc = [[NiceDetailViewController alloc] init];
        //vc.navItemColor = JXColorHex(0x333333);
        vc.niceID = n.jxID.integerValue;
        vc.hidesBottomBarWhenPushed = YES;
        vc.shareIcon = n.tileImage;
        [self.navigationController pushViewController:vc animated:YES];
        
//        [gUser checkLoginWithFinish:^(BOOL isRelogin) {
//            NiceDetailViewController *vc = [[NiceDetailViewController alloc] init];
//            vc.navItemColor = JXColorHex(0x333333);
//            vc.niceID = n.jxID.integerValue;
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//        } error:nil];
        
        return [RACSignal empty];
    }];
}

- (id)fetchLocalData {
    return nil;
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    return [HRInstance showArticleListWithPage:page];
}

- (void)setupRefresh {
    RefreshGifHeader *header = [RefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(triggerRefresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
}

#pragma mark table
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [NiceCell height];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [self.tableView dequeueReusableCellWithIdentifier:[NiceCell identifier] forIndexPath:indexPath];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    NiceCell *myCell = (NiceCell *)cell;
    myCell.data = object;
    
    myCell.separatorImageView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Accessor
- (NSArray *)handleData:(NSArray *)remoteItems {
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.dataSource.firstObject];
    
    if (JXRequestModeRefresh == self.requestMode) {
        Nice *n = remoteItems.lastObject;
        NSMutableArray *olds = [NSMutableArray arrayWithCapacity:JXInstance.pageSize];
        for (Nice *obj in items) {
            if (obj.jxID.integerValue >= n.jxID.integerValue) {
                [olds addObject:obj];
            }else {
                break;
            }
        }
        [items removeObjectsInArray:olds];
        [items insertObjects:remoteItems atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, remoteItems.count)]];
    }else {
        [items addObjectsFromArray:remoteItems];
    }
    
    return items;
}

#pragma mark - Private
#pragma mark - Public
#pragma mark - Action
#pragma mark - Notification
#pragma mark - Delegate
#pragma mark - Class



@end
