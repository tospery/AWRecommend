////
////  JXSwipeNavigationController.m
////  xiaokalv
////
////  Created by 杨建祥 on 16/6/25.
////  Copyright © 2016年 杨建祥. All rights reserved.
////
//
//#import "JXSwipeNavigationController.h"
//
//@interface JXSwipePageViewController : UIPageViewController
//
//@end
//
//@implementation JXSwipePageViewController
//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    if ([self.parentViewController isKindOfClass:[JXSwipeNavigationController class]]) {
//        JXSwipeNavigationController *swipeNC = (JXSwipeNavigationController *)self.parentViewController;
//        [[swipeNC curViewController] viewDidAppear:animated];
//    }
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    if ([self.parentViewController isKindOfClass:[JXSwipeNavigationController class]]) {
//        JXSwipeNavigationController *swipeNC = (JXSwipeNavigationController *)self.parentViewController;
//        [[swipeNC curViewController] viewWillDisappear:animated];
//    }
//}
//@end
//
//////%%% customizeable button attributes
////// static CGFloat X_BUFFER = 0.0; //%%% the number of pixels on either side of the segment
////static CGFloat Y_BUFFER = 14.0; //%%% number of pixels on top of the segment
////static CGFloat HEIGHT = 30.0; //%%% height of the segment
////
//////%%% customizeable selector bar attributes (the black bar under the buttons)
////static CGFloat BOUNCE_BUFFER = 10.0; //%%% adds bounce to the selection bar when you scroll
////static CGFloat ANIMATION_SPEED = 0.2; //%%% the number of seconds it takes to complete the animation
////static CGFloat SELECTOR_Y_BUFFER = 40.0; //%%% the y-value of the bar that shows what page you are on (0 is the top)
////static CGFloat SELECTOR_HEIGHT = 4.0; //%%% thickness of the selector bar
////
////static CGFloat X_OFFSET = 8.0; //%%% for some reason there's a little bit of a glitchy offset.  I'm going to look for a better workaround in the future
//
//@interface JXSwipeNavigationController ()
//@property (nonatomic, assign) BOOL isPageScrollingFlag; //%%% prevents scrolling / segment tap crash
//@property (nonatomic, assign) NSInteger currentPageIndex;
//@property (nonatomic, strong) UIScrollView *pageScrollView;
//
//@property (nonatomic, strong) SMPageControl *pageControl;
//@property (strong, nonatomic) UIScrollView *buttonContainer;
//@property (strong, nonatomic) UIViewController *p_displayingViewController;
//
//@property (nonatomic, assign) CGFloat BUTTON_WIDTH;
//@property (nonatomic, assign) CGFloat X_BUFFER; //%%% the number of pixels on either side of the segment
//@property (nonatomic, assign) CGFloat Y_BUFFER; //%%% number of pixels on top of the segment
//@property (nonatomic, assign) CGFloat HEIGHT; //%%% height of the segment
//@property (nonatomic, assign) CGFloat BOUNCE_BUFFER; //%%% adds bounce to the selection bar when you scroll
//@property (nonatomic, assign) CGFloat ANIMATION_SPEED; //%%% the number of seconds it takes to complete the animation
//@property (nonatomic, assign) CGFloat SELECTOR_Y_BUFFER; //%%% the y-value of the bar that shows what page you are on (0 is the top)
//@property (nonatomic, assign) CGFloat SELECTOR_HEIGHT; //%%% thickness of the selector bar
//@property (nonatomic, assign) CGFloat X_OFFSET;  //%%% for some reason there's a little bit of a glitchy offset.  I'm going to look for a better workaround in the future
//
//@end
//
//@implementation JXSwipeNavigationController
//@synthesize BUTTON_WIDTH;
//@synthesize X_BUFFER;
//@synthesize Y_BUFFER;
//@synthesize HEIGHT;
//@synthesize BOUNCE_BUFFER;
//@synthesize ANIMATION_SPEED;
//@synthesize SELECTOR_Y_BUFFER;
//@synthesize SELECTOR_HEIGHT;
//@synthesize X_OFFSET;
//
//#pragma mark - Override
////- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
////    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
////    }
////    return self;
////}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    // self.navigationBar.barTintColor = [UIColor colorWithRed:0.01 green:0.05 blue:0.06 alpha:1]; // [UIColor redColor]; // //%%% bartint
//    self.navigationBar.translucent = NO;
//    self.controllers = [[NSMutableArray alloc] init];
//    self.currentPageIndex = 0;
//    self.isPageScrollingFlag = NO;
//    
//    // YJX_LIB 返回
//    //    if (self.presentingViewController && !self.hidesDismissBtnWhenPresented) {
//    //        self.navigationItem.leftBarButtonItem = JXCreateCloseItem(self, @selector(returnItemPressed:), JXInstance.navItemColor);
//    //    }
//    
//    // self.navigationBar.navigationItem.leftBarButtonItem = JXCreateCloseItem(self, @selector(returnItemPressed:), JXInstance.navItemColor);
//    //    if (self.presentingViewController) {
//    //        self.navigationBar.navigationItem.leftBarButtonItem = JXCreateCloseItem(self, @selector(returnItemPressed:), JXInstance.navItemColor);
//    //    }
//    //    self.navigationItem.leftBarButtonItem = JXCreateCloseItem(self, @selector(returnItemPressed:), JXInstance.navItemColor);
//    
//    //    - (void)returnItemPressed:(id)sender {
//    //        //    if (self.presentingViewController) {
//    //        //        [self dismissViewControllerAnimated:YES completion:NULL];
//    //        //    }else {
//    //        //        [self.navigationController popViewControllerAnimated:YES];
//    //        //    }
//    //
//    //        [self dismissViewControllerAnimated:YES completion:NULL];
//    //    }
//}
//
//-(void)viewWillAppear:(BOOL)animated {
//    [self setupStyle];
//    [self setupPageViewController];
//    [self setupSegmentButtons];
//}
//
//-(UIStatusBarStyle)preferredStatusBarStyle {
//    return JXInstance.statusBarStyle;
//}
//
//#pragma mark - Accessor
//
//#pragma mark - Assist
//- (void)setupStyle {
//    if (JXSwipeStyleDefault == self.style) {
//        BUTTON_WIDTH = 0.0;
//        X_BUFFER = 0.0;
//        Y_BUFFER = 14.0;
//        HEIGHT = 30.0;
//        BOUNCE_BUFFER = 10.0;
//        ANIMATION_SPEED = 0.2;
//        SELECTOR_Y_BUFFER = 40.0;
//        SELECTOR_HEIGHT = 4.0;
//        X_OFFSET = 8.0;
//    }else if (JXSwipeStyleCoding == self.style) {
//        BUTTON_WIDTH = JXScreenWidth / 3.0f;
//        X_BUFFER = 52.0;
//        Y_BUFFER = 0.0;
//        HEIGHT = 35.0;
//        BOUNCE_BUFFER = 0.0;
//        ANIMATION_SPEED = 0.2;
//        SELECTOR_Y_BUFFER = 32.0;
//        SELECTOR_HEIGHT = 7.0;
//        X_OFFSET = 8.0;
//    }
//}
//
////%%% generic setup stuff for a pageview controller.  Sets up the scrolling style and delegate for the controller
//-(void)setupPageViewController {
//    self.pageController = (UIPageViewController *)self.topViewController;
//    self.pageController.delegate = self;
//    self.pageController.dataSource = self;
//    [self.pageController setViewControllers:@[[self.controllers objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
//    [self syncScrollView];
//}
//
////%%% this allows us to get information back from the scrollview, namely the coordinate information that we can link to the selection bar.
//-(void)syncScrollView {
//    for (UIView* view in self.pageController.view.subviews){
//        if([view isKindOfClass:[UIScrollView class]]) {
//            self.pageScrollView = (UIScrollView *)view;
//            self.pageScrollView.delegate = self;
//        }
//    }
//}
//
////%%% sets up the tabs using a loop.  You can take apart the loop to customize individual buttons, but remember to tag the buttons.  (button.tag=0 and the second button.tag=1, etc)
//-(void)setupSegmentButtons {
//    NSInteger numControllers = self.controllers.count;
//    if (!self.titles) {
//        self.titles = @[@"first", @"second", @"third", @"fourth", @"etc", @"etc", @"etc", @"etc"];
//    }
//    
//    if (JXSwipeStyleDefault == self.style) {
//        self.navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.navigationBar.frame.size.height)];
//        for (int i = 0; i<numControllers; i++) {
//            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(X_BUFFER+i*(self.view.frame.size.width-2*X_BUFFER)/numControllers-X_OFFSET, Y_BUFFER, (self.view.frame.size.width-2*X_BUFFER)/numControllers, HEIGHT)];
//            [self.navigationView addSubview:button];
//            
//            button.tag = i; //%%% IMPORTANT: if you make your own custom buttons, you have to tag them appropriately
//            button.backgroundColor = self.navBarTintColor; // [UIColor colorWithRed:0.03 green:0.07 blue:0.08 alpha:1]; // [UIColor clearColor]; //%%% buttoncolors
//            
//            [button addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//            
//            [button setTitle:[self.titles objectAtIndex:i] forState:UIControlStateNormal]; //%%%buttontitle
//        }
//    }else if (JXSwipeStyleCoding == self.style) {
//        self.navigationView = [[UIView alloc]initWithFrame:CGRectMake(X_BUFFER, 0, self.view.frame.size.width - 2 * X_BUFFER, self.navigationBar.frame.size.height)];
//        
//        //buttons
//        CGRect frameTemp = self.navigationView.bounds;
//        frameTemp.size.height = HEIGHT;
//        self.buttonContainer = [[UIScrollView alloc] initWithFrame:frameTemp];
//        self.buttonContainer.scrollsToTop = NO;
//        CGFloat containerWidth = CGRectGetWidth(self.buttonContainer.frame);
//        CGFloat containerHeight = CGRectGetHeight(self.buttonContainer.frame);
//        
//        for (int i = 0; i<numControllers; i++) {
//            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(containerWidth/2 - BUTTON_WIDTH/2 + BUTTON_WIDTH * i, 0, BUTTON_WIDTH, containerHeight)];
//            [self.buttonContainer addSubview:button];
//            button.tag = i; //%%% IMPORTANT: if you make your own custom buttons, you have to tag them appropriately
//            [button addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//            button.titleLabel.font = [UIFont jx_deviceBoldFontOfSize:18.0f];
//            button.titleLabel.textColor = [UIColor whiteColor];
//            [button setTitle:[self.titles objectAtIndex:i] forState:UIControlStateNormal]; //%%%buttontitle
//        }
//        [self.navigationView addSubview:self.buttonContainer];
//        
//        //pageControl
//        _pageControl = ({
//            SMPageControl *pageControl = [[SMPageControl alloc] init];
//            pageControl.userInteractionEnabled = NO;
//            pageControl.backgroundColor = [UIColor clearColor];
//            pageControl.pageIndicatorImage = [UIImage imageNamed:@"jxres_dot"];
//            pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"jxres_dot_selected"];
//            pageControl.frame = (CGRect){0, SELECTOR_Y_BUFFER, CGRectGetWidth(self.navigationView.frame), SELECTOR_HEIGHT};
//            pageControl.numberOfPages = numControllers;
//            pageControl.currentPage = 0;
//            pageControl;
//        });
//        [self.navigationView addSubview:self.pageControl];
//    }else if (JXSwipeStyleCoding == self.style) {
////        self.navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.navigationBar.frame.size.height)];
////        for (int i = 0; i<numControllers; i++) {
////            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(X_BUFFER+i*(self.view.frame.size.width-2*X_BUFFER)/numControllers-X_OFFSET, Y_BUFFER, (self.view.frame.size.width-2*X_BUFFER)/numControllers, HEIGHT)];
////            [self.navigationView addSubview:button];
////            
////            button.tag = i; //%%% IMPORTANT: if you make your own custom buttons, you have to tag them appropriately
////            button.backgroundColor = self.navBarTintColor; // [UIColor colorWithRed:0.03 green:0.07 blue:0.08 alpha:1]; // [UIColor clearColor]; //%%% buttoncolors
////            
////            [button addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
////            
////            [button setTitle:[self.titles objectAtIndex:i] forState:UIControlStateNormal]; //%%%buttontitle
////        }
//        self.navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.navigationBar.frame.size.height)];
//        for (int i = 0; i < numControllers; ++i) {
//            
//        }
//    }
//    
//    self.pageController.navigationController.navigationBar.topItem.titleView = self.navigationView;
//    [self setupSelectorWithPercentX:self.currentPageIndex];
//    
//    //%%% example custom buttons example:
//    //     NSInteger width = (self.view.frame.size.width-(2*X_BUFFER))/3;
//    //     UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(X_BUFFER, Y_BUFFER, width, HEIGHT)];
//    //     UIButton *middleButton = [[UIButton alloc]initWithFrame:CGRectMake(X_BUFFER+width, Y_BUFFER, width, HEIGHT)];
//    //     UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(X_BUFFER+2*width, Y_BUFFER, width, HEIGHT)];
//    //
//    //     [self.navigationBar addSubview:leftButton];
//    //     [self.navigationBar addSubview:middleButton];
//    //     [self.navigationBar addSubview:rightButton];
//    //
//    //     leftButton.tag = 0;
//    //     middleButton.tag = 1;
//    //     rightButton.tag = 2;
//    //
//    //     leftButton.backgroundColor = [UIColor colorWithRed:0.03 green:0.07 blue:0.08 alpha:1];
//    //     middleButton.backgroundColor = [UIColor colorWithRed:0.03 green:0.07 blue:0.08 alpha:1];
//    //     rightButton.backgroundColor = [UIColor colorWithRed:0.03 green:0.07 blue:0.08 alpha:1];
//    //
//    //     [leftButton addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    //     [middleButton addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    //     [rightButton addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    //
//    //     [leftButton setTitle:@"left" forState:UIControlStateNormal];
//    //     [middleButton setTitle:@"middle" forState:UIControlStateNormal];
//    //     [rightButton setTitle:@"right" forState:UIControlStateNormal];
//    
//    // [self setupSelector];
//}
//
////%%% sets up the selection bar under the buttons on the navigation bar
//-(void)setupSelectorWithPercentX:(CGFloat)percentX {
//    if (JXSwipeStyleDefault == self.style) {
//        self.selectionBar = [[UIView alloc] initWithFrame:CGRectMake(X_BUFFER - X_OFFSET, SELECTOR_Y_BUFFER,(self.view.frame.size.width - 2 * X_BUFFER) / [self.controllers count], SELECTOR_HEIGHT)];
//        self.selectionBar.backgroundColor = self.selectionBarColor; // [UIColor greenColor]; //%%% sbcolor
//        self.selectionBar.alpha = 0.8; //%%% sbalpha
//        [self.navigationView addSubview:self.selectionBar];
//    }else if (JXSwipeStyleCoding == self.style) {
//        NSInteger nearestPage = floorf(percentX + 0.5);
//        _pageControl.currentPage = nearestPage;
//        
//        NSArray *buttons = [_buttonContainer subviews];
//        if (buttons.count > 0) {
//            @weakify(self)
//            [buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
//                @strongify(self)
//                CGFloat distanceTp_percentX = percentX - idx;
//                [button setCenter:CGPointMake(self.buttonContainer.center.x - distanceTp_percentX * self.BUTTON_WIDTH, button.center.y)];
//                button.alpha = MAX(0, 1.0 - ABS(distanceTp_percentX));
//            }];
//        }
//    }
//}
//
////%%% makes sure the nav bar is always aware of what page you're on
////in reference to the array of view controllers you gave
//-(void)updateCurrentPageIndex:(int)newIndex {
//    self.currentPageIndex = newIndex;
//}
//
////%%% checks to see which item we are currently looking at from the array of view controllers.
//// not really a delegate method, but is used in all the delegate methods, so might as well include it here
//-(NSInteger)indexOfController:(UIViewController *)viewController {
//    for (int i = 0; i<[self.controllers count]; i++) {
//        if (viewController == [self.controllers objectAtIndex:i]) {
//            return i;
//        }
//    }
//    return NSNotFound;
//}
//
//- (UIViewController *)curViewController {
//    if (self.controllers.count > self.currentPageIndex) {
//        return [self.controllers objectAtIndex:self.currentPageIndex];
//    }else{
//        return nil;
//    }
//}
//
//#pragma mark - Action
////%%% when you tap one of the buttons, it shows that page,
////but it also has to animate the other pages to make it feel like you're crossing a 2d expansion,
////so there's a loop that shows every view controller in the array up to the one you selected
////eg: if you're on page 1 and you click tab 3, then it shows you page 2 and then page 3
//- (void)tapSegmentButtonAction:(UIButton *)button {
//    if (!self.isPageScrollingFlag) {
//        NSInteger tempIndex = self.currentPageIndex;
//        __weak typeof(self) weakSelf = self;
//        
//        //%%% check to see if you're going left -> right or right -> left
//        if (button.tag > tempIndex) {
//            //%%% scroll through all the objects between the two points
//            for (int i = (int)tempIndex+1; i<=button.tag; i++) {
//                [self.pageController setViewControllers:@[[self.controllers objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL complete){
//                    //%%% if the action finishes scrolling (i.e. the user doesn't stop it in the middle),
//                    //then it updates the page that it's currently on
//                    if (complete) {
//                        [weakSelf updateCurrentPageIndex:i];
//                    }
//                }];
//            }
//        } else if (button.tag < tempIndex) { //%%% this is the same thing but for going right -> left
//            for (int i = (int)tempIndex-1; i >= button.tag; i--) {
//                [self.pageController setViewControllers:@[[self.controllers objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL complete){
//                    if (complete) {
//                        [weakSelf updateCurrentPageIndex:i];
//                    }
//                }];
//            }
//        }
//    }
//}
//
//#pragma mark - Delegate
//#pragma mark UIScrollViewDelegate
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    self.isPageScrollingFlag = YES;
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    self.isPageScrollingFlag = NO;
//}
//
////%%% method is called when any of the pages moves.
////It extracts the xcoordinate from the center point and instructs the selection bar to move accordingly
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (JXSwipeStyleDefault == self.style) {
//        CGFloat xFromCenter = self.view.frame.size.width - scrollView.contentOffset.x; //%%% positive for right swipe, negative for left
//        
//        //%%% checks to see what page you are on and adjusts the xCoor accordingly.
//        //i.e. if you're on the second page, it makes sure that the bar starts from the frame.origin.x of the
//        //second tab instead of the beginning
//        NSInteger xCoor = X_BUFFER + self.selectionBar.frame.size.width * self.currentPageIndex - X_OFFSET;
//        
//        self.selectionBar.frame = CGRectMake(xCoor - xFromCenter/self.controllers.count, self.selectionBar.frame.origin.y, self.selectionBar.frame.size.width, self.selectionBar.frame.size.height);
//    }else if (JXSwipeStyleCoding == self.style) {
//        CGFloat percentX = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
//        
//        NSInteger currentPageIndex = self.currentPageIndex;
//        if (_p_displayingViewController) {
//            currentPageIndex = [self indexOfController:_p_displayingViewController];
//        }
//        percentX += currentPageIndex -1;
//        
//        [self setupSelectorWithPercentX:percentX];
//    }
//}
//
//#pragma mark UIPageViewControllerDataSource
//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
//    _p_displayingViewController = viewController;
//    
//    NSInteger index = [self indexOfController:viewController];
//    if ((index == NSNotFound) || (index == 0)) {
//        return nil;
//    }
//    
//    index--;
//    return [self.controllers objectAtIndex:index];
//}
//
//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
//    _p_displayingViewController = viewController;
//    
//    NSInteger index = [self indexOfController:viewController];
//    
//    if (index == NSNotFound) {
//        return nil;
//    }
//    
//    index++;
//    if (index == self.controllers.count) {
//        return nil;
//    }
//    
//    return [self.controllers objectAtIndex:index];
//}
//
//-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
//    _p_displayingViewController = nil;
//    
//    if (completed) {
//        self.currentPageIndex = [self indexOfController:[pageViewController.viewControllers lastObject]];
//    }
//}
//
//#pragma mark - Class
//+ (instancetype)swipeNCWithStyle:(JXSwipeStyle)style {
//    JXSwipePageViewController *pageVC = [[JXSwipePageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
//    JXSwipeNavigationController *swipeNV = [[JXSwipeNavigationController alloc] initWithRootViewController:pageVC];
//    swipeNV.style = style;
//    return swipeNV;
//}
//
//@end
//
