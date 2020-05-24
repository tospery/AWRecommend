//
//  JXScrollViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/2/20.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXScrollViewController.h"

@interface JXScrollViewController ()
//@property (nonatomic, weak, readwrite) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;

@end

@implementation JXScrollViewController
#pragma mark - Override
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    @weakify(self)
    if (self.shouldRequestRemoteDataOnViewDidLoad) {
        [[self rac_signalForSelector:@selector(bindViewModel)] subscribeNext:^(id x) {
            @strongify(self)
            self.dataSource ? [self triggerUpdate] : [self triggerLoad];
        }];
    }else {
        [[self rac_signalForSelector:@selector(bindViewModel)] subscribeNext:^(id x) {
            @strongify(self)
            [self reloadData];
        }];
    }
    
    self.contentView.backgroundColor = self.viewBgColor;
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self)
//    [[[[RACObserve(self, dataSource) skip:1] distinctUntilChanged] deliverOnMainThread] subscribeNext:^(id x) {
//        @strongify(self)
//        [self reloadData];
//    }];
    
    [[[RACObserve(self, dataSource) skip:1] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        [self reloadData];
    }];
    
//    [[RACObserve(self, shouldInfiniteScrolling) distinctUntilChanged] subscribeNext:^(NSNumber *should) {
//        @strongify(self)
//        if (should.boolValue) {
//            self.scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(triggerMore)];
//        }else {
//            [self.scrollView.mj_footer removeFromSuperview];
//            self.scrollView.mj_footer = nil;
//        }
//    }];
    
    [[self.requestRemoteDataCommand.errors filter:[self requestRemoteDataErrorsFilter]] subscribe:self.errors];
    
    if (![self isKindOfClass:[JXTableViewController class]]) {
        [[RACObserve(self, shouldPullToRefresh) distinctUntilChanged] subscribeNext:^(NSNumber *should) {
            @strongify(self)
            if (should.boolValue) {
//                self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(triggerRefresh)];
                [self setupRefresh];
            }else {
                [self.scrollView.mj_header removeFromSuperview];
                self.scrollView.mj_header = nil;
            }
        }];
    }
}

#pragma mark - Accessor
//- (void)setRequestMode:(JXRequestMode)requestMode {
//    _requestMode = requestMode;
//    
////    if (JXRequestModeLoad == requestMode) {
////        [self.scrollView reloadEmptyDataSet];
////    }
//    
//    
////    switch (requestMode) {
////        case JXRequestModeLoad: {
////            //if (self.scrollView.emptyDataSetSource && self.scrollView.emptyDataSetDelegate) {
////            [self.scrollView reloadEmptyDataSet];
////            //}
////            break;
////        }
////        default:
////            break;
////    }
//}

- (RACCommand *)requestRemoteDataCommand {
    if (!_requestRemoteDataCommand) {
        @weakify(self)
        _requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *page) {
            @strongify(self)
            return [[self requestRemoteDataSignalWithPage:page.integerValue] takeUntil:self.rac_willDeallocSignal];
        }];
    }
    return _requestRemoteDataCommand;
}

#pragma mark - Private
- (BOOL)dataSourceIsEmpty {
    return self.dataSource == nil;
}

#pragma mark - Public
- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    return [RACSignal empty];
}

- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter {
    return ^(NSError *error) {
        // BOOL notFilter = NO;
        
        BOOL notFilter = [self catchError:error];
        
//        if (self.requestMode == JXRequestModeMore &&
//            error.code == JXErrorCodeDataEmpty) {
//            
//        }else {
//            self.dataSource = nil;
//        }
        
//        switch (self.requestMode) {
//            case JXRequestModeLoad: {
//                if (JXErrorCodeLoginExpired == error.code) {
//                    notFilter = NO;
//                }
//                self.error = error;
//                self.requestMode = JXRequestModeNone;
//                self.dataSource = nil;
//                break;
//            }
//            case JXRequestModeUpdate: {
//                self.error = error;
//                if (JXErrorCodeLoginExpired == error.code) {
//                    notFilter = NO;
//                }
//                self.requestMode = JXRequestModeNone;
//                self.dataSource = nil;
//                break;
//            }
//            case JXRequestModeRefresh: {
//                self.error = error;
//                if (JXErrorCodeLoginExpired == error.code) {
//                    notFilter = NO;
//                }
//                [self.scrollView.mj_header endRefreshing];
//                self.requestMode = JXRequestModeNone;
//                self.dataSource = nil;
//                break;
//            }
//            case JXRequestModeMore: {
//                if (JXErrorCodeLoginExpired == error.code) {
//                    self.error = error;
//                    [self.scrollView.mj_footer endRefreshing];
//                    notFilter = NO;
//                }else if (JXErrorCodeDataEmpty == error.code) {
//                    [self.scrollView.mj_footer endRefreshingWithNoMoreData];
//                }else {
//                    [self.scrollView.mj_footer endRefreshing];
//                }
//                
//                self.requestMode = JXRequestModeNone;
//                break;
//            }
//            case JXRequestModeHUD: {
//                self.error = error;
//                if (JXErrorCodeLoginExpired == error.code) {
//                    notFilter = NO;
//                }
//                [JXDialog hideHUD];
//                self.requestMode = JXRequestModeNone;
//                self.dataSource = nil;
//                break;
//            }
//            default:
//                break;
//        }
        
        return notFilter;
    };
}

- (BOOL)catchError:(NSError *)error {
    BOOL notFilter = YES;
    BOOL nedUpdate = YES;
    
    switch (self.requestMode) {
        case JXRequestModeLoad:
        case JXRequestModeUpdate: {
            break;
        }
        case JXRequestModeRefresh: {
            [self.scrollView.mj_header endRefreshing];
            break;
        }
        case JXRequestModeMore: {
            if (JXErrorCodeDataEmpty == error.code) {
                nedUpdate = NO;
                [self.scrollView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.scrollView.mj_footer endRefreshing];
            }
            break;
        }
        case JXRequestModeHUD: {
            [JXDialog hideHUD];
            break;
        }
        default:
            break;
    }
    
    if (JXErrorCodeLoginExpired == error.code) {
        notFilter = NO;
        
        [gUser checkLoginWithFinish:^(BOOL isRelogin) {
            if (isRelogin) {
                [self triggerLoad];
            }
        } error:error];
    }else if (JXErrorCodeDataEmpty == error.code) {
        notFilter = NO;
    }
    
    self.error = error;
    self.requestMode = JXRequestModeNone;
    if (nedUpdate) {
        self.dataSource = nil;
    }
    
    return notFilter;
    
    
//    switch (self.requestMode) {
//        case JXRequestModeLoad:{
//            if (self.shouldPullToRefresh) {
//                [self.scrollView.mj_header removeFromSuperview];
//                self.scrollView.mj_header = nil;
//            }
//            break;
//        }
//        case JXRequestModeRefresh: {
//            [self.scrollView.mj_header endRefreshing];
//            break;
//        }
//        case JXRequestModeMore: {
//            if (JXErrorCodeDataEmpty == error.code) {
//                [self.scrollView.mj_footer endRefreshingWithNoMoreData];
//            }else {
//                [self.scrollView.mj_footer endRefreshing];
//            }
//            break;
//        }
//        default:
//            break;
//    }
//    
//    if (JXErrorCodeLoginExpired == error.code) {
//        [gUser checkLoginWithFinish:^(BOOL isRelogin) {
//            if (isRelogin) {
//                [self triggerLoad];
//            }
//        } error:error];
//    }
}

//- (void)catchError:(NSError *)error {
//    switch (self.requestMode) {
//        case JXRequestModeLoad:{
//            if (self.shouldPullToRefresh) {
//                [self.scrollView.mj_header removeFromSuperview];
//                self.scrollView.mj_header = nil;
//            }
//            break;
//        }
//        case JXRequestModeRefresh: {
//            [self.scrollView.mj_header endRefreshing];
//            break;
//        }
//        case JXRequestModeMore: {
//            if (JXErrorCodeDataEmpty == error.code) {
//                [self.scrollView.mj_footer endRefreshingWithNoMoreData];
//            }else {
//                [self.scrollView.mj_footer endRefreshing];
//            }
//            break;
//        }
//        default:
//            break;
//    }
//    
//    if (JXErrorCodeLoginExpired == error.code) {
//        [gUser checkLoginWithFinish:^(BOOL isRelogin) {
//            if (isRelogin) {
//                [self triggerLoad];
//            }
//        } error:error];
//    }
//}

- (void)handleError:(NSError *)error {
//    switch (self.error.code ) {
//        case JXErrorCodeLoginExpired: {
//            [gUser checkLoginWithFinish:^{
//                [self triggerLoad];
//            } error:nil];
//            break;
//        }
//        case JXErrorCodeNetworkException:
//        case JXErrorCodeServerException:
//        case JXErrorCodeDataInvalid: {
//            [self triggerLoad];
//        }
//            break;
//            
//        default:
//            break;
//    }
    
    if (JXErrorCodeLoginExpired == self.error.code) {
        [gUser checkLoginWithFinish:^(BOOL isRelogin) {
            if (isRelogin) {
                [self triggerLoad];
            }
        } error:error];
    }else {
        [self triggerLoad];
    }
}

- (id)fetchLocalData {
//    self.requestMode = JXRequestModeLoad; // YJX_TODO
//    self.dataSource = nil;
    
    return nil;
}

- (void)triggerLoad {
    self.error = nil;
    
    self.requestMode = JXRequestModeLoad;
    self.dataSource = nil;
    
    @weakify(self)
    [[[self.requestRemoteDataCommand execute:@(JXInstance.pageIndex)] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        //@strongify(self)
        //self.requestMode = JXRequestModeNone;
    } completed:^{
        @strongify(self)
        self.requestMode = JXRequestModeNone;
        if (self.shouldPullToRefresh == YES &&
            self.scrollView.mj_header == nil) {
            [self setupRefresh];
        }
    }];
}

- (void)triggerUpdate {
    self.requestMode = JXRequestModeUpdate;
    [self beginUpdate];
    
    @weakify(self)
    [[[self.requestRemoteDataCommand execute:@(JXInstance.pageIndex)] deliverOnMainThread] subscribeNext:^(NSArray *items) {
        // @strongify(self)
    } completed:^{
        @strongify(self)
        self.requestMode = JXRequestModeNone;
        [self endUpdate];
    }];
}

- (void)triggerHUD {
}

- (void)triggerRefresh {
    self.error = nil;
    self.requestMode = JXRequestModeRefresh;
    
//    if (self.dataSource == nil) {
//        self.dataSource = nil;
//    }
//    if ([self.dataSource isKindOfClass:[NSArray class]] &&
//        ([(NSArray *)self.dataSource count] == 0)) {
//        self.dataSource = nil;
//    }
    
    @weakify(self)
    [[[self.requestRemoteDataCommand execute:@(JXInstance.pageIndex)] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        //@strongify(self)
    } completed:^{
        @strongify(self)
        self.requestMode = JXRequestModeNone;
        [self.scrollView.mj_header endRefreshing];
    }];
}

- (void)triggerMore {
    
}

- (void)reloadData {
    [self.scrollView reloadEmptyDataSet];
    
//    if ([self.scrollView conformsToProtocol:@protocol(DZNEmptyDataSetSource)]
//        && [self.scrollView conformsToProtocol:@protocol(DZNEmptyDataSetSource)]) {
//        [self.scrollView reloadEmptyDataSet];
//    }
}

- (void)beginUpdate {
    // self.navigationItem.title = @"更新中";
}

- (void)endUpdate {
    //self.navigationItem.title = self.navTitle;
}

- (void)setupRefresh {
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(triggerRefresh)];
}

#pragma mark DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return nil;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.error) {
        return nil;
    }
    
    NSString *title = JXStrWithDft(self.error.localizedDescription, kStringDataEmpty);
    return [NSMutableAttributedString jx_attributedStringWithString:title color:JXColorHex(0x999999) font:JXFont(14.0f)];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (!self.error) {
        return nil;
    }
    
    NSString *title = JXStrWithDft([self.error jx_retryTitle], kStringReload);
    return [NSMutableAttributedString jx_attributedStringWithString:title color:(UIControlStateNormal == state ? [UIColor whiteColor] : [[UIColor whiteColor] colorWithAlphaComponent:0.8]) font:JXFont(15.0f)];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    UIImage *image = JXImageWithColor(JXInstance.mainColor ? JXInstance.mainColor : [UIColor blueColor]);
    image = [image scaleToSize:CGSizeMake(JXAdaptScreen(120), JXAdaptScreen(30)) usingMode:NYXResizeModeScaleToFill];
    image = [image jx_makeRadius:JXAdaptScreen(2.0)];
    
    CGFloat slide = JXAdaptValue(-84, -96, -106);
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, slide, 0, slide)];
    
    return (UIControlStateNormal == state ? image : nil);;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.error) {
        return JXImageWithName(@"jxres_loading");
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
    return self.contentView.backgroundColor; //  [UIColor whiteColor];
}

#pragma mark DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    BOOL isDisplay = [self dataSourceIsEmpty];
    return isDisplay;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return !self.error; //JXRequestModeLoad == self.requestMode;
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
    
    [self handleError:self.error];
}

@end








