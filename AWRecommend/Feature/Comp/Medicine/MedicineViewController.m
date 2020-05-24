//
//  MedicineViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/20.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "MedicineViewController.h"
#import "MedicinePriceViewController.h"
#import "MedicineManualViewController.h"
#import "MedicineToolView.h"

@interface MedicinePageViewController : UIPageViewController

@end

@implementation MedicinePageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // self.view.backgroundColor = [UIColor greenColor];
    // self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.parentViewController isKindOfClass:[MedicineViewController class]]) {
        MedicineViewController *swipeNC = (MedicineViewController *)self.parentViewController;
        [[swipeNC curViewController] viewDidAppear:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.parentViewController isKindOfClass:[MedicineViewController class]]) {
        MedicineViewController *swipeNC = (MedicineViewController *)self.parentViewController;
        [[swipeNC curViewController] viewWillDisappear:animated];
    }
}
@end


@interface MedicineViewController ()

@property (nonatomic, strong) CompResultDetail *detail;
@property (nonatomic, strong) MedicineToolView *toolView;

@property (nonatomic, assign) BOOL isPageScrollingFlag; //%%% prevents scrolling / segment tap crash
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, strong) UIScrollView *pageScrollView;

//@property (nonatomic, strong) SMPageControl *pageControl;
@property (strong, nonatomic) UIScrollView *buttonContainer;
@property (strong, nonatomic) UIViewController *p_displayingViewController;

@property (nonatomic, assign) CGFloat BUTTON_WIDTH;
@property (nonatomic, assign) CGFloat X_BUFFER; //%%% the number of pixels on either side of the segment
@property (nonatomic, assign) CGFloat Y_BUFFER; //%%% number of pixels on top of the segment
@property (nonatomic, assign) CGFloat HEIGHT; //%%% height of the segment
@property (nonatomic, assign) CGFloat BOUNCE_BUFFER; //%%% adds bounce to the selection bar when you scroll
@property (nonatomic, assign) CGFloat ANIMATION_SPEED; //%%% the number of seconds it takes to complete the animation
@property (nonatomic, assign) CGFloat SELECTOR_Y_BUFFER; //%%% the y-value of the bar that shows what page you are on (0 is the top)
@property (nonatomic, assign) CGFloat SELECTOR_HEIGHT; //%%% thickness of the selector bar
@property (nonatomic, assign) CGFloat X_OFFSET;  //%%% for some reason there's a little bit of a glitchy offset.  I'm going to look for a better workaround in the future

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
//@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIButton *cameraButton;

@property (nonatomic, strong) JXButton *menuButton;


@end

@implementation MedicineViewController
@synthesize BUTTON_WIDTH;
@synthesize X_BUFFER;
@synthesize Y_BUFFER;
@synthesize HEIGHT;
@synthesize BOUNCE_BUFFER;
@synthesize ANIMATION_SPEED;
@synthesize SELECTOR_Y_BUFFER;
@synthesize SELECTOR_HEIGHT;
@synthesize X_OFFSET;

#pragma mark - Override
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        BUTTON_WIDTH = 0.0;
        X_BUFFER = 38.0;
        Y_BUFFER = 4.0;
        HEIGHT = 40.0;
        BOUNCE_BUFFER = 10.0;
        ANIMATION_SPEED = 0.2;
        SELECTOR_Y_BUFFER = 41.0;
        SELECTOR_HEIGHT = 3.0;
        X_OFFSET = 8.0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    self.shyNavBarManager.scrollView = self.pageScrollView;
    //    self.shyNavBarManager.stickyNavigationBar = NO;
    //    self.shyNavBarManager.fadeBehavior = TLYShyNavBarFadeSubviews;
    
    // self.navigationBar.barTintColor = [UIColor colorWithRed:0.01 green:0.05 blue:0.06 alpha:1]; // [UIColor redColor]; // //%%% bartint
    // self.pageScrollView.backgroundColor = [UIColor orangeColor];
    //self.view.backgroundColor = [UIColor whiteColor];
    // self.mm_drawerController.view.backgroundColor = [UIColor redColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationBar.translucent = NO;
    
    [self.navigationBar jx_configWithParam:@{kJXKeyTranslucent: @NO, kJXKeyBarTintColor: SMInstance.mainColor, kJXKeyTitleColor: SMInstance.navItemColor, kJXKeyTitleFont: [UIFont systemFontOfSize:17.0f]}];
    
    //[self.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.controllers = [[NSMutableArray alloc] init];
    self.currentPageIndex = 0;
    self.isPageScrollingFlag = NO;
    
    //self.navigationItem.leftBarButtonItem = JXCreateCloseItem(self, @selector(closeItemPressed:), SMInstance.navItemColor);
    // YJX_LIB 返回
    //    if (self.presentingViewController && !self.hidesDismissBtnWhenPresented) {
    //        self.navigationItem.leftBarButtonItem = JXCreateCloseItem(self, @selector(returnItemPressed:), JXInstance.navItemColor);
    //    }
    
    // self.navigationBar.navigationItem.leftBarButtonItem = JXCreateCloseItem(self, @selector(returnItemPressed:), JXInstance.navItemColor);
    //    if (self.presentingViewController) {
    //        self.navigationBar.navigationItem.leftBarButtonItem = JXCreateCloseItem(self, @selector(returnItemPressed:), JXInstance.navItemColor);
    //    }
    //    self.navigationItem.leftBarButtonItem = JXCreateCloseItem(self, @selector(returnItemPressed:), JXInstance.navItemColor);
    
    //    - (void)returnItemPressed:(id)sender {
    //        //    if (self.presentingViewController) {
    //        //        [self dismissViewControllerAnimated:YES completion:NULL];
    //        //    }else {
    //        //        [self.navigationController popViewControllerAnimated:YES];
    //        //    }
    //
    //        [self dismissViewControllerAnimated:YES completion:NULL];
    //    }
    
    //    self.segmentedControl = [[HMSegmentedControl alloc] init];
    //    self.segmentedControl.sectionTitles = self.titles;
    //    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : SMInstance.homeNavTitleOptionColor, NSFontAttributeName: SMInstance.mainNavTitleOptionFont};
    //    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : SMInstance.homeNavTitleColor, NSFontAttributeName: SMInstance.mainNavTitleFont};
    //    self.segmentedControl.selectionIndicatorColor = SMInstance.homeNavTitleSelectedColor;
    //    self.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    //    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    //    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    //    self.segmentedControl.selectionIndicatorHeight = 1.5f;
    //
    //    self.segmentedControl.backgroundColor = [UIColor redColor];
    
    
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor orangeColor];
//    [self.view addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.view);
//        make.trailing.equalTo(self.view);
//        make.bottom.equalTo(self.view);
//        make.height.equalTo(@44);
//    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMedicineDidRequest:) name:kNotifyMedicineDidRequest object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMedicineDidBuy:) name:kNotifyMedicineDidBuy object:nil];
}

//- (void)notifyMedicineDidBuy:(NSNotification *)notification {
//    BOOL hide = [notification.object boolValue];
//    self.toolView.hidden = hide;
//}

- (void)notifyMedicineDidRequest:(NSNotification *)notification {
    if (self.detail) {
        return;
    }
    
    self.detail = notification.object;
    
//    NSArray *arr = [TMInstance objectForKey:kTMCompFavorite];
//    for (CompResultDetail *d in arr) {
//        if (d.uid.integerValue == self.detail.uid.integerValue) {
//            self.toolView.favoriteButton.selected = YES;
//        }
//    }
//    self.toolView.favoriteButton.selected = self.detail.favorite;
//    
//    [self.view addSubview:self.toolView];
//    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.view);
//        make.trailing.equalTo(self.view);
//        make.bottom.equalTo(self.view);
//        make.height.equalTo(@50);
//    }];
    
    self.menuButton.hidden = NO;
}

- (MedicineToolView *)toolView {
    if (!_toolView) {
        _toolView = [[[NSBundle mainBundle] loadNibNamed:@"MedicineToolView" owner:nil options:nil] firstObject];
        @weakify(self)
        _toolView.shareBlock = ^() {
            @strongify(self)
            if (![WXApi isWXAppInstalled]) {
                [JXDialog showPopup:@"未安装微信，无法分享"];
                return;
            }
            
            if (0 == self.detail.drugPriceList.count) {
                [JXDialog showPopup:@"无效的详情数据"];
                return;
            }
            
            [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                                       @(UMSocialPlatformType_WechatTimeLine)]];
            [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
            [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                CompResultDetailPrice *p = self.detail.drugPriceList[0];
                
                // JXHUDProcessing(nil);
                [JXDialog showHUD:nil];
                [[SDWebImageManager sharedManager] downloadImageWithURL:JXURLWithStr(p.imgUrl) options:SDWebImageRefreshCached progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    // JXHUDHide();
                    [JXDialog hideHUD];
                    if (finished && image) {
                        NSString *title = JXStrWithDft(self.detail.wiseDrugBrandInstructionsDto.dbiName, @"");
                        NSString *desc = JXStrWithDft(self.detail.wiseDrugBrandInstructionsDto.dbiIndication, @"");
                        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:image];
                        shareObject.webpageUrl = @"http://dl.appvworks.com/doctor/user_app/index.html";
                        
                        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                        messageObject.shareObject = shareObject;
                        
                        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                            //            if (error) {
                            //                JXHUDError(error.localizedDescription, YES);
                            //            }
                        }];
                    }else {
                        NSString *title = JXStrWithDft(self.detail.wiseDrugBrandInstructionsDto.dbiName, @"");
                        NSString *desc = JXStrWithDft(self.detail.wiseDrugBrandInstructionsDto.dbiIndication, @"");
                        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:JXImageWithName(@"my_appicon")];
                        shareObject.webpageUrl = @"https://dl.appvworks.com/doctor/user_app/index.html";
                        
                        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                        messageObject.shareObject = shareObject;
                        
                        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                            //            if (error) {
                            //                JXHUDError(error.localizedDescription, YES);
                            //            }
                        }];
                    }
                }];
                
                //        NSString *title = JXStrWithDft(self.detail.wiseDrugBrandInstructionsDto.dbiName, @"");
                //        NSString *desc = JXStrWithDft(self.detail.wiseDrugBrandInstructionsDto.dbiIndication, @"");
                //        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:p.imgUrl];
                //        shareObject.webpageUrl = @"https://www.appvworks.com/doctor/user_app/index.html";
                //
                //        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                //        messageObject.shareObject = shareObject;
                //        
                //        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                ////            if (error) {
                ////                JXHUDError(error.localizedDescription, YES);
                ////            }
                //        }];
            }];
        };
        _toolView.favoriteBlock = ^(BOOL b) {
            @strongify(self)
            if (!b) {
//                NSArray *arr = [TMInstance objectForKey:kTMCompFavorite];
//                NSMutableArray *ma = [NSMutableArray arrayWithArray:arr];
//                
//                CompResultDetail *detail = nil;
//                for (CompResultDetail *d in ma) {
//                    if ([d.graphicDetails isEqualToString:self.detail.graphicDetails]) {
//                        detail = d;
//                        break;
//                    }
//                }
//                
//                [ma removeObject:detail];
//                [TMInstance setObject:ma forKey:kTMCompFavorite];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyFavoriteDidDel object:(@([self.detail.jxID integerValue]))];
            }else {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyFavoriteDidAdd object:(@([self.detail.jxID integerValue]))];
            }
        };
    }
    return _toolView;
}

- (void)closeItemPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] init];
        _segmentedControl.sectionTitles = self.titles;
        _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName: JXFont(15.0f)};
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : SMInstance.mainColor, NSFontAttributeName: JXFont(15.0f)};
        _segmentedControl.selectionIndicatorColor = [UIColor whiteColor]; // JXColorHex(0xF4E641); // kColorMain;
        _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        _segmentedControl.selectionIndicatorBoxOpacity = 1.0f;
        //_segmentedControl.borderColor = [UIColor greenColor];
        //_segmentedControl.selectionIndicatorHeight = 3.0f;
        
        _segmentedControl.backgroundColor = SMInstance.mainColor; // [UIColor whiteColor];
        
        @weakify(self)
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            @strongify(self)
            //            if (NO == self.onceToken && 1 == index) {
            //                self.onceToken = YES;
            //                [self requestGetOrderMessagesWithMode:JXWebModeLoad];
            //            }
            //            [self.scrollView scrollRectToVisible:CGRectMake(JXScreenWidth * index, 0, JXScreenWidth, self.scrollViewHeight) animated:YES];
            
            if (!self.isPageScrollingFlag) {
                NSInteger tempIndex = self.currentPageIndex;
                //%%% check to see if you're going left -> right or right -> left
                if (index > tempIndex) {
                    //%%% scroll through all the objects between the two points
                    for (int i = (int)tempIndex+1; i<=index; i++) {
                        [self.pageController setViewControllers:@[[self.controllers objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL complete){
                            //%%% if the action finishes scrolling (i.e. the user doesn't stop it in the middle),
                            //then it updates the page that it's currently on
                            @strongify(self)
                            if (complete) {
                                [self updateCurrentPageIndex:i];
                            }
                        }];
                    }
                } else if (index < tempIndex) { //%%% this is the same thing but for going right -> left
                    for (int i = (int)tempIndex-1; i >= index; i--) {
                        [self.pageController setViewControllers:@[[self.controllers objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL complete){
                            @strongify(self)
                            if (complete) {
                                [self updateCurrentPageIndex:i];
                            }
                        }];
                    }
                }
            }
        }];
    }
    return _segmentedControl;
}

//- (UIButton *)menuButton {
//    if (!_menuButton) {
//        //        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        //        [_menuButton setImage:JXImageWithName(@"ic_menu") forState:UIControlStateNormal];
//        //        [_menuButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        _menuButton = [Util menuButtonWithTarget:self action:@selector(menuButtonPressed:)];
//    }
//    return _menuButton;
//}
//
//- (void)menuButtonPressed:(id)sender {
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:NULL];
//}

-(void)viewWillAppear:(BOOL)animated {
    // [self setupStyle];
    [self setupPageViewController];
    [self setupSegmentButtons];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - Accessor

#pragma mark - Assist
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

//%%% generic setup stuff for a pageview controller.  Sets up the scrolling style and delegate for the controller
-(void)setupPageViewController {
    self.pageController = (UIPageViewController *)self.topViewController;
    self.pageController.delegate = self;
    self.pageController.dataSource = self;
    [self.pageController setViewControllers:@[[self.controllers objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    [self syncScrollView];
}

//%%% this allows us to get information back from the scrollview, namely the coordinate information that we can link to the selection bar.
-(void)syncScrollView {
    for (UIView* view in self.pageController.view.subviews){
        if([view isKindOfClass:[UIScrollView class]]) {
            self.pageScrollView = (UIScrollView *)view;
            self.pageScrollView.delegate = self;
        }
    }
}

//%%% sets up the tabs using a loop.  You can take apart the loop to customize individual buttons, but remember to tag the buttons.  (button.tag=0 and the second button.tag=1, etc)
-(void)setupSegmentButtons {
    //NSInteger numControllers = self.controllers.count;
    if (!self.titles) {
        self.titles = @[@"first", @"second", @"third", @"fourth", @"etc", @"etc", @"etc", @"etc"];
    }
    
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
    //            pageControl.pageIndicatorImage = [UIImage imageNamed:@"jx_dot"];
    //            pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"jx_dot_selected"];
    //            pageControl.frame = (CGRect){0, SELECTOR_Y_BUFFER, CGRectGetWidth(self.navigationView.frame), SELECTOR_HEIGHT};
    //            pageControl.numberOfPages = numControllers;
    //            pageControl.currentPage = 0;
    //            pageControl;
    //        });
    //        [self.navigationView addSubview:self.pageControl];
    //    }else if (JXSwipeStyleCoding == self.style) {
    //        //        self.navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.navigationBar.frame.size.height)];
    //        //        for (int i = 0; i<numControllers; i++) {
    //        //            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(X_BUFFER+i*(self.view.frame.size.width-2*X_BUFFER)/numControllers-X_OFFSET, Y_BUFFER, (self.view.frame.size.width-2*X_BUFFER)/numControllers, HEIGHT)];
    //        //            [self.navigationView addSubview:button];
    //        //
    //        //            button.tag = i; //%%% IMPORTANT: if you make your own custom buttons, you have to tag them appropriately
    //        //            button.backgroundColor = self.navBarTintColor; // [UIColor colorWithRed:0.03 green:0.07 blue:0.08 alpha:1]; // [UIColor clearColor]; //%%% buttoncolors
    //        //
    //        //            [button addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //        //
    //        //            [button setTitle:[self.titles objectAtIndex:i] forState:UIControlStateNormal]; //%%%buttontitle
    //        //        }
    //        self.navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.navigationBar.frame.size.height)];
    //        for (int i = 0; i < numControllers; ++i) {
    //
    //        }
    //    }
    
    self.navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.navigationBar.frame.size.height)];
    self.navigationView.backgroundColor = [UIColor clearColor];
    
    VBFPopFlatButton *popFlatButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(8, 12, 20, 20)
                                                                   buttonType:buttonBackType
                                                                  buttonStyle:buttonPlainStyle
                                                        animateToInitialState:NO];
    popFlatButton.lineThickness = 2.0;
    popFlatButton.tintColor = [UIColor whiteColor];
    [popFlatButton addTarget:self action:@selector(closeItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:popFlatButton];
    
    if (self.menuButton == nil) {
        self.menuButton = [JXButton buttonWithType:UIButtonTypeCustom];
        self.menuButton.style = JXButtonStyleRight;
        self.menuButton.distance = 2.0f;
        self.menuButton.titleLabel.font = JXFont(14);
        self.menuButton.frame = CGRectMake(self.navigationView.jx_width - 54.0f, 12.0f, 32.0f, 20.0f);
        [self.menuButton setTitle:@"首页" forState:UIControlStateNormal];
        [self.menuButton setImage:JXAdaptImage(JXImageWithName(@"ic_arrow_slod_down")) forState:UIControlStateNormal];
        [self.menuButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationView addSubview:self.menuButton];
        
        self.menuButton.hidden = YES;
    }
    
    //    CGFloat slideHeight = 44 - Y_BUFFER * 2;
    //    CGFloat slideWidth = X_BUFFER + slideHeight + X_BUFFER;
    //    CGFloat swipeTotalWidth = self.view.frame.size.width - slideWidth * 2;
    //    CGFloat swipeItemWidth = swipeTotalWidth / numControllers;
    //
    //    CGFloat slideWidth = JXScreenScale(50.0f);
    //    //CGFloat slideX1 = 4.0f;
    //    CGFloat slideX2 = self.view.frame.size.width - slideWidth + 10.0f;
    //    // (slideWidth - 30.0f) / 2.0f;
    //    // CGFloat slideX2 = 320 - 50 + (50 - 24 - 4) - 8;
    //
    //    // self.menuButton.frame = CGRectMake(slideX1, 10, 24, 24);
    //    [self.navigationView addSubview:self.menuButton];
    //
    //    // ic_camera
    //    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(slideX2, 10, 24, 24)];
    //    //rightButton.backgroundColor = [UIColor redColor];
    //    [rightButton setImage:JXImageWithName(@"ic_camera") forState:UIControlStateNormal];
    //    [self.navigationView addSubview:rightButton];
    
    CGFloat width = JXScreenScale(150.0f);
    CGFloat marginH = (self.view.jx_width - width) / 2.0f;
    self.segmentedControl.frame = CGRectMake(marginH, 9, width, 26);
    [self.segmentedControl jx_borderWithColor:[UIColor whiteColor] width:1.0f radius:12];
    [self.navigationView addSubview:self.segmentedControl];
    
    
    
    // ic_menu
    //    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(X_BUFFER, Y_BUFFER, slideHeight, slideHeight)];
    //    // leftButton.backgroundColor = [UIColor greenColor];
    //    // leftButton.tag = 0;
    //    [leftButton setImage:JXImageWithName(@"ic_menu") forState:UIControlStateNormal];
    //    [self.navigationView addSubview:leftButton];
    
    //    for (int i = 0; i<numControllers; i++) {
    //        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(X_BUFFER+i*(self.view.frame.size.width-2*X_BUFFER)/numControllers-X_OFFSET, Y_BUFFER, (self.view.frame.size.width-2*X_BUFFER)/numControllers, HEIGHT)];
    //        [self.navigationView addSubview:button];
    //
    //        button.tag = i; //%%% IMPORTANT: if you make your own custom buttons, you have to tag them appropriately
    //        button.backgroundColor = SMInstance.mainNavBarTintColor; // [UIColor colorWithRed:0.03 green:0.07 blue:0.08 alpha:1]; // [UIColor clearColor]; //%%% buttoncolors
    //
    //        [button addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //
    //        [button setTitle:[self.titles objectAtIndex:i] forState:UIControlStateNormal]; //%%%buttontitle
    //
    ////        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(slideWidth + i * (swipeItemWidth), 0, swipeItemWidth, 44)];
    ////        [self.navigationView addSubview:button];
    ////
    ////        button.tag = i; //%%% IMPORTANT: if you make your own custom buttons, you have to tag them appropriately
    ////        button.backgroundColor = SMInstance.mainNavBarTintColor; // [UIColor colorWithRed:0.03 green:0.07 blue:0.08 alpha:1]; // [UIColor clearColor]; //%%% buttoncolors
    ////
    ////        [button addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    ////
    ////        [button setTitle:[self.titles objectAtIndex:i] forState:UIControlStateNormal]; //%%%buttontitle
    //    }
    
    //    UIBarButtonItem *menuItem = [UIBarButtonItem jx_barItemWithType:buttonMenuType color:JXInstance.navItemColor target:self action:@selector(menuItemPressed:)];
    //    menuItem.
    
    self.pageController.navigationController.navigationBar.topItem.titleView = self.navigationView;
    [self.pageController.navigationController.navigationBar jx_hideBottomLine:YES];
    
    // [self.pageController.navigationController.navigationBar setShadowImage:[UIImage new]];
    // [self setupSelectorWithPercentX:self.currentPageIndex];
    
    //%%% example custom buttons example:
    //     NSInteger width = (self.view.frame.size.width-(2*X_BUFFER))/3;
    //     UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(X_BUFFER, Y_BUFFER, width, HEIGHT)];
    //     UIButton *middleButton = [[UIButton alloc]initWithFrame:CGRectMake(X_BUFFER+width, Y_BUFFER, width, HEIGHT)];
    //     UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(X_BUFFER+2*width, Y_BUFFER, width, HEIGHT)];
    //
    //     [self.navigationBar addSubview:leftButton];
    //     [self.navigationBar addSubview:middleButton];
    //     [self.navigationBar addSubview:rightButton];
    //
    //     leftButton.tag = 0;
    //     middleButton.tag = 1;
    //     rightButton.tag = 2;
    //
    //     leftButton.backgroundColor = [UIColor colorWithRed:0.03 green:0.07 blue:0.08 alpha:1];
    //     middleButton.backgroundColor = [UIColor colorWithRed:0.03 green:0.07 blue:0.08 alpha:1];
    //     rightButton.backgroundColor = [UIColor colorWithRed:0.03 green:0.07 blue:0.08 alpha:1];
    //
    //     [leftButton addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //     [middleButton addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //     [rightButton addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //
    //     [leftButton setTitle:@"left" forState:UIControlStateNormal];
    //     [middleButton setTitle:@"middle" forState:UIControlStateNormal];
    //     [rightButton setTitle:@"right" forState:UIControlStateNormal];
    
    // [self setupSelector];
}

- (void)rightButtonPressed:(JXButton *)btn {
    [btn setImage:JXAdaptImage(JXImageWithName(@"ic_arrow_slod_up")) forState:UIControlStateNormal];
    
    [KxMenu setTintColor:[UIColor whiteColor]];
    [KxMenu setTitleFont:JXFont(13.0f)];
    [KxMenu setDisableGradient:YES];
    [KxMenu configHightlightColor:[UIColor whiteColor]];
    [KxMenu setupWillDismissBlock:^{
        [btn setImage:JXAdaptImage(JXImageWithName(@"ic_arrow_slod_down")) forState:UIControlStateNormal];
    }];
    
    KxMenuItem *item1 = [KxMenuItem menuItem:@"  首页" image:JXAdaptImage(JXImageWithName(@"ic_medicine_home")) target:self action:@selector(homeItemClicked:)];
    item1.foreColor = JXColorHex(0x333333);
    item1.alignment = NSTextAlignmentCenter;
    KxMenuItem *item2 = [KxMenuItem menuItem:@"  分享" image:JXAdaptImage(JXImageWithName(@"ic_medicine_share")) target:self action:@selector(shareItemClicked:)];
    item2.foreColor = JXColorHex(0x333333);
    item2.alignment = NSTextAlignmentCenter;
    KxMenuItem *item3 = [KxMenuItem menuItem:@"  收藏" image:JXAdaptImage(JXImageWithName(@"ic_medicine_collection")) target:self action:@selector(favoriteItemClicked:)];
    if (self.detail.favorite) {
        item3 = [KxMenuItem menuItem:@" 已收藏" image:JXAdaptImage(JXImageWithName(@"ic_medicine_collection_clicked")) target:self action:@selector(favoriteItemClicked:)];
    }
    item3.foreColor = JXColorHex(0x333333);
    item3.alignment = NSTextAlignmentCenter;

    CGRect rect = CGRectMake(btn.center.x, btn.jx_y + btn.jx_height + 20.0f + 4.0f, 0, 0);
    [KxMenu showMenuInView:JXAppWindow fromRect:rect menuItems:@[item1, item2, item3]];
}

- (void)homeItemClicked:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        UIViewController *vc = JXCurrentViewController();
        [vc.navigationController popToRootViewControllerAnimated:NO];

//        LLTabBar *tabBar = [JXAppDelegate tabBar];
//        [tabBar itemSelected:tabBar.tabBarItems[0]];
        
        UITabBarController *mainVC = [JXAppDelegate mainTbController];
        [mainVC setSelectedIndex:0];
    }];
}

- (void)shareItemClicked:(id)sender {
    if (![WXApi isWXAppInstalled]) {
        [JXDialog showPopup:@"未安装微信，无法分享"];
        return;
    }
    
    if (0 == self.detail.drugPriceList.count) {
        [JXDialog showPopup:@"无效的详情数据"];
        return;
    }
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        CompResultDetailPrice *p = self.detail.drugPriceList[0];
        
        //JXHUDProcessing(nil);
        [JXDialog showHUD:nil];
        [[SDWebImageManager sharedManager] downloadImageWithURL:JXURLWithStr(p.imgUrl) options:SDWebImageRefreshCached progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            JXHUDHide();
            if (finished && image) {
                NSString *title = JXStrWithDft(self.detail.wiseDrugBrandInstructionsDto.dbiName, @"");
                NSString *desc = JXStrWithDft(self.detail.wiseDrugBrandInstructionsDto.dbiIndication, @"");
                UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:image];
                shareObject.webpageUrl = @"http://dl.appvworks.com/doctor/user_app/index.html";
                
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                messageObject.shareObject = shareObject;
                
                [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                    //            if (error) {
                    //                JXHUDError(error.localizedDescription, YES);
                    //            }
                }];
            }else {
                NSString *title = JXStrWithDft(self.detail.wiseDrugBrandInstructionsDto.dbiName, @"");
                NSString *desc = JXStrWithDft(self.detail.wiseDrugBrandInstructionsDto.dbiIndication, @"");
                UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:JXImageWithName(@"my_appicon")];
                shareObject.webpageUrl = @"https://dl.appvworks.com/doctor/user_app/index.html";
                
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                messageObject.shareObject = shareObject;
                
                [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                    //            if (error) {
                    //                JXHUDError(error.localizedDescription, YES);
                    //            }
                }];
            }
        }];
    }];
}

- (void)favoriteItemClicked:(id)sender {
    if (self.detail.favorite) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyFavoriteDidDel object:(@([self.detail.jxID integerValue]))];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyFavoriteDidAdd object:(@([self.detail.jxID integerValue]))];
    }
    
    self.detail.favorite = !self.detail.favorite;
}

//%%% sets up the selection bar under the buttons on the navigation bar
-(void)setupSelectorWithPercentX:(CGFloat)percentX {
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
    
    self.selectionBar = [[UIView alloc] initWithFrame:CGRectMake(X_BUFFER - X_OFFSET, SELECTOR_Y_BUFFER,(self.view.frame.size.width - 2 * X_BUFFER) / [self.controllers count], SELECTOR_HEIGHT)];
    self.selectionBar.backgroundColor = [UIColor blackColor]; // [UIColor greenColor]; //%%% sbcolor
    self.selectionBar.alpha = 0.8; //%%% sbalpha
    [self.navigationView addSubview:self.selectionBar];
    
    //    CGFloat slideHeight = 44 - Y_BUFFER * 2;
    //    CGFloat slideWidth = X_BUFFER + slideHeight + X_BUFFER;
    //    CGFloat swipeTotalWidth = self.view.frame.size.width - slideWidth * 2;
    //   // CGFloat swipeItemWidth = swipeTotalWidth / self.controllers.count;
    //
    //    CGFloat selectorWidth = 36.0f;
    //    CGFloat x = swipeTotalWidth / 2.0  / 2.0 - 18 + slideWidth;
    //
    //    self.selectionBar = [[UIView alloc] initWithFrame:CGRectMake(x, SELECTOR_Y_BUFFER, selectorWidth, SELECTOR_HEIGHT)];
    //    self.selectionBar.backgroundColor = SMInstance.homeNavTitleSelectedColor;
    //    self.selectionBar.alpha = 0.8;
    //    [self.navigationView addSubview:self.selectionBar];
}

//%%% makes sure the nav bar is always aware of what page you're on
//in reference to the array of view controllers you gave
-(void)updateCurrentPageIndex:(int)newIndex {
    //    if (self.currentPageIndex != newIndex/* && self.segmentedControl.selectedSegmentIndex != newIndex*/) {
    //        [self.segmentedControl setSelectedSegmentIndex:newIndex animated:YES];
    //    }
    self.currentPageIndex = newIndex;
}

//%%% checks to see which item we are currently looking at from the array of view controllers.
// not really a delegate method, but is used in all the delegate methods, so might as well include it here
-(NSInteger)indexOfController:(UIViewController *)viewController {
    for (int i = 0; i<[self.controllers count]; i++) {
        if (viewController == [self.controllers objectAtIndex:i]) {
            return i;
        }
    }
    return NSNotFound;
}

- (UIViewController *)curViewController {
    if (self.controllers.count > self.currentPageIndex) {
        return [self.controllers objectAtIndex:self.currentPageIndex];
    }else{
        return nil;
    }
}

#pragma mark - Action
//%%% when you tap one of the buttons, it shows that page,
//but it also has to animate the other pages to make it feel like you're crossing a 2d expansion,
//so there's a loop that shows every view controller in the array up to the one you selected
//eg: if you're on page 1 and you click tab 3, then it shows you page 2 and then page 3
- (void)tapSegmentButtonAction:(UIButton *)button {
    if (!self.isPageScrollingFlag) {
        NSInteger tempIndex = self.currentPageIndex;
        __weak typeof(self) weakSelf = self;
        
        //%%% check to see if you're going left -> right or right -> left
        if (button.tag > tempIndex) {
            //%%% scroll through all the objects between the two points
            for (int i = (int)tempIndex+1; i<=button.tag; i++) {
                [self.pageController setViewControllers:@[[self.controllers objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL complete){
                    //%%% if the action finishes scrolling (i.e. the user doesn't stop it in the middle),
                    //then it updates the page that it's currently on
                    if (complete) {
                        [weakSelf updateCurrentPageIndex:i];
                    }
                }];
            }
        } else if (button.tag < tempIndex) { //%%% this is the same thing but for going right -> left
            for (int i = (int)tempIndex-1; i >= button.tag; i--) {
                [self.pageController setViewControllers:@[[self.controllers objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL complete){
                    if (complete) {
                        [weakSelf updateCurrentPageIndex:i];
                    }
                }];
            }
        }
    }
}

#pragma mark - Delegate
#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isPageScrollingFlag = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isPageScrollingFlag = NO;
    
    //    CGFloat pageWidth = scrollView.frame.size.width;
    //    NSInteger page = scrollView.contentOffset.x / pageWidth;
    // JXLogDebug(@"page = %@", @(self.currentPageIndex));
    //    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
    if (self.currentPageIndex != self.segmentedControl.selectedSegmentIndex) {
        [self.segmentedControl setSelectedSegmentIndex:self.currentPageIndex animated:YES];
    }
}

//%%% method is called when any of the pages moves.
//It extracts the xcoordinate from the center point and instructs the selection bar to move accordingly
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
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
    
    
    
    //    CGFloat xFromCenter = self.view.frame.size.width - scrollView.contentOffset.x; //%%% positive for right swipe, negative for left
    //
    //    //%%% checks to see what page you are on and adjusts the xCoor accordingly.
    //    //i.e. if you're on the second page, it makes sure that the bar starts from the frame.origin.x of the
    //    //second tab instead of the beginning
    //    NSInteger xCoor = X_BUFFER + self.selectionBar.frame.size.width * self.currentPageIndex - X_OFFSET;
    //
    //    self.selectionBar.frame = CGRectMake(xCoor - xFromCenter/self.controllers.count, self.selectionBar.frame.origin.y, self.selectionBar.frame.size.width, self.selectionBar.frame.size.height);
    
    //    CGFloat xFromCenter = (self.view.frame.size.width - scrollView.contentOffset.x) / self.controllers.count;
    //    JXLogDebug(@"xFromCenter = %@", @(xFromCenter));
    //    self.segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, xFromCenter, 0, -xFromCenter);
    //    [self.segmentedControl setNeedsDisplay];
    
    //    CGFloat slideHeight = 44 - Y_BUFFER * 2;
    //    CGFloat slideWidth = X_BUFFER + slideHeight + X_BUFFER;
    //    CGFloat swipeTotalWidth = self.view.frame.size.width - slideWidth * 2;
    //    CGFloat swipeItemWidth = swipeTotalWidth / self.controllers.count;
    ////
    //    CGFloat selectorWidth = 36.0f;
    //    CGFloat x = swipeTotalWidth / 2.0  / 2.0 - 18 + slideWidth;
    ////    if (0 == self.currentPageIndex) {
    ////        x = swipeTotalWidth / 2.0  / 2.0 - 18 + slideWidth;
    ////    }else {
    ////        x = swipeTotalWidth / 2.0 / 2.0 * 3.0 - 18 + slideWidth;
    ////    }
    //////
    //////    self.selectionBar = [[UIView alloc] initWithFrame:CGRectMake(x, SELECTOR_Y_BUFFER, selectorWidth, SELECTOR_HEIGHT)];
    //////    self.selectionBar.backgroundColor = SMInstance.homeNavTitleSelectedColor;
    //////    self.selectionBar.alpha = 0.8;
    //////    [self.navigationView addSubview:self.selectionBar];
    ////
    ////    JXLogDebug(@"scrollView.contentOffset.x = %@", @(self.view.frame.size.width - scrollView.contentOffset.x));
    ////
    ////    CGFloat xFromCenter = self.view.frame.size.width - scrollView.contentOffset.x;
    ////   self.selectionBar.frame = CGRectMake(x - xFromCenter / self.controllers.count, self.selectionBar.jx_y, self.selectionBar.jx_width, self.selectionBar.jx_height);
    //
    //
    //    CGFloat xFromCenter = self.view.frame.size.width - scrollView.contentOffset.x; //%%% positive for right swipe, negative for left
    //    NSInteger xCoor = x + self.selectionBar.frame.size.width * self.currentPageIndex - X_OFFSET;
    //
    //    self.selectionBar.frame = CGRectMake(xCoor - xFromCenter/self.controllers.count, self.selectionBar.frame.origin.y, self.selectionBar.frame.size.width, self.selectionBar.frame.size.height);
    
}

#pragma mark UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    _p_displayingViewController = viewController;
    
    NSInteger index = [self indexOfController:viewController];
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    
    index--;
    return [self.controllers objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    _p_displayingViewController = viewController;
    
    NSInteger index = [self indexOfController:viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == self.controllers.count) {
        return nil;
    }
    
    return [self.controllers objectAtIndex:index];
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    _p_displayingViewController = nil;
    
    if (completed) {
        self.currentPageIndex = [self indexOfController:[pageViewController.viewControllers lastObject]];
    }
}

#pragma mark - Class
+ (instancetype)medicineNCWithDataSource:(id)dataSource {
    MedicinePageViewController *pageVC = [[MedicinePageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    MedicineViewController *swipeNV = [[MedicineViewController alloc] initWithRootViewController:pageVC];
    
    MedicinePriceViewController *repertoryVC = [[MedicinePriceViewController alloc] init];
    repertoryVC.medicine = dataSource;
    
    MedicineManualViewController *vehiclevVC = [[MedicineManualViewController alloc] init];
    vehiclevVC.medicine = dataSource;
    
    [swipeNV.controllers addObjectsFromArray:@[repertoryVC, vehiclevVC]];
    swipeNV.titles = @[@"价格", @"说明书"];
    
    return swipeNV;
}

@end

