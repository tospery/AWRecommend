//
//  JXAutoRollView.m
//  JXSamples
//
//  Created by 杨建祥 on 16/5/15.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXAutoRollView.h"

#define JXAutoRollViewDefaultDuration               (3.0f)

@interface JXAutoRollView () <UIScrollViewDelegate>
@property (nonatomic, strong) JXScheduleHandler *handler;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) CGFloat startOffsetX;
@property (nonatomic, assign, readwrite) NSInteger currentIndex;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign, readwrite) NSUInteger total;
@property (nonatomic, strong, readwrite) NSArray *views;
@property (nonatomic, strong) NSMutableArray *contentViews;
@property (nonatomic, copy) JXVoidBlock_int didTapBlock;
@end

@implementation JXAutoRollView
#pragma mark - Override
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self customInit];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.currentIndex = 0;
    [self stopRolling];
    [self configContentSize];
    [self configContentViews];
    [self startRolling];
}

- (void)dealloc {
    [self stopRolling];
}

#pragma mark - Accessor
//- (void)setCurrentIndex:(NSInteger)currentIndex {
//    if (_currentIndex != currentIndex &&
//        self.didScrollBlock) {
//        self.didScrollBlock(currentIndex);
//    }
//    
//    _currentIndex = currentIndex;
//}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.contentMode = UIViewContentModeCenter;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (JXScheduleHandler *)handler {
    if (!_handler) {
        _handler = [[JXScheduleHandler alloc] init];
        @weakify(self)
        _handler.didTriggerBlock = ^(id sender) {
            @strongify(self)
            [self performScrolling];
        };
    }
    return _handler;
}

- (NSMutableArray *)contentViews {
    if (!_contentViews) {
        _contentViews = [NSMutableArray arrayWithCapacity:3];
    }
    return _contentViews;
}

- (void)setViews:(NSArray *)views {
    _views = views;
    self.total = views.count;
}

#pragma mark - Assist
#pragma mark custom
- (void)customInit {
    self.duration = JXAutoRollViewDefaultDuration;
    
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark setup
- (void)setupViews:(NSArray *)views didTapBlock:(JXVoidBlock_int)didTapBlock {
    [self setupViews:views didTapBlock:didTapBlock duration:JXAutoRollViewDefaultDuration];
}

- (void)setupViews:(NSArray *)views didTapBlock:(JXVoidBlock_int)didTapBlock duration:(NSTimeInterval)duration {
    BOOL isHave = NO;
    if (0 != self.views.count) {
        isHave = YES;
    }
    
    self.views = views;
    self.didTapBlock = didTapBlock;
    self.duration = duration;
    
    if (isHave) {
        [self stopRolling];
        self.currentIndex = 0;
        [self configContentSize];
        [self configContentViews];
        if (self.total <= 1) {
            [self.scrollView setContentOffset:CGPointZero animated:NO];
        }else {
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.jx_width, 0) animated:NO];
        }
        [self startRolling];
    }else {
        [self setNeedsLayout];
    }
}

#pragma mark config
- (void)configContentSize {
    if (self.total <= 1) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.jx_width + 1, self.scrollView.jx_height);
    }else {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.jx_width * 3, self.scrollView.jx_height);
    }
}

- (void)configContentViews {
    [self.contentViews removeAllObjects];
    if (0 == self.total) {
        // 如果没有数据，应该隐藏Banner
    }else if (1 == self.total) {
        [self.contentViews addObject:self.views[self.currentIndex]];
    }else {
        NSInteger prevIndex = [self getContentIndexWithPageIndex:self.currentIndex - 1];
        NSInteger nextIndex = [self getContentIndexWithPageIndex:self.currentIndex + 1];
        [self.contentViews addObject:self.views[prevIndex]];
        [self.contentViews addObject:self.views[self.currentIndex]];
        [self.contentViews addObject:self.views[nextIndex]];
    }
    

    CGFloat width = self.scrollView.jx_width;
    CGFloat height = self.scrollView.jx_height;
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSInteger i = 0; i < self.contentViews.count; ++i) {
        UIView *view = self.contentViews[i];
        [view jx_addTapGestureWithTarget:self action:@selector(contentViewDidTap:)];
        [view jx_addLongTapGestureWithTarget:self action:@selector(contentViewLongTap:)];
        view.frame = CGRectMake(width * i, 0, width, height);
        [self.scrollView addSubview:view];
    }
    
    if (self.total <= 1) {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }else {
       self.scrollView.contentOffset = CGPointMake(width, 0);
    }
}

#pragma mark other
- (void)startRolling {
    if (self.total <= 1) {
        return;
    }
    
    [self.handler performSelector:@selector(didTriggerAction:) withObject:nil afterDelay:self.duration];
}

- (void)stopRolling {
    [NSObject cancelPreviousPerformRequestsWithTarget:self.handler selector:@selector(didTriggerAction:) object:nil];
}

- (void)performScrolling {
    CGFloat width = self.scrollView.jx_width;
    CGFloat offsetX = self.scrollView.contentOffset.x;
    offsetX = nearbyint(offsetX / width) * width;
    CGPoint newOffset = CGPointMake(offsetX + width, 0);
    [self.scrollView setContentOffset:newOffset animated:YES];
    [self startRolling];
}

- (NSInteger)getContentIndexWithPageIndex:(NSInteger)pageIndex; {
    if (-1 == pageIndex) {
        return self.total - 1;
    }
    
    if (self.total == pageIndex) {
        return 0;
    }
    
    return pageIndex;
}

#pragma mark - Action
- (void)contentViewDidTap:(UITapGestureRecognizer *)tapGR {
    if (self.didTapBlock) {
        self.didTapBlock(self.currentIndex);
    }
}

- (void)contentViewLongTap:(UILongPressGestureRecognizer *)tapGesture {
    if (UIGestureRecognizerStateBegan == tapGesture.state) {
        [self stopRolling];
    }else if (UIGestureRecognizerStateEnded == tapGesture.state) {
        [self startRolling];
    }
}

#pragma mark - Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.total <= 1) {
        return;
    }
    
    self.startOffsetX = scrollView.contentOffset.x;
    [self stopRolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.total <= 1) {
        return;
    }
    
    [self startRolling];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.total <= 1) {
        return;
    }
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if (2 == self.total) {
        if (self.startOffsetX > offsetX) {
            UIView *firstView = self.contentViews.firstObject;
            firstView.frame = CGRectMake(0, 0, firstView.jx_width, firstView.jx_height);
        }else if (self.startOffsetX < offsetX) {
            UIView *secondView = self.contentViews.lastObject;
            secondView.frame = CGRectMake(scrollView.jx_width * 2.0, 0, secondView.jx_width, secondView.jx_height);
        }
    }
    
    if (offsetX <= 0) {
        self.currentIndex = [self getContentIndexWithPageIndex:self.currentIndex - 1];
        [self configContentViews];
    }else if (offsetX >= (scrollView.jx_width * 2)) {
        self.currentIndex = [self getContentIndexWithPageIndex:self.currentIndex + 1];
        [self configContentViews];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.total <= 1) {
        [scrollView setContentOffset:CGPointZero animated:YES];
        return;
    }
    [scrollView setContentOffset:CGPointMake(scrollView.jx_width, 0) animated:YES];
}

#pragma mark - Class



@end
