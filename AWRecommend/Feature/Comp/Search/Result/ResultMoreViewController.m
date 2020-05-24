//
//  ResultMoreViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/17.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ResultMoreViewController.h"
#import "ResultCardCell.h"
#import "BrandViewController.h"

@interface ResultMoreViewController ()

@end

@implementation ResultMoreViewController
#pragma mark - Override methods
- (instancetype)init {
    if (self = [super init]) {
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
        self.shouldInfiniteScrolling = YES;
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
    
    @weakify(self)
    
    //RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[requestRemoteDataSignal deliverOnMainThread] map:^id _Nullable(NSArray *items) {
        //return JXArrDataSource(result);
        @strongify(self)
        
        CompResultList *list = nil;
        for (CompResultList *l in items) {
            if ([l.groupValue isEqualToString:self.scope]) {
                list = l;
                break;
            }
        }
        
        NSMutableArray *rows = [NSMutableArray arrayWithArray:self.dataSource.firstObject];
        [rows addObjectsFromArray:list.datas];
        
        self.isNoMoreData = (rows.count == list.totalSize);
        
        if (0 == rows.count) {
            self.error = [NSError jx_errorWithCode:JXErrorCodeDataEmpty];
            return @[@[]];
        }else {
            self.error = nil;
        }
        
        return @[rows];

    }];
    
//    RAC(self, dataSource) = [self.requestRemoteDataCommand.executionSignals.switchToLatest map:^id _Nullable(NSArray *items) {
//        @strongify(self)
//        if (0 != items.count) {
//            CompResultList *list = items[0];
//            NSMutableArray *rows = [NSMutableArray arrayWithArray:self.dataSource.firstObject];
//            [rows addObjectsFromArray:list.datas];
//            
//            self.isNoMoreData = (rows.count == list.totalSize);
//            
//            return @[rows];
//        }
//        self.isNoMoreData = YES;
//        
//        return self.dataSource;
//    }];
    
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self)
//        BrandViewController *vc = [[CompResultBrandViewController alloc] init];
//        vc.dId = [(CompResultItem *)input.second dId];
//        [self.navigationController pushViewController:vc animated:YES];
//        
//        CompResultItem *item = [CompResultItem new];
//        item.dId = d2.uid.integerValue;
//        item.dName = d2.drugName;
        
        //[gUser checkLoginWithFinish:^{
            BrandViewController *vc = [[BrandViewController alloc] init];
            vc.dataSource = input.second;
            [self.navigationController pushViewController:vc animated:YES];
        //} error:nil];
        
        return [RACSignal empty];
    }];
}

#pragma mark - Private methods
#pragma mark setup

- (void)setupVar {
}

- (void)setupData {
}

- (void)setupView {
    self.navigationItem.title = @"药品列表";
    
    UINib *nib = [UINib nibWithNibName:@"ResultCardCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[ResultCardCell identifier]];
    self.tableView.tableFooterView = [UIView new];
}

- (void)setupSignal {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
#pragma mark assist

#pragma mark - Table
- (id)fetchLocalData {
    return nil;
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    if (self.symptomRequest) {
        return [HRInstance searchThroughDiseases:[self.symptomRequest mj_JSONObject]];
    }
    
    if (self.isPrecised) {
        return [HRInstance getPageGroupBySocName2WithKeyword:self.keyword socName:self.scope page:page rows:JXInstance.pageSize natureType:self.type];
    }
    return [HRInstance getPageGroupBySocNameWithKeyword:self.keyword socName:self.scope page:page rows:JXInstance.pageSize natureType:self.type];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    ResultCardCell *myCell = (ResultCardCell *)cell;
    myCell.data = object;
    myCell.splitImageView.hidden = NO;
    
//    myCell.textLabel.numberOfLines = 2;
//    
//    CompResultItem *item = object;
//    NSString *name = JXStrWithDft(item.dName, @"");
//    NSString *zz = JXStrWithDft(item.dcName, @"");
//    NSString *type = JXStrWithDft(item.dNatureType, @"");
//    NSString *str = JXStrWithFmt(@"%@  %@\n%@", name, type, zz);
//    NSMutableAttributedString *as = [NSMutableAttributedString jx_attributedStringWithString:str color:JXColorHex(0x999999) font:JXFont(10)];
//    
//    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
//    [ps setLineSpacing:2];
//    [as addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, str.length)];
//    
//    [as jx_addAttributeWithColor:JXColorHex(0x333333) font:JXFont(13) range:NSMakeRange(0, name.length)];
//    
//    myCell.textLabel.attributedText = as;
//    myCell.accessoryType = UITableViewCellAccessoryNone;
//    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    if (!myCell.accessoryView) {
//        UIImage *image = JXAdaptImage(JXImageWithName(@"ic_arrow_right"));
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//        myCell.accessoryView = imageView;
//    }
//    
//    NSArray *items = [self.dataSource firstObject];
//    if ((items.count - 1) == indexPath.row) {
//        myCell.separatorInset = UIEdgeInsetsZero;
//    }else {
//        myCell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ResultCardCell height];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [self.tableView dequeueReusableCellWithIdentifier:[ResultCardCell identifier] forIndexPath:indexPath];
}

#pragma mark - Accessor methods
#pragma mark - Action methods
#pragma mark - Notification methods

#pragma mark - Delegate methods
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (0 == [(NSArray *)[self.dataSource firstObject] count]) {
//        return 0;
//    }
//    return JXScreenScale(44);
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (0 == [(NSArray *)[self.dataSource firstObject] count]) {
//        return 0;
//    }
//    
//    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kJXIdentifierHeaderFooter];
//    CategoryView *cv = [view viewWithTag:101];
//    if (!cv) {
//        cv = [[[NSBundle mainBundle] loadNibNamed:@"CategoryView" owner:nil options:nil] firstObject];
//        cv.titleLabel.text = JXStrWithFmt(@"全部%@药品推荐", self.scope);
//        cv.tag = 101;
//        [view addSubview:cv];
//        [cv mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(view);
//        }];
//    }
//    return view;
//}

#pragma mark - Public methods
#pragma mark - Class methods


@end
