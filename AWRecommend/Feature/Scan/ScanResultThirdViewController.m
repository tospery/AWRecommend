//
//  ScanResultThirdViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/9.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ScanResultThirdViewController.h"

@interface ScanResultThirdViewController ()
@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *fatcLabel;
@property (nonatomic, weak) IBOutlet UILabel *specLabel;
@property (nonatomic, weak) IBOutlet UILabel *numLabel;

@end

@implementation ScanResultThirdViewController
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

- (void)bindViewModel {
    [super bindViewModel];
    
//    RAC(self, dataSource) = [[[self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData] map:^id(NSArray *items) {
//        return JXArrValue(items, [NSArray new]);
//    }] map:^id(NSArray *items) {
//        return @[JXArrValue(items, [NSArray new])];
//    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.bgView jx_borderWithColor:[UIColor clearColor] width:0.0 radius:4.0];
}

#pragma mark - Private methods
#pragma mark setup

- (void)setupVar {
}

- (void)setupData {
}

- (void)setupView {
    self.navigationItem.title = @"扫码结果";
//    
//    UINib *cellNib = [UINib nibWithNibName:@"DhzyDaibanCell" bundle:nil];
//    [self.tableView registerNib:cellNib forCellReuseIdentifier:[DhzyDaibanCell identifier]];
//    self.tableView.tableFooterView = [UIView new];
}

- (void)setupSignal {
}

- (void)setupNet {
}

- (void)reloadData {
    [super reloadData];
    
    ScanResult *result = self.dataSource;
    [self.iconImageView sd_setImageWithURL:JXURLWithStr(result.drugBrandCodeDto.dbdImgUrl) placeholderImage:JXImageWithName(@"img_default")];
    self.nameLabel.text = JXStrWithFmt(@"【%@】%@", JXStrWithDft(result.drugBrandCodeDto.dbdBrandName, @""), JXStrWithDft(result.drugBrandCodeDto.dbdName, @""));
    self.fatcLabel.text = JXStrWithDft(result.drugBrandCodeDto.dbdFactoryName, @"暂无");
    self.specLabel.text = JXStrWithDft(result.drugBrandCodeDto.dbdSpec, @"暂无");
    self.numLabel.text = JXStrWithDft(result.drugBrandCodeDto.dbdCode, @"暂无");
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
#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource

#pragma mark - Public methods
#pragma mark - Class methods


@end
