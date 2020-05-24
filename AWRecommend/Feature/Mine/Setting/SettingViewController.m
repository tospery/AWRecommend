//
//  SettingViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/16.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutViewController.h"
#import "FeedbackViewController.h"
#import "ShareViewController.h"
#import "ProfileViewController11.h"
#import "ProfileViewController.h"

@interface SettingViewController ()
@property (nonatomic, weak) IBOutlet UIView *toolView;
@property (nonatomic, strong) RACCommand *exitCommand;

@end

@implementation SettingViewController
#pragma mark - Override
#pragma mark init
- (instancetype)init {
    if (self = [super init]) {
        // self.shouldRequestRemoteDataOnViewDidLoad = YES;
        // self.shouldPullToRefresh = YES;
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
    self.navigationItem.title = @"设置";
    
    //    UINib *nib = [UINib nibWithNibName:@"JXCell" bundle:nil];
    //    [self.tableView registerNib:nib forCellReuseIdentifier:[JXCell identifier]];
    //    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.backgroundColor = JXColorHex(0xF7F8F9);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.sectionHeaderHeight = 12.0f;
    self.tableView.sectionFooterHeight = 0.0f;
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)setupNet {
    
}

#pragma mark scroll
- (void)bindViewModel {
    [super bindViewModel];
    
    RAC(self.toolView, hidden) = [RACObserve(gUser, isLogined) map:^id _Nullable(NSNumber *isLogined) {
        return @(!(isLogined.boolValue));
    }];
    
//    RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
//    // RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
//    RAC(self, dataSource) = [[fetchLocalDataSignal deliverOnMainThread] map:^id _Nullable(id result) {
//        return result;
//    }];
    
    RAC(self, dataSource) = [RACObserve(gUser, isLogined) map:^id _Nullable(id  _Nullable value) {
        return [self getSections];
    }];
    
    @weakify(self)
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self)
        NSString *text = input.second;
        if ([text isEqualToString:@"立即登录"]) {
//            [gUser checkLoginWithFinish:^{
//                // self.dataSource = [self getSections];
//            } error:nil];
            
            [gUser checkLoginWithFinish:^(BOOL isRelogin) {
                
            } error:nil];
        }else if ([text isEqualToString:@"修改个人信息"]) {
            ProfileViewController11 *vc = [[ProfileViewController11 alloc] init];
            vc.navItemColor = JXColorHex(0x333333);
            vc.statusBarStyle = JXStatusBarStyleDefault;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([text isEqualToString:@"好友推荐"]) {
            ShareViewController *vc = [[ShareViewController alloc] init];
            //ProfileViewController *vc = [[ProfileViewController alloc] init];
            vc.navItemColor = JXColorHex(0x333333);
            vc.statusBarStyle = JXStatusBarStyleDefault;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([text isEqualToString:@"帮助与反馈"]) {
            JXWebViewController *vc = [[JXWebViewController alloc] initWithURL:JXURLWithStr(kHelpLink) title:text];
            vc.navItemColor = JXColorHex(0x333333);
            vc.statusBarStyle = JXStatusBarStyleDefault;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([text isEqualToString:@"去好评"]) {
            [[UIApplication sharedApplication] openURL:JXURLWithStr(kAppStoreLink)];
        }else if ([text isEqualToString:@"关于我们"]) {
            AboutViewController *vc = [[AboutViewController alloc] init];
            vc.navItemColor = JXColorHex(0x333333);
            vc.statusBarStyle = JXStatusBarStyleDefault;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        return [RACSignal empty];
    }];
}

//- (id)fetchLocalData {
//    return [self getSections];
//}
//
//- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
//    return [RACSignal empty];
//}

#pragma mark table
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [JXCell height];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
    return [self.tableView dequeueReusableCellWithIdentifier:[JXCell identifier] forIndexPath:indexPath];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    JXCell *myCell = (JXCell *)cell;
    myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    myCell.textLabel.text = object;
    myCell.textLabel.font = JXFont(14);
    
    if ((0 == indexPath.section && 0 == indexPath.row)
        || (1 == indexPath.section && 1 == indexPath.row)
        || (2 == indexPath.section && 1 == indexPath.row)) {
        myCell.separatorImageView.hidden = YES;
    }else {
        myCell.separatorImageView.hidden = NO;
    }
}

#pragma mark - Accessor
- (RACCommand *)exitCommand {
    if (!_exitCommand) {
        _exitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance exitLogin];
        }];
        [_exitCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *items) {
            
        }];
    }
    return _exitCommand;
}

#pragma mark - Private
- (NSArray *)getSections {
    if (gUser.isLogined) {
        return @[@[@"修改个人信息"],
                 @[@"好友推荐"/*, @"帮助与反馈"*/],
                 @[@"去好评", @"关于我们"]];
    }
    
    return @[@[@"立即登录"],
             @[@"好友推荐"/*, @"帮助与反馈"*/],
             @[@"去好评", @"关于我们"]];
}

#pragma mark - Public
#pragma mark - Action
- (IBAction)exitButtonPressed:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您是否确认退出当前账号？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.exitCommand execute:nil];
        [TMInstance removeObjectForKey:kTMTestList];
        [gUser logout];
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
    
//    [self.exitCommand execute:nil];
//    [gUser logout];
    // [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Notification

#pragma mark - Delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.textColor = JXColorHex(0x333333);
    cell.textLabel.font = JXFont(14);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return JXAdaptScreen(12.0f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kJXIdentifierHeaderFooter];
    header.backgroundView.backgroundColor = JXColorHex(0xF7F8F9);
    return header;
}

#pragma mark - Class


@end





