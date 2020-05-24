//
//  ProgressViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/17.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ProgressViewController.h"

@interface ProgressViewController ()
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak) IBOutlet UIView *bottomView;

@property (nonatomic, weak) IBOutlet FLAnimatedImageView *firstImageView;
//@property (nonatomic, weak) IBOutlet FLAnimatedImageView *secondImageView;

@end

@implementation ProgressViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = CGRectMake(0, 0, JXScreenWidth, JXScreenHeight);
    
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
//    effectView.alpha = 0.7;
//    [self.bottomView addSubview:effectView];
//    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.bottomView);
//    }];
    
//    if (self.isBrand) {
//        self.view.frame = CGRectMake(0, 200, JXScreenWidth, JXScreenHeight);
//    }
    
    UIImage *bgImage = self.isBrand ? JXImageWithName(@"bg_loding_brand") : JXImageWithName(@"bg_loding_drug");
    self.bgImageView.image = bgImage;
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"img_loading_img" ofType:@"gif"];
//    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:filePath]];
//    self.firstImageView.animatedImage = image;
    
    NSString *name = self.isBrand ? @"img_loading_font2" : @"img_loading_font1";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:filePath]];
    self.firstImageView.animatedImage = image;
    //self.firstImageView.runLoopMode = NSRunLoopCommonModes;
    
    self.duration = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(scheduledTimer) userInfo:nil repeats:YES];
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

- (IBAction)backButtonPressed:(id)btn {
    if (self.backBlock) {
        self.backBlock();
    }
}

- (void)scheduledTimer {
    self.duration += 0.2;
    
    CGFloat time = self.isBrand ? 3 : 3;
    if (self.toFinish) {
        if (self.duration >= time) {
            [self.timer invalidate];
            self.timer = nil;
            
            if (self.finishBlock) {
                self.finishBlock();
            }
        }
    }else {
        if (self.duration >= 60) {
            [self.timer invalidate];
            self.timer = nil;
            
            if (self.finishBlock) {
                self.finishBlock();
            }
        }
    }
}

@end



