////
////  JXFilterView.m
////  MeijiaStore
////
////  Created by 杨建祥 on 16/1/2.
////  Copyright © 2016年 iOS开发组. All rights reserved.
////
//
//#import "JXFilterView.h"
//#import "JXObjc.h"
//
//@interface JXFilterView ()
//@property (nonatomic, strong) NSArray *categories;
//@end
//
//@implementation JXFilterView
//#pragma mark - Override methods
//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        [self setup];
//    }
//    return self;
//}
//
//- (instancetype)initWithCoder:(NSCoder *)decoder {
//    if (self = [super initWithCoder:decoder]) {
//        [self setup];
//    }
//    return self;
//}
//
////- (void)willMoveToSuperview:(UIView *)newSuperview {
////    JXLogDebug(@"aaaaaaaa");
////    [super willMoveToSuperview:newSuperview];
////    [self reloadData];
////}
//
//- (void)updateConstraints {
//    [self reloadData];
//    
//    [super updateConstraints];
//}
//
//#pragma mark - Accessor methods
//- (UIView *)rootView {
//    if (!_rootView) {
//        _rootView = [self get_rootview];
//    }
//    return _rootView;
//}
//
//- (CGFloat)topOffset {
//    return [self get_topOffset];
//}
//
//#pragma mark - Private methods
//- (void)setup {
//    self.backgroundColor = [UIColor whiteColor];
//}
//
//- (void)reloadData {
////    if (!self.rootView) {
////        self.rootView = [self get_rootview];
////    }
//    
//    NSInteger categoryCount = [self get_numberOfCategories];
//    if (categoryCount <= 0) {
//        return;
//    }
//    
//    [self removeAllSubviews];
//    
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.backgroundColor = [UIColor colorWithRed:205.0f/255.0f green:205.0f/255.0f blue:205.0f/255.0f alpha:1.0];
//    [self addSubview:imageView];
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self);
//        make.trailing.equalTo(self);
//        make.bottom.equalTo(self);
//        make.height.equalTo(@0.5f);
//    }];
//    
//    NSMutableArray *categories = [NSMutableArray arrayWithCapacity:categoryCount];
//    for (int i = 0; i < categoryCount; ++i) {
//        BOOL isLast = (i == (categoryCount - 1));
//        JXFilterViewCategory *category = [self get_categoryAtIndex:i];
//        category.tag = i;
//        category.delegate = self;
//        [self addSubview:category];
//        [category mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self);
//            make.bottom.equalTo(self).offset(-0.5f);
//            make.width.equalTo(self).dividedBy(categoryCount).offset(isLast ? 0 : -0.5f);
//            make.centerX.equalTo(self.mas_centerX).multipliedBy((i * 2 + 1) / (CGFloat)categoryCount).offset(isLast ? 0 : -0.5f);
//        }];
//        
//        if (!isLast) {
//            UIImageView *imageView = [[UIImageView alloc] init];
//            imageView.backgroundColor = [UIColor colorWithRed:205.0f/255.0f green:205.0f/255.0f blue:205.0f/255.0f alpha:1.0];
//            [self addSubview:imageView];
//            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.leading.equalTo(category.mas_trailing);
//                make.top.equalTo(self).offset(12);
//                make.bottom.equalTo(self).offset(-12);
//                make.width.equalTo(@0.5f);
//            }];
//        }
//        
//        [categories addObject:category];
//    }
//    _categories = categories;
//}
//
//#pragma mark implement
//- (UIView *)get_rootview {
//    if ([_dataSource respondsToSelector:@selector(rootviewForFilterView:)]) {
//        return [_dataSource rootviewForFilterView:self];
//    }
//    
//    return 0;
//}
//
//- (NSInteger)get_numberOfCategories {
//    if ([_dataSource respondsToSelector:@selector(numberOfCategoriesInFilterView:)]) {
//        return [_dataSource numberOfCategoriesInFilterView:self];
//    }
//    
//    return 0;
//}
//
//- (CGFloat)get_topOffset {
//    if ([_dataSource respondsToSelector:@selector(topOffsetForFilterView:)]) {
//        return [_dataSource topOffsetForFilterView:self];
//    }
//    
//    return 0;
//}
//
//- (JXFilterViewCategory *)get_categoryAtIndex:(NSInteger)index {
//    if ([_dataSource respondsToSelector:@selector(filterView:categoryAtIndex:)]) {
//        return [_dataSource filterView:self categoryAtIndex:index];
//    }
//    
//    return nil;
//}
//
//- (JXFilterViewSelection *)get_selectionAtIndex:(NSInteger)index {
//    if ([_dataSource respondsToSelector:@selector(filterView:selectionAtIndex:)]) {
//        return [_dataSource filterView:self selectionAtIndex:index];
//    }
//    
//    return nil;
//}
//
//#pragma mark assist
//- (void)removeAllSubviews {
//    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//}
//
//- (void)resetAllSelectionExcept:(NSInteger)index{
//    NSInteger categoryCount = [self get_numberOfCategories];
//    for (int i = 0; i < categoryCount; ++i) {
//        if (i == index) {
//            continue;
//        }
//        
//        JXFilterViewCategory *category = [_categories objectAtIndex:i];
//        if (category.actionButton.selected) {
//            category.actionButton.selected = NO;
//            [self rotateCategory:category begin:NO];
//        }
//        
//        // JXFilterViewSelection *selection = (JXFilterViewSelection *)[self.superview viewWithTag:(JXFilterViewTagBegin + i)];
//        // JXFilterViewSelection *selection = (JXFilterViewSelection *)[self.window viewWithTag:(JXFilterViewTagBegin + i)];
//        JXFilterViewSelection *selection = (JXFilterViewSelection *)[self.rootView viewWithTag:(JXFilterViewTagBegin + i)];
//        if (selection) {
//            // CGFloat contentHeight = selection.contentView.frame.size.height;
//            // selection.contentView.frame = CGRectMake(0, -contentHeight, JXScreenWidth, contentHeight);
//            selection.contentView.frame = CGRectMake(0, 0, JXScreenWidth, 0);
//            selection.alpha = 0.0f;
//            selection.hidden = YES;
//            selection.isAnimating = NO;
//            [self.rootView sendSubviewToBack:selection];
//        }
//    }
//}
//
////- (void)rotateCategory:(JXFilterViewCategory *)category
////                  start:(BOOL)start {
////    CGAffineTransform transform;
////    if (start) {
////        transform = CGAffineTransformRotate(indicator.transform, M_PI);
////    }else {
////        transform = CGAffineTransformRotate(indicator.transform, M_PI * -3);
////    }
////    [UIView beginAnimations:@"JXFilterViewCategory-AnimRotate" context:nil];
////    [UIView setAnimationDuration:0.25];
////    [indicator setTransform:transform];
////    [UIView commitAnimations];
////}
//
//- (void)rotateCategory:(JXFilterViewCategory *)category begin:(BOOL)begin {
//    NSValue *value;
//    if (begin) {
//        value = @(M_PI * 1);
//    }else {
//        value = @0;
//    }
//    
//    category.isAnimating = YES;
//    
//    POPSpringAnimation *anim = [category.indicatorImageView.layer pop_animationForKey:@"rotate"];
//    if (!anim) {
//        anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
//        anim.springSpeed = 12;
//        anim.springBounciness = 1;
//        anim.toValue = value;
//        anim.removedOnCompletion = NO;
//        [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
////            if (finished) {
////                category.isAnimating = NO;
////            }
//            category.isAnimating = NO;
//        }];
//        [category.indicatorImageView.layer pop_addAnimation:anim forKey:@"rotate"];
//    }else {
//        anim.toValue = value;
//    }
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        category.isAnimating = NO;
//    });
//}
//
//
//#pragma mark - Delegate methods
//#pragma mark JXFilterViewCategoryDelegate
//- (void)filterViewCategory:(JXFilterViewCategory *)category
//            didSelectIndex:(NSInteger)index {
//    [self resetAllSelectionExcept:index];
//    
////    id a1 = self.superview;
////    id a2 = [a1 subviews];
////    
////    id a3 = self.window;
////    id a4 = [self.window subviews];
//    // UIView *view = [self.superview viewWithTag:(JXFilterViewTagBegin + index)];
//    // UIView *view = [self.window viewWithTag:(JXFilterViewTagBegin + index)];
//    UIView *view = [self.rootView viewWithTag:(JXFilterViewTagBegin + index)];
//    if (view && ![view isKindOfClass:[JXFilterViewSelection class]]) {
//        return;
//    }
//    
//    JXFilterViewSelection *selection;
//    if (view) {
//        selection = (JXFilterViewSelection *)view;
//    }else {
//        selection = [self get_selectionAtIndex:index];
//        selection.delegate = self;
//        selection.contentView.delegate = self;
//        selection.tag = JXFilterViewTagBegin + index;
//        selection.hidden = YES;
////        [self.superview addSubview:selection];
////        [self.superview bringSubviewToFront:self];
////        [self.window addSubview:selection];
////        [self.window bringSubviewToFront:self];
//        [self.rootView addSubview:selection];
//    }
//    [self.rootView bringSubviewToFront:selection];
//    [selection bringSubviewToFront:selection.contentView];
////    NSArray *aa = selection.subviews;
////    if (aa.count >= 2) {
////        UIView *bb = aa[1];
////        CGFloat cc = bb.alpha;
////        BOOL dd =bb.hidden;
////        int eee = 0;
////    }
//    
//    if (selection.isAnimating) {
//        return;
//    }
//    
//    // CGFloat contentHeight = selection.contentView.frame.size.height;
//    CGFloat contentHeight = selection.contentHeight;
//    
//    selection.isAnimating = YES;
//    selection.frame = CGRectMake(0, CGRectGetMaxY(self.frame) + self.topOffset, JXScreenWidth, JXScreenHeight);
//    if (selection.hidden) {
//        [self rotateCategory:category begin:YES];
//        
//        // 不要动画
////        selection.hidden = NO;
////        selection.alpha = 1.0f;
////        selection.contentView.frame = CGRectMake(0, 0, JXScreenWidth, contentHeight);
////        selection.isAnimating = NO;
////        category.isAnimating = NO;
//        
//        // 系统动画 tableContent无效
////        selection.hidden = NO;
////        selection.alpha = 1.0f;
////        //selection.contentView.frame = CGRectMake(0, -contentHeight, JXScreenWidth, contentHeight);
////        selection.contentView.frame = CGRectMake(0, 0, JXScreenWidth, 0);
////        [UIView animateWithDuration:0.25 animations:^{
////            selection.contentView.frame = CGRectMake(0, 0, JXScreenWidth, contentHeight);
////        } completion:^(BOOL finished) {
////            selection.isAnimating = NO;
////        }];
//        
////        selection.hidden = NO;
////        selection.alpha = 1.0f;
////        //selection.contentView.bounds = CGRectMake(0, 0, JXScreenWidth, 0);
////        // selection.contentView.center = CGPointMake(0, 0);
////        selection.contentView.center = CGPointMake(JXScreenWidth / 2.0f, contentHeight / 2.0f);
////        //selection.contentView.bounds = CGRectMake(0, 0, JXScreenWidth, 0);
////        selection.contentView.frame = CGRectMake(0, 0, JXScreenWidth, 0);
////        [UIView animateWithDuration:2.25 animations:^{
////            selection.contentView.bounds = CGRectMake(0, 0, JXScreenWidth, contentHeight);
////            //selection.contentView.center = CGPointMake(JXScreenWidth / 2.0f, contentHeight / 2.0f);
////        } completion:^(BOOL finished) {
////            selection.isAnimating = NO;
////        }];
//        
//        // POP动画
//        selection.hidden = NO;
//        selection.alpha = 1.0f;
//        selection.contentView.frame = CGRectMake(0, 0, JXScreenWidth, 0);
//
////        POPBasicAnimation *showAnim = [selection.contentView pop_animationForKey:@"showContentAnimation"];
////        if (!showAnim) {
////            showAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
////            showAnim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, 0)];
////            showAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, contentHeight)];
////            showAnim.duration = 0.3;
////            showAnim.removedOnCompletion = NO;
////            [showAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
////                if (selection.contentView.frame.size.height == 0) {
////                    [UIView animateWithDuration:0.1 animations:^{
////                        selection.alpha = 0.0f;
////                    } completion:^(BOOL finished) {
////                        selection.hidden = YES;
////                        category.isAnimating = NO;
////                        selection.isAnimating = NO;
////                    }];
////                }else {
////                    category.isAnimating = NO;
////                    selection.isAnimating = NO;
////                    //[self.rootView bringSubviewToFront:selection];
////                    //[selection bringSubviewToFront:selection.contentView];
////                }
////            }];
////            [selection.contentView pop_addAnimation:showAnim forKey:@"showContentAnimation"];
////        }else {
////            showAnim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, 0)];
////            showAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, contentHeight)];
////        }
////        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////            selection.isAnimating = NO;
////            category.isAnimating = NO;
////            //[self.rootView bringSubviewToFront:selection];
////            //[selection bringSubviewToFront:selection.contentView];
////        });
//        
//        POPBasicAnimation *showAnim = [selection.contentView pop_animationForKey:@"showContentAnimation"];
//        if (!showAnim) {
//            showAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
//            showAnim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, 0)];
//            showAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, contentHeight)];
//            showAnim.duration = 0.3;
//            [showAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
////                if (selection.contentView.frame.size.height == 0) {
////                    [UIView animateWithDuration:0.1 animations:^{
////                        selection.alpha = 0.0f;
////                    } completion:^(BOOL finished) {
////                        selection.hidden = YES;
////                        category.isAnimating = NO;
////                        selection.isAnimating = NO;
////                    }];
////                }else {
////                    category.isAnimating = NO;
////                    selection.isAnimating = NO;
////                    //[self.rootView bringSubviewToFront:selection];
////                    //[selection bringSubviewToFront:selection.contentView];
////                }
//                category.isAnimating = NO;
//                selection.isAnimating = NO;
//            }];
//            [selection.contentView pop_addAnimation:showAnim forKey:@"showContentAnimation"];
//        }else {
//            showAnim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, 0)];
//            showAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, contentHeight)];
//        }
//        
////        [UIView animateWithDuration:0.3 animations:^{
////            selection.alpha = 1.0f;
////        } completion:^(BOOL finished) {
////            category.isAnimating = NO;
////            selection.isAnimating = NO;
////        }];
//        
//        if ([self.delegate respondsToSelector:@selector(filterView:willShowContentView:)]) {
//            [self.delegate filterView:self willShowContentView:selection.contentView];
//        }
//    }else {
//        [self rotateCategory:category begin:NO];
//        
//        // 不要动画
////        selection.contentView.frame = CGRectMake(0, 0, JXScreenWidth, 0);
////        selection.alpha = 0.0f;
////        selection.hidden = YES;
////        selection.isAnimating = NO;
////        category.isAnimating = NO;
//        
//        // 系统动画
////        [UIView animateWithDuration:0.25 animations:^{
////            //selection.contentView.frame = CGRectMake(0, -contentHeight, JXScreenWidth, contentHeight);
////            selection.contentView.frame = CGRectMake(0, 0, JXScreenWidth, 0);
////        } completion:^(BOOL finished) {
////            [UIView animateWithDuration:0.15 animations:^{
////                selection.alpha = 0.0f;
////            } completion:^(BOOL finished) {
////                selection.hidden = YES;
////                selection.isAnimating = NO;
////            }];
////        }];
//        
//        // POP动画
////        POPBasicAnimation *hideAnim = [selection.contentView pop_animationForKey:@"showContentAnimation"];
////        hideAnim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, contentHeight)];
////        hideAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, 0)];
////        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////            selection.isAnimating = NO;
////            category.isAnimating = NO;
////        });
//        
//        POPBasicAnimation *hide1Anim = [selection.contentView pop_animationForKey:@"hideContentAnimation1"];
//        if (!hide1Anim) {
//            hide1Anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
//            hide1Anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, contentHeight)];
//            hide1Anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, 0)];
//            hide1Anim.duration = 0.3;
//            [hide1Anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
//                [UIView animateWithDuration:0.1 animations:^{
//                    selection.alpha = 0.0f;
//                } completion:^(BOOL finished) {
//                    selection.hidden = YES;
//                    category.isAnimating = NO;
//                    selection.isAnimating = NO;
//                }];
//            }];
//            [selection.contentView pop_addAnimation:hide1Anim forKey:@"hideContentAnimation1"];
//        }else {
//            hide1Anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, contentHeight)];
//            hide1Anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, 0)];
//        }
////        [UIView animateWithDuration:0.3 animations:^{
////            selection.alpha = 0.0f;
////        } completion:^(BOOL finished) {
////            category.isAnimating = NO;
////            selection.isAnimating = NO;
////        }];
//        
//        if ([self.delegate respondsToSelector:@selector(filterView:willHideContentView:)]) {
//            [self.delegate filterView:self willHideContentView:selection.contentView];
//        }
//    }
//}
//
//#pragma mark JXFilterViewSelectionDelegate
//- (void)filterViewSelection:(JXFilterViewSelection *)selection
//             didSelectIndex:(NSInteger)index
//                 withObject:(id)obj {
//    JXFilterViewCategory *category = [_categories objectAtIndex:index];
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
////    selection.contentView.frame = CGRectMake(0, 0, JXScreenWidth, 0);
////    selection.alpha = 0.0f;
////    selection.hidden = YES;
////    selection.isAnimating = NO;
////    category.isAnimating = NO;
//    
//    // 系统动画
////    [UIView animateWithDuration:0.25 animations:^{
////        // selection.contentView.frame = CGRectMake(0, -contentHeight, JXScreenWidth, contentHeight);
////        selection.contentView.frame = CGRectMake(0, 0, JXScreenWidth, 0);
////    } completion:^(BOOL finished) {
////        [UIView animateWithDuration:0.15 animations:^{
////            selection.alpha = 0.0f;
////        } completion:^(BOOL finished) {
////            selection.hidden = YES;
////            selection.isAnimating = NO;
////        }];
////    }];
//    
////    // POP动画
////    POPBasicAnimation *hideAnim = [selection.contentView pop_animationForKey:@"showContentAnimation"];
////    hideAnim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, contentHeight)];
////    hideAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, 0)];
////    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        selection.isAnimating = NO;
////        category.isAnimating = NO;
////    });
//    
//    POPBasicAnimation *hide2Anim = [selection.contentView pop_animationForKey:@"hideContentAnimation2"];
//    if (!hide2Anim) {
//        hide2Anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
//        hide2Anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, contentHeight)];
//        hide2Anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, 0)];
//        hide2Anim.duration = 0.3;
//        [hide2Anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
//            [UIView animateWithDuration:0.1 animations:^{
//                selection.alpha = 0.0f;
//            } completion:^(BOOL finished) {
//                selection.hidden = YES;
//                category.isAnimating = NO;
//                selection.isAnimating = NO;
//            }];
//        }];
//        [selection.contentView pop_addAnimation:hide2Anim forKey:@"hideContentAnimation1"];
//    }else {
//        hide2Anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, contentHeight)];
//        hide2Anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, JXScreenWidth, 0)];
//    }
////    [UIView animateWithDuration:0.3 animations:^{
////        selection.alpha = 0.0f;
////    } completion:^(BOOL finished) {
////        selection.hidden = YES;
////        category.isAnimating = NO;
////        selection.isAnimating = NO;
////    }];
//    
//    if ([self.delegate respondsToSelector:@selector(filterView:willHideContentView:)]) {
//        [self.delegate filterView:self willHideContentView:selection.contentView];
//    }
//    
//    if (obj) {
//        if ([_delegate respondsToSelector:@selector(filterView:category:selection:index:object:)]) {
//            [_delegate filterView:self category:category selection:selection index:index object:obj];
//        }
//    }
//}
//
//@end
