//
//  JXItemViewController.m
//  JXSamples
//
//  Created by 杨建祥 on 16/4/23.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXItemViewController.h"

@interface JXItemViewController ()
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JXItemViewController
@dynamic tableView;

//- (instancetype)init {
//    if (self = [super init]) {
//        self.tableView = ({
//            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//            tableView.dataSource = self;
//            tableView.delegate = self;
//            [self.view addSubview:tableView];
//            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(self.view);
//            }];
//            tableView;
//        });
//    }
//    return self;
//}

- (void)viewDidLoad {
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        tableView;
    });
    
    [super viewDidLoad];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self)
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self)
        NSArray *arr = input.second;
        NSString *str = [arr lastObject];
        Class cls = NSClassFromString(str);
        UIViewController *selectedVC = [[cls alloc] init];
        selectedVC.navigationItem.title = [arr firstObject];
        selectedVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:selectedVC animated:YES];
        
        [self.tableView deselectRowAtIndexPath:input.first animated:YES];
        
        return [RACSignal empty];
    }];
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
    if ([object isKindOfClass:[NSArray class]]) {
        NSArray *arr = object;
        cell.textLabel.font = JXFont(12.0);
        cell.textLabel.text = [arr firstObject];
    }
}

@end



