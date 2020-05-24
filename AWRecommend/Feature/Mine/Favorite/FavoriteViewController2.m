//
//  FavoriteViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/10.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "FavoriteViewController2.h"
#import "FavoriteCell.h"
#import "AlertViewController.h"
#import "MedicineViewController.h"
@interface FavoriteViewController2 () <SWTableViewCellDelegate>
@property (nonatomic, strong) RACCommand *delCommand;

@end

@implementation FavoriteViewController2
#pragma mark - Override methods
- (instancetype)init {
    if (self = [super init]) {
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
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

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    //[self triggerLoad];
//    static BOOL onceToken = NO;
//    if (!onceToken) {
//        onceToken = YES;
//    }else {
//        NSArray *arr = [TMInstance objectForKey:kTMCompFavorite];
//        self.dataSource = @[JXArrValue(arr, [NSArray new])];
//    }
//    //[self.navigationController.navigationBar jx_reset];
//}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar jx_transparet];
//}

- (void)bindViewModel {
    [super bindViewModel];
    
//    RAC(self, dataSource) = [[[self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData] map:^id(NSArray *items) {
//        return JXArrValue(items, [NSArray new]);
//    }] map:^id(NSArray *items) {
//        return @[JXArrValue(items, [NSArray new])];
//    }];
    
//    RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
//    RAC(self, dataSource) = [[fetchLocalDataSignal deliverOnMainThread] map:^id(NSArray *items) {
//        return @[JXArrValue(items, [NSArray new])];
//    }];
    
    //RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[requestRemoteDataSignal deliverOnMainThread] map:^id _Nullable(id result) {
        return JXArrDataSource(result);
    }];
    
    @weakify(self)
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self)
        // YJX_TODO
//         *vc = [[CompResultDetailViewController alloc] init];
//        
//        CompResultBrand *b = [CompResultBrand new];
//        b.brandId = [[(CompResultDetail *)input.second uid] integerValue];
//        vc.brand = b;
        
//        CompResultItem *item = [CompResultItem new];
//        item.dId = [[(CompResultDetail *)input.second uid] integerValue];
//        
//        CompResultDetail *d = input.second;
//        
//        CompResultBrand
//
        Favorite *f = input.second;
        
        CompResultBrand *b = [CompResultBrand new];
        b.brandId = f.brandId.integerValue;
        b.brandName = f.brandName;
        b.drugName = f.drugName;
        
        MedicineViewController *vc = [MedicineViewController medicineNCWithDataSource:b];
        [self.navigationController presentViewController:vc animated:YES completion:NULL];
//
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
        
        return [RACSignal empty];
    }];
}

- (void)handleError:(NSError *)error {
    [super handleError:error];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    // [[JXAppDelegate mainTbController] setSelectedIndex:0];
    [JXAppDelegate.tabBar itemSelected:JXAppDelegate.tabBar.tabBarItems[0]];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
}

- (void)setupData {
}

- (void)setupView {
    self.navigationItem.title = @"收藏";
    
    UINib *cellNib = [UINib nibWithNibName:@"FavoriteCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:[FavoriteCell identifier]];
    self.tableView.tableFooterView = [UIView new];
}

- (void)setupSignal {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
#pragma mark assist
- (NSArray *)rightButtons {
    NSMutableArray *buttons = [NSMutableArray new];
    [buttons sw_addUtilityButtonWithColor: [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                    title:@"删除"];
    return buttons;
}

#pragma mark - Table
//- (id)fetchLocalData {
//    return [TMInstance objectForKey:kTMCompFavorite];
//}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    // return [HRInstance requestDhzyDaibanListWithPage:1];
    return [HRInstance findDrugFavoriteList];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    FavoriteCell *myCell = (FavoriteCell *)cell;
    myCell.data = object;
    myCell.delegate = self;
    myCell.rightUtilityButtons = [self rightButtons];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [FavoriteCell height];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [self.tableView dequeueReusableCellWithIdentifier:[FavoriteCell identifier] forIndexPath:indexPath];
}

#pragma mark - SWTableViewDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state {
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {
//            SIAlertView *alert = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"您是否确认删除该收藏？"];
//            [alert addButtonWithTitle:kStringCancel type:SIAlertViewButtonTypeCancel handler:NULL];
//            [alert addButtonWithTitle:kStringOK type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
//                NSArray *arr = [TMInstance objectForKey:kTMCompFavorite];
//                NSMutableArray *ma = [NSMutableArray arrayWithArray:arr];
//                [ma removeObject:[(FavoriteCell *)cell data]];
//                [TMInstance setObject:ma forKey:kTMCompFavorite];
//                
//                self.dataSource = @[JXArrValue(ma, [NSArray new])];
//            }];
//            [alert show];
            
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
                    
                    Favorite *r = [(FavoriteCell *)cell data];
                    [self.delCommand execute:@(r.brandId.integerValue)];
                    
                    NSMutableArray *ma = [NSMutableArray arrayWithArray:self.dataSource.firstObject];
                    [ma removeObject:r];
                    
                    if (ma.count == 0) {
                        self.error = [NSError jx_errorWithCode:JXErrorCodeDataEmpty];
                    }
                    self.dataSource = JXArrTable(ma);
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


#pragma mark - Accessor methods
- (RACCommand *)delCommand {
    if (!_delCommand) {
        _delCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance deleteDrugFavorite:([(NSNumber *)input integerValue])];
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


#pragma mark - Action methods
#pragma mark - Notification methods

#pragma mark - Delegate methods
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.error) {
        return nil;
    }
    
    NSString *title = @"暂时没有收藏记录~";
    return [NSMutableAttributedString jx_attributedStringWithString:title color:JXColorHex(0x999999) font:JXFont(15.0f)];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (!self.error) {
        return nil;
    }
    
    NSString *title = @" 添加收藏";
    NSMutableAttributedString *mas = [NSMutableAttributedString jx_attributedStringWithString:title color:(UIControlStateNormal == state ? [UIColor whiteColor] : [[UIColor whiteColor] colorWithAlphaComponent:0.8]) font:JXFont(15.0f)];
    
    UIImage *image = JXAdaptImage(JXImageWithName(@"ic_btn_add"));
    NSTextAttachment *att = [[NSTextAttachment alloc] init];
    att.bounds = CGRectMake(0, -JXAdaptScreen(4), image.size.width, image.size.height);
    att.image = image;
    [mas insertAttributedString:[NSAttributedString attributedStringWithAttachment:att] atIndex:0];
    
    return mas;
}

//- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
//    return 80;
//}

//- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
//    return JXAdaptImage(JXImageWithName(@"ic_btn_add"));
//}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
//    UIImage *image = JXImageWithColor(JXInstance.mainColor);
//    image = [image scaleToSize:CGSizeMake(100, 34.0f) usingMode:NYXResizeModeScaleToFill];
//    image = [image jx_makeRadius:2.0f];
//    return [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(-10.0, -90.0, -10.0, -90.0)];
    
    UIImage *image = JXImageWithColor(JXInstance.mainColor);
    image = [image scaleToSize:CGSizeMake(JXAdaptScreen(120), JXAdaptScreen(30)) usingMode:NYXResizeModeScaleToFill];
    image = [image jx_makeRadius:JXAdaptScreen(2.0)];
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, -84.0, 0, -84.0)];
    return image;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.error) {
        return JXImageWithName(@"jxres_loading");
    }
    
    UIImage *image = JXImageWithName(@"img_add");
    return JXAdaptImage(image);
}

#pragma mark - Public methods
#pragma mark - Class methods


@end
