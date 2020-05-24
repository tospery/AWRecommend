//
//  ResultViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/4/6.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ResultViewController.h"
#import "ResultHeaderView.h"
#import "ResultCardView.h"
#import "ResultMoreViewController.h"
#import "BrandViewController.h"
#import "MatchViewController.h"
#import "ResultItemCell.h"
#import "ResultOutlineCell.h"
#import "ScanCommitViewController.h"

@interface ResultViewController () <SLExpandableTableViewDatasource, SLExpandableTableViewDelegate>
//@property (nonatomic, strong) ResultHeaderView *headerView;
//@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraint;
//@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet SLExpandableTableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *tipsLabel;

@property (nonatomic, strong) ProgressViewController *progressVC;

@property (nonatomic, weak) IBOutlet UIButton *goButton;
@property (nonatomic, weak) IBOutlet UIView *emptyView;
@property (nonatomic, assign) BOOL isEmpty;

@end

@implementation ResultViewController
#pragma mark - Override methods
- (instancetype)init {
    if (self = [super init]) {
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.isEmpty) {
        [self.navigationController.navigationBar jx_transparet];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.isEmpty) {
        [self.navigationController.navigationBar jx_reset];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //[self.tableView jx_borderWithColor:[UIColor clearColor] width:0.0 radius:4.0];
    
    [SMInstance configButtonStyle1:self.goButton fontSize:16.0f borderRadius:2.0];
}

- (BOOL)catchError:(NSError *)error {
    BOOL result = [super catchError:error];
    self.progressVC.toFinish = YES;
    self.isEmpty = YES;
    return result;
}

- (void)bindViewModel {
    [super bindViewModel];
    
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[requestRemoteDataSignal deliverOnMainThread] map:^id _Nullable(NSArray *result) {
        self.progressVC.toFinish = YES;
        //        NSMutableArray *ar = [NSMutableArray arrayWithArray:result];
        //        [ar addObjectsFromArray:result];
        //        return ar;
        
        NSMutableArray *arr = [NSMutableArray array];
        for (CompResultList *l in result) {
            if (l.datas.count != 0) {
                [arr addObject:l];
            }
        }
        
        if (0 == arr.count) {
            self.isEmpty = YES;
        }
        
        return arr;
    }];
}

#pragma mark - Private methods
#pragma mark setup

- (void)setupVar {
}

- (void)setupData {
}

- (void)setupView {
    self.navigationItem.title = @"搜索结果";
    [self.navigationController.navigationBar jx_transparet];
    
    self.tipsLabel.font = JXFont(12);
    self.tipsLabel.text = JXStrWithFmt(@"以下是“%@”的搜索结果", self.keyword);
    
    [self jx_presentPopupViewController:self.progressVC animationType:JXPopupShowTypeNone layout:JXPopupLayoutCenter bgTouch:NO dismissed:^{
        
    }];
    
    //    self.scrollView.parallaxHeader.view = self.headerView;
    //    self.scrollView.parallaxHeader.height = self.headerView.jx_height;
    //    self.scrollView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    //    self.scrollView.parallaxHeader.minimumHeight = self.headerView.jx_height;
    //
    //    self.heightConstraint.constant += self.headerView.jx_height * -1;
    //
    //    [self.scrollView bringSubviewToFront:self.bgView];
    
    UINib *nib = [UINib nibWithNibName:@"ResultOutlineCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[ResultOutlineCell identifier]];
    nib = [UINib nibWithNibName:@"ResultItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[ResultItemCell identifier]];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kJXIdentifierHeaderFooter];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)setupSignal {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
#pragma mark assist

#pragma mark - Table
- (void)reloadData {
    [super reloadData];
    [self.tableView reloadData];
    
//    NSArray *sections = self.dataSource;
//    if (sections.count >= 1) {
//        [self.tableView expandSection:0 animated:YES];
//    }
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    if (self.symptomRequest) {
        return [HRInstance searchThroughDiseases:[self.symptomRequest mj_JSONObject]];
    }
    
    if (self.isPrecised) {
        return [HRInstance getPageGroupBySocName2WithKeyword:self.keyword socName:self.scope page:page rows:JXInstance.pageSize natureType:nil];
    }
    return [HRInstance getPageGroupBySocNameWithKeyword:self.keyword socName:self.scope page:page rows:JXInstance.pageSize natureType:nil];
}

#pragma mark - Accessor methods
//- (ResultHeaderView *)headerView {
//    if (!_headerView) {
//        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"ResultHeaderView" owner:nil options:nil] firstObject];
////        @weakify(self)
////        _headerView.didSearchBlock = ^() {
////            @strongify(self)
////            // CompSearchViewController *vc = [[CompSearchViewController alloc] init];
////            SearchViewController *vc = [[SearchViewController alloc] init];
////            //TestViewController *vc = [[TestViewController alloc] init];
////            vc.hidesBottomBarWhenPushed = YES;
////            [self.navigationController pushViewController:vc animated:YES];
////        };
////        _headerView.didScanBlock = ^() {
////            @strongify(self)
////            ScanViewController *vc = [[ScanViewController alloc] init];
////            vc.hidesBottomBarWhenPushed = YES;
////            [self.navigationController pushViewController:vc animated:YES];
////        };
//    }
//    return _headerView;
//}

- (ProgressViewController *)progressVC {
    if (!_progressVC) {
        _progressVC = [[ProgressViewController alloc] init];
        @weakify(self)
        _progressVC.finishBlock = ^() {
            @strongify(self)
            if (self.isEmpty) {
                [self.navigationController.navigationBar jx_reset];
                self.emptyView.hidden = NO;
                self.navigationItem.title = @"搜索结果";
            }
            
            [self jx_dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeNone];
            
            NSArray *sections = self.dataSource;
            if (sections.count >= 1) {
                [self.tableView expandSection:0 animated:YES];
            }
        };
        _progressVC.backBlock = ^() {
            @strongify(self)
            [self jx_dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeNone];
            [self.navigationController popViewControllerAnimated:NO];
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                [self dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeNone];
            //            });
        };
    }
    return _progressVC;
}

#pragma mark - Action methods
- (IBAction)goButtonPressed:(id)sender {
    ScanCommitViewController *vc = [[ScanCommitViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Notification methods

#pragma mark - Delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (NSInteger)[(NSArray *)self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = self.dataSource;
    CompResultList *list = sections[section];
    NSInteger count = list.datas.count;
    return count >= 6 ? 7 : (count + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    static NSString *CellIdentifier = @"Cell";
    //
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //    }
    //
    //    NSArray *sections = self.dataSource;
    //    CompResultList *list = sections[indexPath.section];
    //    CompResultItem *item = list.datas[indexPath.row];
    //    cell.textLabel.text = item.drugName;
    
    ResultItemCell *cell = [tableView dequeueReusableCellWithIdentifier:[ResultItemCell identifier] forIndexPath:indexPath];
    
    NSArray *sections = self.dataSource;
    CompResultList *list = sections[indexPath.section];
    CompResultItem *item = list.datas[indexPath.row - 1];
    item.cellIndex = indexPath.row;
    item.cellTotal = list.totalSize;
    cell.data = item;
    
    [cell setMatchBlock:^(NSInteger match) {
        MatchViewController *vc = [[MatchViewController alloc] init];
        vc.closeBlock = ^() {
            [self jx_dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeBounceOut];
        };
        vc.matchDegree = match;
        [self jx_presentPopupViewController:vc animationType:JXPopupShowTypeBounceIn layout:JXPopupLayoutCenter bgTouch:YES dismissed:^{
            
        }];
    }];
    
    return cell;
}

#pragma mark - SLExpandableTableViewDatasource
- (BOOL)tableView:(SLExpandableTableView *)tableView canExpandSection:(NSInteger)section {
    return YES;
}

- (BOOL)tableView:(SLExpandableTableView *)tableView needsToDownloadDataForExpandableSection:(NSInteger)section {
    return NO; // ![self.expandableSections containsIndex:section];
}

- (UITableViewCell<UIExpandingTableViewCell> *)tableView:(SLExpandableTableView *)tableView expandingCellForSection:(NSInteger)section {
    
    ResultOutlineCell *cell = [tableView dequeueReusableCellWithIdentifier:[ResultOutlineCell identifier]];
    
    NSArray *sections = self.dataSource;
    CompResultList *list = sections[section];
    cell.data = list;
    
    
    if (self.symptomRequest == nil) {
        @weakify(self)
        [cell setZyBlock:^(RACTuple *t) {
            @strongify(self)
            ResultMoreViewController *vc = [[ResultMoreViewController alloc] init];
            vc.keyword = t.first;
            vc.scope = t.second;
            vc.type = @"中成药";
            vc.isPrecised = self.isPrecised;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [cell setXyBlock:^(RACTuple *t) {
            @strongify(self)
            ResultMoreViewController *vc = [[ResultMoreViewController alloc] init];
            vc.keyword = t.first;
            vc.scope = t.second;
            vc.type = @"西药";
            vc.isPrecised = self.isPrecised;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }

    cell.isPrecised = self.isPrecised;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSArray *sections = self.dataSource;
    CompResultList *list = sections[section];
    CompResultItem *item = list.datas[row - 1];
    
    if (6 == row) {
        ResultMoreViewController *vc = [[ResultMoreViewController alloc] init];
        vc.keyword = list.keyword;
        vc.scope = list.groupValue;
        vc.isPrecised = self.isPrecised;
        vc.symptomRequest = self.symptomRequest;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        //[gUser checkLoginWithFinish:^{
            BrandViewController *vc = [[BrandViewController alloc] init];
            vc.dataSource = item;
            [self.navigationController pushViewController:vc animated:YES];
        //} error:nil];
    }
}

#pragma mark - SLExpandableTableViewDelegate
- (void)tableView:(SLExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section {
    [tableView expandSection:section animated:YES];
}

//
//- (void)tableView:(SLExpandableTableView *)tableView didCollapseSection:(NSUInteger)section animated:(BOOL)animated
//{
//    [self.expandableSections removeIndex:section];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (0 == row) {
        return [ResultOutlineCell height];
    }
    return [ResultItemCell height];
}

- (void)tableView:(SLExpandableTableView *)tableView willExpandSection:(NSUInteger)section animated:(BOOL)animated {
    NSArray *sections = self.dataSource;
    for (NSInteger i = 0; i < sections.count; ++i) {
        if (i != section) {
            [tableView collapseSection:i animated:YES];
        }
    }
}

- (void)tableView:(SLExpandableTableView *)tableView didExpandSection:(NSUInteger)section animated:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    ResultOutlineCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell configHide:NO];
    
    NSArray *sections = self.dataSource;
    CompResultList *list = sections[section];
    list.cellShow = YES;
}

- (void)tableView:(SLExpandableTableView *)tableView didCollapseSection:(NSUInteger)section animated:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    ResultOutlineCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell configHide:YES];
    
    NSArray *sections = self.dataSource;
    CompResultList *list = sections[section];
    list.cellShow = NO;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 30;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kJXIdentifierHeaderFooter];
//    footer.contentView.backgroundColor = [UIColor redColor];
//    return footer;
//}

#pragma mark - Public methods
#pragma mark - Class methods


@end
