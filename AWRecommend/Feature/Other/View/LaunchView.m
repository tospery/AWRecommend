//
//  LaunchView.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/13.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "LaunchView.h"

@interface LaunchView ()
@property (nonatomic, weak) IBOutlet FLAnimatedImageView *imageView;

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSTimer *timer;
//@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
//@property (nonatomic, weak) IBOutlet UIButton *fgButton;

@property (nonatomic, copy) JXVoidBlock completionBlock;

@property (nonatomic, weak) IBOutlet UIButton *guideButton;

@end

@implementation LaunchView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, JXScreenWidth, JXScreenHeight);
    self.count = 2;
    self.guideButton.tag = 1;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"my_luanchimage_1242X2208" ofType:@"gif"];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:filePath]];
    self.imageView.animatedImage = image;
}

- (void)countdownHandler {
    if (0 == self.count) {
        [self.timer invalidate];
        self.timer = nil;
        
        gMisc.hasFirstGuide = YES; // YJX_TODO 屏蔽引导
        if (gMisc.hasFirstGuide) {
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                //self.frame = CGRectMake(JXScreenWidth * -1, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
                self.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                
                if (self.completionBlock) {
                    self.completionBlock();
                }
            }];
        }else {
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.imageView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                //                [self removeFromSuperview];
                //
                //                if (self.completionBlock) {
                //                    self.completionBlock();
                //                }
            }];
        }
    }else {
        self.count -= 1;
        //self.timeLabel.text = JXStrWithInt(self.count);
    }
}

- (void)startAnimWithCompletion:(JXVoidBlock)completion {
    [JXAppWindow addSubview:self];
    [JXAppWindow bringSubviewToFront:self];
    
    self.completionBlock = completion;
    
    //self.fgButton.alpha = 0.0f;
    //self.fgButton.enabled = NO;
    [UIView animateWithDuration:0.01 animations:^{
        //self.fgButton.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(countdownHandler) userInfo:nil repeats:YES];
    }];
}

- (IBAction)guideButtonPressed:(UIButton *)btn {
    btn.tag++;
    
    if (btn.tag <= 4) {
        UIImage *image = JXImageWithName(JXStrWithFmt(@"new_guidelines_%ld", (long)btn.tag));
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        return;
    }else if (btn.tag == 5) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            gMisc.hasFirstGuide = YES;
            
            [self removeFromSuperview];
            
            if (self.completionBlock) {
                self.completionBlock();
            }
        }];
    }
}


@end




