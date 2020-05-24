//
//  JXTableViewController.m
//  JXSamples
//
//  Created by 杨建祥 on 16/4/23.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXTableViewController2.h"

@interface JXTableViewController2 ()
@property (nonatomic, copy) NSString *navTitle;

//@property (nonatomic, strong) JXPage *page;
@property (nonatomic, assign, readwrite) NSUInteger page;
//@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, weak, readwrite) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak, readwrite) IBOutlet UITableView *tableView;

@property (nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;

@end

@implementation JXTableViewController2
#pragma mark - Override
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.isLoading = YES;
    
    [self.tableView registerClass:[JXCellDefault class] forCellReuseIdentifier:[JXCellDefault identifier]];
    [self.tableView registerClass:[JXCellValue1 class] forCellReuseIdentifier:[JXCellValue1 identifier]];
    // self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kJXIdentifierHeaderFooter];
    
    @weakify(self)
    if (self.shouldRequestRemoteDataOnViewDidLoad) {
        [[self rac_signalForSelector:@selector(bindViewModel)] subscribeNext:^(id x) {
            @strongify(self)
            if (0 != [(NSMutableArray *)self.dataSource.firstObject count]) {
                [self triggerUpdate];
            }else {
                [self triggerLoad];
            }
        }];
    }
    
//    if (self.shouldPullToRefresh) {
//        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(triggerRefresh)];
//    }
//    
//    if (self.shouldInfiniteScrolling) {
//        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(triggerMore)];
//    }
}

- (void)setView:(UIView *)view {
    [super setView:view];
    
    if ([view isKindOfClass:UITableView.class]) {
        self.tableView = (UITableView *)view;
    }
}

- (void)dealloc {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self)
    
    [[RACObserve(self, dataSource) deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        [self reloadData];
    }];
    
//    if (self.shouldPullToRefresh) {
//        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(triggerRefresh)];
//    }
//    
//    if (self.shouldInfiniteScrolling) {
//        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(triggerMore)];
//    }
    
    [[RACObserve(self, shouldPullToRefresh) distinctUntilChanged] subscribeNext:^(NSNumber *should) {
        if (should.boolValue) {
            self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(triggerRefresh)];
        }else {
            [self.tableView.mj_header removeFromSuperview];
            self.tableView.mj_header = nil;
        }
    }];
    
    [[RACObserve(self, shouldInfiniteScrolling) distinctUntilChanged] subscribeNext:^(NSNumber *should) {
        if (should.boolValue) {
            self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(triggerMore)];
        }else {
            [self.tableView.mj_footer removeFromSuperview];
            self.tableView.mj_footer = nil;
        }
    }];
    
    
    //    [[self.requestRemoteDataCommand.executing skip:1] subscribeNext:^(NSNumber *executing) {
    //        @strongify(self)
    ////        UIView *emptyDataSetView = [self.tableView.subviews.rac_sequence objectPassingTest:^(UIView *view) {
    ////            return [NSStringFromClass(view.class) isEqualToString:@"DZNEmptyDataSetView"];
    ////        }];
    ////        emptyDataSetView.alpha = 1.0 - executing.floatValue;
    //        // self.isLoading = executing.boolValue;
    ////        if (!executing.boolValue) {
    ////            self.isLoading = NO;
    ////        }
    //    }];
    
    [self.requestRemoteDataCommand.executing subscribeNext:^(NSNumber *executing) {
        //        if ((JXRequestModeLoad == self.requestMode) &&
        //            (0 != [self.dataSource.firstObject count])) {
        //            JXHUDProcessing(@"正在更新");
        //        }
        
        //        int b = self.requestMode;
        //        id c = self.dataSource.firstObject;
        //        int a = 0;
        
    }];
    
    
    [[self.requestRemoteDataCommand.errors filter:[self requestRemoteDataErrorsFilter]] subscribe:self.errors];
    
    self.navTitle = self.navigationItem.title;
//    [RACObserve(self, requestMode) subscribeNext:^(NSNumber *requestMode) {
//        @strongify(self)
//        BOOL isUpdate = (JXRequestModeUpdate == requestMode.integerValue);
//        [self beginUpdate:isUpdate];
//    }];
}


#pragma mark - Accessor
- (void)setRequestMode:(JXRequestMode)requestMode {
    _requestMode = requestMode;
    
    if (JXRequestModeLoad == requestMode) {
        [self.tableView reloadData];
    }
}

- (RACCommand *)requestRemoteDataCommand {
    if (!_requestRemoteDataCommand) {
        @weakify(self)
        _requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *page) {
            @strongify(self)
            return [[self requestRemoteDataSignalWithPage:page.unsignedIntegerValue] takeUntil:self.rac_willDeallocSignal];
        }];
    }
    return _requestRemoteDataCommand;
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    return [RACSignal empty];
}

//- (void)setIsLoading:(BOOL)isLoading {
//    _isLoading = isLoading;
//    // [self.tableView reloadEmptyDataSet];
//
//    if (isLoading) {
//        [self.tableView reloadData];
//    }
//}

//- (JXPage *)page {
//    if (!_page) {
//        _page = [[JXPage alloc] init];
//    }
//    return _page;
//}

#pragma mark - Assist
- (void)beginUpdate {
    self.navigationItem.title = @"更新中";
}

- (void)endUpdate {
    self.navigationItem.title = self.navTitle;
}

- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter {
    return ^(NSError *error) {
        BOOL isFilter = YES;
        
        switch (self.requestMode) {
            case JXRequestModeLoad: {
                if (JXErrorCodeLoginExpired == error.code) {
                    self.error = error;
                }else if (JXErrorCodeDataEmpty == error.code) {
                    self.error = error;
                    isFilter = NO;
                }
                self.requestMode = JXRequestModeNone;
                self.dataSource = @[[NSMutableArray array]];
                break;
            }
            case JXRequestModeUpdate: {
                if (JXErrorCodeLoginExpired == error.code) {
                    self.error = error;
                }else if (JXErrorCodeDataEmpty == error.code) {
                    self.error = error;
                    isFilter = NO;
                }
                self.requestMode = JXRequestModeNone;
                self.dataSource = @[[NSMutableArray array]];
                break;
            }
            case JXRequestModeRefresh: {
                if (JXErrorCodeLoginExpired == error.code) {
                    self.error = error;
                }else if (JXErrorCodeDataEmpty == error.code) {
                    self.error = error;
                    isFilter = NO;
                }
                [self.tableView.mj_header endRefreshing];
                self.requestMode = JXRequestModeNone;
                self.dataSource = @[[NSMutableArray array]];
                break;
            }
            case JXRequestModeMore: {
                if (JXErrorCodeLoginExpired == error.code) {
                    self.error = error;
                    [self.tableView.mj_footer endRefreshing];
                }else if (JXErrorCodeDataEmpty == error.code) {
                    isFilter = NO;
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    [self.tableView.mj_footer endRefreshing];
                }
                
                self.requestMode = JXRequestModeNone;
                break;
            }
            case JXRequestModeHUD: {
                if (JXErrorCodeLoginExpired == error.code) {
                    self.error = error;
                }else if (JXErrorCodeDataEmpty == error.code) {
                    self.error = error;
                    isFilter = NO;
                }
                [JXDialog hideHUD];
                self.requestMode = JXRequestModeNone;
                self.dataSource = @[[NSMutableArray array]];
                break;
            }
            default:
                break;
        }
        
        return isFilter;
    };
}

- (id)fetchLocalData {
    return nil;
}

- (NSUInteger)nextPageIndex {
    if (JXObjcPageStyleGroup == JXInstance.pageStyle) {
        return self.page + 1;
    }else if (JXObjcPageStyleOffset == JXInstance.pageStyle) {
        return [[(JXObject *)[self.dataSource.firstObject lastObject] jxID] integerValue];
    }
    
    JXLogError(@"pageStyle错误");
    return 0;
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [JXCellDefault height];
}

- (BOOL)dataSourceIsEmptyOrNull {
    return 0 == [(NSArray *)self.dataSource.firstObject count];
}

- (void)triggerLoad {
    //self.error = nil;
    self.requestMode = JXRequestModeLoad;
    self.dataSource = @[[NSMutableArray array]];
    
    //self.isLoading = YES;
    @weakify(self)
    [[[self.requestRemoteDataCommand execute:@(JXInstance.pageIndex)] deliverOnMainThread] subscribeNext:^(NSArray *items) {
        @strongify(self)
        self.page = JXInstance.pageIndex;
        self.requestMode = JXRequestModeNone;
        //        if (JXDataIsEmpty(items)) {
        //            [self reloadData];
        //        }
    } /*error:^(NSError *error) {
        @strongify(self)
        self.requestMode = JXRequestModeNone;
        [self handleError:error mode:JXRequestModeLoad];
        [self reloadData];
    }*/ completed:^{
        //self.requestMode = JXRequestModeNone;
    }];
}

- (void)triggerRefresh {
    //self.error = nil;
    self.requestMode = JXRequestModeRefresh;
    
    @weakify(self)
    [[[self.requestRemoteDataCommand execute:@(JXInstance.pageIndex)] deliverOnMainThread] subscribeNext:^(id x) {
        //@strongify(self)
        //self.page = 1;
        @strongify(self)
        self.requestMode = JXRequestModeNone;
    }/* error:^(NSError *error) {
        @strongify(self)
        [self handleError:error mode:JXRequestModeRefresh];
        [self.tableView.mj_header endRefreshing];
    }*/ completed:^{
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)triggerMore {
    //self.error = nil;
    self.requestMode = JXRequestModeMore;
    
    @weakify(self)
    [[[self.requestRemoteDataCommand execute:@([self nextPageIndex])] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        self.page += 1;
        self.requestMode = JXRequestModeNone;
    }/* error:^(NSError *error) {
        @strongify(self)
        [self handleError:error mode:JXRequestModeMore];
        [self.tableView.mj_footer endRefreshing];
    }*/ completed:^{
        @strongify(self)
        if (self.isNoMoreData) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)triggerHUD {
    //self.error = nil;
    self.requestMode = JXRequestModeHUD;
    
    //JXHUDProcessing(nil);
    [JXDialog showHUD:nil];
    @weakify(self)
    [[[self.requestRemoteDataCommand execute:@(JXInstance.pageIndex)] deliverOnMainThread] subscribeNext:^(id x) {
        //@strongify(self)
        //self.page = 1;
        @strongify(self)
        self.page = JXInstance.pageIndex;
        self.requestMode = JXRequestModeNone;
    }/* error:^(NSError *error) {
        @strongify(self)
        [self handleError:error mode:self.requestMode];
    }*/ completed:^{
        [JXDialog hideHUD];
    }];
}

- (void)triggerUpdate {
//    // [self.tableView.mj_header beginRefreshing];
//    
    // self.navigationItem.title = @"更新中";
//    [self triggerLoad];
    
    //self.error = nil;
    self.requestMode = JXRequestModeUpdate;
    [self beginUpdate];
    //self.isLoading = YES;
    @weakify(self)
    [[[self.requestRemoteDataCommand execute:@(JXInstance.pageIndex)] deliverOnMainThread] subscribeNext:^(NSArray *items) {
        @strongify(self)
        //self.requestMode = JXRequestModeNone;
        self.page = 1;
        //        if (JXDataIsEmpty(items)) {
        //            [self reloadData];
        //        }
    } error:^(NSError *error) {
        @strongify(self)
        [self endUpdate];
        [self handleError:error mode:self.requestMode];
        self.requestMode = JXRequestModeNone;
        [self reloadData];
    } completed:^{
        [self endUpdate];
        self.requestMode = JXRequestModeNone;
    }];
    
    //[[self.requestRemoteDataCommand execute:@1] deliverOnMainThread] sub
}

- (void)handleError:(NSError *)error mode:(JXRequestMode)mode {
    //    if (JXRequestModeLoad == mode) {
    //        // self.error = (JXErrorCodeNetworkException == error.code ? error : nil);
    //
    ////        if ((JXErrorCodeNetworkException != error.code)
    ////            && (JXErrorCodeTokenInvalid != error.code)) {
    ////            self.error = nil;
    ////        }
    //
    //        self.error = error;
    ////        [self checkLogin:^{
    ////
    ////        }];
    //
    ////        if (![self dataSourceIsEmptyOrNull]) {
    ////            JXHUDError(error.localizedDescription, YES);
    ////        }
    //    }else if (JXRequestModeRefresh == mode) {
    //        if (JXErrorCodeNetworkException == error.code) {
    //            JXHUDError(error.localizedDescription, YES);
    //        }
    //    }else if (JXRequestModeMore == mode) {
    //        if (JXErrorCodeNetworkException == error.code) {
    //            JXHUDError(error.localizedDescription, YES);
    //        }
    //    }
    
    self.error = error;
//    BOOL pass = [gUser checkLoginWithFinish:^{
//        
//    } error:error];
    
    [gUser checkLoginWithFinish:^(BOOL isRelogin) {
        
    } error:error];

//    if (pass && (JXRequestModeMore == mode)) {
//        JXHUDError(error.localizedDescription, YES);
//    }
    
//    if (pass) {
//        if (JXRequestModeLoad == mode) {
//            self.dataSource = @[[NSMutableArray array]];
//        }else if (JXRequestModeMore == mode) {
//            JXHUDError(error.localizedDescription, YES);
//        }else if (JXRequestModeHUD == mode) {
//            JXHUDError(error.localizedDescription, YES);
//        }
//    }
    
    if (JXRequestModeLoad == mode) {
        //if (pass) {
            self.dataSource = @[[NSMutableArray array]];
        //}
//        else {
//            JXHUDError(error.localizedDescription, YES);
//        }
    }else if (JXRequestModeUpdate == mode) {
        self.dataSource = @[[NSMutableArray array]];
    }else if (JXRequestModeMore == mode) {
        // JXHUDError(error.localizedDescription, YES);
        [JXDialog showPopup:error.localizedDescription];
    }else if (JXRequestModeHUD == mode) {
        // JXHUDError(error.localizedDescription, YES);
        [JXDialog showPopup:error.localizedDescription];
    }
}

- (void)retryLoad {
    if (JXErrorCodeLoginExpired == self.error.code) {
//        [gUser checkLoginWithFinish:^{
//            [self triggerLoad];
//        } error:nil];
        [gUser checkLoginWithFinish:^(BOOL isRelogin) {
            if (isRelogin) {
                [self triggerLoad];
            }
        } error:nil];
    }else if (JXErrorCodeDataEmpty == self.error.code) {
        [self triggerLoad];
    }else if (JXErrorCodeNetworkException == self.error.code) {
        [self triggerLoad];
    }else {
        [self triggerLoad];
    }
}

#pragma mark - Action

#pragma mark - Delegate
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource ? self.dataSource.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSMutableArray *)self.dataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = self.dataSource[indexPath.section][indexPath.row];
    return [self heightForRowAtIndexPath:indexPath object:object];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView dequeueReusableCellWithIdentifier:[JXCellDefault identifier] forIndexPath:indexPath];
    
    id object = self.dataSource[indexPath.section][indexPath.row];
    [self configCell:cell indexPath:indexPath object:object];
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section >= self.viewModel.sectionIndexTitles.count) {
//        return nil;
//    }
//    return self.viewModel.sectionIndexTitles[section];
//}
//
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    // YJX_TODO 待理解
//    if (self.searchBar != nil) {
//        if (self.viewModel.sectionIndexTitles.count != 0) {
//            return [self.viewModel.sectionIndexTitles.rac_sequence startWith:UITableViewIndexSearch].array;
//        }
//    }
//    return self.viewModel.sectionIndexTitles;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    if (self.searchBar != nil) {
//        if (index == 0) {
//            [tableView scrollRectToVisible:self.searchBar.frame animated:NO];
//        }
//        return index - 1;
//    }
//    return index;
//}

#pragma mark UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    //    // YJX_TODO 待理解
    //    UINavigationController *topNavigationController = JXAppDelegate.navigationControllerStack.topNavigationController;
    //    JXViewController *topViewController = (JXViewController *)topNavigationController.topViewController;
    //    topViewController.snapshot = [topNavigationController.view snapshotViewAfterScreenUpdates:NO];
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    // RACTuplePack(indexPath, self.dataSource[indexPath.section][indexPath.row]);
    // [self.didSelectCommand execute:indexPath];
    [self.didSelectCommand execute:RACTuplePack(indexPath, self.dataSource[indexPath.section][indexPath.row])];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 0.01f;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.01f;
//}

#pragma mark DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    if (JXRequestModeLoad == self.requestMode) {
//        return nil;
//    }
//    
//    NSString *title = kStringDataEmpty;
//    if (self.error) {
//        title = self.error.localizedDescription;
//    }
//    
//    return [NSMutableAttributedString jx_attributedStringWithString:title color:[UIColor lightGrayColor] font:JXFont(17.0f)];
    return nil;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if (JXRequestModeLoad == self.requestMode) {
        return nil;
    }
    
    NSString *title = kStringDataEmpty;
    if (self.error) {
        title = self.error.localizedDescription;
    }
    
    return [NSMutableAttributedString jx_attributedStringWithString:title color:JXColorHex(0x999999) font:JXFont(15.0f)];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (JXRequestModeLoad == self.requestMode) {
        return nil;
    }
    
    NSString *title = JXStrWithDft([self.error jx_retryTitle], kStringReload);
    return [NSMutableAttributedString jx_attributedStringWithString:title color:(UIControlStateNormal == state ? [UIColor whiteColor] : [[UIColor whiteColor] colorWithAlphaComponent:0.8]) font:JXFont(15.0f)];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    // UIImage *image = JXImageWithColor(JXColorHex(0xE52E04));
    UIImage *image = JXImageWithColor(JXInstance.mainColor);
    image = [image scaleToSize:CGSizeMake(100, 34.0f) usingMode:NYXResizeModeScaleToFill];
    image = [image jx_makeRadius:2.0f];
    return [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(-10.0, -90.0, -10.0, -90.0)];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (JXRequestModeLoad == self.requestMode) {
        return JXImageWithName(@"jxres_loading");
    }
    
    UIImage *image = [self.error jx_reasonImage];
    image = image ? image : JXImageWithName(@"jxres_error_empty");
    return image;
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
    return [self dataSourceIsEmptyOrNull];
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return JXRequestModeLoad == self.requestMode;
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
    [self retryLoad];
}


#pragma mark Class
#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.refreshControl scrollViewDidScroll];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    [self.refreshControl scrollViewDidEndDragging];
//}

#pragma mark - Listening for the user to trigger a refresh

//- (void)triggerRefresh:(id)sender {
//    @weakify(self)
//    [[[self.viewModel.requestRemoteDataCommand
//       execute:@1]
//     	deliverOnMainThread]
//    	subscribeNext:^(id x) {
//            @strongify(self)
//            self.viewModel.page = 1;
//        } error:^(NSError *error) {
//            @strongify(self)
//            [self.refreshControl finishingLoading];
//        } completed:^{
//            @strongify(self)
//            [self.refreshControl finishingLoading];
//        }];
//}

#pragma mark - UISearchBarDelegate

//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    [searchBar setShowsCancelButton:YES animated:YES];
//}
//
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    self.viewModel.keyword = searchText;
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    [searchBar resignFirstResponder];
//}
//
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    [searchBar setShowsCancelButton:NO animated:YES];
//    [searchBar resignFirstResponder];
//
//    searchBar.text = nil;
//    self.viewModel.keyword = nil;
//}

//#pragma mark - DZNEmptyDataSetSource
//
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    return [[NSAttributedString alloc] initWithString:@"No Data"];
//}
//
//#pragma mark - DZNEmptyDataSetDelegate
//
//- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
//    return self.viewModel.dataSource == nil;
//}
//
//- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
//    return YES;
//}
//
//- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView {
//    return CGPointMake(0, -(self.tableView.contentInset.top - self.tableView.contentInset.bottom) / 2);
//}

@end
