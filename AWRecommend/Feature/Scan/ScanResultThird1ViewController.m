//
//  ScanResultThird1ViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/7/12.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ScanResultThird1ViewController.h"

@interface ScanResultThird1ViewController ()
@property (nonatomic, weak) IBOutlet UILabel *codeLabel;
@property (nonatomic, weak) IBOutlet UITextField *brandField;
@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *phoneField;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;

@property (nonatomic, strong) RACCommand *submitCommand;

@end

@implementation ScanResultThird1ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"扫码结果";
    self.codeLabel.text = self.barcode;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [SMInstance configButtonStyle1:self.submitButton fontSize:16.0f borderRadius:8.0f];
}

- (RACCommand *)submitCommand {
    if (!_submitCommand) {
        _submitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *t) {
            return [HRInstance addUserSeggestionsWithBarcode:t.first brandName:t.second drugName:t.third phone:t.fourth];
        }];
        
        [_submitCommand.executing subscribe:self.executing];
        [_submitCommand.errors subscribe:self.errors];
        
        @weakify(self)
        [_submitCommand.executionSignals.switchToLatest subscribeNext:^(NSString *result) {
            @strongify(self)
            // JXHUDSuccess(@"提交成功~", NO);
            [JXDialog showPopup:@"提交成功~"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }];
    }
    return _submitCommand;
}

- (IBAction)submitButtonPressed:(id)sender {
    [self.submitCommand execute:RACTuplePack(self.barcode, self.brandField.text, self.nameField.text, self.phoneField.text)];
}

@end
     
     
     
