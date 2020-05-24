//
//  FavoriteViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/11/30.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "FavoriteViewController.h"
#import "FavoriteCell.h"
#import "FavoriteArticleCell.h"
#import "AlertViewController.h"
#import "MedicineViewController.h"
#import "NiceDetailViewController.h"

@interface FavoriteViewController () <SWTableViewCellDelegate>
@property (nonatomic, strong) RACCommand *delCommand;

@end

@implementation FavoriteViewController
#pragma mark - Override
#pragma mark init
- (instancetype)init {
    if (self = [super init]) {
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
        self.shouldPullToRefresh = YES;
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
}

- (void)setupView {
    self.navigationItem.title = @"我的收藏";
    
    UINib *nib = [UINib nibWithNibName:@"FavoriteCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[FavoriteCell identifier]];
    self.tableView.tableFooterView = [UIView new];
}

- (void)setupNet {
    
}

#pragma mark scroll
- (void)bindViewModel {
    [super bindViewModel];
    
    // RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[requestRemoteDataSignal deliverOnMainThread] map:^id _Nullable(id result) {
        return JXArrTable(result);
    }];
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    return [HRInstance listGoodsCollect];
    
//    [[HRInstance listGoodsCollect/*findDrugFavoriteList*/] subscribeNext:^(NSArray *items) {
//        if ([items isKindOfClass:[NSArray class]]) {
//            [self.remoteDatas replaceObjectAtIndex:index withObject:items];
//        }
//        if([(NSArray *)self.remoteDatas[0] count] == 0) {
//            [self.requestErrors replaceObjectAtIndex:index withObject:[NSError jx_errorWithCode:JXErrorCodeDataEmpty]];
//        }else {
//            [self.requestErrors replaceObjectAtIndex:index withObject:[NSError jx_errorWithCode:JXErrorCodePlaceholder]];
//        }
//        [(UITableView *)self.tableViews[index] reloadData];
//    } error:^(NSError * _Nullable error) {
//        [gUser checkLoginWithFinish:^(BOOL isRelogin) {
//            if (isRelogin) {
//                [self requestDataWithIndex:index page:page];
//            }
//        } error:error];
//
//        [self.requestErrors replaceObjectAtIndex:index withObject:error];
//        [(UITableView *)self.tableViews[index] reloadData];
//    }];
}

#pragma mark table
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [FavoriteCell height];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [self.tableView dequeueReusableCellWithIdentifier:[FavoriteCell identifier] forIndexPath:indexPath];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    FavoriteCell *myCell = (FavoriteCell *)cell;
    myCell.delegate = self;
    myCell.rightUtilityButtons = [self rightButtons];
    myCell.data = object;
}

#pragma mark - SWTableViewDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state {
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            AlertViewController *vc = [[AlertViewController alloc] init];
            vc.message = @"您是否确认删除该收藏？";
            vc.didOkBlock = ^(NSInteger ok) {
                if (ok) {
                    //                    NSArray *arr = [TMInstance objectForKey:kTMCompFavorite];
                    //                    NSMutableArray *ma = [NSMutableArray arrayWithArray:arr];
                    //                    [ma removeObject:[(FavoriteCell *)cell data]];
                    //                    [TMInstance setObject:ma forKey:kTMCompFavorite];
                    //
                    //                    self.dataSource = @[JXArrValue(ma, [NSArray new])];
                    
                    id r = [self.dataSource.firstObject objectAtIndex:index];
                    FavoriteLP *obj = (FavoriteLP *)r;
                    [self.delCommand execute:RACTuplePack(@(obj.goodsId), @(obj.sceneId))];
                    
                    NSMutableArray *ma = [NSMutableArray arrayWithArray:self.dataSource.firstObject];
                    [ma removeObject:r];
                    if (ma.count == 0) {
                        self.error = [NSError jx_errorWithCode:JXErrorCodeDataEmpty];
                    }else {
                        self.error = nil;
                    }
                    self.dataSource = JXArrTable(ma);
                    
//                    if (ma.count == 0) {
//                        // self.error = [NSError jx_errorWithCode:JXErrorCodeDataEmpty];
//                        [self.requestErrors replaceObjectAtIndex:selectIndex withObject:[NSError jx_errorWithCode:JXErrorCodeDataEmpty]];
//                    }
//                    [self.remoteDatas replaceObjectAtIndex:selectIndex withObject:ma];
//                    [(UITableView *)self.tableViews[selectIndex] reloadData];
//                    // self.dataSource = JXArrTable(ma);
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

#pragma mark empty
#pragma mark - Accessor
#pragma mark - Private
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


- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.error) {
        return nil;
    }
    
    if (self.error.code == JXErrorCodeDataEmpty) {
        return [NSMutableAttributedString jx_attributedStringWithString:@"收藏空空如也~" color:JXColorHex(0x999999) font:JXFont(15.0f)];
    }
    
    NSString *title = JXStrWithDft(self.error.localizedDescription, kStringDataEmpty);
    return [NSMutableAttributedString jx_attributedStringWithString:title color:JXColorHex(0x999999) font:JXFont(15.0f)];
}


- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (!self.error) {
        return nil;
    }
    
    if (self.error.code == JXErrorCodeDataEmpty) {
        NSString *title = @"进入良品";
        return [NSMutableAttributedString jx_attributedStringWithString:title color:(UIControlStateNormal == state ? [UIColor whiteColor] : [[UIColor whiteColor] colorWithAlphaComponent:0.8]) font:JXFont(15.0f)];
    }
    
    NSString *title = JXStrWithDft([self.error jx_retryTitle], kStringReload);
    return [NSMutableAttributedString jx_attributedStringWithString:title color:(UIControlStateNormal == state ? [UIColor whiteColor] : [[UIColor whiteColor] colorWithAlphaComponent:0.8]) font:JXFont(15.0f)];
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.error) {
        return nil;
    }
    
    if (self.error.code == JXErrorCodeDataEmpty) {
        return JXAdaptImage(JXImageWithName(@"img_null"));
    }
    
    return JXObjWithDft([self.error jx_reasonImage], JXImageWithName(@"jxres_error_empty"));
}

- (void)handleError:(NSError *)error {
    if (JXErrorCodeLoginExpired == self.error.code) {
        [gUser checkLoginWithFinish:^(BOOL isRelogin) {
            if (isRelogin) {
                [self triggerLoad];
            }
        } error:error];
    }else {
        if (self.error.code == JXErrorCodeDataEmpty) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            UITabBarController *mainVC = [JXAppDelegate mainTbController];
            [mainVC setSelectedIndex:0];
        }else {
         [self triggerLoad];
        }
    }
}

@end
