//
//  SearchViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/2/22.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "SearchViewController3.h"
#import "FilterViewController.h"
#import "CompSearchTitleView.h"
#import "SearchResultViewController.h"

@interface SearchViewController3 ()
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *tipsLabel;

@property (nonatomic, strong) CompSearchTitleView *titleView;

@property (nonatomic, strong) RACCommand *suggestCommand;
@property (nonatomic, strong) NSArray *suggests;
@property (nonatomic, weak) IBOutlet UITableView *suggestTableView;
@property (nonatomic, weak) IBOutlet UIView *suggestBgView;
@property (nonatomic, weak) IBOutlet UIView *suggestAlphaView;

@end

@implementation SearchViewController3
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
    
    @weakify(self)
    [RACObserve(self, suggests) subscribeNext:^(NSArray *suggests) {
        @strongify(self)
        if (0 == suggests.count) {
            self.suggestAlphaView.backgroundColor = [UIColor blackColor];
            self.suggestAlphaView.alpha = 0.3;
            
            NSString *searchText = [self.titleView.searchBar.text jx_trimWhitespace];
            if (0 == searchText.length) {
                self.tipsLabel.text = @"您可以输入部分或全部药品名，或者疾病症状进行搜索。例如：“小儿氨酚黄那敏”，“发烧 咳嗽”";
            }else {
                self.tipsLabel.text = JXStrWithFmt(@"无法获得“%@”的相关信息，您可以尝试通过下面疾病标签进行查询", searchText);
            }
        }else {
            self.suggestAlphaView.backgroundColor = [UIColor whiteColor];
            self.suggestAlphaView.alpha = 1.0;
        }
        [self.suggestTableView reloadData];
    }];
    
    RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[[[fetchLocalDataSignal merge:requestRemoteDataSignal] deliverOnMainThread] map:^id(NSArray *items) {
        return JXArrValue(items, [NSArray new]);
    }] map:^id(NSArray *items) {
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
        return JXArrValue(sections, @[[NSArray new]]);
    }];
    
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self)
        FilterViewController *vc = [[FilterViewController alloc] init];
        vc.classify = input.second;
        [self.navigationController pushViewController:vc animated:YES];
        
        return [RACSignal empty];
    }];
}

#pragma mark - Private methods
#pragma mark setup

- (void)setupVar {
}

- (void)setupData {
}

- (void)setupView {
    self.navigationItem.titleView = self.titleView;
    
    self.tipsLabel.textColor = JXColorHex(0x333333);
    self.tipsLabel.font = JXFont(13);
    self.tipsLabel.text = @"您可以输入部分或全部药品名，或者疾病症状进行搜索。例如：“小儿氨酚黄那敏”，“发烧 咳嗽”";
    
    //[self.tableView registerClass:[JXCellDefault class] forCellReuseIdentifier:[JXCellDefault identifier]];
    self.tableView.backgroundColor = JXColorHex(0xF5F5F5);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    //self.tableView.barTintColor = [UIColor redColor];
    
    //self.headerView.frame = CGRectMake(0, 0, JXScreenWidth, JXScreenScale(124));
    
    [self.suggestTableView registerClass:[JXCellDefault class] forCellReuseIdentifier:[JXCellDefault identifier]];
    self.suggestTableView.tableFooterView = [UIView new];
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

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    return [HRInstance queryDrugCategory];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    JXCellDefault *myCell = (JXCellDefault *)cell;
    myCell.textLabel.font = JXFont(13);
    myCell.textLabel.textColor = JXColorHex(0x333333);
    myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    SearchClassify *c = object;
    NSString *text = JXStrWithFmt(@"按%@%@找", c.categoryName, [Util stringWithSearchKind:c.kind]);
    myCell.textLabel.text = text;
    
//    CGRect frame = myCell.textLabel.frame;
//    myCell.textLabel.frame = CGRectMake(40, frame.origin.y, frame.size.width, frame.size.height);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JXCellDefault height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:[JXCellDefault identifier] forIndexPath:indexPath];
}

#pragma mark - Accessor methods
- (CompSearchTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[[NSBundle mainBundle] loadNibNamed:@"CompSearchTitleView" owner:nil options:nil] firstObject];
        _titleView.searchBar.delegate = self;
    }
    return _titleView;
}

- (RACCommand *)suggestCommand {
    if (!_suggestCommand) {
        _suggestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *keyword) {
            return [HRInstance getSearchSuggestWithKeyword:keyword];
        }];
        //[_suggestCommand.executing subscribe:self.executing];
        
        @weakify(self)
        [[_suggestCommand.errors filter:^BOOL(NSError *error) {
            @strongify(self)
            if (JXErrorCodeDataEmpty == error.code) {
                self.suggests = nil;
                return NO;
            }
            return YES;
        }] subscribe:self.errors];
        
        [_suggestCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *items) {
            @strongify(self)
            self.suggests = items;
        }];
    }
    return _suggestCommand;
}

#pragma mark - Action methods
#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    CGRect frame = cell.textLabel.frame;
//    cell.textLabel.frame = CGRectMake(40, frame.origin.y, frame.size.width, frame.size.height);
    // cell.tintColor = [UIColor greenColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.suggestTableView) {
        return 0;
    }
    return JXScreenScale(8);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kJXIdentifierHeaderFooter];
    footer.contentView.backgroundColor = JXColorHex(0xF5F5F5);
    return footer;
}

#pragma mark DZNEmptyDataSetSource
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return JXColorHex(0xF5F5F5);
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return JXScreenScale(62);
}

#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.suggestBgView.hidden = NO;
    [searchBar setShowsCancelButton:YES animated:YES];
    
    UIButton *cancelBtn = [searchBar valueForKey:@"cancelButton"];
    if ([cancelBtn isKindOfClass:[UIButton class]]) {
        cancelBtn.titleLabel.font = JXFont(14.0f);
        [cancelBtn setTitleColor:SMInstance.mainColor forState:UIControlStateNormal];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.suggestBgView.hidden = YES;
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    NSArray *histories = [TMInstance objectForKey:kTMCompHistory];
    
    //    if (![histories containsObject:searchBar.text]) {
    //    }
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:histories];
    [mArr removeObject:searchBar.text];
    
    [mArr insertObject:searchBar.text atIndex:0];
    if (mArr.count > 50) {
        [mArr removeObjectsInRange:NSMakeRange(50, mArr.count - 50)];
    }
    [TMInstance setObject:mArr forKey:kTMCompHistory];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyHistoryDidChange object:mArr];
    
    SearchResultViewController *vc = [[SearchResultViewController alloc] init];
    vc.searchText = searchBar.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *text = [searchText jx_trimWhitespace];
    if (0 == text.length) {
        self.suggests = nil;
        return;
    }
    [self.suggestCommand execute:text];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.suggestTableView) {
        return 1;
    }
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.suggestTableView) {
        return self.suggests.count;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.suggestTableView) {
        JXCellDefault *cell = [tableView dequeueReusableCellWithIdentifier:[JXCellDefault identifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.suggests[indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.suggestTableView) {
        SearchResultViewController *vc = [[SearchResultViewController alloc] init];
        vc.searchText = self.suggests[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Public methods
#pragma mark - Class methods

@end
