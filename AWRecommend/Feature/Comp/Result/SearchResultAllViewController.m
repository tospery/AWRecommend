//
//  SearchResultAllViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/2/23.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "SearchResultAllViewController.h"
#import "CompResultBrandViewController.h"

@interface SearchResultAllViewController ()

@end

@implementation SearchResultAllViewController
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
    RAC(self, dataSource) = [self.requestRemoteDataCommand.executionSignals.switchToLatest map:^id _Nullable(NSArray *items) {
        @strongify(self)
        if (0 != items.count) {
            CompResultList *list = items[0];
            NSMutableArray *rows = [NSMutableArray arrayWithArray:self.dataSource.firstObject];
            [rows addObjectsFromArray:list.datas];
            
            self.isNoMoreData = (rows.count == list.totalSize);
            
            return @[rows];
        }
        self.isNoMoreData = YES;
        
        return self.dataSource;
    }];
    
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self)
        CompResultBrandViewController *vc = [[CompResultBrandViewController alloc] init];
        vc.dId = [(CompResultItem *)input.second dId];
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
    self.navigationItem.title = @"药品列表";
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorColor = JXColorHex(0xe7e7e7);
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
    JXCell *myCell = (JXCell *)cell;

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
    myCell.accessoryType = UITableViewCellAccessoryNone;
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!myCell.accessoryView) {
        UIImage *image = JXAdaptImage(JXImageWithName(@"ic_arrow_right"));
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        myCell.accessoryView = imageView;
    }
    
    NSArray *items = [self.dataSource firstObject];
    if ((items.count - 1) == indexPath.row) {
        myCell.separatorInset = UIEdgeInsetsZero;
    }else {
        myCell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JXCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:[JXCell identifier] forIndexPath:indexPath];
}

#pragma mark - Accessor methods
#pragma mark - Action methods
#pragma mark - Notification methods

#pragma mark - Delegate methods
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

#pragma mark - Public methods
#pragma mark - Class methods


@end
