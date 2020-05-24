//
//  AboutViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/4/26.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutCell.h"

@interface AboutViewController ()
@property (nonatomic, weak) IBOutlet UILabel *introLabel;

@end

@implementation AboutViewController
#pragma mark - Override methods
- (instancetype)init {
    if (self = [super init]) {
        // self.shouldRequestRemoteDataOnViewDidLoad = YES;
        // self.shouldPullToRefresh = YES;
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)bindViewModel {
    [super bindViewModel];
    
    RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    //RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[fetchLocalDataSignal deliverOnMainThread] map:^id _Nullable(id result) {
        return JXArrEmpty(result, nil);
    }];
    
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        NSIndexPath *path = input.first;
        if (2 == path.row) {
            [JXDevice dialNumber:@"02869061922"];
        }
        
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
    self.navigationItem.title = @"关于我们";
    
    self.headerView.frame = CGRectMake(0, 0, JXScreenWidth, JXScreenScale(220));
    
    UINib *nib = [UINib nibWithNibName:@"AboutCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[AboutCell identifier]];
    // self.tableView.tableFooterView = [UIView new];
    
    UIColor *color = JXColorHex(0xf1f2f3);
    self.view.backgroundColor = color;
    self.contentView.backgroundColor = color;
    self.tableView.backgroundColor = color;
    self.headerView.backgroundColor = color;
    self.footerView.backgroundColor = color;
    
    NSMutableAttributedString *as = [NSMutableAttributedString jx_attributedStringWithString:@"健康智选——-以传承中医药养生文化为指导，臻萃道地药食同源食材，创新时尚本草产品，把提升现代人日常健康水平作为目标，为不同体质人群找到适合自己的本草，以食代药，以茶代药，用本草的能量滋养生命的元气。" color:JXColorHex(0x555555) font:JXFont(13.0f)];
    [as jx_addLineSpacing:8.0 alignment:NSTextAlignmentLeft];
    self.introLabel.attributedText = as;
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
    return @[@[RACTuplePack(@"官方网址：", @"http://www.appvworks.com"),
               RACTuplePack(@"客服邮箱：", @"ai.bao@appvworks.com"),
               /*RACTuplePack(@"客服微博：", @"@健康智选"),*/
               RACTuplePack(@"客服电话：", @"028 6906 1922"),
               RACTuplePack(@"微信公众号：", @"健康智选"),
               RACTuplePack(@"版本更新：", [JXApp sharedInstance].version)]];
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    return [RACSignal empty];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    AboutCell *myCell = (AboutCell *)cell;
    myCell.data = object;
    if (2 == indexPath.row) {
        myCell.accessoryImageView.hidden = NO;
    }else {
        myCell.accessoryImageView.hidden = YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [AboutCell height];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [self.tableView dequeueReusableCellWithIdentifier:[AboutCell identifier] forIndexPath:indexPath];
}

#pragma mark - Accessor methods
#pragma mark - Action methods
#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource

#pragma mark - Public methods
#pragma mark - Class methods


@end
