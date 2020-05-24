//
//  CompSearchViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "CompSearchViewController.h"
#import "CompSearchTitleView.h"
#import "SearchResultViewController.h"
#import "CompClassifyViewController.h"
#import "FilterViewController.h"

@interface CompSearchViewController () // <UMSocialShareMenuViewDelegate>
@property (nonatomic, strong) CompSearchTitleView *titleView;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *tipsLabel;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *typeLabels;
@property (nonatomic, strong) RACCommand *suggestCommand;
@property (nonatomic, strong) NSArray *suggests;
@property (nonatomic, weak) IBOutlet UITableView *suggestTableView;
@property (nonatomic, weak) IBOutlet UIView *suggestBgView;
@property (nonatomic, weak) IBOutlet UIView *suggestAlphaView;

@end

@implementation CompSearchViewController
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
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
}

- (void)setupData {
}

- (void)setupView {
    //UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 34)];
    self.view.backgroundColor = JXColorHex(0xF4F5F6);
    self.navigationItem.titleView = self.titleView;
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(0, 0, 16, 1);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:label];
    
    //self.titleView.center = self.titleView.superview.center;
    
    //    UINib *cellNib = [UINib nibWithNibName:@"DhzyDaibanCell" bundle:nil];
    //    [self.tableView registerNib:cellNib forCellReuseIdentifier:[DhzyDaibanCell identifier]];
    //    self.tableView.tableFooterView = [UIView new];
    [self.suggestTableView registerClass:[JXCellDefault class] forCellReuseIdentifier:[JXCellDefault identifier]];
    self.suggestTableView.tableFooterView = [UIView new];
    
    [self configUI];
}

- (void)setupSignal {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
#pragma mark assist
- (void)configUI {
    self.tipsLabel.textColor = JXColorHex(0x333333);
    self.tipsLabel.font = JXFont(14);
    self.tipsLabel.text = @"您可以输入部分或全部药品名，或者疾病症状进行搜索。例如：“小儿氨酚黄那敏”，“发烧 咳嗽”";
    
    for (UILabel *label in self.typeLabels) {
        label.font = JXFont(14);
    }
}

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
- (IBAction)classifyButtonPressed:(UIButton *)btn {
    //CompClassifyViewController *vc = [[CompClassifyViewController alloc] init];
    FilterViewController *vc = [[FilterViewController alloc] init];
    //vc.classify = btn.tag;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Notification methods

#pragma mark - Delegate methods
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.suggests.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return JXScreenScale(44.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JXCellDefault *cell = [tableView dequeueReusableCellWithIdentifier:[JXCellDefault identifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.suggests[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultViewController *vc = [[SearchResultViewController alloc] init];
    vc.searchText = self.suggests[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Public methods
#pragma mark - Class methods


@end
