//
//  JXButton.m
//  JXSamples
//
//  Created by 杨建祥 on 16/4/23.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXButton.h"

@implementation JXButton
/****************************************************************************
 ***************************************************************************/
#pragma mark Override
#pragma mark Accessor
#pragma mark Assist
#pragma mark Action
#pragma mark Delegate
#pragma mark Class



#pragma mark Override
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self custom];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self custom];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    switch (self.style) {
        case JXButtonStyleLeft:
            [self styleLeft];
            break;
        case JXButtonStyleTop:
            break;
        case JXButtonStyleRight:
            [self styleRight];
            break;
        case JXButtonStyleBottom:
            [self styleBottom];
            break;
        case JXButtonStyleCustom1:
            [self styleCustom1];
            break;
        default:
            break;
    }
}

#pragma mark Accessor
- (JXButtonStyle)style {
    if (JXButtonStyleNone == _style) {
        _style = JXButtonStyleLeft;
    }
    return _style;
}

- (CGFloat)distance {
    if (0 == _distance) {
        _distance = 4.0f;
    }
    return _distance;
}

#pragma mark Assist
- (void)custom {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)styleLeft {
    [self.titleLabel sizeToFit];
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize imageSize = [self imageForState:UIControlStateNormal].size;
    
    if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
        return;
    }
    
    CGFloat slide = (CGRectGetWidth(self.frame) - titleSize.width - self.distance - imageSize.width) / 2.0;
    
    CGFloat imageX = slide + imageSize.width / 2.0;
    CGFloat imageY = CGRectGetHeight(self.frame) / 2.0;
    self.imageView.center = CGPointMake(imageX, imageY);
    
    CGFloat titleX = CGRectGetWidth(self.frame) - slide - titleSize.width / 2.0;
    CGFloat titleY = CGRectGetHeight(self.frame) / 2.0;
    self.titleLabel.center = CGPointMake(titleX, titleY);
}

- (void)styleRight {
    [self.titleLabel sizeToFit];
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize imageSize = [self imageForState:UIControlStateNormal].size;
    
    if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
        return;
    }
    
    CGFloat imageX = CGRectGetWidth(self.frame) - (CGRectGetWidth(self.frame) - titleSize.width - self.distance - imageSize.width) / 2.0 - imageSize.width / 2.0;
    CGFloat imageY = CGRectGetHeight(self.frame) / 2.0;
    self.imageView.center = CGPointMake(imageX, imageY);
    
    CGFloat titleX = (CGRectGetWidth(self.frame) - titleSize.width - self.distance - imageSize.width) / 2.0 + titleSize.width / 2.0;
    CGFloat titleY = CGRectGetHeight(self.frame) / 2.0;
    self.titleLabel.center = CGPointMake(titleX, titleY);
}

- (void)styleBottom {
    [self.titleLabel sizeToFit];
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize imageSize = [self imageForState:UIControlStateNormal].size;
    
    if (imageSize.width != 0 && imageSize.height != 0) {
        CGFloat imageViewCenterY = (CGRectGetHeight(self.frame) - imageSize.height - self.distance - titleSize.height) / 2.0 + imageSize.height / 2.0;
        // CGFloat imageViewCenterY = CGRectGetHeight(self.frame) - 3 - titleSize.height - imageSize.height / 2 - 5;
        self.imageView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, imageViewCenterY);
    } else {
        CGPoint imageViewCenter = self.imageView.center;
        imageViewCenter.x = CGRectGetWidth(self.frame) / 2;
        imageViewCenter.y = (CGRectGetHeight(self.frame) - titleSize.height) / 2;
        self.imageView.center = imageViewCenter;
    }
    
    CGFloat titleLabelCenterY = (CGRectGetHeight(self.frame) - imageSize.height - self.distance - titleSize.height) / 2.0 + imageSize.height + self.distance + titleSize.height / 2.0;
    CGPoint labelCenter = CGPointMake(CGRectGetWidth(self.frame) / 2, titleLabelCenterY);
    self.titleLabel.center = labelCenter;
}

- (void)styleCustom1 {
    [self.titleLabel sizeToFit];
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize imageSize = [self imageForState:UIControlStateNormal].size;
    
    if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
        return;
    }
    
    CGFloat slide = (self.jx_width - imageSize.width - self.distance - titleSize.width) / 2.0;
    CGFloat imageX = slide + imageSize.width / 2.0;
    CGFloat imageY = self.jx_height / 2.0;
    self.imageView.center = CGPointMake(imageX, imageY);
    
    CGFloat titleX = self.jx_width - slide - titleSize.width / 2.0;
    CGFloat titleY = imageY;
    self.titleLabel.center = CGPointMake(titleX, titleY);
}


@end






