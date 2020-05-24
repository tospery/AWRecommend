//
//  ScanManualViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/8.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ScanManualViewController.h"
#import "BrandViewController.h"
#import "BrandViewController.h"
#import "ScanResultThirdViewController.h"
#import "ScanResultServerViewController.h"
#import "ScanEmptyViewController.h"

@interface ScanManualViewController ()
@property (nonatomic, weak) IBOutlet UITextField *codeField;
@property (nonatomic, weak) IBOutlet UIButton *queryButton;
@property (nonatomic, strong) RACCommand *resultCommand;

@end

@implementation ScanManualViewController
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
    [self.queryButton jx_borderWithColor:[UIColor clearColor] width:0.0 radius:6.0];
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
    self.navigationItem.title = @"条形码输入";
    
    [SMInstance configButtonStyle2:self.queryButton];
//    UINib *cellNib = [UINib nibWithNibName:@"DhzyDaibanCell" bundle:nil];
//    [self.tableView registerNib:cellNib forCellReuseIdentifier:[DhzyDaibanCell identifier]];
//    self.tableView.tableFooterView = [UIView new];
}

- (void)setupSignal {
    
}

- (void)setupNet {
    
}

#pragma mark fetch
#pragma mark request
#pragma mark assist

//#pragma mark - Table
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
- (RACCommand *)resultCommand {
    if (!_resultCommand) {
        _resultCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance getCodeData:input];
        }];
        [_resultCommand.executing subscribe:self.executing];
        [_resultCommand.errors subscribe:self.errors];
        
        @weakify(self)
        [_resultCommand.executionSignals.switchToLatest subscribeNext:^(ScanResult *result) {
            @strongify(self)
            if (0 == result.resultDataType) {
                ScanResultServerViewController *vc = [[ScanResultServerViewController alloc] init];
                vc.dataSource = result;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (1 == result.resultDataType) {
                ScanResultThirdViewController *vc = [[ScanResultThirdViewController alloc] init];
                vc.dataSource = result;
                // vc.barcode = self.codeField.text;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                ScanResultThird1ViewController *vc = [[ScanResultThird1ViewController alloc] init];
                vc.barcode = self.codeField.text;
                [self.navigationController pushViewController:vc animated:YES];
            }
            [JXDialog hideHUD];
        }];
    }
    return _resultCommand;
}

#pragma mark - Action methods
- (IBAction)queryButtonPressed:(id)sender {
    if (0 == self.codeField.text.length) {
        [JXDialog showPopup:@"请输入条形码"];
        return;
    }
    
    [self.resultCommand execute:self.codeField.text];
    
//    CompResultItem *ds = [CompResultItem new];
//    ds.uid = self.codeField.text;
//    
//    BrandViewController *vc = [[BrandViewController alloc] init];
//    vc.fromScan = YES;
//    vc.dataSource = ds;
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource

#pragma mark - Public methods
#pragma mark - Class methods


@end
