//
//  ShortcutView.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/9/1.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ShortcutView.h"

@interface ShortcutView ()
@property (nonatomic, weak) IBOutlet UILabel *countLabel;

@end

@implementation ShortcutView
- (void)awakeFromNib {
    [super awakeFromNib];
    CGFloat width = JXAdaptScreen(115);
    CGFloat height = width / 115.0f * 40.0f;
    self.frame = CGRectMake(0, 0, width, height);
    
    @weakify(self)
    [RACObserve(gMisc, cartCount) subscribeNext:^(NSNumber *num) {
        @strongify(self)
        NSInteger count = num.integerValue;
        self.countLabel.text = (count >= 10 ? @"9+" : JXStrWithInt(count));
        if (count == 0) {
            self.countLabel.hidden = YES;
        }else {
            self.countLabel.hidden = NO;
        }
    }];
}

- (void)dealloc {
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.countLabel jx_circleWithColor:[UIColor clearColor] border:0.0];
}


- (IBAction)doctorButtonPressed:(id)sender {
    if (self.doctorBlock) {
        self.doctorBlock();
    }
}


- (IBAction)cartButtonPressed:(id)sender {
    if (self.cartBlock) {
        self.cartBlock();
    }
}

@end





