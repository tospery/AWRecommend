//
//  ResultViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/15.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ResultViewController1.h"
#import "ResultCardView.h"
#import "ResultMoreViewController.h"
#import "BrandViewController.h"
#import "MatchViewController.h"

@interface ResultViewController1 () <iCarouselDataSource, iCarouselDelegate>
@property (nonatomic, strong) IBOutlet UILabel *tipsLabel;
@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property (nonatomic, strong) ResultCardView *cardView;

@property (nonatomic, strong) ProgressViewController *progressVC;

@end

@implementation ResultViewController1
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
    
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[requestRemoteDataSignal deliverOnMainThread] map:^id _Nullable(id result) {
        self.progressVC.toFinish = YES;
//        NSMutableArray *ar = [NSMutableArray arrayWithArray:result];
//        [ar addObjectsFromArray:result];
//        return ar;
       return result;
    }];
}

- (void)reloadData {
    [super reloadData];
    [self.carousel reloadData];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
}

- (void)setupData {
}

- (void)setupView {
    self.navigationItem.title = @"搜索结果";
    
    self.tipsLabel.font = JXFont(13);
    self.tipsLabel.text = JXStrWithFmt(@"以下是“%@”的搜索结果", self.keyword);
    
    self.carousel.type = iCarouselTypeTimeMachine;
    self.carousel.vertical = YES;
    self.carousel.backgroundColor = JXInstance.viewBgColor;
    
    //    UINib *cellNib = [UINib nibWithNibName:@"DhzyDaibanCell" bundle:nil];
    //    [self.tableView registerNib:cellNib forCellReuseIdentifier:[DhzyDaibanCell identifier]];
    //    self.tableView.tableFooterView = [UIView new];
    
    
    
    //ProgressViewController *vc = [[ProgressViewController alloc] init];
//    vc.didOkBlock = ^(NSInteger ok) {
//        if (ok) {
//            NSArray *arr = [TMInstance objectForKey:kTMCompFavorite];
//            NSMutableArray *ma = [NSMutableArray arrayWithArray:arr];
//            [ma removeObject:[(FavoriteCell *)cell data]];
//            [TMInstance setObject:ma forKey:kTMCompFavorite];
//            
//            self.dataSource = @[JXArrValue(ma, [NSArray new])];
//        }
//        [self dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeBounceOut];
//    };
//    
//
    
//    @weakify(self)
//    vc.finishBlock = ^() {
//        @strongify(self)
//        [self dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeNone];
//    };
    
    [self jx_presentPopupViewController:self.progressVC animationType:JXPopupShowTypeNone layout:JXPopupLayoutCenter bgTouch:NO dismissed:^{
        
    }];
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

//- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter {
//    self.progressVC.toFinish = YES;
//    return [super requestRemoteDataErrorsFilter];
//}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    if (self.isPrecised) {
        return [HRInstance getPageGroupBySocName2WithKeyword:self.keyword socName:self.scope page:page rows:JXInstance.pageSize natureType:nil];
    }
    return [HRInstance getPageGroupBySocNameWithKeyword:self.keyword socName:self.scope page:page rows:JXInstance.pageSize natureType:nil];
}
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
- (ProgressViewController *)progressVC {
    if (!_progressVC) {
        _progressVC = [[ProgressViewController alloc] init];
        @weakify(self)
        _progressVC.finishBlock = ^() {
            @strongify(self)
            [self jx_dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeNone];
        };
        _progressVC.backBlock = ^() {
            @strongify(self)
            [self jx_dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeNone];
            [self.navigationController popViewControllerAnimated:NO];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeNone];
//            });
        };
    }
    return _progressVC;
}
//- (ResultCardView *)cardView {
//    if (!_cardView) {
//        _cardView = [[[NSBundle mainBundle] loadNibNamed:@"ResultCardView" owner:nil options:nil] firstObject];
//    }
//    return _cardView;
//}

#pragma mark - Action methods
#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark iCarousel methods
- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel {
    return (NSInteger)[(NSArray *)self.dataSource count];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (!view) {
        view = [[[NSBundle mainBundle] loadNibNamed:@"ResultCardView" owner:nil options:nil] firstObject];
    }
    NSArray *items = self.dataSource;
    [(ResultCardView *)view setList:items[index]];
    @weakify(self)
    [(ResultCardView *)view setMoreBlock:^(RACTuple *t) {
        @strongify(self)
        ResultMoreViewController *vc = [[ResultMoreViewController alloc] init];
        vc.keyword = t.first;
        vc.scope = t.second;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [(ResultCardView *)view setZyBlock:^(RACTuple *t) {
        @strongify(self)
        ResultMoreViewController *vc = [[ResultMoreViewController alloc] init];
        vc.keyword = t.first;
        vc.scope = t.second;
        vc.type = @"中成药";
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [(ResultCardView *)view setXyBlock:^(RACTuple *t) {
        @strongify(self)
        ResultMoreViewController *vc = [[ResultMoreViewController alloc] init];
        vc.keyword = t.first;
        vc.scope = t.second;
        vc.type = @"西药";
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [(ResultCardView *)view setItemBlock:^(CompResultItem *i) {
        @strongify(self)
        BrandViewController *vc = [[BrandViewController alloc] init];
        vc.dataSource = i;
        //vc.item = i;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [(ResultCardView *)view setMatchBlock:^(NSInteger match) {
        MatchViewController *vc = [[MatchViewController alloc] init];
        vc.closeBlock = ^() {
            [self jx_dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeBounceOut];
        };
        vc.matchDegree = match;
        [self jx_presentPopupViewController:vc animationType:JXPopupShowTypeBounceIn layout:JXPopupLayoutCenter bgTouch:YES dismissed:^{
            
        }];
    }];
    
    return view;
}

//- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
//{
//    //note: placeholder views are only displayed on some carousels if wrapping is disabled
//    return 2;
//}

//- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
//{
//    UILabel *label = nil;
//
//    //create new view if no view is available for recycling
//    if (view == nil)
//    {
//        //don't do anything specific to the index within
//        //this `if (view == nil) {...}` statement because the view will be
//        //recycled and used with other index values later
//        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0, 200.0)];
//        ((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
//        view.contentMode = UIViewContentModeCenter;
//
//        label = [[UILabel alloc] initWithFrame:view.bounds];
//        label.backgroundColor = [UIColor clearColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = [label.font fontWithSize:50.0];
//        label.tag = 1;
//        [view addSubview:label];
//    }
//    else
//    {
//        //get a reference to the label in the recycled view
//        label = (UILabel *)[view viewWithTag:1];
//    }
//
//    //set item label
//    //remember to always set any properties of your carousel item
//    //views outside of the `if (view == nil) {...}` check otherwise
//    //you'll get weird issues with carousel item content appearing
//    //in the wrong place in the carousel
//    label.text = (index == 0)? @"[": @"]";
//
//    return view;
//}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0.0, 1.0, 0.0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.carousel.itemWidth);
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
//    switch(option) {
//        iCarouselOptionVisibleItems:{ return 3; break; }
//        default:{ return value; }
//    }
    
    //customize carousel display
    switch (option) {
        case iCarouselOptionWrap: {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing: {
            //add a bit of spacing between the item views
            //return value * 1.05;
            //return value * 2.05;
            JXDeviceInch inch = [JXDevice sharedInstance].inch;
            CGFloat beishu = 0.64;
            if (JXDeviceInch47 == inch) {
                beishu = 0.56;
            }else if (JXDeviceInch55 == inch) {
                beishu = 0.50;
            }
            return value * beishu;
        }
        case iCarouselOptionFadeMax: {
            //            if (self.carousel.type == iCarouselTypeCustom)
            //            {
            //                //set opacity based on distance from camera
            //                return 0.0;
            //            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:{
            return value;
        }
        case iCarouselOptionVisibleItems: {
            return value;
        }
    }
}

#pragma mark -
#pragma mark iCarousel taps
- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    //    NSNumber *item = (self.items)[(NSUInteger)index];
    //    NSLog(@"Tapped view number: %@", item);
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel {
    //NSLog(@"Index: %@", @(self.carousel.currentItemIndex));
}

#pragma mark - Public methods
#pragma mark - Class methods


@end
