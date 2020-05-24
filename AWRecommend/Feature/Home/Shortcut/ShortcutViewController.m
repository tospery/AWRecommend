//
//  ShortcutViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/18.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ShortcutViewController.h"
#import "BrandViewController.h"
#import "ResultViewController.h"
#import "FilterCell.h"
#import "ShortcutSymptomRequest.h"

#define lShortcutClassifyViewTag         (100000)

@interface ShortcutViewController () <UITableViewDataSource, UITableViewDelegate, JXClassifyViewDataSource>
@property (nonatomic, weak) IBOutlet HMSegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UIView *separatorView;

@property (nonatomic, weak) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, weak) IBOutlet UIView *mainContentView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *mainWidthConstraint;
@property (nonatomic, assign) CGFloat mainScrollViewHeight;
@property (nonatomic, assign) BOOL isMainHScrolling;

@property (nonatomic, strong) NSMutableArray *tableViews;
@property (nonatomic, strong) NSMutableArray *classifyViews;
@property (nonatomic, strong) NSMutableArray *selectedSymptoms;

@property (nonatomic, strong) UITableView *preTableView;

// @property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@end

@implementation ShortcutViewController
#pragma mark - Override
#pragma mark init
- (instancetype)init {
    if (self = [super init]) {
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
//        self.shouldPullToRefresh = YES;
    }
    return self;
}

#pragma mark view
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVar];
    [self setupView];
    [self setupNet];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
//    //[self.separatorView jx_addGradientLayerWithColors:@[(id)[UIColor redColor].CGColor, (id)[UIColor whiteColor].CGColor]];
//    
//    //  创建 CAGradientLayer 对象
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    
//    //  设置 gradientLayer 的 Frame
//    gradientLayer.frame = self.separatorView.bounds;
//    
//    //  创建渐变色数组，需要转换为CGColor颜色
//    gradientLayer.colors = @[(id)[UIColor redColor].CGColor,
//                             (id)[UIColor whiteColor].CGColor];
//    
//    //  设置三种颜色变化点，取值范围 0.0~1.0
//    gradientLayer.locations = @[@(0.2f)];
//    
//    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(0, 1);
//    
//    //  添加渐变色到创建的 UIView 上去
//    [self.separatorView.layer addSublayer:gradientLayer];
}

#pragma mark setupr
- (void)setupVar {
    self.tableViews = [NSMutableArray array];
    self.classifyViews = [NSMutableArray array];
    self.selectedSymptoms = [NSMutableArray array];
}

- (void)setupView {
    self.navigationItem.title = ShortcutTypeString(self.type);
    
    if (ShortcutTypeSymptom == self.type) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(okItemPressed:)];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    
    //self.separatorView.backgroundColor = [UIColor darkGrayColor];
    
//    UINib *nib = [UINib nibWithNibName:@"JXCell" bundle:nil];
//    [self.tableView registerNib:nib forCellReuseIdentifier:[JXCell identifier]];
//    self.tableView.tableFooterView = [UIView new];
    
    
    // _segmentedControl = [[HMSegmentedControl alloc] init];
    //_segmentedControl.backgroundColor = [UIColor whiteColor];
    
    //_segmentedControl.sectionImages = @[JXImageWithName(@"img_adult"), JXImageWithName(@"img_children"), JXImageWithName(@"img_man")];
    
    self.segmentedControl.type = HMSegmentedControlTypeTextImages;
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : JXColorHex(0x999999), NSFontAttributeName: JXFont(13.0f)};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : kColorGreenDark, NSFontAttributeName: JXFont(13.0f)};
    self.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.selectionIndicatorColor = SMInstance.mainColor;
    self.segmentedControl.selectionIndicatorHeight = 2.0f;
    self.segmentedControl.borderType = HMSegmentedControlBorderTypeNone;
    self.segmentedControl.borderWidth = 0;
    
    @weakify(self)
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        @strongify(self)
//        if (NO == self.onceToken && 1 == index) {
//            self.onceToken = YES;
//            [self requestGetOrderMessagesWithMode:JXWebModeLoad];
//        }
        
        if (ShortcutTypeSymptom == self.type) {
            //[self.selectedSymptoms removeAllObjects];
            //self.navigationItem.rightBarButtonItem.enabled = NO;
            
//            for (JXClassifyView *cv in self.classifyViews) {
//                [cv reloadData];
//            }
            
            JXClassifyView *cv = self.classifyViews[index];
            UITableView *tv = (UITableView *)[cv mainView];
            [tv reloadData];
        }
        
        [self.mainScrollView scrollRectToVisible:CGRectMake(JXScreenWidth * index, 0, JXScreenWidth, self.mainScrollViewHeight) animated:YES];
    }];
    
//    _segmentedControl.borderType = HMSegmentedControlBorderTypeLeft;
//    _segmentedControl.borderColor = [UIColor redColor];
//    _segmentedControl.borderWidth = 4.0f;
    
    //_segmentedControl.backgroundColor = SMInstance.mainColor; // [UIColor whiteColor];
}

- (void)setupNet {
    
}

#pragma mark scroll
- (void)bindViewModel {
    [super bindViewModel];
    
//    if (ShortcutTypeSymptom == self.type) {
//        RAC(self.navigationItem.rightBarButtonItem, enabled) = RACObserve(self.selectedSymptoms, count);
//    }
    
    
    // RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    
    @weakify(self)
    RAC(self, dataSource) = [[requestRemoteDataSignal deliverOnMainThread] map:^id _Nullable(NSArray *result) {
        @strongify(self)
        if (ShortcutTypeSymptom == self.type) {
            [self handleDataSourceForSymptom:result];
        }else {
            [self handleDataSourceForName:result];
        }
        
        return JXArrEmpty(result, nil);
    }];
}

- (id)fetchLocalData {
    return nil;
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    //return [HRInstance requestDhzyDaibanListWithPage:1];
    if (ShortcutTypeSymptom == self.type) {
        return [HRInstance searchThroughDisease];
    }
    
    return [HRInstance searchThroughDrug];
}

- (void)reloadData {
    [super reloadData];
    
    for (UITableView *tv in self.tableViews) {
        [tv reloadData];
    }
    
    for (JXClassifyView *cv in self.classifyViews) {
        [cv reloadData];
    }
}

#pragma mark table
//- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
//    return [JXCell height];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath object:(id)object {
//    return [tableView dequeueReusableCellWithIdentifier:[JXCell identifier] forIndexPath:indexPath];
//}
//
//- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
//    JXCell *myCell = (JXCell *)cell;
//    myCell.data = object;
//}

#pragma mark - Accessor
- (CGFloat)mainScrollViewHeight {
    if (0 == _mainScrollViewHeight) {
        _mainScrollViewHeight = JXScreenHeight - 64 - JXAdaptScreen(71);
    }
    return _mainScrollViewHeight;
}

#pragma mark - Private
- (void)handleDataSourceForName:(NSArray *)result {
    NSInteger count = result.count;
    self.mainWidthConstraint.constant = JXScreenWidth * (count - 1);
    
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray *uimages = [NSMutableArray arrayWithCapacity:count];
    
    for (NSInteger i = 0; i < count; ++i) {
        ShortcutName *sn = result[i];
        
        [titles addObject:sn.categoryName];
        
        UIImage *image = JXImageWithName(JXStrWithFmt(@"%@_selected", sn.categoryName));
        if (!image) {
            image = JXImageWithName(@"男性_selected");
        }
        UIImage *uimage = JXImageWithName(sn.categoryName);
        if (!uimage) {
            uimage = JXImageWithName(@"男性");
        }
        [images addObject:image];
        [uimages addObject:uimage];
        
        NSArray *keys = [sn.sortedDrugs.allKeys sortedArrayUsingSelector:@selector(compare:)];
        NSMutableArray *sections = [NSMutableArray arrayWithCapacity:keys.count];
        NSMutableArray *rows = [NSMutableArray arrayWithCapacity:keys.count];
        for (NSString *key in keys) {
            NSArray *arr = sn.sortedDrugs[key];
            if (0 != arr.count) {
                [sections addObject:key];
                [rows addObject:arr];
            }
        }
        
        if (0 == rows.count) {
            sn.error = [NSError jx_errorWithCode:JXErrorCodeDataEmpty];
        }
        sn.sections = sections;
        sn.rows = rows;
        
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.tag = i;
        tableView.dataSource = self;
        tableView.delegate = self;
        
        tableView.tableFooterView = [UIView new];
        tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        tableView.sectionIndexColor = JXColorHex(0x333333);
        //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [tableView registerClass:[JXCellDefault class] forCellReuseIdentifier:[JXCellDefault identifier]];
        [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kJXIdentifierHeaderFooter];
        
        [self.mainContentView addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mainContentView).offset(JXScreenWidth * i);
            make.top.equalTo(self.mainContentView);
            make.bottom.equalTo(self.mainContentView);
            make.width.equalTo(@(JXScreenWidth));
        }];
        
        [self.tableViews addObject:tableView];
    }
    
    self.segmentedControl.sectionTitles = titles;
    self.segmentedControl.sectionImages = uimages;
    self.segmentedControl.sectionSelectedImages = images;
    
    [self.segmentedControl setNeedsDisplay];
}

- (void)handleDataSourceForSymptom:(NSArray *)result {
    NSInteger count = result.count;
    self.mainWidthConstraint.constant = JXScreenWidth * (count - 1);
    
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray *uimages = [NSMutableArray arrayWithCapacity:count];
    
    for (NSInteger i = 0; i < count; ++i) {
        ShortcutSymptom *sn = result[i];
        
        [titles addObject:sn.categoryName];
        
        UIImage *image = JXImageWithName(JXStrWithFmt(@"%@_selected", sn.categoryName));
        if (!image) {
            image = JXImageWithName(@"男性_selected");
        }
        UIImage *uimage = JXImageWithName(sn.categoryName);
        if (!uimage) {
            uimage = JXImageWithName(@"男性");
        }
        [images addObject:image];
        [uimages addObject:uimage];
        
        if (0 == sn.disease.count) {
            sn.error = [NSError jx_errorWithCode:JXErrorCodeDataEmpty];
        }
        
        JXClassifyView *classifyView = [[JXClassifyView alloc] initWithFrame:CGRectMake(JXScreenWidth * i, 0, JXScreenWidth, self.mainScrollViewHeight) percent:0.32];
        classifyView.tag = i;
        classifyView.dataSource = self;
        classifyView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        classifyView.tableView.backgroundColor = JXColorHex(0xf3f3f3);
        
        [self.mainContentView addSubview:classifyView];
        [classifyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mainContentView).offset(JXScreenWidth * i);
            make.top.equalTo(self.mainContentView);
            make.bottom.equalTo(self.mainContentView);
            make.width.equalTo(@(JXScreenWidth));
        }];

        [self.classifyViews addObject:classifyView];
    }
    
    self.segmentedControl.sectionTitles = titles;
    self.segmentedControl.sectionImages = uimages;
    self.segmentedControl.sectionSelectedImages = images;
    
//    NSMutableArray *allLinks = [NSMutableArray arrayWithArray:links];
//    [allLinks addObjectsFromArray:ulinks];
//    
//    self.segmentedControl.sectionLinks = links;
//    self.segmentedControl.sectionSelectedLinks = ulinks;
    
    [self.segmentedControl setNeedsDisplay];
}

#pragma mark - Public
#pragma mark - Action
- (void)okItemPressed:(id)sender {
    if (0 == self.selectedSymptoms.count) {
        return;
    }
    
//    ResultViewController *vc = [[ResultViewController alloc] init];
//    NSMutableString *ms = [NSMutableString string];
//    //    for (CompClassify *c in self.dataSource) {
//    //        for (CompClassifyData1 *d in c.datas) {
//    //            if (d.selected) {
//    //                [ms appendString:d.typeName];
//    //                [ms appendString:@" "];
//    //            }
//    //        }
//    //    }
//    for (ShortcutSymptomListDisease *t in self.selectedSymptoms) {
//        NSArray *arr = [t.tag componentsSeparatedByString:@"---"];
//        [ms appendString:arr[1]];
//        [ms appendString:@" "];
//    }
//    [ms deleteCharactersInRange:NSMakeRange(ms.length - 1, 1)];
//    vc.keyword = ms;
//
//    ShortcutSymptom *sn = [(NSArray *)self.dataSource objectAtIndex:self.segmentedControl.selectedSegmentIndex];
//    vc.scope = sn.categoryName;
//
//    
//    [self.navigationController pushViewController:vc animated:YES];
    
    ResultViewController *vc = [[ResultViewController alloc] init];
    
    NSInteger selected = self.segmentedControl.selectedSegmentIndex;
    ShortcutSymptom *symptom = [self.dataSource objectAtIndex:selected];
    
    ShortcutSymptomRequest *request = [ShortcutSymptomRequest new];
    request.current = 1;
    request.size = 20;
    request.suitObjectId = [symptom.jxID integerValue];
    
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableString *ms = [NSMutableString string];
    
    for (ShortcutSymptomListDisease *d in self.selectedSymptoms) {
        ShortcutSymptomRequestParam *p = [ShortcutSymptomRequestParam new];
        p.id = [d.jxID integerValue];
        p.tag = d.tag;
        [arr addObject:p];
        
        [ms appendString:p.tag];
        [ms appendString:@" "];
    }
    request.params = arr;
    vc.symptomRequest = request;
    
    [ms deleteCharactersInRange:NSMakeRange(ms.length - 1, 1)];
    vc.keyword = ms;
    vc.scope = symptom.categoryName;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Notification
#pragma mark - Delegate
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (ShortcutTypeSymptom == self.type) {
        return 1;
    }
    
    ShortcutName *sn = [(NSArray *)self.dataSource objectAtIndex:tableView.tag];
    return sn.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (ShortcutTypeSymptom == self.type) {
        NSInteger tag = tableView.tag / lShortcutClassifyViewTag;
        JXClassifyView *cv = self.classifyViews[tag];
        ShortcutSymptom *sn = [(NSArray *)self.dataSource objectAtIndex:tag];
        ShortcutSymptomList *c = sn.disease[cv.selectedIndexPath.row];
        return c.disease.count;
    }
    
    ShortcutName *sn = [(NSArray *)self.dataSource objectAtIndex:tableView.tag];
    NSArray *rows = sn.rows[section];
    return rows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (ShortcutTypeSymptom == self.type) {
        return [FilterCell height];
    }
    
    return JXAdaptScreen(44);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (ShortcutTypeSymptom == self.type) {
        FilterCell *cell = [tableView dequeueReusableCellWithIdentifier:[FilterCell identifier] forIndexPath:indexPath];
        
        NSInteger tag = tableView.tag / lShortcutClassifyViewTag;
        JXClassifyView *cv = self.classifyViews[tag];
        ShortcutSymptom *sn = [(NSArray *)self.dataSource objectAtIndex:tag];
        ShortcutSymptomList *c = sn.disease[cv.selectedIndexPath.row];

        NSInteger row = indexPath.row;
        ShortcutSymptomListDisease *d = [c.disease objectAtIndex:row];
        //NSString *identifer = tableView.jxIdentifier;
        //NSString *selectedStr = JXStrWithFmt(@"%@---%@", identifer, d.tag);
        
        cell.data = RACTuplePack(@1, d, @([self.selectedSymptoms containsObject:d]));
        
        return cell;
    }
    
    JXCellDefault *cell = [tableView dequeueReusableCellWithIdentifier:[JXCellDefault identifier] forIndexPath:indexPath];
    
    ShortcutName *sn = [(NSArray *)self.dataSource objectAtIndex:tableView.tag];
    NSArray *rows = sn.rows[indexPath.section];
    NSDictionary *dict = rows[indexPath.row];
    
    ShortcutNameListItem *item = [ShortcutNameListItem mj_objectWithKeyValues:dict];
    cell.textLabel.text = item.drugName;
    cell.textLabel.font = JXFont(13);
    cell.textLabel.textColor = JXColorHex(0x666666);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (ShortcutTypeSymptom == self.type) {
        return nil;
    }
    
    ShortcutName *sn = [(NSArray *)self.dataSource objectAtIndex:tableView.tag];
    return sn.sections[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (ShortcutTypeSymptom == self.type) {
        return nil;
    }
    
    ShortcutName *sn = [(NSArray *)self.dataSource objectAtIndex:tableView.tag];
    return sn.sections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (ShortcutTypeSymptom == self.type) {
        return 0.0f;
    }
    
    return JXScreenScale(30);
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (ShortcutTypeSymptom == self.type) {
        return;
    }
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.backgroundView.backgroundColor = JXColorHex(0xE9E9E9);
    header.textLabel.textColor = JXColorHex(0x333333);
    header.textLabel.font = JXFont(15);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (ShortcutTypeSymptom == self.type) {
        
        if (tableView != self.preTableView) {
            [self.selectedSymptoms removeAllObjects];
            // [self.preTableView reloadData];
        }
        self.preTableView = tableView;
        
        NSInteger tag = tableView.tag / lShortcutClassifyViewTag;
        
        JXClassifyView *cv = self.classifyViews[tag];
        NSInteger ind = cv.selectedIndexPath.row;
        NSInteger row = indexPath.row;
        
        ShortcutSymptom *sn = [(NSArray *)self.dataSource objectAtIndex:tag];
        ShortcutSymptomList *c = sn.disease[ind];
        ShortcutSymptomListDisease *d = c.disease[row];
        
        //NSString *identifer = tableView.jxIdentifier;
        //NSString *name = JXStrWithFmt(@"%@---%@", identifer, d.tag);
        
        if ([self.selectedSymptoms containsObject:d]) {
            [self.selectedSymptoms removeObject:d];
        }else {
            [self.selectedSymptoms addObject:d];
        }
        
        // [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [tableView reloadData];
        
        //    BOOL hasSelect = NO;
        //    for (CompClassify *c in self.dataSource) {
        //        for (CompClassifyData1 *d in c.datas) {
        //            if (d.selected) {
        //                hasSelect = YES;
        //                break;
        //            }
        //        }
        //    }
        
        BOOL hasChange = NO;
        if (self.selectedSymptoms.count >= 1) {
            if (self.navigationItem.rightBarButtonItem.enabled == NO) {
                self.navigationItem.rightBarButtonItem.enabled = YES;
                hasChange = YES;
            }
        }else {
            if (self.navigationItem.rightBarButtonItem.enabled == YES) {
                self.navigationItem.rightBarButtonItem.enabled = NO;
                hasChange = YES;
            }
        }
        
//        if (hasChange) {
//            self.okButton.hidden = NO;
//            
//            [self.view setNeedsUpdateConstraints];
//            [self.view updateConstraintsIfNeeded];
//            [UIView animateWithDuration:0.25 animations:^{
//                [self.view layoutIfNeeded];
//            } completion:^(BOOL finished) {
//                if (self.heightConstraint.constant == 0) {
//                    self.okButton.hidden = YES;
//                }
//            }];
//        }
        
        return;
    }
    
    ShortcutName *sn = [(NSArray *)self.dataSource objectAtIndex:tableView.tag];
    NSArray *rows = sn.rows[indexPath.section];
    NSDictionary *dict = rows[indexPath.row];
    
    ShortcutNameListItem *i = [ShortcutNameListItem mj_objectWithKeyValues:dict];
    
    CompResultItem *item = [CompResultItem new];
    item.dId = i.jxID.integerValue;
    item.dName = i.drugName;
    
    BrandViewController *vc = [[BrandViewController alloc] init];
    vc.dataSource = item;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark JXClassifyViewDataSource
- (NSInteger)totalClassifiesWithClassifyView:(JXClassifyView *)classifyView {
    // return self.dataSource.count;
    
    ShortcutSymptom *sn = [(NSArray *)self.dataSource objectAtIndex:classifyView.tag];
    return sn.disease.count;
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
    
    //CompClassify *c = self.dataSource[indexPath.row];
    //cell.textLabel.text = c.drugCategoryName;
    // FilterSymptom *c = self.dataSource[indexPath.row];
    ShortcutSymptom *sn = [(NSArray *)self.dataSource objectAtIndex:classifyView.tag];
    ShortcutSymptomList *c = sn.disease[indexPath.row];
    
    NSMutableAttributedString *as = [NSMutableAttributedString jx_attributedStringWithString:c.drugCategoryName color:JXColorHex(0x333333) font:JXFont(13)];
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setLineSpacing:1];
    [as addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, as.length)];
    
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.attributedText = as;
}

- (UIView *)classifyView:(JXClassifyView *)classifyView viewForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    //tableView.backgroundView.tag = classifyView.tag;
    tableView.tag = classifyView.tag * lShortcutClassifyViewTag + indexPath.row;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    UINib *nib = [UINib nibWithNibName:@"FilterCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[FilterCell identifier]];
    [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kJXIdentifierHeaderFooter];
    
    return tableView;
}

- (NSString *)classifyView:(JXClassifyView *)classifyView identifierForRowAtIndexPath:(NSIndexPath *)indexPath {
    return JXStrWithFmt(@"%ld#%ld", self.segmentedControl.selectedSegmentIndex, indexPath.row);
}

- (void)classifyView:(JXClassifyView *)classifyView didChangeAtIndexPath:(NSIndexPath *)indexPath forView:(UIView *)view {
    [(UITableView *)view reloadData];
    //[self.selectedSymptoms removeAllObjects];
    //self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewWillBeginDecelerating: %@", NSStringFromCGPoint(scrollView.contentOffset));
//    
//    if (self.mainScrollView != scrollView) {
//        return;
//    }
//    
//    if (scrollView.contentOffset.x != 0 && scrollView.contentOffset.y == 0) {
//        self.isMainHScrolling = YES;
//    }else {
//        self.isMainHScrolling = NO;
//    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //NSLog(@"scrollViewDidEndDecelerating: %@", NSStringFromCGPoint(scrollView.contentOffset));
    
    if (self.mainScrollView != scrollView) {
        return;
    }
    
//    if (!self.isMainHScrolling) {
//        return;
//    }
    
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
//    if (NO == self.outToken && 1 == page) {
//        self.outToken = YES;
//        [self requestOutWithMode:JXWebModeLoad];
//    }else if (NO == self.inToken && 2 == page) {
//        self.inToken = YES;
//        [self requestInWithMode:JXWebModeLoad];
//    }
}

//- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
//    JXCellDefault *myCell = (JXCellDefault *)cell;
//    
//    //myCell.data = object;
//    FilterNameItem *item = [FilterNameItem mj_objectWithKeyValues:object];
//    myCell.textLabel.text = item.drugName;
//    myCell.textLabel.font = JXFont(14);
//    myCell.textLabel.textColor = JXColorHex(0x333333);
//    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [JXCellDefault height];
//}
//
//- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
//    return [self.tableView dequeueReusableCellWithIdentifier:[JXCellDefault identifier] forIndexPath:indexPath];
//}
//

#pragma mark - Class


@end
