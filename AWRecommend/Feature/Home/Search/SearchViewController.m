//
//  SearchViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/22.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "SearchViewController.h"
#import "ResultViewController.h"

@interface SearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) VBFPopFlatButton *cancelButton;

@property (nonatomic, weak) IBOutlet UIButton *scanButton;

@property (nonatomic, strong) NSArray *historis;
@property (nonatomic, weak) IBOutlet UIView *hisotryView;
@property (nonatomic, strong) NSArray *hotwords;
@property (nonatomic, weak) IBOutlet UIView *hotwordView;

// @property (nonatomic, weak) IBOutlet UIView *clearButton;
@property (nonatomic, weak) IBOutlet UIView *hisotryTitleView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *historyTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *hotwordHeightConstraint;


@property (nonatomic, strong) RACCommand *resultCommand;
@property (nonatomic, strong) NSArray *results;
@property (nonatomic, weak) IBOutlet UITableView *resultTableView;
@property (nonatomic, weak) IBOutlet UIView *resultBackgroundView;
@property (nonatomic, weak) IBOutlet UIView *resultAlphaView;

@end

@implementation SearchViewController
#pragma mark - Override
#pragma mark init
- (instancetype)init {
    if (self = [super init]) {
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
//        self.shouldPullToRefresh = YES;
    }
    return self;
}

- (void)dealloc {
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark view
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVar];
    [self setupView];
    [self setupNet];
}

#pragma mark setup
- (void)setupVar {
    self.historis = [TMInstance objectForKey:kTMCompHistory];
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyHistoryDidChange:) name:kNotifyHistoryDidChange object:nil];
}

- (void)setupView {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JXScreenScale(240), 34)];
    [titleView addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(titleView);
    }];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
    self.cancelButton.hidden = YES;
    
    [self.searchBar becomeFirstResponder];
    
//    self.navigationItem.title = @"设置";
//    
//    UINib *nib = [UINib nibWithNibName:@"JXCell" bundle:nil];
//    [self.tableView registerNib:nib forCellReuseIdentifier:[JXCell identifier]];
//    self.tableView.tableFooterView = [UIView new];
    
    [self.resultTableView registerClass:[JXCellDefault class] forCellReuseIdentifier:[JXCellDefault identifier]];
    self.resultTableView.tableFooterView = [UIView new];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    JXAdaptButton(self.scanButton, JXFont(14));
}

- (void)setupNet {
    
}

#pragma mark scroll
- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self)
    [RACObserve(self, historis) subscribeNext:^(id x) {
        @strongify(self)
        [self configShortcuts:self.historis isFixed:YES];
        //[self configShortcuts:self.hotwords isFixed:NO];
    }];
    
    [RACObserve(self, results) subscribeNext:^(NSArray *results) {
        @strongify(self)
        if (0 == results.count) {
            //self.resultAlphaView.backgroundColor = [UIColor blackColor];
            //self.resultAlphaView.alpha = 0.3;
            
            //            NSString *searchText = [self.searchBar.text jx_trimWhitespace];
            //            if (0 == searchText.length) {
            //                self.tipsLabel.text = @"您可以输入部分或全部药品名，或者疾病症状进行搜索。例如：“小儿氨酚黄那敏”，“发烧 咳嗽”";
            //            }else {
            //                self.tipsLabel.text = JXStrWithFmt(@"无法获得“%@”的相关信息，您可以尝试通过下面疾病标签进行查询", searchText);
            //            }
            self.resultBackgroundView.hidden = YES;
        }else {
            //self.resultAlphaView.backgroundColor = [UIColor whiteColor];
            //self.resultAlphaView.alpha = 1.0;
            self.resultBackgroundView.hidden = NO;
        }
        [self.resultTableView reloadData];
    }];
    
    //RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[requestRemoteDataSignal deliverOnMainThread] map:^id _Nullable(id result) {
        return result;
    }];
}

- (id)fetchLocalData {
    return nil;
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    //return [HRInstance requestDhzyDaibanListWithPage:1];
    //return [RACSignal empty];
    return [HRInstance showHotWords];
}

- (void)reloadData {
    [super reloadData];
    [self configShortcuts:self.dataSource isFixed:NO];
}

#pragma mark table
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [JXCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [tableView dequeueReusableCellWithIdentifier:[JXCell identifier] forIndexPath:indexPath];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    JXCell *myCell = (JXCell *)cell;
    myCell.data = object;
    myCell.separatorImageView.hidden = YES;
}

#pragma mark - Accessor
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"搜药品名称，疾病症状";
        _searchBar.delegate = self;
        _searchBar.backgroundImage = [UIImage new];
        [_searchBar setImage:JXImageWithName(@"ic_clear") forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
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

- (RACCommand *)resultCommand {
    if (!_resultCommand) {
        _resultCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *keyword) {
            return [HRInstance getSearchSuggestWithKeyword:keyword];
        }];
        
        @weakify(self)
        [[_resultCommand.errors filter:^BOOL(NSError *error) {
            @strongify(self)
            if (JXErrorCodeDataEmpty == error.code) {
                self.results = nil;
                return NO;
            }
            return YES;
        }] subscribe:self.errors];
        
        [_resultCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *items) {
            @strongify(self)
            self.results = items;
        }];
    }
    return _resultCommand;
}

#pragma mark - Private
- (void)configShortcuts:(NSArray *)shortcuts isFixed:(BOOL)isFixed {
    CGFloat interval = JXScreenScale(20);
    CGFloat height = JXScreenScale(34);
    CGFloat textHeight = JXScreenScale(22);
    CGFloat textMargin = JXScreenScale(12);
    CGFloat x = 0;
    CGFloat y = (height - textHeight) / 2.0;
    CGFloat lines = 0;
    UIFont *font = JXFont(11);
    UIButton *btn = nil;
    
    if (isFixed) {
        [self.hisotryView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }else {
        [self.hotwordView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    for (NSInteger i = 0; i < shortcuts.count; ++i) {
        NSString *str = shortcuts[i];
        if (str.length > 10) {
            str = JXStrWithFmt(@"%@...", [str substringToIndex:10]);
        }
        CGSize size = [str jx_sizeWithFont:font width:INT32_MAX];
        if (x + interval + size.width + textMargin + interval > JXScreenWidth) {
            if (isFixed && (2 == lines)) {
                break;
            }
            
            lines++;
            x = 0;
            y += height;
        }
        
        //        if (isFixed && (3 == lines)) {
        //            break;
        //        }
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = font;
        btn.backgroundColor = JXColorHex(0xEAEAEA);
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:JXColorHex(0x666666) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(wordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        btn.frame = CGRectMake(x + interval, y, btn.jx_width + textMargin, textHeight);
        [btn jx_borderWithColor:[UIColor clearColor] width:0.0 radius:8];
        if (isFixed) {
            [self.hisotryView addSubview:btn];
        }else {
            [self.hotwordView addSubview:btn];
        }
        
        x = btn.jx_x + btn.jx_width;
    }
    
//    if (btn && !isFixed) {
//        CGFloat offset = 0;
//        if (!self.hisotryTitleView.hidden) {
//            offset = JXScreenScale(44);
//        }
//        // self.realHeightConstraint.constant = offset + self.historyHeightConstraint.constant + JXScreenScale(44) + btn.jx_y + textHeight + JXScreenScale(12);
//    }
    
//    if (isFixed) {
//        self.clearButton.hidden = (0 == shortcuts.count);
//        NSInteger multiples = (0 == shortcuts.count) ? 0 : (lines + 1);
//        self.hotwordHeightConstraint.constant = JXScreenScale(34) * multiples;
//        
//        if (0 == shortcuts.count) {
//            self.hisotryTitleView.hidden = YES;
//            self.historyTopConstraint.constant = JXScreenScale(40) * -1;
//        }else {
//            self.hisotryTitleView.hidden = NO;
//            self.historyTopConstraint.constant = 0;
//        }
//    }
    
    if (isFixed) {
//        self.clearButton.hidden = (0 == shortcuts.count);
//        NSInteger multiples = (0 == shortcuts.count) ? 0 : (lines + 1);
//        self.hotwordHeightConstraint.constant = JXScreenScale(34) * multiples;
//        
        if (0 == shortcuts.count) {
            self.hisotryTitleView.hidden = YES;
            self.historyTopConstraint.constant = JXScreenScale(40) * -1;
        }else {
            self.hisotryTitleView.hidden = NO;
            self.historyTopConstraint.constant = 0;
        }
    }else {
        NSInteger multiples = (0 == shortcuts.count) ? 0 : (lines + 1);
        self.hotwordHeightConstraint.constant = height * multiples;
    }
}

#pragma mark - Public
#pragma mark - Action
- (void)cancelItemPressed:(id)sender {
    [self.searchBar resignFirstResponder];
}

- (IBAction)scanButtonPressed:(id)sender {
    EntryScan(self.navigationController);
}

- (void)wordButtonPressed:(UIButton *)btn {
    [self.searchBar resignFirstResponder];
    
    ResultViewController *vc = [[ResultViewController alloc] init];
    vc.keyword = [btn titleForState:UIControlStateNormal];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clearButtonPressed:(id)sender {
    [TMInstance removeObjectForKey:kTMCompHistory];
    self.historis = nil;
}

#pragma mark - Notification
#pragma mark - Delegate
#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    //self.resultBackgroundView.hidden = NO;
    self.cancelButton.hidden = NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.resultBackgroundView.hidden = YES;
    self.cancelButton.hidden = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = [self.searchBar.text jx_trimWhitespace];
    if (0 == searchText.length) {
        [JXDialog showPopup:@"搜索内容不能全为空白字符"];
        return;
    }
    
    [searchBar resignFirstResponder];
    
//    NSArray *histories = [TMInstance objectForKey:kTMCompHistory];
//    NSMutableArray *mArr = [NSMutableArray arrayWithArray:histories];
//    [mArr removeObject:searchText];
//
//    [mArr insertObject:searchText atIndex:0];
//    if (mArr.count > 50) {
//        [mArr removeObjectsInRange:NSMakeRange(50, mArr.count - 50)];
//    }
//    [TMInstance setObject:mArr forKey:kTMCompHistory];
    
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.historis];
    [mArr removeObject:searchText];
    [mArr insertObject:searchText atIndex:0];
    if (mArr.count > 50) {
        [mArr removeObjectsInRange:NSMakeRange(50, mArr.count - 50)];
    }
    self.historis = mArr;
    [TMInstance setObject:self.historis forKey:kTMCompHistory];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyHistoryDidChange object:mArr];
//    
    ResultViewController *vc = [[ResultViewController alloc] init];
    vc.keyword = searchText;
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
    [self.resultCommand execute:text];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JXCellDefault height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JXCellDefault *cell = [tableView dequeueReusableCellWithIdentifier:[JXCellDefault identifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.results[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ResultViewController *vc = [[ResultViewController alloc] init];
    vc.keyword = self.results[indexPath.row];
    vc.isPrecised = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Class

@end
