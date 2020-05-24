//
//  ResultCardCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/16.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ResultCardCell.h"
#import "CircleView.h"

@interface ResultCardCell ()
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *applyLabel;
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UIView *matchView;

@property (nonatomic, strong) CircleView *circleView;
@property (nonatomic, strong) UILabel *degreeLabel;

@end

@implementation ResultCardCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.font = JXFont(14);
    self.applyLabel.font = JXFont(11);
    self.typeLabel.font = JXFont(11);
    
    [self.matchView addSubview:self.circleView];
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.matchView);
    }];
    
    [self.matchView addSubview:self.degreeLabel];
    [self.degreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.matchView);
    }];
}

- (CircleView *)circleView {
    if (!_circleView) {
        _circleView = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, JXScreenScale(44), JXScreenScale(44))];
        _circleView.strokeColor = SMInstance.mainColor;
        [_circleView setStrokeEnd:0 animated:NO];
    }
    return _circleView;
}

- (UILabel *)degreeLabel {
    if (!_degreeLabel) {
        _degreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, JXScreenScale(40), JXScreenScale(40))];
        _degreeLabel.font = JXFont(10);
        _degreeLabel.textColor = SMInstance.mainColor;
        _degreeLabel.numberOfLines = 2;
        _degreeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _degreeLabel;
}

- (void)setData:(CompResultItem *)item {
    [super setData:item];
    self.nameLabel.text = item.dName;
    self.applyLabel.text = item.dcName;
    self.typeLabel.text = item.dNatureType;
    
    [self.circleView setStrokeEnd:(item.matchDegree / 100.0f)animated:YES];
    
//    // YJX_TODO整理到JX中
//    NSString *animName = @"degreeAnimation";
//    [self.degreeLabel pop_removeAnimationForKey:animName];
//    
//    POPBasicAnimation *anim = [POPBasicAnimation animation];
//    anim.duration = 1.0;
//    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    
//    POPAnimatableProperty * prop = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) {
//        prop.readBlock = ^(id obj, CGFloat values[]) {
//            values[0] = [[obj description] floatValue];
//        };
//        prop.writeBlock = ^(id obj, const CGFloat values[]) {
//            [obj setText:[NSString stringWithFormat:@"匹配度\n%ld%%",(long)values[0]]];
//        };
//        prop.threshold = 0.01;
//    }];
//    
//    anim.property = prop;
//    anim.fromValue = @(0);
//    anim.toValue = @(item.matchDegree);
//    [self.degreeLabel pop_addAnimation:anim forKey:animName];
    
    [self.degreeLabel jx_animateCountWithDuration:1.0 count:item.matchDegree isInt:YES format:@"匹配度\n%ld%%"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)matchButtonPressed:(id)sender {
    CompResultItem *item = self.data;
    if (self.matchBlock) {
        self.matchBlock(item.matchDegree);
    }
}


+ (CGFloat)height {
    return JXScreenScale(60);
}

@end
