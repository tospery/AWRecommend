//
//  SearchViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/13.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "SearchViewController7.h"
#import "SearchCell.h"
#import "ResultViewController.h"
#import "FilterViewController.h"
#import "FilterNameViewController.h"

@interface SearchViewController7 () <UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
//@property (nonatomic, strong) UIBarButtonItem *cancelItem;
@property (nonatomic, strong) VBFPopFlatButton *cancelButton;

@property (nonatomic, strong) RACCommand *searchCommand;
@property (nonatomic, strong) NSArray *results;
@property (nonatomic, weak) IBOutlet UITableView *resultTableView;
@property (nonatomic, weak) IBOutlet UIView *resultBackgroundView;
@property (nonatomic, weak) IBOutlet UIView *resultAlphaView;

@end

@implementation SearchViewController7
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
    
    //RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[requestRemoteDataSignal deliverOnMainThread] map:^id _Nullable(id result) {
        
//        NSMutableArray *sections = [NSMutableArray array];
//        for (NSInteger i = 0; i < items.count; i += 2) {
//            NSMutableArray *rows = [NSMutableArray arrayWithCapacity:2];
//            [rows addObject:items[i]];
//            NSInteger j = i + 1;
//            if (j < items.count) {
//                [rows addObject:items[j]];
//            }
//            [sections addObject:rows];
//        }
//        return JXArrValue(sections, nil);
        
        return JXArrDataSource(result);
    }];
    
    @weakify(self)
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self)

        SearchClassify *cur = input.second;
        NSArray *datas = self.dataSource.firstObject;
        for (SearchClassify *c in datas) {
            if (c == cur) {
                c.selected = !c.selected;
            }else {
                c.selected = NO;
            }
        }
        [self.tableView reloadData];
        
        return [RACSignal empty];
    }];
    
    [RACObserve(self, results) subscribeNext:^(NSArray *results) {
        @strongify(self)
        if (0 == results.count) {
            self.resultAlphaView.backgroundColor = [UIColor blackColor];
            self.resultAlphaView.alpha = 0.3;
            
//            NSString *searchText = [self.searchBar.text jx_trimWhitespace];
//            if (0 == searchText.length) {
//                self.tipsLabel.text = @"您可以输入部分或全部药品名，或者疾病症状进行搜索。例如：“小儿氨酚黄那敏”，“发烧 咳嗽”";
//            }else {
//                self.tipsLabel.text = JXStrWithFmt(@"无法获得“%@”的相关信息，您可以尝试通过下面疾病标签进行查询", searchText);
//            }
        }else {
            self.resultAlphaView.backgroundColor = [UIColor whiteColor];
            self.resultAlphaView.alpha = 1.0;
        }
        [self.resultTableView reloadData];
    }];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
}

- (void)setupData {
}

- (void)setupView {
    self.navigationItem.title = @"搜索->替换搜索框";
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JXScreenScale(240), 34)];
    //titleView.backgroundColor = [UIColor clearColor];
    [titleView addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(titleView);
    }];
    self.navigationItem.titleView = titleView;
    
//    self.cancelButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)
//                                                                   buttonType:(FlatButtonType)buttonCloseType
//                                                                  buttonStyle:buttonPlainStyle
//                                                        animateToInitialState:NO];
//    self.cancelButton.lineThickness = 2.0;
//    self.cancelButton.tintColor = [UIColor whiteColor];
//    [self.cancelButton addTarget:self action:@selector(cancelItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
    self.cancelButton.hidden = YES;
    
//    - (UIBarButtonItem *)cancelItem {
//        if (!_cancelItem) {
//            _cancelItem = [UIBarButtonItem jx_barItemWithType:buttonCloseType color:[UIColor whiteColor] target:self action:@selector(cancelItemPressed:)];
//        }
//        return _cancelItem;
//    }
    
    UINib *nib = [UINib nibWithNibName:@"SearchCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[SearchCell identifier]];
    self.tableView.tableFooterView = [UIView new];
    
    self.headerView.frame = CGRectMake(0, 0, JXScreenWidth, JXScreenScale(10));
    
    [self.resultTableView registerClass:[JXCellDefault class] forCellReuseIdentifier:[JXCellDefault identifier]];
    self.resultTableView.tableFooterView = [UIView new];
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
    return [HRInstance queryDrugCategory];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    SearchCell *myCell = (SearchCell *)cell;
    myCell.data = object;
    @weakify(self)
    myCell.pressBlock = ^(RACTuple *t) {
        @strongify(self)
        SearchClassify *c = t.first;
        NSInteger k = [t.second integerValue];
        c.kind = k + 1;
        if (2 == c.kind) {
            FilterNameViewController *vc = [[FilterNameViewController alloc] init];
            vc.classify = c;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            FilterViewController *vc = [[FilterViewController alloc] init];
            vc.classify = c;
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
}


- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [self.tableView dequeueReusableCellWithIdentifier:[SearchCell identifier] forIndexPath:indexPath];
}

#pragma mark - Accessor methods
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        //_searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"搜药品名称，疾病症状";
        _searchBar.delegate = self;
        //_searchBar.tintColor = [UIColor redColor];
        //_searchBar.barTintColor = [UIColor orangeColor]; // SMInstance.mainColor;
        //_searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.backgroundImage = [UIImage new];
    }
    return _searchBar;
}

- (VBFPopFlatButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)
                                                         buttonType:(FlatButtonType)buttonCloseType
                                                        buttonStyle:buttonPlainStyle
                                              animateToInitialState:NO];
       _cancelButton.lineThickness = 2.0;
        _cancelButton.tintColor = [UIColor whiteColor];
        [_cancelButton addTarget:self action:@selector(cancelItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
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
- (void)cancelItemPressed:(id)sender {
    [self.searchBar resignFirstResponder];
    //self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.resultBackgroundView.hidden = NO;
//    //[searchBar setShowsCancelButton:YES animated:YES];
    self.cancelButton.hidden = NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.resultBackgroundView.hidden = YES;
//    //[searchBar setShowsCancelButton:NO animated:YES];
    self.cancelButton.hidden = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = [self.searchBar.text jx_trimWhitespace];
    if (0 == searchText.length) {
        [JXDialog showPopup:@"搜索内容不能全为空白字符"];
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
    
    ResultViewController *vc = [[ResultViewController alloc] init];
    vc.keyword = searchText;
    [self.navigationController pushViewController:vc animated:YES];
  
    // YJX_TODO 搜索动画
//    ProgressViewController *vc = [[ProgressViewController alloc] init];
//    vc.didOkBlock = ^(NSInteger ok) {
//        if (ok) {
//            NSArray *arr = [TMInstance objectForKey:kTMCompFavorite];
//            NSMutableArray *ma = [NSMutableArray arrayWithArray:arr];
//            [ma removeObject:[(FavoriteCell *)cell data]];
//            [TMInstance setObject:ma forKey:kTMCompFavorite];
//            
//            self.dataSource = @[JXArrValue(ma, [NSArray new])];
//        }
//        [self dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeBounceOut];
//    };
//    
//    
//    [self presentPopupViewController:vc animationType:JXPopupShowTypeNone layout:JXPopupLayoutCenter bgTouch:NO dismissed:^{
//        
//    }];
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
    if (tableView == self.resultTableView) {
        return [JXCellDefault height];
    }
    
    return [SearchCell height];
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
        ResultViewController *vc = [[ResultViewController alloc] init];
        vc.keyword = self.results[indexPath.row];
        vc.isPrecised = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}


#pragma mark - Public methods
#pragma mark - Class methods


@end







