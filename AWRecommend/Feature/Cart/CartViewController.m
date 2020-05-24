//
//  CartViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/8/21.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "CartViewController.h"

@interface CartViewController ()
@property (nonatomic, strong) UIBarButtonItem *editItem;
@property (nonatomic, strong) UIBarButtonItem *finishItem;

@end

@implementation CartViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editItemPressed:)];
    self.finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishItemPressed:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = self.editItem;
}

- (void)editItemPressed:(id)sender {
    self.navigationItem.rightBarButtonItem = self.finishItem;
    
    WebInteraction *wi = [WebInteraction new];
    wi.code = 5;
    wi.data = [WebInteractionData new];
    wi.data.platform = 2;
    wi.data.token = JXStrWithDft(gUser.token, @"");
    
    NSString *jsonString = [wi mj_JSONString];
    [self.bridge callHandler:self.jsCallbackIdentifier data:jsonString responseCallback:^(id responseData) {
        //NSLog(@"55555555");
    }];
}

- (void)finishItemPressed:(id)sender {
    self.navigationItem.rightBarButtonItem = self.editItem;
    
    WebInteraction *wi = [WebInteraction new];
    wi.code = 6;
    wi.data = [WebInteractionData new];
    wi.data.platform = 2;
    wi.data.token = JXStrWithDft(gUser.token, @"");
    
    NSString *jsonString = [wi mj_JSONString];
    [self.bridge callHandler:self.jsCallbackIdentifier data:jsonString responseCallback:^(id responseData) {
        //NSLog(@"66666666");
    }];
}

- (void)finishLoad {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
