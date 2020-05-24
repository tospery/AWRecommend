//
//  CompResultBrandViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/9.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "CompResultBrandViewController.h"
#import "CompResultBrandDescCell.h"
#import "CompResultBrandProductCell.h"
#import "CompResultBrandDescHeader.h"
#import "CompResultBrandProductHeader.h"
#import "CompResultDetailViewController.h"

@interface CompResultBrandViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) RACCommand *infoCommand;
@property (nonatomic, strong) CompResultItem *item;

@end

@implementation CompResultBrandViewController
#pragma mark - Override methods
//- (instancetype)init {
//    if (self = [super init]) {
//        self.shouldRequestRemoteDataOnViewDidLoad = YES;
//        self.shouldPullToRefresh = YES;
//    }
//    return self;
//}

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
    
    
    [self.infoCommand execute:@(self.dId)];
}

#pragma mark - Private methods
#pragma mark setup

- (void)setupVar {
    
}

- (void)setupData {
}

- (void)setupView {
    self.navigationItem.title = @"药品推荐";
    
    //    UINib *cellNib = [UINib nibWithNibName:@"DhzyDaibanCell" bundle:nil];
    //    [self.tableView registerNib:cellNib forCellReuseIdentifier:[DhzyDaibanCell identifier]];
    //    self.tableView.tableFooterView = [UIView new];
    
    UINib *nib = [UINib nibWithNibName:@"CompResultBrandDescCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[CompResultBrandDescCell identifier]];
    nib = [UINib nibWithNibName:@"CompResultBrandProductCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[CompResultBrandProductCell identifier]];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kJXIdentifierHeaderFooter];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorColor = JXColorHex(0xe2e2e2);
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
- (RACCommand *)infoCommand {
    if (!_infoCommand) {
        _infoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *drugId) {
            return [HRInstance drugDescriptionWithDrugId:drugId.integerValue/*5845*/]; // YJX_TODO
        }];
        [_infoCommand.executing subscribe:self.executing];
        [_infoCommand.errors subscribe:self.errors];
        
        @weakify(self)
        [_infoCommand.executionSignals.switchToLatest subscribeNext:^(CompResultItem *item) {
            @strongify(self)
            self.item = item;
            //self.item.dSafety = 0;
            //self.item.dStability = 0;
            for (CompResultBrand *b in self.item.drugBandDtoList) {
                b.drugName = self.item.drugName;
            }
            [self.tableView reloadData];
            JXHUDHide();
        }];
    }
    return _infoCommand;
}


#pragma mark - Action methods
#pragma mark - Notification methods

#pragma mark - Delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return 3;
    }
    
    return self.item.drugBandDtoList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        NSString *title = @"适应症";
        NSString *str = self.item.indication;
        if (1 == indexPath.row) {
            title = @"药师指导";
            str = self.item.pharmacistGuide;
        }else if (2 == indexPath.row) {
            title = @"药品成分";
            str = self.item.ingredient;
        }
        return [CompResultBrandDescCell heightWithData:RACTuplePack(self.item, title, str)];
    }
    
    return [CompResultBrandProductCell heightWithData:self.item.drugBandDtoList[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        CompResultBrandDescCell *cell = [tableView dequeueReusableCellWithIdentifier:[CompResultBrandDescCell identifier]];
        NSString *title = @"适应症";
        NSString *str = self.item.indication;
        if (1 == indexPath.row) {
            title = @"药师指导";
            str = self.item.pharmacistGuide;
        }else if (2 == indexPath.row) {
            title = @"药品成分";
            str = self.item.ingredient;
        }
        cell.data = RACTuplePack(self.item, title, str);
        return cell;
    }
    
    CompResultBrandProductCell *cell = [tableView dequeueReusableCellWithIdentifier:[CompResultBrandProductCell identifier]];
    cell.data = self.item.drugBandDtoList[indexPath.row];
    cell.safeDidPressBlock = ^(CompResultBrand *b) {
        CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"安全提示" message:JXStrWithDft(b.safety, @"") cancelButtonTitle:@"我知道了"];
        [alertView show];
    };
    
    NSArray *items = self.item.drugBandDtoList;
    if ((items.count - 1) == indexPath.row) {
        //cell.separatorInset = UIEdgeInsetsZero;
        cell.leadingConstraint.constant = 0;
    }else {
        //cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        cell.leadingConstraint.constant = 20;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            if (self.item.cantExpansion1) {
                return;
            }
            self.item.isExpansion1 = !self.item.isExpansion1;
        }else if (1 == indexPath.row) {
            if (self.item.cantExpansion2) {
                return;
            }
            self.item.isExpansion2 = !self.item.isExpansion2;
        }else if (2 == indexPath.row) {
            if (self.item.cantExpansion3) {
                return;
            }
            self.item.isExpansion3 = !self.item.isExpansion3;
        }
        [self.tableView reloadData];
    }else {
        CompResultDetailViewController *vc = [[CompResultDetailViewController alloc] init];
        vc.brand = self.item.drugBandDtoList[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        CGFloat height = JXScreenScale(50);
        NSString *safe = [Util securityWithValue:self.item.dSafety];
        if (0 != safe.length) {
            height += 10;
        }
        NSString *stab = [Util stabilityWithValue:self.item.dStability];
        if (0 != stab.length) {
            height += 10;
        }
        return height;
    }
    return JXScreenScale(50);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kJXIdentifierHeaderFooter];
    if (0 == section) {
        CompResultBrandDescHeader *coverView1 = [headerView viewWithTag:101];
        CompResultBrandProductHeader *coverView2 = [headerView viewWithTag:102];
        coverView1.hidden = NO;
        coverView2.hidden = YES;
        if (!coverView1) {
            coverView1 = [[[NSBundle mainBundle] loadNibNamed:@"CompResultBrandDescHeader" owner:nil options:nil] firstObject];
            coverView1.tag = 101;
            coverView1.item = self.item;
            [headerView addSubview:coverView1];
            [coverView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(headerView);
            }];
        }
        coverView1.item = self.item;
    }else {
        CompResultBrandDescHeader *coverView1 = [headerView viewWithTag:101];
        CompResultBrandProductHeader *coverView2 = [headerView viewWithTag:102];
        coverView1.hidden = YES;
        coverView2.hidden = NO;
        if (!coverView2) {
            coverView2 = [[[NSBundle mainBundle] loadNibNamed:@"CompResultBrandProductHeader" owner:nil options:nil] firstObject];
            coverView2.tag = 102;
            [headerView addSubview:coverView2];
            [coverView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(headerView);
            }];
        }
    }
    return headerView;
}


#pragma mark - SLExpandableTableViewDatasource
//- (BOOL)tableView:(SLExpandableTableView *)tableView canExpandSection:(NSInteger)section {
//    return YES;
//}
//
//- (BOOL)tableView:(SLExpandableTableView *)tableView needsToDownloadDataForExpandableSection:(NSInteger)section {
//    return NO; // ![self.expandableSections containsIndex:section];
//}
//
//- (UITableViewCell<UIExpandingTableViewCell> *)tableView:(SLExpandableTableView *)tableView expandingCellForSection:(NSInteger)section {
//    //    static NSString *CellIdentifier = @"SLExpandableTableViewControllerHeaderCell";
//    //    YjqxRwbkCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    //    if (!cell) {
//    //        cell = [[YjqxRwbkCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//    //    }
//    //
//    //    // cell.textLabel.text = [NSString stringWithFormat:@"Section %ld", (long)section];
//    //    cell.textLabel.text = JXStrWithFmt(@"%ld 工单类型", (long)section);
//    //
//    //    return cell;
//    CompResultBrandOutlineCell *cell = [tableView dequeueReusableCellWithIdentifier:[CompResultBrandOutlineCell identifier]];
//
////    DiaoduGroup *group = self.dp.rows[tableView.tag];
////    NSArray *items = group.team_list;
////    cell.data = items[section];
//
//    return cell;
//}
//
//#pragma mark - SLExpandableTableViewDelegate
//- (void)tableView:(SLExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section {
//    [tableView expandSection:section animated:YES];
//}
////
////- (void)tableView:(SLExpandableTableView *)tableView didCollapseSection:(NSUInteger)section animated:(BOOL)animated
////{
////    [self.expandableSections removeIndex:section];
////}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger row = indexPath.row % 2;
//    return row ? [CompResultBrandDetailCell height] : [CompResultBrandOutlineCell height];
//}
//
//#pragma mark - UITableViewDataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
////    DiaoduGroup *group = self.dp.rows[tableView.tag];
////    NSArray *items = group.team_list;
////
////    return items.count;
//    return 3;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 2;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    //    static NSString *CellIdentifier = @"Cell";
//
//    CompResultBrandDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[CompResultBrandDetailCell identifier]];
//    //    if (cell == nil) {
//    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    //    }
//
//    //    NSArray *dataArray = self.sectionsArray[indexPath.section];
//    //    cell.textLabel.text = dataArray[indexPath.row - 1];
//    //cell.textLabel.text = @"aaa";
//
////    DiaoduGroup *group = self.dp.rows[tableView.tag];
////    NSArray *items = group.team_list;
////    cell.data = items[indexPath.section];
//
//    return cell;
//}
//
////- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
////    return YES;
////}
////
////- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
////    if (indexPath.row == 0) {
////        [self.sectionsArray removeObjectAtIndex:indexPath.section];
////        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
////    }
////}
//
//#pragma mark - UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    //    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    //    NSInteger section = indexPath.section;
//    //    YjqxZhddViewController *vc = [[YjqxZhddViewController alloc] init];
//    //    vc.rwkb = self.items[section];
//    //    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark - Public methods
#pragma mark - Class methods


@end
