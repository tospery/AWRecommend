//
//  JXActionBar.m
//  JXSamples
//
//  Created by 杨建祥 on 16/6/1.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXActionBar.h"

#define kJXActionBarRotateAnimation                 (@"kJXActionBarRotateAnimation")
#define kJXActionBarShowContentAnimation            (@"kJXActionBarShowContentAnimation")
#define kJXActionBarHideContentAnimation            (@"kJXActionBarHideContentAnimation")
#define kJXActionBarAnimtionDuration                (0.2f)
#define kJXActionBarAlphaDuration                   (0.02f)

@interface JXActionBar ()
@property (nonatomic, strong) NSArray *categories;
@end

@implementation JXActionBar
#pragma mark - Override methods
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}

//- (void)willMoveToSuperview:(UIView *)newSuperview {
//    JXLogDebug(@"aaaaaaaa");
//    [super willMoveToSuperview:newSuperview];
//    [self reloadData];
//}

- (void)updateConstraints {
    [self reloadData];
    
    [super updateConstraints];
}

#pragma mark - Accessor methods
- (UIView *)rootView {
    if (!_rootView) {
        _rootView = [self get_rootview];
    }
    return _rootView;
}

- (CGFloat)topOffset {
    return [self get_topOffset];
}

#pragma mark - Private methods
- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
}

- (void)reloadData {
    //    if (!self.rootView) {
    //        self.rootView = [self get_rootview];
    //    }
    
    NSInteger categoryCount = [self get_numberOfCategories];
    if (categoryCount <= 0) {
        return;
    }
    
    [self removeAllSubviews];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor colorWithRed:205.0f/255.0f green:205.0f/255.0f blue:205.0f/255.0f alpha:1.0];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@0.5f);
    }];
    
    NSMutableArray *categories = [NSMutableArray arrayWithCapacity:categoryCount];
    for (int i = 0; i < categoryCount; ++i) {
        BOOL isLast = (i == (categoryCount - 1));
        JXActionCategory *category = [self get_categoryAtIndex:i];
        category.tag = i;
        category.delegate = self;
        [self addSubview:category];
        [category mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.bottom.equalTo(self).offset(-0.5f);
            make.width.equalTo(self).dividedBy(categoryCount).offset(isLast ? 0 : -0.5f);
            make.centerX.equalTo(self.mas_centerX).multipliedBy((i * 2 + 1) / (CGFloat)categoryCount).offset(isLast ? 0 : -0.5f);
        }];
        
        if (!isLast) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.backgroundColor = [UIColor colorWithRed:205.0f/255.0f green:205.0f/255.0f blue:205.0f/255.0f alpha:1.0];
            [self addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(category.mas_trailing);
                make.top.equalTo(self).offset(12);
                make.bottom.equalTo(self).offset(-12);
                make.width.equalTo(@0.5f);
            }];
        }
        
        [categories addObject:category];
    }
    _categories = categories;
}

#pragma mark implement
- (UIView *)get_rootview {
    if ([_dataSource respondsToSelector:@selector(rootviewForActionBar:)]) {
        return [_dataSource rootviewForActionBar:self];
    }
    
    return 0;
}

- (NSInteger)get_numberOfCategories {
    if ([_dataSource respondsToSelector:@selector(numberOfCategoriesInActionBar:)]) {
        return [_dataSource numberOfCategoriesInActionBar:self];
    }
    
    return 0;
}

- (CGFloat)get_topOffset {
    if ([_dataSource respondsToSelector:@selector(topOffsetForActionBar:)]) {
        return [_dataSource topOffsetForActionBar:self];
    }
    
    return 0;
}

- (JXActionCategory *)get_categoryAtIndex:(NSInteger)index {
    if ([_dataSource respondsToSelector:@selector(actionBar:categoryAtIndex:)]) {
        return [_dataSource actionBar:self categoryAtIndex:index];
    }
    
    return nil;
}

- (JXActionSelection *)get_selectionAtIndex:(NSInteger)index {
    if ([_dataSource respondsToSelector:@selector(actionBar:selectionAtIndex:)]) {
        return [_dataSource actionBar:self selectionAtIndex:index];
    }
    
    return nil;
}

#pragma mark assist
- (void)removeAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)resetAllSelectionExcept:(NSInteger)index{
    NSInteger categoryCount = [self get_numberOfCategories];
    for (int i = 0; i < categoryCount; ++i) {
        if (i == index) {
            continue;
        }
        
        JXActionCategory *category = [_categories objectAtIndex:i];
        
        // YJX_LIB
        if (category.isSort) {
            continue;
        }
        
        if (category.actionButton.selected) {
            category.actionButton.selected = NO;
            [self rotateCategory:category begin:NO];
        }
        
        // JXFilterViewSelection *selection = (JXFilterViewSelection *)[self.superview viewWithTag:(JXFilterViewTagBegin + i)];
        // JXFilterViewSelection *selection = (JXFilterViewSelection *)[self.window viewWithTag:(JXFilterViewTagBegin + i)];
        JXActionSelection *selection = (JXActionSelection *)[self.rootView viewWithTag:(JXActionBarTagBegin + i)];
        if (selection) {
            // CGFloat contentHeight = selection.contentView.frame.size.height;
            // selection.contentView.frame = CGRectMake(0, -contentHeight, JXScreenWidth, contentHeight);
            selection.contentView.frame = CGRectMake(0, 0, JXScreenWidth, 0);
            selection.alpha = 0.0f;
            selection.hidden = YES;
            selection.isAnimating = NO;
            [self.rootView sendSubviewToBack:selection];
        }
    }
}

//- (void)rotateCategory:(JXFilterViewCategory *)category
//                  start:(BOOL)start {
//    CGAffineTransform transform;
//    if (start) {
//        transform = CGAffineTransformRotate(indicator.transform, M_PI);
//    }else {
//        transform = CGAffineTransformRotate(indicator.transform, M_PI * -3);
//    }
//    [UIView beginAnimations:@"JXFilterViewCategory-AnimRotate" context:nil];
//    [UIView setAnimationDuration:0.25];
//    [indicator setTransform:transform];
//    [UIView commitAnimations];
//}

- (void)rotateCategory:(JXActionCategory *)category begin:(BOOL)begin {
    NSValue *value;
    if (begin) {
        value = @(M_PI * 1);
    }else {
        value = @0;
    }
    
    category.isAnimating = YES;
    
    POPSpringAnimation *anim = [category.indicatorImageView.layer pop_animationForKey:kJXActionBarRotateAnimation];
    if (!anim) {
        anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
        anim.springSpeed = 12;
        anim.springBounciness = 1;
        anim.toValue = value;
        anim.removedOnCompletion = NO;
        [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            //            if (finished) {
            //                category.isAnimating = NO;
            //            }
            category.isAnimating = NO;
        }];
        [category.indicatorImageView.layer pop_addAnimation:anim forKey:kJXActionBarRotateAnimation];
    }else {
        anim.toValue = value;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((kJXActionBarAnimtionDuration + kJXActionBarAlphaDuration) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        category.isAnimating = NO;
    });
}


#pragma mark - Delegate methods
#pragma mark JXActionCategoryDelegate
- (void)actionCategory:(JXActionCategory *)category didSelectIndex:(NSInteger)index {
    [self resetAllSelectionExcept:index];
    
    // YJX_LIB
    if (category.isSort) {
        [self rotateCategory:category begin:!category.sortPositive];
        category.sortPositive = !category.sortPositive;
        
        if ([_delegate respondsToSelector:@selector(actionBar:category:selection:index:object:)]) {
            [_delegate actionBar:self category:category selection:nil index:index object:@(category.sortPositive)];
        }
        
        return;
    }
    
    //    id a1 = self.superview;
    //    id a2 = [a1 subviews];
    //
    //    id a3 = self.window;
    //    id a4 = [self.window subviews];
    // UIView *view = [self.superview viewWithTag:(JXFilterViewTagBegin + index)];
    // UIView *view = [self.window viewWithTag:(JXFilterViewTagBegin + index)];
    UIView *view = [self.rootView viewWithTag:(JXActionBarTagBegin + index)];
    if (view && ![view isKindOfClass:[JXActionSelection class]]) {
        return;
    }
    
    JXActionSelection *selection;
    if (view) {
        selection = (JXActionSelection *)view;
    }else {
        selection = [self get_selectionAtIndex:index];
        selection.delegate = self;
        selection.contentView.delegate = self;
        selection.tag = JXActionBarTagBegin + index;
        selection.hidden = YES;
        //        [self.superview addSubview:selection];
        //        [self.superview bringSubviewToFront:self];
        //        [self.window addSubview:selection];
        //        [self.window bringSubviewToFront:self];
        [self.rootView addSubview:selection];
    }
    [self.rootView bringSubviewToFront:selection];
    [selection bringSubviewToFront:selection.contentView];
    //    NSArray *aa = selection.subviews;
    //    if (aa.count >= 2) {
    //        UIView *bb = aa[1];
    //        CGFloat cc = bb.alpha;
    //        BOOL dd =bb.hidden;
    //        int eee = 0;
    //    }
    
    if (selection.isAnimating) {
        return;
    }
    
    // CGFloat contentHeight = selection.contentView.frame.size.height;
    CGFloat contentHeight = selection.contentHeight;
    
    selection.isAnimating = YES;
    selection.frame = CGRectMake(0, CGRectGetMaxY(self.frame) + self.topOffset, JXScreenWidth, JXScreenHeight);
    if (selection.hidden) {
        [self rotateCategory:category begin:YES];
        
        // 不要动画
        //        selection.hidden = NO;
        //        selection.alpha = 1.0f;
        //        selection.contentView.frame = CGRectMake(0, 0, JXScreenWidth, contentHeight);
        //        selection.isAnimating = NO;
        //        category.isAnimating = NO;
        
        // 系统动画 tableContent无效
        //        selection.hidden = NO;
        //        selection.alpha = 1.0f;
        //        //selection.contentView.frame = CGRectMake(0, -contentHeight, JXScreenWidth, contentHeight);
        //        selection.contentView.frame = CGRectMake(0, 0, JXScreenWidth, 0);
        //        [UIView animateWithDuration:0.25 animations:^{
        //            selection.contentView.frame = CGRectMake(0, 0, JXScreenWidth, contentHeight);
        //        } completion:^(BOOL finished) {
        //            selection.isAnimating = NO;
        //        }];
        
        //        selection.hidden = NO;
        //        selection.alpha = 1.0f;
        //        //selection.contentView.bounds = CGRectMake(0, 0, JXScreenWidth, 0);
        //        // selection.contentView.center = CGPointMake(0, 0);
        //        selection.contentView.center = CGPointMake(JXScreenWidth / 2.0f, contentHeight / 2.0f);
        //        //selection.contentView.bounds = CGRectMake(0, 0, JXScreenWidth, 0);
        //        selection.contentView.frame = CGRectMake(0, 0, JXScreenWidth, 0);
        //        [UIView animateWithDuration:2.25 animations:^{
        //            selection.contentView.bounds = CGRectMake(0, 0, JXScreenWidth, contentHeight);
        //            //selection.contentView.center = CGPointMake(JXScreenWidth / 2.0f, contentHeight / 2.0f);
        //        } completion:^(BOOL finished) {
        //            selection.isAnimating = NO;
        //        }];
        
        // POP动画
        selection.hidden = NO;
        selection.alpha = 1.0f;
        selection.contentView.frame = CGRectMake(0, 0, JXScreenWidth, 0);
        //selection.coverView.alpha = 0.0;
        
        //        POPBasicAnimation *showAnim = [selection.contentView pop_animationForKey:kJXActionBarShowContentAnimation];
        //        if (!showAnim) {
        //            showAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        //            showAnim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, 0)];
        //            showAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, contentHeight)];
        //            showAnim.duration = 0.3;
        //            showAnim.removedOnCompletion = NO;
        //            [showAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        //                if (selection.contentView.frame.size.height == 0) {
        //                    [UIView animateWithDuration:0.1 animations:^{
        //                        selection.alpha = 0.0f;
        //                    } completion:^(BOOL finished) {
        //                        selection.hidden = YES;
        //                        category.isAnimating = NO;
        //                        selection.isAnimating = NO;
        //                    }];
        //                }else {
        //                    category.isAnimating = NO;
        //                    selection.isAnimating = NO;
        //                    //[self.rootView bringSubviewToFront:selection];
        //                    //[selection bringSubviewToFront:selection.contentView];
        //                }
        //            }];
        //            [selection.contentView pop_addAnimation:showAnim forKey:kJXActionBarShowContentAnimation];
        //        }else {
        //            showAnim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, 0)];
        //            showAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, contentHeight)];
        //        }
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            selection.isAnimating = NO;
        //            category.isAnimating = NO;
        //            //[self.rootView bringSubviewToFront:selection];
        //            //[selection bringSubviewToFront:selection.contentView];
        //        });
        
        // POPBasicAnimation *showAnim = [selection.contentView pop_animationForKey:kJXActionBarShowContentAnimation];
        // if (!showAnim) {
        POPBasicAnimation *showAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        showAnim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, 0)];
        showAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, contentHeight)];
        showAnim.duration = kJXActionBarAnimtionDuration;
        //showAnim.removedOnCompletion = NO;
        [showAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            //                if (selection.contentView.frame.size.height == 0) {
            //                    [UIView animateWithDuration:0.1 animations:^{
            //                        selection.alpha = 0.0f;
            //                    } completion:^(BOOL finished) {
            //                        selection.hidden = YES;
            //                        category.isAnimating = NO;
            //                        selection.isAnimating = NO;
            //                    }];
            //                }else {
            //                    category.isAnimating = NO;
            //                    selection.isAnimating = NO;
            //                    //[self.rootView bringSubviewToFront:selection];
            //                    //[selection bringSubviewToFront:selection.contentView];
            //                }
            category.isAnimating = NO;
            selection.isAnimating = NO;
            //selection.coverView.alpha = 0.5;
        }];
        [selection.contentView pop_addAnimation:showAnim forKey:kJXActionBarShowContentAnimation];
        //        }else {
        //            showAnim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, 0)];
        //            showAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, contentHeight)];
        //            showAnim.duration = 0.3;
        //        }
        
        //        [UIView animateWithDuration:0.3 animations:^{
        //            selection.alpha = 1.0f;
        //        } completion:^(BOOL finished) {
        //            category.isAnimating = NO;
        //            selection.isAnimating = NO;
        //        }];
        
        if ([self.delegate respondsToSelector:@selector(actionBar:willShowContentView:)]) {
            [self.delegate actionBar:self willShowContentView:selection.contentView];
        }
    }else {
        [self rotateCategory:category begin:NO];
        
        // 不要动画
        //        selection.contentView.frame = CGRectMake(0, 0, JXScreenWidth, 0);
        //        selection.alpha = 0.0f;
        //        selection.hidden = YES;
        //        selection.isAnimating = NO;
        //        category.isAnimating = NO;
        
        // 系统动画
        //        [UIView animateWithDuration:0.25 animations:^{
        //            //selection.contentView.frame = CGRectMake(0, -contentHeight, JXScreenWidth, contentHeight);
        //            selection.contentView.frame = CGRectMake(0, 0, JXScreenWidth, 0);
        //        } completion:^(BOOL finished) {
        //            [UIView animateWithDuration:0.15 animations:^{
        //                selection.alpha = 0.0f;
        //            } completion:^(BOOL finished) {
        //                selection.hidden = YES;
        //                selection.isAnimating = NO;
        //            }];
        //        }];
        
        // POP动画
        //        POPBasicAnimation *hideAnim = [selection.contentView pop_animationForKey:kJXActionBarShowContentAnimation];
        //        hideAnim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, contentHeight)];
        //        hideAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, 0)];
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            selection.isAnimating = NO;
        //            category.isAnimating = NO;
        //        });
        
        // POPBasicAnimation *hide1Anim = [selection.contentView pop_animationForKey:@"hideContentAnimation1"];
        // if (!hide1Anim) {
        POPBasicAnimation *hide1Anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        hide1Anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, contentHeight)];
        hide1Anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, 0)];
        hide1Anim.duration = kJXActionBarAnimtionDuration;
        [hide1Anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            [UIView animateWithDuration:kJXActionBarAlphaDuration animations:^{
                selection.alpha = 0.0f;
            } completion:^(BOOL finished) {
                selection.hidden = YES;
                category.isAnimating = NO;
                selection.isAnimating = NO;
            }];
        }];
        [selection.contentView pop_addAnimation:hide1Anim forKey:kJXActionBarHideContentAnimation];
        
        
        //        [UIView animateWithDuration:0.3 animations:^{
        //            selection.alpha = 0.0f;
        //        } completion:^(BOOL finished) {
        //            selection.hidden = YES;
        //            category.isAnimating = NO;
        //            selection.isAnimating = NO;
        //        }];
        
        //        }else {
        //            hide1Anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, contentHeight)];
        //            hide1Anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, 0)];
        //        }
        //        [UIView animateWithDuration:0.3 animations:^{
        //            selection.alpha = 0.0f;
        //        } completion:^(BOOL finished) {
        //            category.isAnimating = NO;
        //            selection.isAnimating = NO;
        //        }];
        
        if ([self.delegate respondsToSelector:@selector(actionBar:willHideContentView:)]) {
            [self.delegate actionBar:self willHideContentView:selection.contentView];
        }
    }
}

#pragma mark JXActionSelectionDelegate
- (void)actionSelection:(JXActionSelection *)selection didSelectIndex:(NSInteger)index withObject:(id)obj {
    JXActionCategory *category = [_categories objectAtIndex:index];
    if (category.isAnimating || !category.actionButton.selected) {
        return;
    }
    
    if (category.actionButton.selected) {
        category.actionButton.selected = NO;
        [self rotateCategory:category begin:NO];
    }
    
    CGFloat contentHeight = selection.contentHeight;
    category.isAnimating = YES;
    
    POPBasicAnimation *hide2Anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    hide2Anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, contentHeight)];
    hide2Anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, 0)];
    hide2Anim.duration = kJXActionBarAnimtionDuration;
    [selection.contentView pop_addAnimation:hide2Anim forKey:kJXActionBarHideContentAnimation];
    [UIView animateWithDuration:(kJXActionBarAnimtionDuration + kJXActionBarAlphaDuration) animations:^{
        selection.alpha = 0.0f;
    } completion:^(BOOL finished) {
        selection.hidden = YES;
        category.isAnimating = NO;
        selection.isAnimating = NO;
    }];
    
    if ([self.delegate respondsToSelector:@selector(actionBar:willHideContentView:)]) {
        [self.delegate actionBar:self willHideContentView:selection.contentView];
    }
    
    if (obj) {
        if ([_delegate respondsToSelector:@selector(actionBar:category:selection:index:object:)]) {
            [_delegate actionBar:self category:category selection:selection index:index object:obj];
        }
    }
}

//- (void)actionSelection:(JXActionSelection *)selection didSelectIndex:(NSInteger)index withObject:(id)obj {
//    JXActionCategory *category = [_categories objectAtIndex:index];
//    if (category.isAnimating || !category.actionButton.selected) {
//        return;
//    }
//    
//    if (category.actionButton.selected) {
//        category.actionButton.selected = NO;
//        [self rotateCategory:category begin:NO];
//    }
//    
//    CGFloat contentHeight = selection.contentHeight;
//    category.isAnimating = YES;
//    
//    // 不要动画
//    //    selection.contentView.frame = CGRectMake(0, 0, JXScreenWidth, 0);
//    //    selection.alpha = 0.0f;
//    //    selection.hidden = YES;
//    //    selection.isAnimating = NO;
//    //    category.isAnimating = NO;
//    
//    // 系统动画
//    //    [UIView animateWithDuration:0.25 animations:^{
//    //        // selection.contentView.frame = CGRectMake(0, -contentHeight, JXScreenWidth, contentHeight);
//    //        selection.contentView.frame = CGRectMake(0, 0, JXScreenWidth, 0);
//    //    } completion:^(BOOL finished) {
//    //        [UIView animateWithDuration:0.15 animations:^{
//    //            selection.alpha = 0.0f;
//    //        } completion:^(BOOL finished) {
//    //            selection.hidden = YES;
//    //            selection.isAnimating = NO;
//    //        }];
//    //    }];
//    
//    //    // POP动画
//    //    POPBasicAnimation *hideAnim = [selection.contentView pop_animationForKey:kJXActionBarShowContentAnimation];
//    //    hideAnim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, contentHeight)];
//    //    hideAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, 0)];
//    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    //        selection.isAnimating = NO;
//    //        category.isAnimating = NO;
//    //    });
//    
//    // POPBasicAnimation *hide2Anim = [selection.contentView pop_animationForKey:@"hideContentAnimation2"];
//    // if (!hide2Anim) {
//    POPBasicAnimation *hide2Anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
//    hide2Anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, contentHeight)];
//    hide2Anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, 0)];
//    hide2Anim.duration = kJXActionBarAnimtionDuration;
//    [hide2Anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
//        [UIView animateWithDuration:kJXActionBarAlphaDuration animations:^{
//            selection.alpha = 0.0f;
//        } completion:^(BOOL finished) {
//            selection.hidden = YES;
//            category.isAnimating = NO;
//            selection.isAnimating = NO;
//        }];
//    }];
//    [selection.contentView pop_addAnimation:hide2Anim forKey:kJXActionBarHideContentAnimation];
//    //    }else {
//    //        hide2Anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, contentHeight)];
//    //        hide2Anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, 0)];
//    //    }
//    //    [UIView animateWithDuration:0.3 animations:^{
//    //        selection.alpha = 0.0f;
//    //    } completion:^(BOOL finished) {
//    //        selection.hidden = YES;
//    //        category.isAnimating = NO;
//    //        selection.isAnimating = NO;
//    //    }];
//    
//    if ([self.delegate respondsToSelector:@selector(actionBar:willHideContentView:)]) {
//        [self.delegate actionBar:self willHideContentView:selection.contentView];
//    }
//    
//    if (obj) {
//        if ([_delegate respondsToSelector:@selector(actionBar:category:selection:index:object:)]) {
//            [_delegate actionBar:self category:category selection:selection index:index object:obj];
//        }
//    }
//}

@end

