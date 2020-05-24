//
//  CompClassifyViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/3.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "CompClassifyViewController.h"
#import "CompClassifyFirstCell.h"
#import "CompClassifySecondCell.h"
#import "CompClassifyCoverView.h"
#import "CompResultBrandViewController.h"
#import "SearchResultViewController.h"

@interface CompClassifyViewController ()
// @property (nonatomic, assign) NSInteger firstIndex;

//@property (nonatomic, strong) NSError *error;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;


@property (nonatomic, weak) IBOutlet UITableView *firstTableView;
@property (nonatomic, weak) IBOutlet UITableView *secondTableView;

@property (nonatomic, assign) NSInteger selectedCount;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic, weak) IBOutlet UIButton *selectButton;

@property (nonatomic, strong) RACCommand *listCommand;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation CompClassifyViewController
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
//    [RACObserve(self, selectedArray.count) subscribeNext:^(NSNumber *count) {
//        @strongify(self)
//        BOOL changed = NO;
//        if (0 == count.integerValue) {
//            if (0 != self.heightConstraint.constant) {
//                self.heightConstraint.constant = 0;
//                changed = YES;
//            }
//        }else {
//            if (JXScreenScale(44) != self.heightConstraint.constant) {
//                self.heightConstraint.constant = JXScreenScale(44);
//                changed = YES;
//            }
//        }
//        
//        if (changed) {
//            [self.view setNeedsUpdateConstraints];
//            [self.view updateConstraintsIfNeeded];
//            [UIView animateWithDuration:0.4 animations:^{
//                [self.view layoutIfNeeded];
//            } completion:NULL];
//        }
//    }];
//    RACAbleWithStart(<#...#>)
//    RACAble(<#...#>)
//    RACObserve(<#TARGET#>, <#KEYPATH#>)
    
//    [[RACSignal combineLatest:@[RACAbleWithStart(self.selectedCount)]] subscribeNext:^(id x) {
//        int a = 0;
//    }];
    
    [[[RACObserve(self, selectedIndex) skip:1] distinctUntilChanged] subscribeNext:^(NSNumber *index) {
        for (CompClassify *c in self.items) {
            for (CompClassifyData1 *d in c.datas) {
                d.selected = NO;
            }
        }
        [self.selectedArray removeAllObjects];
        if (0 != self.heightConstraint.constant) {
            self.heightConstraint.constant = 0;
            [self.view setNeedsUpdateConstraints];
            [self.view updateConstraintsIfNeeded];
            [UIView animateWithDuration:0.25 animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.selectButton.hidden = YES;
            }];
        }
        [self.secondTableView reloadData];
    }];
    
    [[[RACSignal merge:@[RACObserve(self, items), RACObserve(self, error)]] skip:1] subscribeNext:^(id x) {
        @strongify(self)
        [self.firstTableView reloadData];
        [self.secondTableView reloadData];
        // self.error = nil;
        [self.scrollView reloadEmptyDataSet];
    }];
    [self.listCommand execute:@(self.classify)];
    
    //    [RACObserve(self, items) subscribeNext:^(id x) {
    //        [self.firstTableView reloadData];
    //        [self.secondTableView reloadData];
    //
    //        self.error = nil;
    //        [self.scrollView reloadEmptyDataSet];
    //
    //        [self.listCommand execute:@(self.classify)];
    //    }];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
    self.selectedArray = [NSMutableArray array];
}

- (void)setupData {
}

- (void)setupView {
    self.navigationItem.title = [Util stringWithSearchClassify:self.classify];
    
    UINib *nib = [UINib nibWithNibName:@"CompClassifyFirstCell" bundle:nil];
    [self.firstTableView registerNib:nib forCellReuseIdentifier:[CompClassifyFirstCell identifier]];
    self.firstTableView.tableFooterView = [UIView new];
    
    nib = [UINib nibWithNibName:@"CompClassifySecondCell" bundle:nil];
    [self.secondTableView registerNib:nib forCellReuseIdentifier:[CompClassifySecondCell identifier]];
    [self.secondTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kJXIdentifierHeaderFooter];
    self.secondTableView.tableFooterView = [UIView new];
}

- (void)setupSignal {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
#pragma mark assist

//#pragma mark - Table
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
- (NSInteger)selectedCount {
    return self.selectedArray.count;
}

- (RACCommand *)listCommand {
    if (!_listCommand) {
        _listCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
            // return [HRInstance queryDrugDatasWithClassify:input.integerValue];
            return [HRInstance queryDrugDatasWithType:input.integerValue kind:input.integerValue];
        }];
        
        @weakify(self)
        //        [[_listCommand.executing skip:1] subscribeNext:^(NSNumber *executing) {
        //            @strongify(self)
        //            if (executing.boolValue) {
        //                [self.scrollView reloadEmptyDataSet];
        //            }
        //        }];
        [[_listCommand.errors filter:^BOOL(NSError *error) {
            @strongify(self)
            BOOL ret = NO;
            self.error = error;
            if (JXErrorCodeTokenInvalid == error.code) {
                ret = YES;
            }
            
            return ret;
        }] subscribe:self.errors];
        
        [_listCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *items) {
            @strongify(self)
            self.items = items;
        }];
    }
    return _listCommand;
}


#pragma mark - Action methods
- (IBAction)okButtonPressed:(id)sender {
    SearchResultViewController *vc = [[SearchResultViewController alloc] init];
    NSMutableString *ms = [NSMutableString string];
    for (NSString *str in self.selectedArray) {
        [ms appendString:str];
        [ms appendString:@" "];
    }
    [ms deleteCharactersInRange:NSMakeRange(ms.length - 1, 1)];
   // vc.keyword = ms;
    if (SearchClassifyChildrenSickness == self.classify) {
        // vc.type = PeopleTypeChild;
        vc.searchScope = @"儿童";
    }else if (SearchClassifyAdultSickness == self.classify) {
        // vc.type = PeopleTypeAdult;
        vc.searchScope = @"成人";
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (0 == self.items.count) {
        return 0;
    }
    
    
    if ([Util isMedicineWithSearchClassify:self.classify]) {
        if (tableView == self.firstTableView) {
            return 1;
        }
        CompClassify *c = self.items[self.selectedIndex];
        return c.datas.count;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == self.items.count) {
        return 0;
    }
    
    if ([Util isMedicineWithSearchClassify:self.classify]) {
        if (tableView == self.firstTableView) {
            return self.items.count;
        }
        CompClassify *c = self.items[self.selectedIndex];
        CompClassifyData1 *d = c.datas[section];
        return d.datas.count;
    }
    
    if (tableView == self.firstTableView) {
        return self.items.count;
    }
    CompClassify *c = self.items[self.selectedIndex];
    return c.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.firstTableView) {
        return [CompClassifyFirstCell height];
    }
    
    return [CompClassifySecondCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.firstTableView) {
        CompClassifyFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:[CompClassifyFirstCell identifier]];
        cell.data = self.items[indexPath.row];
        cell.backgroundColor = (indexPath.row == self.selectedIndex ? [UIColor whiteColor] : JXColorHex(0xF3F3F3));
        return cell;
    }
    
    CompClassifySecondCell *cell = [tableView dequeueReusableCellWithIdentifier:[CompClassifySecondCell identifier]];
    
    id data = nil;
    if ([Util isMedicineWithSearchClassify:self.classify]) {
        CompClassify *c = self.items[self.selectedIndex];
        CompClassifyData1 *d = c.datas[indexPath.section];
        data = d.datas[indexPath.row];
    }else {
        CompClassify *c = self.items[self.selectedIndex];
        data = c.datas[indexPath.row];
    }
    cell.data = data;
    
    return cell;
    
    
    //    JXCellDefault *cell = [tableView dequeueReusableCellWithIdentifier:[JXCellDefault identifier]];
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //
    //    if (tableView == self.firstTableView) {
    //        TicketGroup *kind = self.groups[indexPath.row];
    //        cell.textLabel.font = JXFont(13.0f);
    //        cell.textLabel.text = kind.name;
    //
    //        if ([kind.name isEqualToString:@"20元票"]) {
    //            cell.imageView.image = JXImageWithName(@"cwl2.0_catgory_list_20yuan");
    //        }else if ([kind.name isEqualToString:@"2元票"]) {
    //            cell.imageView.image = JXImageWithName(@"cwl2.0_catgory_list_2yuan");
    //        }else if ([kind.name isEqualToString:@"10元票"]) {
    //            cell.imageView.image = JXImageWithName(@"cwl2.0_catgory_list_10yuan");
    //        }else if ([kind.name isEqualToString:@"特色票种"]) {
    //            cell.imageView.image = JXImageWithName(@"cwl2.0_catgory_list_tese");
    //        }else if ([kind.name isEqualToString:@"5元票"]) {
    //            cell.imageView.image = JXImageWithName(@"cwl2.0_catgory_list_5yuan");
    //        }else if ([kind.name isEqualToString:@"新上市票种"]) {
    //            cell.imageView.image = JXImageWithName(@"cwl2.0_catgory_list_new");
    //        }else if ([kind.name isEqualToString:@"热门票"]) {
    //            cell.imageView.image = JXImageWithName(@"cwl2.0_catgory_list_hot");
    //        }else {
    //            cell.imageView.image = JXImageWithName(@"cwl2.0_catgory_list_tese");
    //        }
    //
    //        // cell.imageView.image = JXImageWithName(@"cwl2.0_catgory_list_5yuan");
    //        //        cell.imageView.image = [JXImageWithName(@"ic_ticket_category") scaleToSize:self.imgSize usingMode:NYXResizeModeScaleToFill];
    //
    //        if (kind.selected) {
    //            cell.backgroundColor = JXColorHex(0xDADD2F);
    //            cell.textLabel.textColor = kColorTextDark; // kColorMain;
    //        }else {
    //            cell.backgroundColor = [UIColor whiteColor];
    //            cell.textLabel.textColor = kColorTextDark;
    //        }
    //
    //        //        if (kind.option.count == 0) {
    //        //            cell.accessoryType = UITableViewCellAccessoryNone;
    //        //        }else {
    //        //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //        //        }
    //
    //        return cell;
    //    }else if (tableView == self.secondTableView) {
    //        TicketGroup *kind = self.groups[self.firstIndex];
    //        Ticket *child = kind.option[indexPath.row];
    //        cell.backgroundColor = JXColorHex(0xEEEEEE);
    //        cell.textLabel.font = JXFont(15.0f);
    //        cell.textLabel.text = child.name;
    //
    //        cell.imageView.image = [JXImageWithName(@"ic_ticket_item") scaleToSize:self.imgSize usingMode:NYXResizeModeScaleToFill];
    //        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:JXURLWithStr(child.imgUrl) options:0 progress:NULL completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
    //            if (image) {
    //                cell.imageView.image = [image scaleToSize:self.imgSize usingMode:NYXResizeModeScaleToFill];
    //            }
    //        }];
    //
    //        //        if (child.selected) {
    //        //            cell.accessoryType = UITableViewCellAccessoryCheckmark;
    //        //            cell.textLabel.textColor = kColorMain;
    //        //        }else {
    //        //            cell.accessoryType = UITableViewCellAccessoryNone;
    //        //            cell.textLabel.textColor = kColorTextDark;
    //        //        }
    //
    //        return cell;
    //    }
    
    //    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.firstTableView) {
        return 0;
    }
    
    if ([Util isMedicineWithSearchClassify:self.classify]) {
        return JXScreenScale(30);
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.firstTableView) {
        return nil;
    }
    
    if ([Util isMedicineWithSearchClassify:self.classify]) {
        UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kJXIdentifierHeaderFooter];
        CompClassifyCoverView *coverView = [header viewWithTag:101];
        if (!coverView) {
            coverView = [[[NSBundle mainBundle] loadNibNamed:@"CompClassifyCoverView" owner:nil options:nil] firstObject];
            coverView.tag = 101;
            //coverView.backgroundColor = [UIColor whiteColor];
            [header addSubview:coverView];
            [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(header);
            }];
        }
        //header.contentView.backgroundColor = [UIColor whiteColor];
        
        CompClassify *c = self.items[self.selectedIndex];
        CompClassifyData1 *d = c.datas[section];
        coverView.textLabel.text = d.typeName;
        // [coverView.textLabel sizeToFit];
        
        
        //[header.textLabel sizeToFit];
        // coverView.textLabel.frame = CGRectMake(coverView.textLabel.jx_x, coverView.textLabel.jx_y, coverView.textLabel.jx_width + 100, coverView.textLabel.jx_height);
        //    header.textLabel.backgroundColor = JXColorHex(0xE6E6E6);
        //    header.textLabel.textColor = JXColorHex(0x00BFFE);
        //    header.textLabel.font = JXFont(10);
        
        return header;
    }
    
    return nil;
}

//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
//    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//    header.textLabel.backgroundColor = JXColorHex(0xE6E6E6);
//    header.textLabel.textColor = JXColorHex(0x00BFFE);
//    header.textLabel.font = JXFont(10);
//    //header.textLabel.textAlignment = NSTextAlignmentCenter;
//}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.firstTableView) {
        self.selectedIndex = indexPath.row;
        [self.firstTableView reloadData];
        [self.secondTableView reloadData];
        return;
    }
    
    if (![Util isMedicineWithSearchClassify:self.classify]) {
        CompClassify *c = self.items[self.selectedIndex];
        CompClassifyData1 *data = c.datas[indexPath.row];
        data.selected = !data.selected;
        if (0 != data.typeName.length) {
            if (data.selected) {
                [self.selectedArray addObject:data.typeName];
            }else {
                [self.selectedArray removeObject:data.typeName];
            }
        }
        
        BOOL changed = NO;
        if (0 == self.selectedArray.count) {
            if (0 != self.heightConstraint.constant) {
                self.heightConstraint.constant = 0;
                changed = YES;
            }
        }else {
            if (JXScreenScale(44) != self.heightConstraint.constant) {
                self.heightConstraint.constant = JXScreenScale(44);
                changed = YES;
            }
        }
        
        if (changed) {
            self.selectButton.hidden = NO;
            
            [self.view setNeedsUpdateConstraints];
            [self.view updateConstraintsIfNeeded];
            [UIView animateWithDuration:0.25 animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                if (self.heightConstraint.constant == 0) {
                    self.selectButton.hidden = YES;
                }
            }];
        }
        
        [self.secondTableView reloadData];
    }else {
        CompClassify *c = self.items[self.selectedIndex];
        CompClassifyData1 *data1 = c.datas[indexPath.section];
        CompClassifyData2 *data2 = data1.datas[indexPath.row];
        CompResultItem *i = [CompResultItem new];
        i.dId = data2.uid.integerValue;
        i.dName = data2.drugName;
        
        CompResultBrandViewController *vc = [[CompResultBrandViewController alloc] init];
        // vc.item = i;
        vc.dId = data2.uid.integerValue;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return nil;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.error) {
        return nil;
    }
    
    return [NSMutableAttributedString jx_attributedStringWithString:self.error.localizedDescription color:JXColorHex(0x999999) font:JXFont(15.0f)];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (!self.error) {
        return nil;
    }
    
    NSString *title = kStringReload;
    if (JXErrorCodeTokenInvalid == self.error.code) {
        title = kStringReLogin;
    }else if (JXErrorCodeDataEmpty == self.error.code) {
        title = kStringRefresh;
    }
    
    return [NSMutableAttributedString jx_attributedStringWithString:[self.error jx_retryTitle] color:(UIControlStateNormal == state ? [UIColor whiteColor] : [[UIColor whiteColor] colorWithAlphaComponent:0.8]) font:JXFont(15.0f)];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    UIImage *image = JXImageWithColor(JXInstance.mainColor);
    image = [image scaleToSize:CGSizeMake(100, 34.0f) usingMode:NYXResizeModeScaleToFill];
    image = [image jx_makeRadius:2.0f];
    return [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(-10.0, -90.0, -10.0, -90.0)];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.error) {
        return JXImageWithName(@"jxres_loading");
    }
    
    return [self.error jx_reasonImage];
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor whiteColor];
}

#pragma mark DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return 0 == self.items.count;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return (nil == self.error);
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    //    self.error = nil;
    //    [self.listCommand execute:nil];
    // self.items = @[];
    self.error = nil;
    [self.listCommand execute:@(self.classify)];
}

#pragma mark - Public methods
#pragma mark - Class methods


@end
