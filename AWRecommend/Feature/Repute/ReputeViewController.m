//
//  ReputeViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/10/30.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ReputeViewController.h"
#import "ReputeCell.h"

@interface ReputeViewController ()
@property (nonatomic, strong) OrderDetail *od;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) RACCommand *submitCommand;

@end

@implementation ReputeViewController
#pragma mark - Override
#pragma mark init
- (instancetype)init {
    if (self = [super init]) {
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
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

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.submitButton jx_borderWithColor:[UIColor clearColor] width:0.0 radius:8.0];
}

#pragma mark setup
- (void)setupVar {
}

- (void)setupView {
    self.navigationItem.title = @"评价";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:self action:@selector(skipItemPressed:)];
    [self.navigationItem.rightBarButtonItem jx_configWithParam:@{kJXKeyTitleColor: JXColorHex(0x333333), kJXKeyTitleColorDisabled: [UIColor lightTextColor], kJXKeyTitleFont: JXFont(14)}];
    
    UINib *nib = [UINib nibWithNibName:@"ReputeCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[ReputeCell identifier]];
    self.tableView.tableFooterView = [UIView new];
}

- (void)setupNet {
    
}

#pragma mark scroll
- (void)bindViewModel {
    [super bindViewModel];
    
    //RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[requestRemoteDataSignal deliverOnMainThread] map:^id _Nullable(OrderDetail *result) {
        self.od = result;
        return JXArrTable(result.detailData.goods);
    }];
}

- (id)fetchLocalData {
    return nil;
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    return [HRInstance getOrderParticular:self.param];
}

#pragma mark table
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [ReputeCell height];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [self.tableView dequeueReusableCellWithIdentifier:[ReputeCell identifier] forIndexPath:indexPath];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    ReputeCell *myCell = (ReputeCell *)cell;
    myCell.data = object;
}

#pragma mark empty
#pragma mark - Accessor
- (RACCommand *)submitCommand {
    if (!_submitCommand) {
        _submitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance addCommentsForMac:input];
        }];
        
        [_submitCommand.executing subscribe:self.executing];
        [_submitCommand.errors subscribe:self.errors];
        
        @weakify(self)
        [_submitCommand.executionSignals.switchToLatest subscribeNext:^(NSString *str) {
            @strongify(self)
            JXHUDHide();
            [self skipItemPressed:nil];
        }];
    }
    return _submitCommand;
}


#pragma mark - Private
#pragma mark - Public
#pragma mark - Action
- (void)skipItemPressed:(id)sender {
    NSArray *arr = self.navigationController.viewControllers;
    NSMutableArray *ma = [NSMutableArray array];
    [ma addObject:arr.firstObject];
    [ma addObject:arr.lastObject];
    self.navigationController.viewControllers = ma;
    
    NSInteger index = 4;
    NSString *link = JXStrWithFmt(kOrderLink, index);
    AWWebViewController *vc = [[AWWebViewController alloc] initWithURL:JXURLWithStr(link) title:@"我的订单"];
    vc.jxIdentifier = @"我的订单";
    vc.hidesBottomBarWhenPushed = YES;
    vc.navItemColor = JXColorHex(0x333333);
    vc.statusBarStyle = JXStatusBarStyleDefault;
    [self.navigationController pushViewController:vc animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *arr = self.navigationController.viewControllers;
        NSMutableArray *ma = [NSMutableArray array];
        [ma addObject:arr.firstObject];
        [ma addObject:arr.lastObject];
        self.navigationController.viewControllers = ma;
    });
}

- (IBAction)submitButtonDidPressed:(id)sender {
    NSMutableArray *arr = [NSMutableArray array];
    for (OrderDetailDataGoods *g in self.od.detailData.goods) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:JXStrWithDft(g.commentContent, @"") forKey:@"content"];
        [dict setObject:@(g.goodsId) forKey:@"goodId"];
        [dict setObject:JXStrWithDft(g.commentStar, @"") forKey:@"stars"];
        
        NSMutableString *ids = [NSMutableString string];
        for (NSString *str in g.commentTagIds) {
            [ids appendString:str];
            [ids appendString:@","];
        }
        if (0 != ids.length) {
            [ids deleteCharactersInRange:NSMakeRange(ids.length - 1, 1)];
        }
        NSMutableString *names = [NSMutableString string];
        for (NSString *str in g.commentTagNames) {
            [names appendString:str];
            [names appendString:@","];
        }
        if (0 != names.length) {
            [names deleteCharactersInRange:NSMakeRange(names.length - 1, 1)];
        }
        
        
        [dict setObject:ids forKey:@"tagId"];
        [dict setObject:names forKey:@"tagName"];
        [arr addObject:dict];
    }
    NSDictionary *input = @{@"orderId": @(self.od.detailData.orderId),
                            @"list":arr};
    
    [self.submitCommand execute:input];
}

#pragma mark - Notification
#pragma mark - Delegate
#pragma mark - Class

@end
