//
//  JXTextView.m
//  JXSamples
//
//  Created by 杨建祥 on 2017/8/7.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXTextView.h"

@interface JXTextView ()
@property (nonatomic, strong, readwrite) UILabel *placeholderLabel;

@end

@implementation JXTextView
#pragma mark - Override
#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self custom];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self custom];
    }
    return self;
}

#pragma mark other
- (void)layoutSubviews {
    [super layoutSubviews];
    [self textChanged:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Accessor
- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.textColor = [UIColor colorWithRed:.78 green:.78 blue:.80 alpha:1.0];
        _placeholderLabel.font = JXFont(14);
        _placeholderLabel.userInteractionEnabled = NO;
        _placeholderLabel.hidden = YES;
    }
    return _placeholderLabel;
}

#pragma mark - Private
- (void)custom {
    self.textContainerInset = UIEdgeInsetsMake(8, 6, 8, 6);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
    [self addSubview:self.placeholderLabel];
}

#pragma mark - Public
#pragma mark - Action
- (void)textChanged:(NSNotification *)notification {
    if (0 == self.placeholderLabel.text.length) {
        return;
    }
    
    if (0 == self.text.length) {
        self.placeholderLabel.frame = CGRectMake(10, 8, self.bounds.size.width - 16, 0);
        [self.placeholderLabel sizeToFit];
        self.placeholderLabel.hidden = NO;
    }else {
        self.placeholderLabel.hidden = YES;
    }
}


#pragma mark - Notification
#pragma mark - Delegate
#pragma mark - Class

@end
