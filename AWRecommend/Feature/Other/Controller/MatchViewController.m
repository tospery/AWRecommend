//
//  MatchViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/22.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "MatchViewController.h"
#import "CircleView.h"

@interface MatchViewController ()
@property (nonatomic, weak) IBOutlet UIView *matchView;
@property (nonatomic, weak) IBOutlet UIView *bgView;

@property (nonatomic, strong) CircleView *circleView;
@property (nonatomic, strong) UILabel *degreeLabel;

@end

@implementation MatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = CGRectMake(0, 0, JXScreenScale(220), JXScreenScale(120));
    [self.matchView addSubview:self.circleView];
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.matchView);
    }];
    
    [self.matchView addSubview:self.degreeLabel];
//    [self.degreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        //make.center.equalTo(self.matchView);
//        make.center.equalTo(self.matchView);
//    }];
    
    [self.circleView setStrokeEnd:(self.matchDegree / 100.0f)animated:NO];
    self.degreeLabel.text = JXStrWithFmt(@"匹配度\n%ld%%", (long)self.matchDegree);
}

- (CircleView *)circleView {
    if (!_circleView) {
        _circleView = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, JXScreenScale(44), JXScreenScale(44))];
        _circleView.strokeColor = [UIColor whiteColor];
        [_circleView setStrokeEnd:0 animated:NO];
    }
    return _circleView;
}

- (UILabel *)degreeLabel {
    if (!_degreeLabel) {
        _degreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, JXScreenScale(44), JXScreenScale(44))];
        _degreeLabel.backgroundColor = [UIColor clearColor];
        _degreeLabel.font = JXFont(9);
        _degreeLabel.textColor = [UIColor whiteColor];
        _degreeLabel.numberOfLines = 2;
        _degreeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _degreeLabel;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //self.circleView.center = self.matchView.center;
    //self.degreeLabel.center = self.matchView.center;
    
    [self.view jx_borderWithColor:[UIColor clearColor] width:0.0 radius:8.0];
}

- (IBAction)closeButtonPressed:(id)sender {
    if (self.closeBlock) {
        self.closeBlock();
    }
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
