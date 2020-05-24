//
//  SearchViewController2.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/2/22.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "SearchViewController2.h"
#import "FilterViewController.h"
#import "ResultViewController.h"
#import "SearchResultViewController.h"

@interface SearchViewController2 () <UISearchBarDelegate>
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *tipsLabel;
@property (nonatomic, weak) IBOutlet UILabel *classifyLabel;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) RACCommand *searchCommand;
@property (nonatomic, strong) NSArray *results;
@property (nonatomic, weak) IBOutlet UITableView *resultTableView;
@property (nonatomic, weak) IBOutlet UIView *resultBackgroundView;
@property (nonatomic, weak) IBOutlet UIView *resultAlphaView;

@property (nonatomic, strong) UIBarButtonItem *cancelItem;

@end

@implementation SearchViewController2
#pragma mark - Override methods
- (instancetype)init {
    if (self = [super init]) {
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
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
    
    RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[[fetchLocalDataSignal merge:requestRemoteDataSignal] deliverOnMainThread] map:^id(NSArray *items) {
        NSMutableArray *sections = [NSMutableArray array];
        for (NSInteger i = 0; i < items.count; i += 2) {
            NSMutableArray *rows = [NSMutableArray arrayWithCapacity:2];
            [rows addObject:items[i]];
            NSInteger j = i + 1;
            if (j < items.count) {
                [rows addObject:items[j]];
            }
            [sections addObject:rows];
        }
        return JXArrValue(sections, nil);
    }];
    
    @weakify(self)
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self)
        FilterViewController *vc = [[FilterViewController alloc] init];
        vc.classify = input.second;
        [self.navigationController pushViewController:vc animated:YES];
        
        return [RACSignal empty];
    }];
    
    [RACObserve(self, results) subscribeNext:^(NSArray *results) {
        @strongify(self)
        if (0 == results.count) {
            self.resultAlphaView.backgroundColor = [UIColor blackColor];
            self.resultAlphaView.alpha = 0.3;
            
            NSString *searchText = [self.searchBar.text jx_trimWhitespace];
            if (0 == searchText.length) {
                self.tipsLabel.text = @"您可以输入部分或全部药品名，或者疾病症状进行搜索。例如：“小儿氨酚黄那敏”，“发烧 咳嗽”";
            }else {
                self.tipsLabel.text = JXStrWithFmt(@"无法获得“%@”的相关信息，您可以尝试通过下面疾病标签进行查询", searchText);
            }
        }else {
            self.resultAlphaView.backgroundColor = [UIColor whiteColor];
            self.resultAlphaView.alpha = 1.0;
        }
        [self.resultTableView reloadData];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
}

- (void)setupData {
}

- (void)setupView {
    self.navigationItem.title = @"分类搜索";
    
    self.tipsLabel.textColor = JXColorHex(0x333333);
    self.tipsLabel.font = JXFont(14);
    self.tipsLabel.text = @"您可以输入部分或全部药品名，或者疾病症状进行搜索。例如：“小儿氨酚黄那敏”，“发烧 咳嗽”";
    
    self.classifyLabel.font = [UIFont jx_deviceBoldFontOfSize:14];
    
    self.tableView.backgroundColor = JXColorHex(0xF5F5F5);
    //self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    
    [self.resultTableView registerClass:[JXCellDefault class] forCellReuseIdentifier:[JXCellDefault identifier]];
    self.resultTableView.tableFooterView = [UIView new];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 30)];
    //titleView.backgroundColor = [UIColor clearColor];
    [titleView addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(titleView);
    }];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.leftBarButtonItem = JXCreateBackItem(self, @selector(returnItemPressed:), [UIColor whiteColor]);
}

- (void)setupSignal {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
#pragma mark assist
- (UIBarButtonItem *)cancelItem {
    if (!_cancelItem) {
        _cancelItem = [UIBarButtonItem jx_barItemWithType:buttonCloseType color:[UIColor whiteColor] target:self action:@selector(cancelItemPressed:)];
    }
    return _cancelItem;
}

- (void)cancelItemPressed:(id)sender {
    [self.searchBar resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - Table
- (id)fetchLocalData {
    return nil;
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    return [HRInstance queryDrugCategory];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    JXCell *myCell = (JXCell *)cell;
    myCell.textLabel.font = JXFont(14);
    myCell.textLabel.textColor = JXColorHex(0x333333);
    myCell.accessoryType = UITableViewCellAccessoryNone;
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!myCell.accessoryView) {
        UIImage *image = JXAdaptImage(JXImageWithName(@"ic_arrow_right"));
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        myCell.accessoryView = imageView;
    }
    
    UIImageView *imageView = [myCell viewWithTag:101];
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = JXColorHex(0xe7e7e7);
        [myCell addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(myCell);
            make.trailing.equalTo(myCell);
            make.bottom.equalTo(myCell);
            make.height.equalTo(@1);
        }];
    }
    
    SearchClassify *c = object;
    NSString *text = JXStrWithFmt(@"按%@%@找", c.categoryName, [Util stringWithSearchKind:c.kind]);
    myCell.textLabel.text = text;
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:[JXCell identifier] forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.resultTableView) {
        return;
    }
}

#pragma mark - Accessor methods
//- (void)configureSearchController {
//    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    _searchController.searchResultsUpdater = self;
//    _searchController.searchBar.placeholder = @"";
//    _searchController.dimsBackgroundDuringPresentation = NO;
//    _searchController.searchBar.delegate = self;
//    [_searchController.searchBar sizeToFit];
//    self.tableView.tableHeaderView = _searchController.searchBar;
//}


//- (UISearchController *)searchController {
//    if (!_searchController) {
//        ResultViewController *vc = [[ResultViewController alloc] init];
//        _searchController = [[UISearchController alloc] initWithSearchResultsController:vc];
//        _searchController.searchResultsUpdater = self;
//        _searchController.searchBar.delegate = self;
//        _searchController.dimsBackgroundDuringPresentation = NO;
//    }
//    return _searchController;
//}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        //_searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"搜索内容";
        _searchBar.delegate = self;
        //_searchBar.tintColor = [UIColor redColor];
        //_searchBar.barTintColor = [UIColor orangeColor]; // SMInstance.mainColor;
        //_searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.backgroundImage = [UIImage new];
    }
    return _searchBar;
}

- (RACCommand *)searchCommand {
    if (!_searchCommand) {
        _searchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *keyword) {
            return [HRInstance getSearchSuggestWithKeyword:keyword];
        }];
        //[_suggestCommand.executing subscribe:self.executing];
        
        @weakify(self)
        [[_searchCommand.errors filter:^BOOL(NSError *error) {
            @strongify(self)
            if (JXErrorCodeDataEmpty == error.code) {
                self.results = nil;
                return NO;
            }
            return YES;
        }] subscribe:self.errors];
        
        [_searchCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *items) {
            @strongify(self)
            self.results = items;
        }];
    }
    return _searchCommand;
}


#pragma mark - Action methods
#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.resultTableView) {
        return 0;
    }
    
    return JXScreenScale(8);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView == self.resultTableView) {
        return nil;
    }
    
    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kJXIdentifierHeaderFooter];
    footer.contentView.backgroundColor = JXColorHex(0xF5F5F5);
    return footer;
}

#pragma mark DZNEmptyDataSetSource
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return JXColorHex(0xF5F5F5);
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.resultBackgroundView.hidden = NO;
    //[searchBar setShowsCancelButton:YES animated:YES];
    self.navigationItem.rightBarButtonItem = self.cancelItem;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.resultBackgroundView.hidden = YES;
    //[searchBar setShowsCancelButton:NO animated:YES];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = [self.searchBar.text jx_trimWhitespace];
    if (0 == searchText.length) {
        JXHUDInfo(@"搜索内容不能全为空白字符", YES);
        return;
    }
    
    [searchBar resignFirstResponder];
    
    NSArray *histories = [TMInstance objectForKey:kTMCompHistory];
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:histories];
    [mArr removeObject:searchText];
    
    [mArr insertObject:searchText atIndex:0];
    if (mArr.count > 50) {
        [mArr removeObjectsInRange:NSMakeRange(50, mArr.count - 50)];
    }
    [TMInstance setObject:mArr forKey:kTMCompHistory];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyHistoryDidChange object:mArr];
    
    SearchResultViewController *vc = [[SearchResultViewController alloc] init];
    vc.searchText = searchText;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *text = [searchText jx_trimWhitespace];
    if (0 == text.length) {
        self.results = nil;
        return;
    }
    [self.searchCommand execute:text];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.resultTableView) {
        return 1;
    }
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.resultTableView) {
        return self.results.count;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JXCellDefault height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.resultTableView) {
        JXCellDefault *cell = [tableView dequeueReusableCellWithIdentifier:[JXCellDefault identifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.results[indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.resultTableView) {
        SearchResultViewController *vc = [[SearchResultViewController alloc] init];
        vc.searchText = self.results[indexPath.row];
        vc.fromTJ = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Public methods
#pragma mark - Class methods


@end






