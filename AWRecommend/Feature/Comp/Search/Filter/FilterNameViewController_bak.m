//
//  FilterViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/2/20.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "FilterNameViewController.h"
#import "FilterCell.h"
#import "FilterDrugCoverView.h"
//#import "CompResultBrandViewController.h"
//#import "SearchResultViewController.h"
#import "BrandViewController.h"
#import "ResultViewController.h"

@interface FilterNameViewController () <UITableViewDataSource, UITableViewDelegate, JXClassifyViewDataSource>
@property (nonatomic, strong) NSArray *dataSource;
//@property (nonatomic, strong) RACCommand *listCommand;


@property (nonatomic, weak) IBOutlet JXClassifyView *classifyView;
@property (nonatomic, strong) UITableView *tableView;

//@property (nonatomic, assign) BOOL isSickness;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic, weak) IBOutlet UIButton *okButton;

@end

@implementation FilterNameViewController
@synthesize dataSource;

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
    
    //    RAC(self, dataSource) = [[[self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData] map:^id(NSArray *items) {
    //        return JXArrValue(items, [NSArray new]);
    //    }] map:^id(NSArray *items) {
    //        return @[JXArrValue(items, [NSArray new])];
    //    }];
    

    @weakify(self)
    //RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[requestRemoteDataSignal deliverOnMainThread] map:^id _Nullable(id result) {
        return result;
    }];
    
//    RAC(self, dataSource) = [[self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:[self fetchLocalData]] map:^id _Nullable(id result) {
//        return result;
//    }];
    
    
    [[[RACObserve(self.classifyView, selectedIndexPath) skip:1] distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        for (CompClassify *c in self.dataSource) {
            for (CompClassifyData1 *d in c.datas) {
                d.selected = NO;
            }
        }
        
        if (0 != self.heightConstraint.constant) {
            self.heightConstraint.constant = 0;
            [self.view setNeedsUpdateConstraints];
            [self.view updateConstraintsIfNeeded];
            [UIView animateWithDuration:0.25 animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.okButton.hidden = YES;
            }];
        }
    }];
    
    //[self.listCommand execute:@(self.classify)];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
    self.requestParam = RACTuplePack(@(self.classify.type), @(self.classify.kind)); // @(self.classify);
    //self.isSickness = (self.classify % 2 != 0 );
}

- (void)setupData {
}

- (void)setupView {
    // self.navigationItem.title = [Util stringWithSearchClassify:self.classify];
    
    
    NSString *title = JXStrWithFmt(@"%@%@", self.classify.categoryName, [Util titleWithSearchKind:self.classify.kind]);
    self.navigationItem.title = title;
    
    //    UINib *cellNib = [UINib nibWithNibName:@"DhzyDaibanCell" bundle:nil];
    //    [self.tableView registerNib:cellNib forCellReuseIdentifier:[DhzyDaibanCell identifier]];
    //    self.tableView.tableFooterView = [UIView new];
    
    //    self.classifyView.tableView.separatorInset = UIEdgeInsetsZero;
    //    self.classifyView.tableView.layoutMargins = UIEdgeInsetsZero;
    self.classifyView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.classifyView.tableView.separatorColor = [UIColor redColor];
    self.classifyView.tableView.backgroundColor = JXColorHex(0xf3f3f3);
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

//@property (nonatomic, strong) RACCommand *infoCommand;
//- (RACCommand *)infoCommand {
//    if (!_infoCommand) {
//        _infoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//            return [HRInstance requestYjqxFuncItems];
//        }];
//
//        [_infoCommand.executing subscribe:self.executing];
//        [_infoCommand.errors subscribe:self.errors];
//
//        @weakify(self)
//        [_infoCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *items) {
//            @strongify(self)
//        }];
//    }
//    return _infoCommand;
//}


#pragma mark - Accessor methods
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        //_tableView.separatorColor = JXColorHex(0xe7e7e7);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        UINib *nib = [UINib nibWithNibName:@"FilterCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:[FilterCell identifier]];
        [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kJXIdentifierHeaderFooter];
    }
    return _tableView;
}

//- (RACCommand *)listCommand {
//    if (!_listCommand) {
//        _listCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
//            return [HRInstance queryDrugDatasWithClassify:input.integerValue];
//        }];
//        [_listCommand.executing subscribe:self.executing];
//        [_listCommand.errors subscribe:self.errors];
//        //
//        @weakify(self)
//        //        //        [[_listCommand.executing skip:1] subscribeNext:^(NSNumber *executing) {
//        //        //            @strongify(self)
//        //        //            if (executing.boolValue) {
//        //        //                [self.scrollView reloadEmptyDataSet];
//        //        //            }
//        //        //        }];
//        //        [[_listCommand.errors filter:^BOOL(NSError *error) {
//        //            @strongify(self)
//        //            BOOL ret = NO;
//        //            self.error = error;
//        //            if (JXErrorCodeTokenInvalid == error.code) {
//        //                ret = YES;
//        //            }
//        //
//        //            return ret;
//        //        }] subscribe:self.errors];
//        
//        [_listCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *items) {
//            @strongify(self)
//            self.items = items;
//            [self.classifyView reloadData];
//            JXHUDHide();
//        }];
//    }
//    return _listCommand;
//}

#pragma mark - Scroll
- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    if (1 == self.classify.kind) {
        return [HRInstance queryDiseaseBySuitObjectId:[self.classify.uid integerValue]];
    }
    
    return [HRInstance queryDrugDatasWithType:self.classify.type kind:self.classify.kind];
    //return [HRInstance queryDrugDatasWithClassify:[(NSNumber *)param integerValue]];
}

- (void)reloadData {
    [super reloadData];
    [self.classifyView reloadData];
}

#pragma mark - Action methods
- (IBAction)okButtonPressed:(id)sender {
    ResultViewController *vc = [[ResultViewController alloc] init];
    NSMutableString *ms = [NSMutableString string];
    for (CompClassify *c in self.dataSource) {
        for (CompClassifyData1 *d in c.datas) {
            if (d.selected) {
                [ms appendString:d.typeName];
                [ms appendString:@" "];
            }
        }
    }
    [ms deleteCharactersInRange:NSMakeRange(ms.length - 1, 1)];
    vc.keyword = ms;
    vc.scope = self.classify.categoryName;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark JXClassifyViewDataSource
- (NSInteger)totalClassifiesWithClassifyView:(JXClassifyView *)classifyView {
    return self.dataSource.count;
}

- (void)classifyView:(JXClassifyView *)classifyView didCreateCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (101 != cell.backgroundView.tag) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.tag = 101;
        view.backgroundColor = JXColorHex(0xf3f3f3);
        
        UIImageView *imageViewTrailing = [[UIImageView alloc] init];
        imageViewTrailing.backgroundColor = JXColorHex(0xe7e7e7);
        [view addSubview:imageViewTrailing];
        [imageViewTrailing mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view);
            make.bottom.equalTo(view);
            make.trailing.equalTo(view);
            make.width.equalTo(@1);
        }];
        
        cell.backgroundView = view;
    }
    
    if (102 != cell.selectedBackgroundView.tag) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.tag = 102;
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageViewTop = [[UIImageView alloc] init];
        imageViewTop.backgroundColor = JXColorHex(0xe7e7e7);
        [view addSubview:imageViewTop];
        [imageViewTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(view);
            make.top.equalTo(view);
            make.trailing.equalTo(view);
            make.height.equalTo(@1);
        }];
        
        UIImageView *imageViewBottom = [[UIImageView alloc] init];
        imageViewBottom.backgroundColor = JXColorHex(0xe7e7e7);
        [view addSubview:imageViewBottom];
        [imageViewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(view);
            make.bottom.equalTo(view);
            make.trailing.equalTo(view);
            make.height.equalTo(@1);
        }];
        
        cell.selectedBackgroundView = view;
    }
    
    cell.textLabel.font = JXFont(13);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = JXColorHex(0x333333);
    cell.textLabel.highlightedTextColor = nil;
    
    CompClassify *c = self.dataSource[indexPath.row];
    //cell.textLabel.text = c.drugCategoryName;
    
    NSMutableAttributedString *as = [NSMutableAttributedString jx_attributedStringWithString:c.drugCategoryName color:JXColorHex(0x333333) font:JXFont(13)];
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setLineSpacing:1];
    [as addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, as.length)];
    
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.attributedText = as;
}

- (UIView *)classifyView:(JXClassifyView *)classifyView viewForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UIView *view = [[UIView alloc] init];
    //    view.backgroundColor = [UIColor greenColor];
    //    return view;
    return self.tableView;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (SearchKindSickness == self.classify.kind) {
        return 1;
    }
    
    CompClassify *c = self.dataSource[self.classifyView.selectedIndexPath.row];
    return c.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (SearchKindSickness == self.classify.kind) {
        CompClassify *c = self.dataSource[self.classifyView.selectedIndexPath.row];
        return c.datas.count;
    }
    
    CompClassify *c = self.dataSource[self.classifyView.selectedIndexPath.row];
    CompClassifyData1 *d = c.datas[section];
    return d.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [FilterCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FilterCell *cell = [tableView dequeueReusableCellWithIdentifier:[FilterCell identifier] forIndexPath:indexPath];
    
    if (SearchKindSickness == self.classify.kind) {
        CompClassify *c = self.dataSource[self.classifyView.selectedIndexPath.row];
        CompClassifyData1 *d = c.datas[indexPath.row];
        cell.data = d;
        
        return cell;
    }
    
    CompClassify *c = self.dataSource[self.classifyView.selectedIndexPath.row];
    CompClassifyData1 *d1 = c.datas[indexPath.section];
    CompClassifyData2 *d2 = d1.datas[indexPath.row];
    cell.data = d2;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (SearchKindSickness == self.classify.kind) {
        return 0;
    }
    
    return JXScreenScale(30);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (SearchKindSickness == self.classify.kind) {
        return [UIView new];
    }
    
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kJXIdentifierHeaderFooter];
    FilterDrugCoverView *coverView = [header viewWithTag:101];
    if (!coverView) {
        coverView = [[[NSBundle mainBundle] loadNibNamed:@"FilterDrugCoverView" owner:nil options:nil] firstObject];
        coverView.tag = 101;
        [header addSubview:coverView];
        [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(header);
        }];
    }
    
    CompClassify *c = self.dataSource[self.classifyView.selectedIndexPath.row];
    CompClassifyData1 *d = c.datas[section];
    coverView.textLabel.text = d.typeName;
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (SearchKindSickness == self.classify.kind) {
        CompClassify *c = self.dataSource[self.classifyView.selectedIndexPath.row];
        CompClassifyData1 *d = c.datas[indexPath.row];
        d.selected = !d.selected;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        BOOL hasSelect = NO;
        for (CompClassify *c in self.dataSource) {
            for (CompClassifyData1 *d in c.datas) {
                if (d.selected) {
                    hasSelect = YES;
                    break;
                }
            }
        }
        
        BOOL hasChange = NO;
        if (hasSelect) {
            if (0 == self.heightConstraint.constant) {
                self.heightConstraint.constant = JXScreenScale(44);
                hasChange = YES;
            }
        }else {
            if (0 != self.heightConstraint.constant) {
                self.heightConstraint.constant = 0;
                hasChange = YES;
            }
        }
        
        if (hasChange) {
            self.okButton.hidden = NO;
            
            [self.view setNeedsUpdateConstraints];
            [self.view updateConstraintsIfNeeded];
            [UIView animateWithDuration:0.25 animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                if (self.heightConstraint.constant == 0) {
                    self.okButton.hidden = YES;
                }
            }];
        }
        
        return;
    }
//    
//    CompClassify *c = self.dataSource[self.classifyView.selectedIndexPath.row];
//    CompClassifyData1 *d1 = c.datas[indexPath.section];
//    CompClassifyData2 *d2 = d1.datas[indexPath.row];
//
//    CompResultBrandViewController *vc = [[CompResultBrandViewController alloc] init];
//    vc.dId = d2.uid.integerValue;
//    [self.navigationController pushViewController:vc animated:YES];
    
    CompClassify *c = self.dataSource[self.classifyView.selectedIndexPath.row];
    CompClassifyData1 *d1 = c.datas[indexPath.section];
    CompClassifyData2 *d2 = d1.datas[indexPath.row];

    CompResultItem *item = [CompResultItem new];
    item.dId = d2.uid.integerValue;
    item.dName = d2.drugName;
    
    BrandViewController *vc = [[BrandViewController alloc] init];
    vc.dataSource = item;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


//#pragma mark UITableViewDataSource
//- (NSString *)classifyView:(JXClassifyView *)classifyView titleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CompClassify *c = self.items[indexPath.row];
//    return c.drugCategoryName;
//}
//
//- (NSInteger)totalClassifiesWithClassifyView:(JXClassifyView *)classifyView {
//    return self.items.count;
//}
//
//- (UIView *)classifyView:(JXClassifyView *)classifyView viewForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor orangeColor];
//    return view;
//}
//
//- (void)classifyView:(JXClassifyView *)classifyView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    cell.textLabel.textAlignment = NSTextAlignmentLeft;
//    cell.textLabel.font = JXFont(13);
//    cell.textLabel.textColor = JXColorHex(0x333333);
//    cell.textLabel.highlightedTextColor = nil;
//}
//
//- (UIColor *)backgroundColorForSelectedWithClassifyView:(JXClassifyView *)classifyView {
//    return [UIColor whiteColor];
//}

#pragma mark - Public methods
#pragma mark - Class methods


@end

