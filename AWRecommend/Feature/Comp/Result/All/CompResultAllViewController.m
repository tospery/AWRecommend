//
//  CompResultAllViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/9.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "CompResultAllViewController.h"
#import "CompResultBrandViewController.h"

@interface CompResultAllViewController ()
@property (nonatomic, strong) CompResultList *list;
//@property (nonatomic, strong) JXPage *page;
//@property (nonatomic, weak) IBOutlet UIView *headerView;

@end

@implementation CompResultAllViewController
#pragma mark - Override methods
- (instancetype)init {
    if (self = [super init]) {
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
        self.shouldInfiniteScrolling = YES;
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
    RAC(self, dataSource) = [[[self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData] map:^id(NSArray *items) {
        @strongify(self)
        if (0 != items.count) {
            self.list = items[0];
            items = self.list.datas;
            
            NSMutableArray *results = [NSMutableArray arrayWithArray:[self.dataSource firstObject]];
            [results addObjectsFromArray:items];
            
            items = results;
            
            if (items.count >= self.list.totalSize) {
                self.isNoMoreData = YES;
            }
        }
        return JXArrValue(items, [NSArray new]);
    }] map:^id(NSArray *items) {
        return @[JXArrValue(items, [NSArray new])];
    }];
    
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self)
        CompResultBrandViewController *vc = [[CompResultBrandViewController alloc] init];
        // vc.item = input.second;
        vc.dId = [(CompResultItem *)input.second dId];
        [self.navigationController pushViewController:vc animated:YES];
        
        return [RACSignal empty];
    }];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
    //self.page = [JXPage new];
}

- (void)setupData {
}

- (void)setupView {
    self.navigationItem.title = @"药品列表";
    
    //self.headerView.frame = CGRectMake(0, 0, 320, JXScreenScale(44));

    [self.tableView registerClass:[JXCellDefault class] forCellReuseIdentifier:[JXCellDefault identifier]];
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
- (id)fetchLocalData {
    return nil;
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    return [HRInstance getPageGroupBySocNameWithKeyword:self.searchText socName:self.searchScope page:page rows:JXInstance.pageSize];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    JXCellDefault *myCell = (JXCellDefault *)cell;
    
//    CompResultItem *item = object;
//    NSString *name = JXStrWithDft(item.dName, @"");
//    NSString *type = JXStrWithDft(item.dNatureType, @"");
//    NSString *str = JXStrWithFmt(@"%@  %@", name, type);
//    NSMutableAttributedString *as = [NSMutableAttributedString jx_attributedStringWithString:str color:JXColorHex(0x333333) font:JXFont(14)];
//    [as jx_addAttributeWithColor:JXColorHex(0x999999) font:JXFont(11) range:NSMakeRange(name.length + 2, type.length)];
    
    myCell.textLabel.numberOfLines = 2;
    
    CompResultItem *item = object;
    NSString *name = JXStrWithDft(item.dName, @"");
    NSString *zz = JXStrWithDft(item.dcName, @"");
    NSString *type = JXStrWithDft(item.dNatureType, @"");
    NSString *str = JXStrWithFmt(@"%@  %@\n%@", name, type, zz);
    NSMutableAttributedString *as = [NSMutableAttributedString jx_attributedStringWithString:str color:JXColorHex(0x999999) font:JXFont(10)];
    
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setLineSpacing:2];
    [as addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, str.length)];
    
    [as jx_addAttributeWithColor:JXColorHex(0x333333) font:JXFont(13) range:NSMakeRange(0, name.length)];
    
    myCell.textLabel.attributedText = as;
    myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *items = [self.dataSource firstObject];
    if ((items.count - 1) == indexPath.row) {
        myCell.separatorInset = UIEdgeInsetsZero;
    }else {
        myCell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    }
    
//    BOOL aa = myCell.preservesSuperviewLayoutMargins;
//    UIEdgeInsets bb = myCell.separatorInset;
//    UIEdgeInsets cc = myCell.layoutMargins;
//    
//    if ((items.count - 1) == indexPath.row) {
//        
//        myCell.preservesSuperviewLayoutMargins = NO;
//        myCell.separatorInset = UIEdgeInsetsZero;
//        myCell.layoutMargins = UIEdgeInsetsZero;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JXCellDefault height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:[JXCellDefault identifier] forIndexPath:indexPath];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    NSInteger number = [super numberOfSectionsInTableView:tableView];
//    return self.dataSource ? self.dataSource.count : 1;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == [(NSArray *)[self.dataSource firstObject] count]) {
        return 0;
    }
    return JXScreenScale(44);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (0 == [(NSArray *)[self.dataSource firstObject] count]) {
        return 0;
    }
    
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kJXIdentifierHeaderFooter];
    CategoryView *cv = [view viewWithTag:101];
    if (!cv) {
        cv = [[[NSBundle mainBundle] loadNibNamed:@"CategoryView" owner:nil options:nil] firstObject];
        cv.titleLabel.text = JXStrWithFmt(@"全部%@药品推荐", self.searchScope);
        cv.tag = 101;
        [view addSubview:cv];
        [cv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
    }
    return view;
}

#pragma mark - Accessor methods
#pragma mark - Action methods
#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource

#pragma mark - Public methods
#pragma mark - Class methods


@end
