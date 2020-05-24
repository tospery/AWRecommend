//
//  JXRatingView.m
//  JXSamples
//
//  Created by 杨建祥 on 16/8/9.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXRatingView.h"

@interface JXRatingView ()
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, assign) BOOL animated;
@property (nonatomic, copy) JXVoidBlock completion;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *fgView;
@end

@implementation JXRatingView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self initialize];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    CGFloat height = JXAdaptScreen(28.0f);
    return CGSizeMake(height * self.count, height);
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (0 == self.subviews.count) {
        [self addSubview:self.bgView];
        [self addSubview:self.fgView];
        
        if (self.score) {
            [self setScore:self.score animated:self.animated completion:self.completion];
            self.score = 0.0f;
        }else {
            [self setScore:0.0 animated:NO completion:NULL];
        }
    }
}

- (void)initialize {
    _count = 5;
    _enable = YES;
}

- (UIImage *)bgImage {
    if (!_bgImage) {
        _bgImage = JXAdaptImage(JXImageWithName(@"jxres_rating_bg"));
    }
    return _bgImage;
}

- (UIImage *)fgImage {
    if (!_fgImage) {
        _fgImage = JXAdaptImage(JXImageWithName(@"jxres_rating_fg"));
    }
    return _fgImage;
}

- (UIView *)bgView {
    if (!_bgView) {
        CGRect frame = self.bounds;
        _bgView = [[UIView alloc] initWithFrame:frame];
        _bgView.clipsToBounds = YES;
        for (NSInteger i = 0; i < self.count; i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:self.bgImage];
            imageView.contentMode = UIViewContentModeCenter;
            imageView.frame = CGRectMake(i * frame.size.width / self.count, 0, frame.size.width / self.count, frame.size.height);
            [_bgView addSubview:imageView];
        }
    }
    return _bgView;
}

- (UIView *)fgView {
    if (!_fgView) {
        CGRect frame = self.bounds;
        _fgView = [[UIView alloc] initWithFrame:frame];
        _fgView.clipsToBounds = YES;
        for (NSInteger i = 0; i < self.count; i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:self.fgImage];
            imageView.contentMode = UIViewContentModeCenter;
            imageView.frame = CGRectMake(i * frame.size.width / self.count, 0, frame.size.width / self.count, frame.size.height);
            [_fgView addSubview:imageView];
        }
    }
    return _fgView;
}

- (void)setScore:(CGFloat)score animated:(BOOL)animated completion:(JXVoidBlock)completion {
    NSAssert((score >= 0.0)&&(score <= 1.0), @"score must be between 0 and 1");
    
    if (!_fgView) {
        self.score = score;
        self.animated = animated;
        self.completion = completion;
        return;
    }
    
    if (score < 0) {
        score = 0;
    }
    
    if (score > 1) {
        score = 1;
    }
    
    CGPoint point = CGPointMake(score * self.frame.size.width, 0);
    
    if(animated) {
        @weakify(self)
        [UIView animateWithDuration:0.2 animations:^ {
            @strongify(self)
            [self changeFgViewWithPoint:point];
        } completion:^(BOOL finished) {
            if (completion && finished) {
                completion();
            }
        }];
    } else {
        [self changeFgViewWithPoint:point];
    }
}

- (void)changeFgViewWithPoint:(CGPoint)point {
    CGPoint p = point;
    
    if (p.x < 0) {
        p.x = 0;
    }
    
    if (p.x > self.frame.size.width) {
        p.x = self.frame.size.width;
    }
    
    NSString *str = [NSString stringWithFormat:@"%0.2f",p.x / self.frame.size.width];
    float score = [str floatValue];
    p.x = score * self.frame.size.width;
    self.fgView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
    //    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)])
    //    {
    //        [self.delegate starRatingView:self score:score];
    //    }
}

#pragma mark - Touche Event
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!self.enable) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect, point)) {
        [self changeFgViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.enable) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    @weakify(self)
    [UIView animateWithDuration:0.2 animations:^ {
        @strongify(self)
         [self changeFgViewWithPoint:point];
     }];
}

@end










