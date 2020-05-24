//
//  CompResultViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/3.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "CompResultViewController.h"
#import "CompResultAllViewController.h"
#import "CompResultBrandViewController.h"
#import "CompResultBrandViewController.h"

@interface CompResultViewController ()
@property (nonatomic, strong) NSArray *items;
//@property (nonatomic, strong) NSError *error;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) JXPage *page;
@property (nonatomic, strong) RACCommand *searchCommand;

@property (nonatomic, weak) IBOutlet UILabel *tipsLabel;

@property (nonatomic, weak) IBOutlet UIView *childBgView;
@property (nonatomic, weak) IBOutlet UIView *adultBgView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *adultYConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *childHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *adultHeightConstraint;

@property (nonatomic, weak) IBOutlet UIView *child1View;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *child1Labels;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *child1Buttons;

@property (nonatomic, weak) IBOutlet UIView *child2View;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *child2Labels;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *child2Buttons;

@property (nonatomic, weak) IBOutlet UIView *child3View;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *child3Labels;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *child3Buttons;

@property (nonatomic, weak) IBOutlet UIView *child4View;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *child4Labels;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *child4Buttons;

@property (nonatomic, weak) IBOutlet UIView *adult1View;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *adult1Labels;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *adult1Buttons;

@property (nonatomic, weak) IBOutlet UIView *adult2View;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *adult2Labels;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *adult2Buttons;

@property (nonatomic, weak) IBOutlet UIView *adult3View;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *adult3Labels;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *adult3Buttons;

@property (nonatomic, weak) IBOutlet UIView *adult4View;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *adult4Labels;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *adult4Buttons;

@end

@implementation CompResultViewController
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//    
////    [[HRInstance getPageGroupBySocNameWithKeyword:self.keyword socName:nil page:1 rows:20] subscribeNext:^(id  _Nullable x) {
////        int a = 0;
////    } error:^(NSError * _Nullable error) {
////        int b = 0;
////    }];
//}

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
    [[[RACSignal merge:@[RACObserve(self, items), RACObserve(self, error)]] skip:1] subscribeNext:^(id x) {
        @strongify(self)
        [self.scrollView reloadEmptyDataSet];
    }];
    [self.searchCommand execute:nil];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
    self.page = [JXPage new];
}

- (void)setupData {
}

- (void)setupView {
    self.navigationItem.title = @"搜索结果";
    
    self.tipsLabel.text = JXStrWithFmt(@"以下是\"%@\"的搜索结果", self.keyword);
//    UINib *cellNib = [UINib nibWithNibName:@"DhzyDaibanCell" bundle:nil];
//    [self.tableView registerNib:cellNib forCellReuseIdentifier:[DhzyDaibanCell identifier]];
//    self.tableView.tableFooterView = [UIView new];
}

- (void)setupSignal {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
#pragma mark assist
- (void)configUI {
    if (1 == self.items.count) {
        CompResultList *list = self.items[0];
        NSArray *items = list.datas;
        
        NSArray *labels = nil;
        NSArray *buttons = nil;
        if ([list.groupValue isEqualToString:@"儿童"]) {
            self.childBgView.hidden = NO;
            self.adultBgView.hidden = YES;
            
            self.child1View.hidden = YES;
            self.child2View.hidden = YES;
            self.child3View.hidden = YES;
            self.child4View.hidden = YES;
            
            NSInteger count = items.count;
            if (1 == count) {
                self.child1View.hidden = NO;
                labels = self.child1Labels;
                buttons = self.child1Buttons;
                self.childHeightConstraint.constant = JXScreenScale(44 + 40);
            }else if (2 == count) {
                self.child2View.hidden = NO;
                labels = self.child2Labels;
                buttons = self.child2Buttons;
                self.childHeightConstraint.constant = JXScreenScale(44 + 40 * 2);
            }else if (3 == count) {
                self.child3View.hidden = NO;
                labels = self.child3Labels;
                buttons = self.child3Buttons;
                self.childHeightConstraint.constant = JXScreenScale(44 + 40 * 3);
            }else {
                self.child4View.hidden = NO;
                labels = self.child4Labels;
                buttons = self.child4Buttons;
                self.childHeightConstraint.constant = JXScreenScale(44 + 40 * 4);
            }
        }else {
            self.childBgView.hidden = YES;
            self.adultBgView.hidden = NO;
            
            self.adult1View.hidden = YES;
            self.adult2View.hidden = YES;
            self.adult3View.hidden = YES;
            self.adult4View.hidden = YES;
            
            self.adultYConstraint.constant = 10;
            
            NSInteger count = items.count;
            if (1 == count) {
                self.adult1View.hidden = NO;
                labels = self.adult1Labels;
                buttons = self.adult1Buttons;
                self.adultHeightConstraint.constant = JXScreenScale(44 + 40);
            }else if (2 == count) {
                self.adult2View.hidden = NO;
                labels = self.adult2Labels;
                buttons = self.adult2Buttons;
                self.adultHeightConstraint.constant = JXScreenScale(44 + 40 * 2);
            }else if (3 == count) {
                self.adult3View.hidden = NO;
                labels = self.adult3Labels;
                buttons = self.adult3Buttons;
                self.adultHeightConstraint.constant = JXScreenScale(44 + 40 * 3);
            }else {
                self.adult4View.hidden = NO;
                labels = self.adult4Labels;
                buttons = self.adult4Buttons;
                self.adultHeightConstraint.constant = JXScreenScale(44 + 40 * 4);
            }
        }
        
        for (NSInteger i = 0; i < labels.count; ++i) {
            UILabel *label = labels[i];
            UIButton *button = buttons[i];
            
            if (3 == i) {
                label.text = JXStrWithFmt(@"更多%ld种药品", (long)list.totalSize);
                continue;
            }
            
            label.numberOfLines = 2;
            
            CompResultItem *item = items[i];
            NSString *name = JXStrWithDft(item.dName, @"");
            NSString *zz = JXStrWithDft(item.dcName, @"");
            NSString *type = JXStrWithDft(item.dNatureType, @"");
            NSString *str = JXStrWithFmt(@"%@  %@\n%@", name, type, zz);
            NSMutableAttributedString *as = [NSMutableAttributedString jx_attributedStringWithString:str color:JXColorHex(0x999999) font:JXFont(10)];
            [as jx_addAttributeWithColor:JXColorHex(0x333333) font:JXFont(13) range:NSMakeRange(0, name.length)];
            label.attributedText = as;
            
            button.tag = item.dId;
        }
    }else {
        CompResultList *list1 = self.items[0];
        CompResultList *list2 = self.items[1];
        
        self.childBgView.hidden = NO;
        self.child1View.hidden = YES;
        self.child2View.hidden = YES;
        self.child3View.hidden = YES;
        self.child4View.hidden = YES;
        
        CompResultList *list = nil;
        if ([list1.groupValue isEqualToString:@"儿童"]) {
            list = list1;
        }else {
            list = list2;
        }
        NSArray *items = list.datas;
        NSInteger count = items.count;
        NSArray *labels = nil;
        NSArray *buttons = nil;
        if (1 == count) {
            self.child1View.hidden = NO;
            labels = self.child1Labels;
            buttons = self.child1Buttons;
            self.childHeightConstraint.constant = JXScreenScale(44 + 40);
        }else if (2 == count) {
            self.child2View.hidden = NO;
            labels = self.child2Labels;
            buttons = self.child2Buttons;
            self.childHeightConstraint.constant = JXScreenScale(44 + 40 * 2);
        }else if (3 == count) {
            self.child3View.hidden = NO;
            labels = self.child3Labels;
            buttons = self.child3Buttons;
            self.childHeightConstraint.constant = JXScreenScale(44 + 40 * 3);
        }else {
            self.child4View.hidden = NO;
            labels = self.child4Labels;
            buttons = self.child4Buttons;
            self.childHeightConstraint.constant = JXScreenScale(44 + 40 * 4);
        }
        
        for (NSInteger i = 0; i < labels.count; ++i) {
            UILabel *label = labels[i];
            UIButton *button = buttons[i];
            
            if (3 == i) {
                label.text = JXStrWithFmt(@"更多%ld种药品", (long)list.totalSize);
                continue;
            }
            
            label.numberOfLines = 2;
            
            CompResultItem *item = items[i];
            NSString *name = JXStrWithDft(item.dName, @"");
            NSString *zz = JXStrWithDft(item.dcName, @"");
            NSString *type = JXStrWithDft(item.dNatureType, @"");
            NSString *str = JXStrWithFmt(@"%@  %@\n%@", name, type, zz);
            NSMutableAttributedString *as = [NSMutableAttributedString jx_attributedStringWithString:str color:JXColorHex(0x999999) font:JXFont(10)];
            [as jx_addAttributeWithColor:JXColorHex(0x333333) font:JXFont(13) range:NSMakeRange(0, name.length)];
            label.attributedText = as;
            
            button.tag = item.dId;
        }
        
        // 成人
        self.adultBgView.hidden = NO;
        self.adult1View.hidden = YES;
        self.adult2View.hidden = YES;
        self.adult3View.hidden = YES;
        self.adult4View.hidden = YES;
        
        self.adultYConstraint.constant = 10 + self.childHeightConstraint.constant + 10;
        
        if ([list1.groupValue isEqualToString:@"成人"]) {
            list = list1;
        }else {
            list = list2;
        }
        items = list.datas;
        count = items.count;
        labels = nil;
        if (1 == count) {
            self.adult1View.hidden = NO;
            labels = self.adult1Labels;
            buttons = self.adult1Buttons;
            self.adultHeightConstraint.constant = JXScreenScale(44 + 40);
        }else if (2 == count) {
            self.adult2View.hidden = NO;
            labels = self.adult2Labels;
            buttons = self.adult2Buttons;
            self.adultHeightConstraint.constant = JXScreenScale(44 + 40 * 2);
        }else if (3 == count) {
            self.adult3View.hidden = NO;
            labels = self.adult3Labels;
            buttons = self.adult3Buttons;
            self.adultHeightConstraint.constant = JXScreenScale(44 + 40 * 3);
        }else {
            self.adult4View.hidden = NO;
            labels = self.adult4Labels;
            buttons = self.adult4Buttons;
            self.adultHeightConstraint.constant = JXScreenScale(44 + 40 * 4);
        }
        
        for (NSInteger i = 0; i < labels.count; ++i) {
            UILabel *label = labels[i];
            UIButton *button = buttons[i];
            
            if (3 == i) {
                label.text = JXStrWithFmt(@"更多%ld种药品", (long)list.totalSize);
                continue;
            }
            
//            CompResultItem *item = items[i];
//            NSString *name = JXStrWithDft(item.dcName, @"");
//            NSString *type = JXStrWithDft(item.dNatureType, @"");
//            NSString *str = JXStrWithFmt(@"%@  %@", name, type);
//            NSMutableAttributedString *as = [NSMutableAttributedString jx_attributedStringWithString:str color:JXColorHex(0x333333) font:JXFont(14)];
//            [as jx_addAttributeWithColor:JXColorHex(0x999999) font:JXFont(11) range:NSMakeRange(name.length + 2, type.length)];
//            label.attributedText = as;
            
            label.numberOfLines = 2;
            
            CompResultItem *item = items[i];
            NSString *name = JXStrWithDft(item.dName, @"");
            NSString *zz = JXStrWithDft(item.dcName, @"");
            NSString *type = JXStrWithDft(item.dNatureType, @"");
            NSString *str = JXStrWithFmt(@"%@  %@\n%@", name, type, zz);
            NSMutableAttributedString *as = [NSMutableAttributedString jx_attributedStringWithString:str color:JXColorHex(0x999999) font:JXFont(10)];
            [as jx_addAttributeWithColor:JXColorHex(0x333333) font:JXFont(13) range:NSMakeRange(0, name.length)];
            label.attributedText = as;
            
            button.tag = item.dId;
        }
    }
}

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
- (RACCommand *)searchCommand {
    if (!_searchCommand) {
        @weakify(self)
        _searchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [HRInstance getPageGroupBySocNameWithKeyword:self.keyword socName:[Util stringWithPeopleType:self.type] page:self.page.index rows:self.page.size];
        }];

        [[_searchCommand.errors filter:^BOOL(NSError *error) {
            @strongify(self)
            BOOL ret = NO;
            self.error = error;
            if (JXErrorCodeTokenInvalid == error.code) {
                ret = YES;
            }
            
            return ret;
        }] subscribe:self.errors];
        
        [_searchCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *items) {
            @strongify(self)
//            if (2 == items.count) {
//                CompResultList *list1 = items[0];
//                CompResultList *list2 = items[1];
//                NSMutableArray *arr = [NSMutableArray arrayWithCapacity:2];
//                if (list1.datas.count != 0) {
//                    [arr addObject:list1];
//                }
//                if (list2.datas.count != 0) {
//                    [arr addObject:list2];
//                }
//                items = arr;
//            }
//            
//            if (items.count >= 3) {
//                items = nil;
//            }
            
            CompResultList *adultList = nil;
            CompResultList *childList = nil;
            for (CompResultList *list in items) {
                if ([list.groupValue isEqualToString:@"成人"]) {
                    adultList = list;
                }
                if ([list.groupValue isEqualToString:@"儿童"]) {
                    childList = list;
                }
            }
            
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:2];
            if (adultList) {
                [arr addObject:adultList];
            }
            if (childList) {
                [arr addObject:childList];
            }
            
            if (0 == arr.count) {
                self.error = [NSError jx_errorWithCode:JXErrorCodeDataEmpty];
            }else {
                self.items = arr;
            }
        }];
    }
    return _searchCommand;
}


#pragma mark - Action methods
- (IBAction)childButtonPressed:(UIButton *)btn {
//    CompResultAllViewController *vc = [[CompResultAllViewController alloc] init];
//    vc.type = PeopleTypeChild;
//    vc.searchText = [btn titleForState:UIControlStateNormal];
//    [self.navigationController pushViewController:vc animated:YES];
    
    CompResultBrandViewController *vc = [[CompResultBrandViewController alloc] init];
//    CompResultItem *item = nil;
//    for (CompResultList *l in self.items) {
//        for (CompResultItem *i in l.datas) {
//            if (i.dId == btn.tag) {
//                item = i;
//                break;
//            }
//        }
//    }
//    vc.item = item;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)adultButtonPressed:(UIButton *)btn {
//    CompResultAllViewController *vc = [[CompResultAllViewController alloc] init];
//    vc.type = PeopleTypeAdult;
//    vc.searchText = [btn titleForState:UIControlStateNormal];
//    [self.navigationController pushViewController:vc animated:YES];
    
    CompResultBrandViewController *vc = [[CompResultBrandViewController alloc] init];
//    CompResultItem *item = nil;
//    for (CompResultList *l in self.items) {
//        for (CompResultItem *i in l.datas) {
//            if (i.dId == btn.tag) {
//                item = i;
//                break;
//            }
//        }
//    }
//    vc.item = item;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)moreButtonPressed:(UIButton *)btn {
    CompResultAllViewController *vc = [[CompResultAllViewController alloc] init];
   // vc.type = btn.tag;
    vc.searchText = self.keyword;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Notification methods

#pragma mark - Delegate methods
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
    UIImage *image = JXImageWithColor(SMInstance.mainColor);
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
    BOOL isEmpty = (0 == self.items.count);
    if (!isEmpty) {
        [self configUI];
    }
    return isEmpty;
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
    self.error = nil;
    [self.searchCommand execute:nil];
}

#pragma mark - Public methods
#pragma mark - Class methods


@end
