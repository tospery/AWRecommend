//
//  FavoriteViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/23.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "FavoriteViewController3.h"
#import "FavoriteCell.h"
#import "FavoriteArticleCell.h"
#import "AlertViewController.h"
#import "MedicineViewController.h"
#import "NiceDetailViewController.h"

@interface FavoriteViewController3 () <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>
@property (nonatomic, strong) RACCommand *delCommand;
@property (nonatomic, strong) RACCommand *delArticleCommand;

@property (nonatomic, assign) BOOL isPageScrollingFlag;
@property (nonatomic, weak) IBOutlet HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) IBOutletCollection(UITableView) NSArray *tableViews;
@property (nonatomic, strong) NSMutableArray *remoteDatas;
@property (nonatomic, strong) NSMutableArray *requestErrors;

@property (nonatomic, assign) CGFloat scrollViewHeight;
@property (nonatomic, weak) IBOutlet UIScrollView *mainScrollView;

@end

@implementation FavoriteViewController3
#pragma mark - Override
#pragma mark init
- (instancetype)init {
    if (self = [super init]) {
        //self.shouldRequestRemoteDataOnViewDidLoad = YES;
        //self.shouldPullToRefresh = YES;
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

#pragma mark setup
- (void)setupVar {
    // self.isPageScrollingFlag = NO;
}

- (void)setupView {
    self.navigationItem.title = @"我的收藏";
    
    for (UITableView *tv in self.tableViews) {
        tv.emptyDataSetSource = self;
        tv.emptyDataSetDelegate = self;
    }
    
    //    NSString *title = @" 立即扫码";
    //    NSMutableAttributedString *mas = [NSMutableAttributedString jx_attributedStringWithString:title color:(UIControlStateNormal == state ? [UIColor whiteColor] : [[UIColor whiteColor] colorWithAlphaComponent:0.8]) font:JXFont(15.0f)];
    //
    //    UIImage *image = JXAdaptImage(JXImageWithName(@"ic_btn_add"));
    //    NSTextAttachment *att = [[NSTextAttachment alloc] init];
    //    att.bounds = CGRectMake(0, -JXAdaptScreen(4), image.size.width, image.size.height);
    //    att.image = image;
    //    [mas insertAttributedString:[NSAttributedString attributedStringWithAttachment:att] atIndex:0];
    
    // NSMutableAttributedString *yp = [NSMutableAttributedString jx_attributedStringWithString:@"药品" color:(UIControlStateNormal == state ? [UIColor whiteColor] : [[UIColor whiteColor] colorWithAlphaComponent:0.8]) font:JXFont(15.0f)];
    //    NSMutableAttributedString *yp = [NSMutableAttributedString jx_attributedStringWithString:@"药品" color:JXColorHex(0x999999) font:JXFont(15.0f)];
    //    UIImage *image = JXAdaptImage(JXImageWithName(@"ic_btn_add"));
    //    NSTextAttachment *att = [[NSTextAttachment alloc] init];
    //    att.bounds = CGRectMake(0, -JXAdaptScreen(4), image.size.width, image.size.height);
    //    att.image = image;
    //    [mas insertAttributedString:[NSAttributedString attributedStringWithAttachment:att] atIndex:0];
    
    
    self.segmentedControl.sectionTitles = @[@"良品", @"好价"];
//    self.segmentedControl.sectionImages = @[JXAdaptImage(JXImageWithName(@"collection_pills_disable")), JXAdaptImage(JXImageWithName(@"collection_product_disable"))];
//    self.segmentedControl.sectionSelectedImages = @[JXAdaptImage(JXImageWithName(@"collection_pills")), JXAdaptImage(JXImageWithName(@"collection_product"))];
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : JXColorHex(0x999999), NSFontAttributeName: JXFont(14.0f)};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : SMInstance.mainColor, NSFontAttributeName: JXFont(14.0f)};
    self.segmentedControl.type = HMSegmentedControlTypeText;
    //self.segmentedControl.selectionIndicatorColor = SMInstance.mainColor;
    self.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
//    self.segmentedControl.borderColor = [UIColor redColor];// JXColorHex(0xe1e1e1);
//    self.segmentedControl.borderType = HMSegmentedControlBorderTypeBottom;
//    self.segmentedControl.borderWidth = 1.0f;
    
    @weakify(self)
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        @strongify(self)
        //        if (NO == self.onceToken && 1 == index) {
        //            self.onceToken = YES;
        //            [self requestGetOrderMessagesWithMode:JXWebModeLoad];
        //        }
        UITableView *tv = self.tableViews[index];
        if (0 == [(NSString *)tv.jxIdentifier length]) {
            [self requestDataWithIndex:index page:1];
        }
        [self.mainScrollView scrollRectToVisible:CGRectMake(JXScreenWidth * index, 0, JXScreenWidth, self.scrollViewHeight) animated:YES];
    }];
    
    //    UINib *nib = [UINib nibWithNibName:@"JXCell" bundle:nil];
    //    [self.tableView registerNib:nib forCellReuseIdentifier:[JXCell identifier]];
    //    self.tableView.tableFooterView = [UIView new];
    
    UINib *nib = [UINib nibWithNibName:@"FavoriteCell" bundle:nil];
    UITableView *tv = (UITableView *)self.tableViews[0];
    [tv registerNib:nib forCellReuseIdentifier:[FavoriteCell identifier]];
    tv.tableFooterView = [UIView new];
    
    nib = [UINib nibWithNibName:@"FavoriteArticleCell" bundle:nil];
    tv = (UITableView *)self.tableViews[1];
    [tv registerNib:nib forCellReuseIdentifier:[FavoriteArticleCell identifier]];
    tv.tableFooterView = [UIView new];
}

- (void)setupNet {
    [self requestDataWithIndex:0 page:1];
}

#pragma mark scroll
- (void)bindViewModel {
    [super bindViewModel];
    
    // RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    //    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    //    RAC(self, dataSource) = [[requestRemoteDataSignal deliverOnMainThread] map:^id _Nullable(HTTPResponseList *list) {
    //        return JXArrTable(list);
    //    }];
}

//- (id)fetchLocalData {
//    return nil;
//}
//
//- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
//    switch (self.segmentedControl.selectedSegmentIndex) {
//        case 0: {
//            return [[HRInstance findDrugFavoriteList] takeUntil:self.rac_willDeallocSignal];
//            break;
//        }
//        case 1: {
//            return [[HRInstance findDrugFavoriteList] takeUntil:self.rac_willDeallocSignal];
//            break;
//        }
//        default:
//            break;
//    }
//    return [RACSignal empty];
//}
//
//- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter {
//    return ^(NSError *error) {
//        NSString *a = error.jxIdentifier;
//        return YES;
//    };
//}
//
//- (void)catchError:(NSError *)error {
//    NSString *a = error.jxIdentifier;
//
//    int b = 0;
//    // [super catchError:error];
//    // [self.requestErrors replaceObjectAtIndex:self.segmentedControl.selectedSegmentIndex withObject:<#(nonnull id)#>]
//}
//
//- (void)reloadData {
//    [super reloadData];
//}

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
- (NSMutableArray *)requestErrors {
    if (!_requestErrors) {
        _requestErrors = [NSMutableArray arrayWithCapacity:self.tableViews.count];
        for (NSInteger i = 0; i < self.tableViews.count; ++i) {
            [_requestErrors addObject:[NSError jx_errorWithCode:JXErrorCodePlaceholder]];
        }
    }
    return _requestErrors;
}

- (NSMutableArray *)remoteDatas {
    if (!_remoteDatas) {
        _remoteDatas = [NSMutableArray arrayWithCapacity:self.tableViews.count];
        for (NSInteger i = 0; i < self.tableViews.count; ++i) {
            [_remoteDatas addObject:@[]];
        }
    }
    return _remoteDatas;
}

- (CGFloat)scrollViewHeight {
    if (!_scrollViewHeight) {
        _scrollViewHeight = JXAdaptScreenHeight() - 64 - JXAdaptScreen(40);
    }
    return _scrollViewHeight;
}

- (RACCommand *)delCommand {
    if (!_delCommand) {
        _delCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *t) {
            // return [HRInstance deleteDrugFavorite:([(NSNumber *)input integerValue])];
            return [HRInstance removeGoodsCollect:[(NSNumber *)t.first integerValue] sceneId:[(NSNumber *)t.second integerValue]];
        }];
        
        //        [_delCommand.executing subscribe:self.executing];
        //        [_delCommand.errors subscribe:self.errors];
        
        //@weakify(self)
        [_delCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *items) {
            //@strongify(self)
        }];
    }
    return _delCommand;
}

- (RACCommand *)delArticleCommand {
    if (!_delArticleCommand) {
        _delArticleCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance collectArticle:([(NSNumber *)input integerValue])];
        }];
        
        //        [_delCommand.executing subscribe:self.executing];
        //        [_delCommand.errors subscribe:self.errors];
        
        //@weakify(self)
        [_delArticleCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *items) {
            //@strongify(self)
        }];
    }
    return _delArticleCommand;
}


// remoteDatas

#pragma mark - Private
- (void)requestDataWithIndex:(NSInteger)index page:(NSInteger)page {
    [self.requestErrors replaceObjectAtIndex:index withObject:[NSError jx_errorWithCode:JXErrorCodePlaceholder]];
    UITableView *tableView = self.tableViews[index];
    if (0 == [(NSString *)tableView.jxIdentifier length]) {
        tableView.jxIdentifier = JXStrWithInt(index);
    }
    [tableView reloadData];
    
    switch (index) {
        case 0: {
            [[HRInstance listGoodsCollect/*findDrugFavoriteList*/] subscribeNext:^(NSArray *items) {
                if ([items isKindOfClass:[NSArray class]]) {
                    [self.remoteDatas replaceObjectAtIndex:index withObject:items];
                }
                if([(NSArray *)self.remoteDatas[0] count] == 0) {
                    [self.requestErrors replaceObjectAtIndex:index withObject:[NSError jx_errorWithCode:JXErrorCodeDataEmpty]];
                }else {
                    [self.requestErrors replaceObjectAtIndex:index withObject:[NSError jx_errorWithCode:JXErrorCodePlaceholder]];
                }
                [(UITableView *)self.tableViews[index] reloadData];
            } error:^(NSError * _Nullable error) {
                [gUser checkLoginWithFinish:^(BOOL isRelogin) {
                    if (isRelogin) {
                        [self requestDataWithIndex:index page:page];
                    }
                } error:error];
                
                [self.requestErrors replaceObjectAtIndex:index withObject:error];
                [(UITableView *)self.tableViews[index] reloadData];
            }];
            break;
        }
        case 1: {
            [[HRInstance showCollectionList:page] subscribeNext:^(FavoriteArticleList *list) {
                if ([list.datas isKindOfClass:[NSArray class]]) {
                    [self.remoteDatas replaceObjectAtIndex:index withObject:list.datas];
                }
                if([(NSArray *)self.remoteDatas[1] count] == 0) {
                    [self.requestErrors replaceObjectAtIndex:index withObject:[NSError jx_errorWithCode:JXErrorCodeDataEmpty]];
                }else {
                    [self.requestErrors replaceObjectAtIndex:index withObject:[NSError jx_errorWithCode:JXErrorCodePlaceholder]];
                }
                [(UITableView *)self.tableViews[index] reloadData];
            } error:^(NSError * _Nullable error) {
                [gUser checkLoginWithFinish:^(BOOL isRelogin) {
                    if (isRelogin) {
                        [self requestDataWithIndex:index page:page];
                    }
                } error:error];
                
                [self.requestErrors replaceObjectAtIndex:index withObject:error];
                [(UITableView *)self.tableViews[index] reloadData];
            }];
            break;
        }
        default:
            break;
    }
}

- (NSArray *)rightButtons {
    NSMutableArray *buttons = [NSMutableArray new];
    
//    [buttons sw_addUtilityButtonWithColor: [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
//                                    title:@"删除"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = JXColorHex(0xF5F5F5);
    [btn setImage:JXAdaptImage(JXImageWithName(@"ic_delete")) forState:UIControlStateNormal];
    [buttons addObject:btn];
    
    return buttons;
}

#pragma mark - Public
#pragma mark - Action
#pragma mark - Notification
#pragma mark - Delegate
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    self.isPageScrollingFlag = YES;
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    self.isPageScrollingFlag = NO;
//
//    //    CGFloat pageWidth = scrollView.frame.size.width;
//    //    NSInteger page = scrollView.contentOffset.x / pageWidth;
//    // JXLogDebug(@"page = %@", @(self.currentPageIndex));
//    //    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
//    if (self.currentPageIndex != self.segmentedControl.selectedSegmentIndex) {
//        [self.segmentedControl setSelectedSegmentIndex:self.currentPageIndex animated:YES];
//    }
//}

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
    UITableView *tv = self.tableViews[page];
    if (0 == [(NSString *)tv.jxIdentifier length]) {
        [self requestDataWithIndex:page page:1];
    }
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *items = self.remoteDatas[tableView.tag];
     return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *items = self.remoteDatas[tableView.tag];
    
    if (0 == tableView.tag) {
        FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:[FavoriteCell identifier] forIndexPath:indexPath];
        cell.data = items[indexPath.row];
        cell.delegate = self;
        cell.rightUtilityButtons = [self rightButtons];
        return cell;
    }else {
        FavoriteArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:[FavoriteArticleCell identifier] forIndexPath:indexPath];
        cell.data = items[indexPath.row];
        cell.delegate = self;
        cell.rightUtilityButtons = [self rightButtons];
        return cell;
    }
    
    return nil;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == tableView.tag) {
        return [FavoriteCell height];
    }
    
    return [FavoriteArticleCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == tableView.tag) {
        FavoriteLP *f = [self.remoteDatas[0] objectAtIndex:indexPath.row];
        
        NSString *link = JXStrWithFmt(kGoodsDetailLink, f.goodsId, f.sceneId);
        
        AWWebViewController *vc = [[AWWebViewController alloc] initWithURL:JXURLWithStr(link) title:@"商品详情"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.navItemColor = JXColorHex(0x333333);
        vc.statusBarStyle = JXStatusBarStyleDefault;
        [self.navigationController pushViewController:vc animated:YES];
        
//        CompResultBrand *b = [CompResultBrand new];
//        b.brandId = f.brandId.integerValue;
//        b.brandName = f.brandName;
//        b.drugName = f.drugName;
//
//        MedicineViewController *vc = [MedicineViewController medicineNCWithDataSource:b];
//        [self.navigationController presentViewController:vc animated:YES completion:NULL];
    }else {
        FavoriteArticle *f = [self.remoteDatas[1] objectAtIndex:indexPath.row];
        
        NiceDetailViewController *vc = [[NiceDetailViewController alloc] init];
        vc.navItemColor = JXColorHex(0x333333);
        vc.statusBarStyle = JXStatusBarStyleDefault;
        vc.niceID = f.jxID.integerValue;
        vc.shareIcon = f.tileImage;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - SWTableViewDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state {
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            NSInteger selectIndex = self.segmentedControl.selectedSegmentIndex;
            
            AlertViewController *vc = [[AlertViewController alloc] init];
            vc.message = @"您是否确认删除该收藏？";
            if (1 == selectIndex) {
                vc.message = @"您是否确认删除该文章？";
            }
            vc.didOkBlock = ^(NSInteger ok) {
                if (ok) {
                    //                    NSArray *arr = [TMInstance objectForKey:kTMCompFavorite];
                    //                    NSMutableArray *ma = [NSMutableArray arrayWithArray:arr];
                    //                    [ma removeObject:[(FavoriteCell *)cell data]];
                    //                    [TMInstance setObject:ma forKey:kTMCompFavorite];
                    //
                    //                    self.dataSource = @[JXArrValue(ma, [NSArray new])];
                    
                    id r = (selectIndex == 0) ? [(FavoriteCell *)cell data] : [(FavoriteArticleCell *)cell data];
                    if (0 == selectIndex) {
                        FavoriteLP *obj = (FavoriteLP *)r;
                        //[self.delCommand execute:@(obj.brandId.integerValue)];
                        [self.delCommand execute:RACTuplePack(@(obj.goodsId), @(obj.sceneId))];
                    }else {
                        FavoriteArticle *obj = (FavoriteArticle *)r;
                        [self.delArticleCommand execute:@(obj.jxID.integerValue)];
                    }
                    
                    NSArray *items = self.remoteDatas[selectIndex];
                    NSMutableArray *ma = [NSMutableArray arrayWithArray:items];
                    [ma removeObject:r];
                    
                    if (ma.count == 0) {
                        // self.error = [NSError jx_errorWithCode:JXErrorCodeDataEmpty];
                        [self.requestErrors replaceObjectAtIndex:selectIndex withObject:[NSError jx_errorWithCode:JXErrorCodeDataEmpty]];
                    }
                    [self.remoteDatas replaceObjectAtIndex:selectIndex withObject:ma];
                    [(UITableView *)self.tableViews[selectIndex] reloadData];
                    // self.dataSource = JXArrTable(ma);
                }
                [self jx_dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeBounceOut];
            };
            [self jx_presentPopupViewController:vc animationType:JXPopupShowTypeBounceIn layout:JXPopupLayoutCenter bgTouch:NO dismissed:^{
                
            }];
            
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return NO;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    return YES;
}

#pragma mark DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return nil;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSError *error = self.requestErrors[scrollView.tag];
    if (error.code == JXErrorCodePlaceholder) {
        return nil;
    }
    
    if (error.code == JXErrorCodeDataEmpty) {
        return [NSMutableAttributedString jx_attributedStringWithString:@"收藏空空如也~" color:JXColorHex(0x999999) font:JXFont(15.0f)];
    }
    
    NSString *title = JXStrWithDft(self.error.localizedDescription, kStringDataEmpty);
    return [NSMutableAttributedString jx_attributedStringWithString:title color:JXColorHex(0x999999) font:JXFont(15.0f)];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSError *error = self.requestErrors[scrollView.tag];
    if (error.code == JXErrorCodePlaceholder) {
        return nil;
    }
    
    if (error.code == JXErrorCodeDataEmpty) {
        return nil;
    }
    
    NSString *title = JXStrWithDft([self.error jx_retryTitle], kStringReload);
    return [NSMutableAttributedString jx_attributedStringWithString:title color:(UIControlStateNormal == state ? [UIColor whiteColor] : [[UIColor whiteColor] colorWithAlphaComponent:0.8]) font:JXFont(15.0f)];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    UIImage *image = JXImageWithColor(JXInstance.mainColor);
    image = [image scaleToSize:CGSizeMake(JXAdaptScreen(120), JXAdaptScreen(30)) usingMode:NYXResizeModeScaleToFill];
    image = [image jx_makeRadius:JXAdaptScreen(2.0)];
    
    CGFloat slide = JXAdaptValue(-84, -96, -106);
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, slide, 0, slide)];
    
    return image;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    NSError *error = self.requestErrors[scrollView.tag];
    if (error.code == JXErrorCodePlaceholder) {
        return JXImageWithName(@"jxres_loading");
    }
    
    if (error.code == JXErrorCodeDataEmpty) {
        return JXAdaptImage(JXImageWithName(@"img_null"));
    }
    
    return JXObjWithDft([self.error jx_reasonImage], JXImageWithName(@"jxres_error_empty"));
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    
    return animation;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor whiteColor];
}

#pragma mark DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    NSString *identifier = scrollView.jxIdentifier;
    NSInteger tag = scrollView.tag;
    if (0 == [(NSString *)scrollView.jxIdentifier length]) {
        return NO;
    }
    
    NSArray *items = self.remoteDatas[scrollView.tag];
    return items.count == 0;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    NSError *error = self.requestErrors[scrollView.tag];
    return error.code == JXErrorCodePlaceholder;
}

//- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
//    //[self.requestRemoteDataCommand execute:@(JXInstance.pageIndex)];
//    //[self triggerLoad];
//
////    if (JXErrorCodeTokenInvalid == self.error.code) {
////        [self checkLoginWithError:nil finish:^{
////            [self triggerLoad];
////        }];
////    }else {
////        [self triggerLoad];
////    }
//    [self retryLoad];
//}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    //[self.requestRemoteDataCommand execute:@(JXInstance.pageIndex)];
    //[self triggerLoad];
    
    //    if (JXErrorCodeTokenInvalid == self.error.code) {
    //        [self checkLoginWithError:nil finish:^{
    //            [self triggerLoad];
    //        }];
    //    }else {
    //        [self triggerLoad];
    //    }
    
    //    if (JXErrorCodeTokenInvalid == self.error.code) {
    //        [gUser checkLoginWithFinish:^{
    //            [self triggerLoad];
    //        } error:nil];
    //    }else if (JXErrorCodeDataEmpty == self.error.code) {
    //        [self triggerLoad];
    //    }else if (JXErrorCodeNetworkException == self.error.code) {
    //        [self triggerLoad];
    //    }else {
    //        [self triggerLoad];
    //    }
    
    //    if (JXErrorCodeTokenInvalid == self.error.code) {
    //        [gUser checkLoginWithFinish:^{
    //            [self triggerLoad];
    //        } error:nil];
    //    }else if (<#expression#>)
    //
    //    else {
    //        [self triggerLoad];
    //    }
    
    //[self handleError:self.error];
    [self requestDataWithIndex:scrollView.tag page:1];
}




#pragma mark - Class

@end
