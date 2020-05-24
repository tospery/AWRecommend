//
//  ScanRecordViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/9.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ScanRecordViewController.h"
#import "ScanRecordCell.h"
#import "AlertViewController.h"
#import "BrandViewController.h"
#import "ScanResultThirdViewController.h"
#import "ScanResultServerViewController.h"
#import "ScanEmptyViewController.h"

@interface ScanRecordViewController () <SWTableViewCellDelegate>
@property (nonatomic, strong) RACCommand *delCommand;
@property (nonatomic, strong) RACCommand *resultCommand;

@property (nonatomic, copy) NSString *barcode;
@property (nonatomic, assign) BOOL onceToken;

@end

@implementation ScanRecordViewController
#pragma mark - Override methods
- (instancetype)init {
    if (self = [super init]) {
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
//        self.shouldPullToRefresh = YES;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.onceToken) {
        [self triggerLoad];
    }else {
        self.onceToken = YES;
    }
}

- (void)bindViewModel {
    [super bindViewModel];
    
    //RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[requestRemoteDataSignal deliverOnMainThread] map:^id _Nullable(id result) {
        return JXArrTable(result);
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
        ScanRecord *r = input.second;
        self.barcode = r.code;
        [self.resultCommand execute:r.code];
        
        
        return [RACSignal empty];
    }];
}

- (void)handleError:(NSError *)error {
    [super handleError:error];
    
    EntryScan(self.navigationController);
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    });
}

#pragma mark - Private methods
- (RACCommand *)resultCommand {
    if (!_resultCommand) {
        _resultCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance getCodeData:input];
        }];
        [_resultCommand.executing subscribe:self.executing];
        [_resultCommand.errors subscribe:self.errors];
        
        @weakify(self)
        [_resultCommand.executionSignals.switchToLatest subscribeNext:^(ScanResult *result) {
            @strongify(self)
            if (0 == result.resultDataType) {
                ScanResultServerViewController *vc = [[ScanResultServerViewController alloc] init];
                vc.dataSource = result;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (1 == result.resultDataType) {
                ScanResultThirdViewController *vc = [[ScanResultThirdViewController alloc] init];
                vc.dataSource = result;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                ScanResultThird1ViewController *vc = [[ScanResultThird1ViewController alloc] init];
                vc.barcode = self.barcode;
                [self.navigationController pushViewController:vc animated:YES];
            }
            [JXDialog hideHUD];
        }];
    }
    return _resultCommand;
}

#pragma mark setup
- (void)setupVar {
}

- (void)setupData {
}

- (void)setupView {
    self.navigationItem.title = @"扫码记录";
    
    UINib *nib = [UINib nibWithNibName:@"ScanRecordCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[ScanRecordCell identifier]];
    self.tableView.tableFooterView = [UIView new];
}

- (void)setupSignal {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
- (RACCommand *)delCommand {
    if (!_delCommand) {
        _delCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance userRomoveCodeLog:input];
        }];
        // YJX_TODO
        //[_delCommand.executing subscribe:self.executing];
        //[_delCommand.errors subscribe:self.errors];
        
        [_delCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *items) {
        }];
    }
    return _delCommand;
}



#pragma mark assist
- (NSArray *)rightButtons {
    NSMutableArray *buttons = [NSMutableArray new];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = JXColorHex(0xF5F5F5);
    [btn setImage:JXAdaptImage(JXImageWithName(@"ic_delete")) forState:UIControlStateNormal];
    [buttons addObject:btn];
    return buttons;
}

#pragma mark - Table
- (id)fetchLocalData {
    return nil;
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    return [HRInstance getUserCodeLogs];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    ScanRecordCell *myCell = (ScanRecordCell *)cell;
    myCell.data = object;
    myCell.delegate = self;
    myCell.rightUtilityButtons = [self rightButtons];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ScanRecordCell height];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [self.tableView dequeueReusableCellWithIdentifier:[ScanRecordCell identifier] forIndexPath:indexPath];
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
            vc.message = @"您是否确认删除该扫码记录？";
            vc.didOkBlock = ^(NSInteger ok) {
                if (ok) {
                    ScanRecord *r = [(ScanRecordCell *)cell data];
                    [self.delCommand execute:r.jxID];
                    
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
#pragma mark - Action methods
#pragma mark - Notification methods

#pragma mark - Delegate methods
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.error) {
        return nil;
    }
    
    NSString *title = @"暂时没有扫码记录~";
    return [NSMutableAttributedString jx_attributedStringWithString:title color:JXColorHex(0x999999) font:JXFont(15.0f)];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (!self.error) {
        return nil;
    }
    
    NSString *title = @" 立即扫码";
    NSMutableAttributedString *mas = [NSMutableAttributedString jx_attributedStringWithString:title color:(UIControlStateNormal == state ? [UIColor whiteColor] : [[UIColor whiteColor] colorWithAlphaComponent:0.8]) font:JXFont(15.0f)];
    
    UIImage *image = JXAdaptImage(JXImageWithName(@"ic_btn_add"));
    NSTextAttachment *att = [[NSTextAttachment alloc] init];
    att.bounds = CGRectMake(0, -JXAdaptScreen(4), image.size.width, image.size.height);
    att.image = image;
    [mas insertAttributedString:[NSAttributedString attributedStringWithAttachment:att] atIndex:0];
    
    return mas;
}

//- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
//    return JXAdaptImage(JXImageWithName(@"ic_btn_add"));
//}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
//    UIImage *image = JXImageWithColor(JXInstance.mainColor);
//    image = [image scaleToSize:CGSizeMake(100, 34.0f) usingMode:NYXResizeModeScaleToFill];
//    image = [image jx_makeRadius:2.0f];
//    return [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(-10.0, -90.0, -10.0, -90.0)];
    
    //return JXImageWithName(@"btn_share");
    
//    UIImage *image = JXImageWithColor(JXInstance.mainColor);
//    image = [image scaleToSize:CGSizeMake(JXAdaptScreen(120), JXAdaptScreen(34)) usingMode:NYXResizeModeScaleToFill];
//    image = [image jx_makeRadius:JXAdaptScreen(2.0)];
//    CGSize size = image.size;
//    return image; // [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(-10.0, -90.0, -10.0, -90.0)];

    // return JXImageWithName(@"img_search_trashcan");
    
    UIImage *image = JXImageWithColor(JXInstance.mainColor);
    image = [image scaleToSize:CGSizeMake(JXAdaptScreen(120), JXAdaptScreen(30)) usingMode:NYXResizeModeScaleToFill];
    image = [image jx_makeRadius:JXAdaptScreen(2.0)];
    
    CGFloat slide = JXAdaptValue(-84, -96, -106);
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, slide, 0, slide)];
    
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
