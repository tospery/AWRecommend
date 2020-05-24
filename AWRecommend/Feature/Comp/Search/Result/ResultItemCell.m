//
//  ResultItemCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/4/6.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ResultItemCell.h"
#import "CircleView.h"

@interface ResultItemCell ()
@property (nonatomic, weak) IBOutlet UIView *matchView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *applyLabel;
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;

@property (nonatomic, weak) IBOutlet UIButton *moreButton;
@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UIView *fgView;

@property (nonatomic, strong) CircleView *circleView;
@property (nonatomic, strong) UILabel *degreeLabel;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *widthConstraint;

@end

@implementation ResultItemCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    CGFloat width = JXAdaptScreen(36);
    self.widthConstraint.constant = width;
    
    [self.matchView addSubview:self.circleView];
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.matchView);
        make.width.equalTo(@(width));
        make.height.equalTo(@(width));
    }];
    
    [self.matchView addSubview:self.degreeLabel];
    [self.degreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.matchView);
        make.width.equalTo(@(width - 2));
        make.height.equalTo(@(width - 2));
    }];
}

- (CircleView *)circleView {
    if (!_circleView) {
        CGFloat width = JXAdaptScreen(36);
        _circleView = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        _circleView.strokeColor = kColorGreenDark;
        [_circleView setStrokeEnd:0 animated:NO];
    }
    return _circleView;
}

- (UILabel *)degreeLabel {
    if (!_degreeLabel) {
        CGFloat width = JXAdaptScreen(36) - 2;
        _degreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        _degreeLabel.font = JXFont(8);
        _degreeLabel.textColor = kColorGreenDark;
        _degreeLabel.numberOfLines = 2;
        _degreeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _degreeLabel;
}

- (void)setData:(CompResultItem *)item {
    [super setData:item];
    
    if (6 == item.cellIndex) {
        self.bgView.hidden = YES;
        self.fgView.hidden = NO;
        
        NSString *more = JXStrWithFmt(@"更多%ld种药品", (long)item.cellTotal);
        [self.moreButton setTitle:more forState:UIControlStateNormal];
        
    }else {
        self.bgView.hidden = NO;
        self.fgView.hidden = YES;
        
        self.nameLabel.text = item.dName;
        self.applyLabel.text = item.dcName;
        self.typeLabel.text = item.dNatureType;
        
        [self.circleView setStrokeEnd:(item.matchDegree / 100.0f)animated:YES];
        [self.degreeLabel jx_animateCountWithDuration:1.0 count:item.matchDegree isInt:YES format:@"匹配度\n%ld%%"];
    }
}

- (IBAction)matchButtonPressed:(id)sender {
    CompResultItem *item = self.data;
    if (self.matchBlock) {
        self.matchBlock(item.matchDegree);
    }
}


+ (CGFloat)height{
    return JXScreenScale(50.0f);
}

@end
