//
//  JXTipsViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/11.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXTipsViewController.h"

@interface JXTipsViewController ()
@property (nonatomic, strong) NSAttributedString *message;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;

@end

@implementation JXTipsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.messageLabel.lineSpacing = 2.0f;
//    self.messageLabel.text = self.message;
//    self.messageLabel.textColor = [UIColor whiteColor];
//    self.messageLabel.font = [UIFont systemFontOfSize:JXAdaptFontSize(13)];
//    self.messageLabel.numberOfLines = 0;

    CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:self.message withConstraints:CGSizeMake(JXAdaptScreen(180), CGFLOAT_MAX) limitedToNumberOfLines:INT32_MAX];
    
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.attributedText = self.message;
    
    self.view.backgroundColor = SMInstance.mainColor;
    self.view.frame = CGRectMake(0, 0, size.width + 40 + 14, size.height + 40 + 8);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view jx_borderWithColor:[UIColor clearColor] width:0.0 radius:6.0];
}

- (instancetype)initWithMessage:(NSAttributedString *)message {
    if (self = [self init]) {
        _message = message;
    }
    return self;
}



@end




